//
//  AddFoodDataManager.swift
//  BEABoxer
//
//  Created by Vishwas on 17/11/18.
//  Copyright © 2018 apollo INC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FoodManager {
    //declaring the array
    var babyFoodArray : [BabyFood] = [BabyFood]()
    var food : String
    var whom : String
    var ndno : String = ""
    
    init(foodinit:String,whominit:String) {
        self.food = foodinit
        self.whom = whominit
    }
    
    func getNutritionData() {
        
        let userDefaults = UserDefaults.standard
        let food = self.food
        let foodEncoded = food.replacingOccurrences(of: " ", with: "%20")
        var url = "https://api.edamam.com/api/nutrition-data?app_id=93b3b0e8&app_key=5c576f4531b40bb4dcbabe5ecd25bec0&ingr=\(foodEncoded)"
        Alamofire.request(url,method:.get,encoding: JSONEncoding.prettyPrinted)
            .responseString {response in
                // print("String:\(response.result.value)")
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        
                        let jsonString = response.result.value
                        let dat = jsonString?.data(using: String.Encoding.utf8)
                        print(JSON(jsonString))
                        
                        do {
                            let jsonData = try JSONSerialization.jsonObject(with: dat!, options: .mutableContainers)
                            var json = SwiftyJSON.JSON(jsonData)
                            let energyFromJson = json["calories"].doubleValue
                            let fatFromJson = json["totalNutrients"]["FAT"]["quantity"].doubleValue
                            let carboFromJson = json["totalNutrients"]["CHOCDF"]["quantity"].doubleValue
                            let protien = json["totalNutrients"]["PROCNT"]["quantity"].doubleValue
                            let calciumFromJson = json["totalNutrients"]["CA"]["quantity"].doubleValue
                            let ironFromJson = json["totalNutrients"]["FE"]["quantity"].doubleValue
                            
                            
                            let babyFood = BabyFood(iron: 0.0, fat: 0.0, Calcium: 0.0, Carbo: 0.0, totalCal: 0.0, food: "", Whom: "")
                            babyFood.food = self.food
                            babyFood.Whom = self.whom
                            babyFood.iron = ironFromJson
                            babyFood.carbo = carboFromJson
                            babyFood.Fat = fatFromJson
                            babyFood.Calcium = calciumFromJson
                            babyFood.totalCal = energyFromJson
                            //calling the function to append the data
                            //syntax
                            self.appendTheData(food: babyFood)
                            
                            if(self.whom == "baby") {
                                
                                print("baby")
                                UserDefaults(suiteName: "group.addFoodIntent.test")!.double(forKey: "TotalCaloriesForBaby")
                                
                                var calcium = UserDefaults(suiteName: "group.addFoodIntent.test")!.double(forKey: "calciumForBaby")
                                var fat = UserDefaults(suiteName: "group.addFoodIntent.test")!.double(forKey: "FatForBaby")
                                var iron =  UserDefaults(suiteName: "group.addFoodIntent.test")!.double(forKey: "IronForBaby")
                                var carbo = UserDefaults(suiteName: "group.addFoodIntent.test")!.double(forKey: "carboHydratesForBaby")
                                var energy  = UserDefaults(suiteName: "group.addFoodIntent.test")!.double(forKey: "TotalCaloriesForBaby")
                                print("energy before appending")
                                print(energy)
                                calcium = calcium + self.babyFoodArray[0].Calcium
                                fat = fat + self.babyFoodArray[0].Fat
                                iron = iron + self.babyFoodArray[0].iron
                                carbo = carbo + self.babyFoodArray[0].iron
                                energy = energy + self.babyFoodArray[0].totalCal
                                print("after appending")
                                print(energy)
                                UserDefaults(suiteName: "group.addFoodIntent.test")!.set(carbo, forKey: "carboHydratesForBaby")
                                UserDefaults(suiteName: "group.addFoodIntent.test")!.set(fat, forKey: "FatForBaby")
                                UserDefaults(suiteName: "group.addFoodIntent.test")!.set(iron, forKey: "IronForBaby")
                                UserDefaults(suiteName: "group.addFoodIntent.test")!.set(calcium, forKey: "calciumForBaby")
                                UserDefaults(suiteName: "group.addFoodIntent.test")!.set(energy, forKey: "TotalCaloriesForBaby")
                                
                            }
                            if(self.whom == "mom") {
                                var enerrgyForMom = self.babyFoodArray[0].totalCal
                                enerrgyForMom = energyFromJson
                                print("****************mom**************")
                                print(energyFromJson)
                                
                                let currentEnergy  = UserDefaults(suiteName: "group.addFoodIntent.test")!.double(forKey: "TotalCaloriesForMom")
                                print("current Energy")
                                print(currentEnergy)
                                enerrgyForMom = energyFromJson + currentEnergy
                                UserDefaults(suiteName: "group.addFoodIntent.test")!.set(round(enerrgyForMom), forKey: "TotalCaloriesForMom")
                                print("data get Failes")
                                print(UserDefaults(suiteName: "group.addFoodIntent.test")!.double(forKey: "TotalCaloriesForBaby"))
                                
                                
                                
                            }
                        } catch let myJSONError {
                            print(myJSONError)
                        }
                    }
                    
                case .failure(_):
                    //print("Error message:\(response.result.error)")
                    break
                }
                print("outside")
                
                
                
        }
    }
    
    
    
    
    
    
    func getNutritionValue(url:String,parameters:[String:String]) {
        let userDefaults = UserDefaults.standard
        //defining userDefaults
        Alamofire.request(url,method : .get , parameters: parameters).responseJSON {response in
            if response.result.isSuccess {
                print("got the report")
                let dataJSON : JSON = JSON(response.result.value!)
                
                //print(dataJSON["foods"][0]["food"]["nutrients"][7])
                let energyFromJson = dataJSON["foods"][0]["food"]["nutrients"][0]["value"].doubleValue
                let protienFromJson = dataJSON["foods"][0]["food"]["nutrients"][1]["value"].doubleValue
                let fatFromJson = dataJSON["foods"][0]["food"]["nutrients"][2]["value"].doubleValue
                let carboFromJson = dataJSON["foods"][0]["food"]["nutrients"][3]["Value"].doubleValue
                let ironFromJson = dataJSON["foods"][0]["food"]["nutrients"][7]["value"].doubleValue
                let babyFood = BabyFood(iron: 0.0, fat: 0.0, Calcium: 0.0, Carbo: 0.0, totalCal: 0.0, food: "", Whom: "")
                babyFood.food = self.food
                babyFood.Whom = self.whom
                babyFood.iron = ironFromJson
                babyFood.carbo = carboFromJson
                babyFood.Fat = fatFromJson
                babyFood.Calcium = protienFromJson
                babyFood.totalCal = energyFromJson
                //calling the function to append the data
                //syntax
                //fname(variable_name:variable_type)
                self.appendTheData(food: babyFood)
                //self.babyFoodArray.append(babyFood)
                //  donate(babyfood: self.babyFoodArray)
                if(self.whom == "baby") {
                    //                    print(self.babyFoodArray[0].food)
                    //                     print(self.babyFoodArray[0].Whom)
                    
                    //                    print("sender baby")
                    //                    print(self.babyFoodArray[0].Calcium)
                    //                    print(self.babyFoodArray[0].totalCal)
                    //                    print(self.babyFoodArray[0].iron)
                    
                    var calcium =  UserDefaults(suiteName: "group.addFoodIntent.test")!.double(forKey: "calciumForBaby")
                    
                    var fat = UserDefaults(suiteName: "group.addFoodIntent.test")!.double(forKey: "FatForBaby")
                    
                    var iron =  UserDefaults(suiteName: "group.addFoodIntent.test")!.double(forKey: "IronForBaby")
                    
                    var carbo = UserDefaults(suiteName: "group.addFoodIntent.test")!.double(forKey: "carboHydratesForBaby")
                    
                    var energy  = UserDefaults(suiteName: "group.addFoodIntent.test")!.double(forKey: "TotalCaloriesForBaby")
                    calcium = calcium + self.babyFoodArray[0].Calcium
                    fat = fat + self.babyFoodArray[0].Fat
                    iron = iron + self.babyFoodArray[0].iron
                    carbo = carbo + self.babyFoodArray[0].iron
                    energy = energy + self.babyFoodArray[0].totalCal
                    UserDefaults(suiteName: "group.addFoodIntent.test")!.set(carbo, forKey: "carboHydratesForBaby")
                    UserDefaults(suiteName: "group.addFoodIntent.test")!.set(fat, forKey: "FatForBaby")
                    UserDefaults(suiteName: "group.addFoodIntent.test")!.set(iron, forKey: "IronForBaby")
                    UserDefaults(suiteName: "group.addFoodIntent.test")!.set(calcium, forKey: "calciumForBaby")
                    UserDefaults(suiteName: "group.addFoodIntent.test")!.set(energy, forKey: "TotalCaloriesForBaby")
                    
                    
                    
                    
                    
                }
                
                let enerrgyForMom = energyFromJson
                UserDefaults(suiteName: "group.addFoodIntent.test")!.set(enerrgyForMom, forKey: "TotalCaloriesForMom")
                
                
                
                
                
            }
            else {
                print("data get Failes")
                
                
                
            }
        }
        
    }
    
    //append the data for retrieval
    func appendTheData(food:BabyFood) {
        self.babyFoodArray.append(food)
        //donate(food:food)
    }
    //donating the siri intent function
    
    
}
