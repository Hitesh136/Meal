//
//  ViewController.swift
//  MyMeal
//
//  Created by Hitesh  Agarwal on 8/7/18.
//  Copyright © 2018 Hitesh  Agarwal. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    var dataModal: DataModal? = nil
    enum CustomWeekDay: Int {
        case sun, mon, tue, wed, thu, fri, sat
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    self.get()
                })
            case .authorized:

                self.get()
            case .denied:
                print("Application Not Allowed to Display Notifications")
             
              
            }
            
        }
        
    }
    
    func get() {
        DataModal.getDataFromApi { (dataModalValue) in
            if let tempDataModal = dataModalValue {
                self.dataModal = tempDataModal
                self.createReminders()
            }
            else {
                print("Something went wrong")
            }
        }
        
    }
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func getNotificationDate(formDay day: Day, weekDay: CustomWeekDay) -> NotificationData?{
        let arrTime = day.mealTime.components(separatedBy: ":")
        
        if arrTime.count == 2 {
            let tempHour = Int(arrTime[0])
            let tempMinute = Int(arrTime[1])
            
            guard let hour = tempHour, let min = tempMinute else {
                return nil
            }
            let currentDate = Date()
            let calender = Calendar.current
            var dateComponent = calender.dateComponents([.hour, .minute, .day, .second,.weekday, .month, .year], from: currentDate)
            
            dateComponent.hour = hour
            dateComponent.minute = min
//            dateComponent.second = (dateComponent.second ?? 0) + 10
            if let timeInterval = calender.date(from: dateComponent)?.timeIntervalSinceNow {
                var tempTimeInterval = timeInterval
                if timeInterval < 0 {
                    tempTimeInterval = timeInterval + 604800
                }
                
                if day.food == "Soup ,Rice and Chicken" {
                    print("tftf = \(tempTimeInterval)")
                }
                let notificationData = NotificationData(title: "It's time for",
                                                        message: day.food,
                                                        timeInterval: tempTimeInterval)
                return notificationData
            }
            return nil
        }
        return nil
    }
    
    func createReminders() {
        guard let dataModalValue = dataModal else {
            return
        }
        
        var arrNotification = [NotificationData]()
        for day in dataModalValue.weekDietData.monday {
            let notificationData = getNotificationDate(formDay: day, weekDay: .mon)
            if let notificationData = notificationData {
                arrNotification.append(notificationData)
            }
        }
        
        for day in dataModalValue.weekDietData.thursday {
            let notificationData = getNotificationDate(formDay: day, weekDay: .mon)
            if let notificationData = notificationData {
                arrNotification.append(notificationData)
            }
        }
        
        for day in dataModalValue.weekDietData.wednesday {
            let notificationData = getNotificationDate(formDay: day, weekDay: .mon)
            if let notificationData = notificationData {
                arrNotification.append(notificationData)
            }
        }
        
        for notificatonModal in arrNotification {
            
            guard let timeInterval = notificatonModal.timeInterval else {
                continue
            }
            let notification = UNMutableNotificationContent()
            notification.title = notificatonModal.title ?? ""
            notification.subtitle = notificatonModal.message ?? ""
            let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            
            let request = UNNotificationRequest(identifier: "notification1", content: notification, trigger: notificationTrigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
                }
                else {
                    print("\(notificatonModal.message ?? "") wtih \(timeInterval)")
                }
            }
        }
    }
}


extension ViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
}

