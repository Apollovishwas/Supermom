//
//  babyFood.swift
//
//
//  Created by Vishwas on 16/11/18.
//

import Foundation
class BabyFood : Codable {
    
    var iron:Double
    var Fat:Double
    var Calcium:Double
    var carbo:Double
    var totalCal:Double
    var food:String
    var Whom:String
    init(iron:Double,fat:Double,Calcium:Double,Carbo:Double,totalCal:Double,food:String,Whom:String) {
        self.iron = iron
        self.Fat = fat
        self.Calcium = Calcium
        self.carbo = Carbo
        self.totalCal = totalCal
        self.food = food
        self.Whom = Whom
    }
}

//siri intents content provider extension
//this extension provides siri shortcut functionality
extension BabyFood {
    public var intent : AddFoodIntent {
        let addFoodIntent = AddFoodIntent()
        print(self.food)
        print(self.Whom)
        addFoodIntent.food =  self.food
        addFoodIntent.whom = self.Whom
        addFoodIntent.calories = NSNumber(value: self.totalCal)
        
        return addFoodIntent
    }
}
