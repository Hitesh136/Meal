//
//  DataModal.swift
//  MyMeal
//
//  Created by Hitesh  Agarwal on 8/7/18.
//  Copyright © 2018 Hitesh  Agarwal. All rights reserved.
//

import Foundation
import Alamofire

class WeekDietData: Codable {
    let thursday, wednesday, monday: [Day]
    
    init(thursday: [Day], wednesday: [Day], monday: [Day]) {
        self.thursday = thursday
        self.wednesday = wednesday
        self.monday = monday
    }
}

class Day: Codable {
    let food, mealTime: String
    
    enum CodingKeys: String, CodingKey {
        case food
        case mealTime = "meal_time"
    }
    
    init(food: String, mealTime: String) {
        self.food = food
        self.mealTime = mealTime
    }
}

class DataModal: Codable {
    let dietDuration: Int
    let weekDietData: WeekDietData
    
    enum CodingKeys: String, CodingKey {
        case dietDuration = "diet_duration"
        case weekDietData = "week_diet_data"
    }
    
    init(dietDuration: Int, weekDietData: WeekDietData) {
        self.dietDuration = dietDuration
        self.weekDietData = weekDietData
    }
    
    static func getDataFromApi(completionHandler completion: @escaping (_ dataModal: DataModal?) -> Void) {
        
        let urlString = "http://naviadoctors.com/dummy/"
        let optionalURL = URL(string: urlString)
        guard let url = optionalURL else {
            completion(nil)
            return
        }
        
        Alamofire.request(url, parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: nil) 
            .responseJSON { dataResponse in
                
                if let data = dataResponse.data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let dataModal = try jsonDecoder.decode(DataModal.self, from: data)
                        completion(dataModal)
                    }
                    catch let error {
                        print(error.localizedDescription)
                        completion(nil)
                    }
                }
                else {
                    completion(nil)
                }
        }
        
    }
}

