//
//  AddFoodViewController.swift
//  BEABoxer
//
//  Created by Vishwas on 12/11/18.
//  Copyright © 2018 apollo INC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Intents
import IntentsUI
import CoreSpotlight
import CoreServices
import Comets
import GradientKit

protocol reloadDataDelegate {
    func reloadData()
}

class AddFoodViewController: UIViewController,UITextFieldDelegate,INUIAddVoiceShortcutViewControllerDelegate{
    //delegate
    var delegate : reloadDataDelegate?
    
  
    //variable declaraions
    var darkYellow = UIColor(red:0.94, green:0.58, blue:0.20, alpha:1.0)
    var lightYellow = UIColor(red:0.98, green:0.81, blue:0.23, alpha:1.0)
    var servingWeight = 0
    var Sender:String = ""
    var foodName = ""
    var babyFood :BabyFood?
    var babyFoodArray : [BabyFood] = [BabyFood]()
    //outlets
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var foodInput: UITextField!
    @IBOutlet weak var bg: UIView!
    
//viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let userDefaults = UserDefaults.standard
        //blurEffect
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, at: 0)
        //blurEffect Ends
        
        //gradient starts
        let addFoodGradient = LinearGradientLayer(direction: .horizontal)
        addFoodGradient.colors = [darkYellow, lightYellow]
        let h = bg.frame.size.height
        let w = bg.frame.size.width
        addFoodGradient.frame =  CGRect(x: 0, y: 0, width: w, height: h)
        bg.layer.insertSublayer(addFoodGradient, at: 0)
        //gradientEnds
        
        //button styling
        backButton.layer.cornerRadius = 10.0
        addButton.layer.cornerRadius = 10.0
        
        //comets
        let width = bg.bounds.width
        let height = bg.bounds.height
        let comets = [Comet(startPoint: CGPoint(x: 100, y: 0),
                            endPoint: CGPoint(x: 0, y: 100),
                            lineColor: UIColor.white.withAlphaComponent(0.45)),
                      Comet(startPoint: CGPoint(x: 0.4 * width, y: 0),
                            endPoint: CGPoint(x: width, y: 0.8 * width),
                            lineColor: UIColor.white.withAlphaComponent(0.45)),
                      Comet(startPoint: CGPoint(x: 0.8 * width, y: 0),
                            endPoint: CGPoint(x: width, y: 0.2 * width),
                            lineColor: UIColor.white.withAlphaComponent(0.45)),
                      Comet(startPoint: CGPoint(x: width, y: 0.2 * height),
                            endPoint: CGPoint(x: 0, y: 0.25 * height),
                            lineColor: UIColor.white.withAlphaComponent(0.45)),
                      Comet(startPoint: CGPoint(x: 0, y: height - 0.8 * width),
                            endPoint: CGPoint(x: 0.6 * width, y: height),
                            lineColor: UIColor.white.withAlphaComponent(0.45)),
                      Comet(startPoint: CGPoint(x: width - 100, y: height),
                            endPoint: CGPoint(x: width, y: height - 100),
                            lineColor: UIColor.white.withAlphaComponent(0.45)),
                      Comet(startPoint: CGPoint(x: 0, y: 0.8 * height),
                            endPoint: CGPoint(x: width, y: 0.75 * height),
                            lineColor: UIColor.white.withAlphaComponent(0.45))]
        // draw track and animate
        for comet in comets {
            bg.layer.addSublayer(comet.drawLine())
            bg.layer.addSublayer(comet.animate())
        }
        
        bg.layer.cornerRadius = 15.0
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        foodInput.delegate = self
        
        
        
    }
  
    //dismiss the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //closing the ViewController
    @IBAction func closeTheViewController(_ sender: Any) {
        delegate?.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    //addFood function
    @IBAction func addFood(_ sender: Any) {
        let foodInput = self.foodInput.text
        foodName = String(foodInput!)
        edamam()
        
    }
    
    
    
    func edamam() {
        //a constant for userDefault
        let userDefaults = UserDefaults.standard
        //getting the text on the input box
        let food = foodInput.text
        //checking whether it's empty or not
        if food == "" {
            //if it's empty , show an alert
            let alert = UIAlertController(title: "Blank", message: "Enter any food to Continue", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            //main part of the code starts here
        else {
            
            //showing the spinner
            var indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
            indicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
            indicator.center = view.center
            view.addSubview(indicator)
            indicator.bringSubviewToFront(view)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            indicator.startAnimating()
            //showing the spinner code ends
            
            //replaing the spaces with %20 for URL Encoding
            let foodEncoded = food!.replacingOccurrences(of: " ", with: "%20")
            var url = "https://api.edamam.com/api/nutrition-data?app_id=93b3b0e8&app_key=5c576f4531b40bb4dcbabe5ecd25bec0&ingr=\(foodEncoded)"
            Alamofire.request(url,method:.get,encoding: JSONEncoding.prettyPrinted)
                .responseString {response in
                    
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
                                self.servingWeight = json["totalWeight"].intValue
                                //checkong whether the food is valid or not
                                if energyFromJson == 0.0 {
                                    let alert = UIAlertController(title: "Error", message: "No Food Found", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
                                let babyFood = BabyFood(iron: 0.0, fat: 0.0, Calcium: 0.0, Carbo: 0.0, totalCal: 0.0, food: "", Whom: "")
                                babyFood.food = food!
                                babyFood.Whom = self.Sender
                                babyFood.iron = ironFromJson
                                babyFood.carbo = carboFromJson
                                babyFood.Fat = fatFromJson
                                babyFood.Calcium = calciumFromJson
                                babyFood.totalCal = energyFromJson
                                //calling the function to append the data
                                //syntax
                                //fname(variable_name:variable_type)
                                self.appendTheData(food: babyFood)
                                if(self.Sender == "baby") {
                                    
                                    print("baby")
                                    print("energy from json")
                                    print(energyFromJson)
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
                                    UserDefaults(suiteName: "group.addFoodIntent.test")!.set(round(carbo), forKey: "carboHydratesForBaby")
                                    UserDefaults(suiteName: "group.addFoodIntent.test")!.set(round(fat), forKey: "FatForBaby")
                                    UserDefaults(suiteName: "group.addFoodIntent.test")!.set(round(iron), forKey: "IronForBaby")
                                    UserDefaults(suiteName: "group.addFoodIntent.test")!.set(round(calcium), forKey: "calciumForBaby")
                                    UserDefaults(suiteName: "group.addFoodIntent.test")!.set(round(energy), forKey: "TotalCaloriesForBaby")
                                    indicator.stopAnimating()
                                    let alert = UIAlertController(title: "Food Added", message: "The serving weight of the food is \(self.servingWeight) gm/ml", preferredStyle: UIAlertController.Style.alert)
                                    
                                    // add an action (button)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                    
                                    // show the alert
                                    self.present(alert, animated: true, completion: nil)
                                    
                                    
                                }
                                if(self.Sender == "mom") {
                                    print("mom")
                                    print("energy from json")
                                    print(energyFromJson)
                                    let currentEnergy  = UserDefaults(suiteName: "group.addFoodIntent.test")!.double(forKey: "TotalCaloriesForMom")
                                    print(currentEnergy)
                                    var enerrgyForMom = energyFromJson + currentEnergy
                                    UserDefaults(suiteName: "group.addFoodIntent.test")!.set(round(enerrgyForMom), forKey: "TotalCaloriesForMom")
                                    print("after appending")
                                    print(enerrgyForMom)
                                    enerrgyForMom = 0.0
                                    let alert = UIAlertController(title: "Food Added", message: "The serving weight of the food is \(self.servingWeight) gm/ml", preferredStyle: UIAlertController.Style.alert)
                                    
                                    // add an action (button)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                    indicator.stopAnimating()
                                    self.present(alert, animated: true, completion: nil)
                                    //                                self.addToSiri.isHidden = false
                                    
                                }
                            } catch let myJSONError {
                                print(myJSONError)
                                let alert = UIAlertController(title: "Error", message: "Try again Later", preferredStyle: UIAlertController.Style.alert)
                                
                                // add an action (button)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                indicator.stopAnimating()
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        
                    case .failure(_):
                        print("Error message:\(response.result.error)")
                        let alert = UIAlertController(title: "Error", message: "No Food Found", preferredStyle: UIAlertController.Style.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        indicator.stopAnimating()
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                        break
                    }
                    print("outside")
                    
                    
                    
            }
        }
    }
    
    //currently not in use
    
//    func addSiriButton() {
//        guard let intent = self.babyFood?.intent,
//            let shortcut = INShortcut(intent:intent) else {
//                print("error adding intent")
//                return
//        }
//        let vc = INUIAddVoiceShortcutViewController(shortcut: shortcut)
//        vc.delegate = self
//        self.present(vc, animated: true, completion: nil)
//
//
//    }
    
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        if let error = error {
            print(error)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    //append the data for retrieval
    func appendTheData(food:BabyFood) {
        self.babyFoodArray.append(food)
        donate(food:food)
    }
    
    
    //donating the siri intent function
    private func donate(food:BabyFood) {
        let interaction = INInteraction(intent: food.intent, response: nil)
        interaction.donate { error in
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
    }
    
    
    
}

