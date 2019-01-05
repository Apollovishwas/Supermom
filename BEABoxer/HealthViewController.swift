//
//  HealthViewController.swift
//  
//
//  Created by Vishwas on 11/11/18.
//

import UIKit
import Alamofire
import SwiftyJSON


class HealthViewController: UIViewController {
   

    @IBOutlet weak var babyCalcium: UILabel!
    @IBOutlet weak var babyCarbo: UILabel!
    @IBOutlet weak var babyFat: UILabel!
    @IBOutlet weak var babyIron: UILabel!
    @IBOutlet weak var babyTotalCalories: UILabel!
    @IBOutlet weak var momTotalConsumed: UILabel!
    @IBOutlet weak var momTotalBurnt: UILabel!
    
    
    @IBAction func addFoodForMom(_ sender: Any) {
        self.performSegue(withIdentifier: "healthToAddFoodMom", sender:self)

    }
    
    @IBAction func addFoodForBabt(_ sender: Any) {
       self.performSegue(withIdentifier: "healthToAddFoodBaby", sender:self)


    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "healthToAddFoodBaby" {
            let addFoodVC = segue.destination as! AddFoodViewController
            addFoodVC.Sender = "baby"
        }
        if segue.identifier == "healthToAddFoodMom" {
            let addFoodVC = segue.destination as! AddFoodViewController
            addFoodVC.Sender = "mom"
        }
     
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //registering instance of userDefaults
        statResetter()
        nutritionSetter()
        //applying some css to the two UIView
        //applying some ios kinda styles to the babyView
        babyView.layer.shadowColor = UIColor.gray.cgColor
        babyView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        babyView.layer.shadowRadius = 12.0
        babyView.layer.shadowOpacity = 0.9
        babyView.layer.cornerRadius = 15.0
        //applying some styles to the momView
        momView.layer.shadowColor = UIColor.gray.cgColor
        momView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        momView.layer.shadowRadius = 12.0
        momView.layer.shadowOpacity = 0.9
        momView.layer.cornerRadius = 15.0
      
   
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        statResetter()
        nutritionSetter()
    }

    @IBOutlet weak var babyView: UIView!
    @IBOutlet weak var momView: UIView!
    
    
    
    //strong debugging required
    func statResetter() {
        //print("start resetter")
        let userDefaults = UserDefaults.standard
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "EEEE"//"EE" to get short style
        let dayInWeek = dateFormatter.string(from: date as Date)
        //for setting for the FirstTime run
        let Today = userDefaults.string(forKey: "Today")
        print("before nil ")
        if(Today == nil) {
            print("if for seting today called")
            userDefaults.set(dayInWeek, forKey: "Today")
            UserDefaults(suiteName: "group.addFoodIntent.test")!.set(0.0, forKey: "carboHydratesForBaby")
            UserDefaults(suiteName: "group.addFoodIntent.test")!.set(0.0, forKey: "FatForBaby")
            UserDefaults(suiteName: "group.addFoodIntent.test")!.set(0.0, forKey: "IronForBaby")
            UserDefaults(suiteName: "group.addFoodIntent.test")!.set(0.0, forKey: "calciumForBaby")
            UserDefaults(suiteName: "group.addFoodIntent.test")!.set(0.0, forKey: "TotalCaloriesForBaby")
            UserDefaults(suiteName: "group.addFoodIntent.test")!.set(0.0, forKey: "TotalCaloriesForMom")

        }

        let secondCondition = userDefaults.string(forKey: "Today")
        if(secondCondition != dayInWeek) {
            print("if called")
            UserDefaults(suiteName: "group.addFoodIntent.test")!.set(0.0, forKey: "carboHydratesForBaby")
            UserDefaults(suiteName: "group.addFoodIntent.test")!.set(0.0, forKey: "FatForBaby")
            UserDefaults(suiteName: "group.addFoodIntent.test")!.set(0.0, forKey: "IronForBaby")
            UserDefaults(suiteName: "group.addFoodIntent.test")!.set(0.0, forKey: "calciumForBaby")
            UserDefaults(suiteName: "group.addFoodIntent.test")!.set(0.0, forKey: "TotalCaloriesForBaby")
            UserDefaults(suiteName: "group.addFoodIntent.test")!.set(0.0, forKey: "TotalCaloriesForMom")

            userDefaults.set(dayInWeek, forKey: "Today")
            
            
        }
        
    }
    
    func nutritionSetter() {
       // print("nutrition setter called")
       // let UserDefaults = UserDefaults.standard
        babyCalcium.text = String(UserDefaults(suiteName: "group.addFoodIntent.test")!.double(forKey: "calciumForBaby"))
        babyFat.text = String(UserDefaults(suiteName: "group.addFoodIntent.test")!.double(forKey: "FatForBaby"))
        babyIron.text =  String(UserDefaults(suiteName: "group.addFoodIntent.test")!.double(forKey: "IronForBaby"))
        babyCarbo.text = String(UserDefaults(suiteName: "group.addFoodIntent.test")!.double(forKey: "carboHydratesForBaby"))
      
        babyTotalCalories.text =   String(UserDefaults(suiteName: "group.addFoodIntent.test")!.double(forKey: "TotalCaloriesForBaby"))
        momTotalConsumed.text = String(UserDefaults(suiteName: "group.addFoodIntent.test")!.double(forKey: "TotalCaloriesForMom"))
       // print(userDefaults.string(forKey: "FatForBaby"))
        
    }
 
}
