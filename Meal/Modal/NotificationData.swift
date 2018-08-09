//
//  NotificationData.swift
//  MyMeal
//
//  Created by Hitesh Agarwal on 08/08/18.
//

import Foundation

class NotificationData: NSObject {
    
    var title: String?
    var message: String?
    var timeInterval: TimeInterval?
    
    init(title: String, message: String, timeInterval: TimeInterval) {
         
        self.title = title
        self.message = message
        self.timeInterval = timeInterval
    }
}
