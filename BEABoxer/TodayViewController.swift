//
//  TodayViewController.swift
//  BEABoxer
//
//  Created by Vishwas on 02/11/18.
//  Copyright © 2018 apollo INC. All rights reserved.
//

import UIKit
import HealthKit
import Colorify
import Comets
import GradientKit


class TodayViewController: UIViewController{
    let healthKitStore:HKHealthStore = HKHealthStore()
    var darkCyan = UIColor(red:0.30, green:0.77, blue:0.75, alpha:1.0)
    var lightcyan = UIColor(red:0.56, green:0.99, blue:0.94, alpha:1.0)
    var darkRed = UIColor(red:0.90, green:0.13, blue:0.15, alpha:1.0)
    var lightRed = UIColor(red:0.90, green:0.24, blue:0.58, alpha:1.0)
    var lime = UIColor(red:0.81, green:0.98, blue:0.23, alpha:1.0)
    ///labels for autoShrinking programtically
    @IBOutlet weak var mindfullnessLabel: UILabel!
    @IBOutlet weak var activeEnergyLabel: UILabel!
    @IBOutlet weak var sleepLabel: UILabel!
    @IBOutlet weak var sleepAdvice: UILabel!
    @IBOutlet weak var meditationAdvice: UILabel!
    
    @IBOutlet weak var realMindFullView: UIView!
    @IBOutlet weak var mindFullnessMinutes: UILabel!
    @IBOutlet weak var greetings: UILabel!
    @IBOutlet weak var sleepAnalysisView: UIView!
    @IBOutlet weak var MindFullNessView: UIView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var TodayDate: UILabel!
    
    //button outlets
    @IBOutlet weak var meditateButton: UIButton!
    @IBOutlet weak var AEButton: UIButton!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.authorizeHealthKit()
        print("View Did Appear called")
        self.retrieveSleepAnalysis()
        self.retrieveMindFullSessio()
        self.secondLabel.text = String(UserDefaults(suiteName: "group.addFoodIntent.test")!.double(forKey: "TotalCaloriesForMom"))
        
    }
    
    
    //Onload Function thid function will be called when the page loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sleepGradient = LinearGradientLayer(direction: .horizontal)
        sleepGradient.colors = [.green, .yellow]
        let h = sleepAnalysisView.frame.size.height
        let w = sleepAnalysisView.frame.size.width
        sleepGradient.frame =  CGRect(x: 0, y: 0, width: w, height: h)
        sleepAnalysisView.layer.insertSublayer(sleepGradient, at: 0)
        
        let activeEnergyGradient = LinearGradientLayer(direction: .horizontal)
        activeEnergyGradient.colors = [darkRed, lightRed]
        let hOfAE = MindFullNessView.frame.size.height
        let wOfAE = MindFullNessView.frame.size.width
        activeEnergyGradient.frame =  CGRect(x: 0, y: 0, width: wOfAE, height: hOfAE)
        MindFullNessView.layer.insertSublayer(activeEnergyGradient, at: 0)
        
        let mindfulnessGradient = LinearGradientLayer(direction: .horizontal)
        mindfulnessGradient.colors = [darkCyan, lightcyan]
        let hOfM = realMindFullView.frame.size.height
        let wOfM = realMindFullView.frame.size.width
        mindfulnessGradient.frame =  CGRect(x: 0, y: 0, width: wOfM, height: hOfM)
        realMindFullView.layer.insertSublayer(mindfulnessGradient, at: 0)
        
        
        let ActiveEnergyGradientlayer = CAGradientLayer()
        ActiveEnergyGradientlayer.frame = MindFullNessView.bounds
        ActiveEnergyGradientlayer.colors = [darkRed,lightRed]
        ActiveEnergyGradientlayer.startPoint = CGPoint.zero
        ActiveEnergyGradientlayer.cornerRadius = 15.0
        ActiveEnergyGradientlayer.endPoint = CGPoint(x: 1, y: 2)
        MindFullNessView.layer.insertSublayer(ActiveEnergyGradientlayer, at: 0)
        
        let mindFullnessGradientlayer = CAGradientLayer()
        mindFullnessGradientlayer.frame = realMindFullView.bounds
        mindFullnessGradientlayer.colors = [darkCyan,lightcyan]
        mindFullnessGradientlayer.startPoint = CGPoint.zero
        mindFullnessGradientlayer.cornerRadius = 15.0
        mindFullnessGradientlayer.endPoint = CGPoint(x: 1, y: 0)
        realMindFullView.layer.insertSublayer(mindFullnessGradientlayer, at: 0)
        
        //sleepAnalysisView.layer.addSublayer(layer)
        self.secondLabel.text = String(UserDefaults(suiteName: "group.addFoodIntent.test")!.double(forKey: "TotalCaloriesForMom"))
        let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
        sleepLabel.numberOfLines = 1
        sleepLabel.adjustsFontSizeToFitWidth = true
        sleepLabel.minimumScaleFactor = 0.3
        activeEnergyLabel.numberOfLines = 1
        activeEnergyLabel.adjustsFontSizeToFitWidth = true
        activeEnergyLabel.minimumScaleFactor = 0.3
        mindfullnessLabel.numberOfLines = 1
        mindfullnessLabel.adjustsFontSizeToFitWidth = true
        mindfullnessLabel.minimumScaleFactor = 0.5
        firstLabel.numberOfLines = 1
        firstLabel.adjustsFontSizeToFitWidth = true
        firstLabel.minimumScaleFactor = 0.3
        secondLabel.numberOfLines = 1
        secondLabel.adjustsFontSizeToFitWidth = true
        secondLabel.minimumScaleFactor = 0.3
        mindFullnessMinutes.numberOfLines = 1
        mindFullnessMinutes.adjustsFontSizeToFitWidth = true
        mindFullnessMinutes.minimumScaleFactor = 0.3
        //applying the cornerRadius
        self.realMindFullView.layer.cornerRadius = 15.0
        self.sleepAnalysisView.layer.cornerRadius = 15.0
        self.MindFullNessView.layer.cornerRadius = 15.0
        //applying shadow
        realMindFullView.layer.shadowColor = UIColor.black.cgColor
        realMindFullView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        realMindFullView.layer.shadowOpacity = 0.6
        realMindFullView.layer.shadowRadius = 4.0
        sleepAnalysisView.layer.shadowColor = UIColor.black.cgColor
        sleepAnalysisView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        sleepAnalysisView.layer.shadowOpacity = 0.7
        sleepAnalysisView.layer.shadowRadius = 4.0
        MindFullNessView.layer.shadowColor = UIColor.black.cgColor
        MindFullNessView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        MindFullNessView.layer.shadowOpacity = 0.7
        MindFullNessView.layer.shadowRadius = 4.0
        //applying gradient using Colorify
        
        //calculating the day in string
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "EEEE"//"EE" to get short style
        let dayInWeek = dateFormatter.string(from: date as Date)
        TodayDate.text = dayInWeek
        //calling the function
        self.authorizeHealthKit()
        self.retrieveSleepAnalysis()
        //self.readStepCount()
        self.retrieveMindFullSessio()
        // Customize your comet for the particle session
        let width = MindFullNessView.bounds.width
        let height = MindFullNessView.bounds.height
        let comets = [Comet(startPoint: CGPoint(x: 100, y: 0),
                            endPoint: CGPoint(x: 0, y: 100),
                            lineColor: UIColor.black.withAlphaComponent(0.45)),
                      Comet(startPoint: CGPoint(x: 0.4 * width, y: 0),
                            endPoint: CGPoint(x: width, y: 0.8 * width),
                            lineColor: UIColor.black.withAlphaComponent(0.45)),
                      Comet(startPoint: CGPoint(x: 0.8 * width, y: 0),
                            endPoint: CGPoint(x: width, y: 0.2 * width),
                            lineColor: UIColor.black.withAlphaComponent(0.45)),
                      Comet(startPoint: CGPoint(x: width, y: 0.2 * height),
                            endPoint: CGPoint(x: 0, y: 0.25 * height),
                            lineColor: UIColor.black.withAlphaComponent(0.45)),
                      Comet(startPoint: CGPoint(x: 0, y: height - 0.8 * width),
                            endPoint: CGPoint(x: 0.6 * width, y: height),
                            lineColor: UIColor.black.withAlphaComponent(0.45)),
                      Comet(startPoint: CGPoint(x: width - 100, y: height),
                            endPoint: CGPoint(x: width, y: height - 100),
                            lineColor: UIColor.black.withAlphaComponent(0.45)),
                      Comet(startPoint: CGPoint(x: 0, y: 0.8 * height),
                            endPoint: CGPoint(x: width, y: 0.75 * height),
                            lineColor: UIColor.black.withAlphaComponent(0.45))]
        // draw track and animate
        for comet in comets {
            MindFullNessView.layer.addSublayer(comet.drawLine())
            MindFullNessView.layer.addSublayer(comet.animate())
            sleepAnalysisView.layer.addSublayer(comet.drawLine())
            sleepAnalysisView.layer.addSublayer(comet.animate())
            realMindFullView.layer.addSublayer(comet.drawLine())
            realMindFullView.layer.addSublayer(comet.animate())
            
            
        }
        
        //applying motionEffects
        
        
        let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = CGFloat(-12)
        xMotion.maximumRelativeValue = CGFloat(12)
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = CGFloat(-12)
        yMotion.maximumRelativeValue = CGFloat(12)
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [xMotion,yMotion]
        sleepAnalysisView.addMotionEffect(motionEffectGroup)
        mindfullnessLabel.addMotionEffect(motionEffectGroup)
        realMindFullView.addMotionEffect(motionEffectGroup)
        //motionEffect for labels
        
        
        
        
    }
    
    //authorizing the healthKit
    func authorizeHealthKit() {
        let healthKitTypesToRead:Set<HKObjectType> = [HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!,HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!]
        let healthKitTypesToWrite:Set<HKSampleType> = []
        if !HKHealthStore.isHealthDataAvailable() {
            print("error occured on health data availabilty")
            self.showNilError()
            
        }
        healthKitStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) {
            (success,error) -> Void in
            print("autorization success")
            //self.readActiveEnergy()
            self.retrieveSleepAnalysis()
            ///self.readStepCount()
            self.retrieveMindFullSessio()
            
            
            
        }
    }
    
    
    func showNilError() {
        let alert = UIAlertController(title: "No Health Data Found", message: "There was no Data found.It may be the Permision Issue. Please go to the settings app (Privacy -> HealthKit) to change this.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Go to settings", style: .default, handler:  { action in
            if let url = URL(string:UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }            }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //retrievnig sleeping minutes
    func retrieveSleepAnalysis() {
        print("retrieve SleepAnalysis")
        //showing the spinner
        
        
        // first, we define the object type we want
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            let endDate = Date()
            let startDate = endDate.addingTimeInterval(-1.0 * 60.0 * 60.0 * 24.0)
            print(endDate)
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
            // Use a sortDescriptor to get the recent data first
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            
            // we create our query with a block completion to execute
            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
                
                if error != nil {
                    self.showNilError()
                    // something happened
                    print("errorOccured")
                    print("sleep failure animation************************************")
                    
                    
                    return
                    
                }
                
                if let result = tmpResult {
                    if result.count == 0 {
                        DispatchQueue.main.async {
                            self.showNilError()
                        }
                    }
                    // do something with my data
                    for item in result {
                        if let sample = item as? HKCategorySample {
                            let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "InBed" : "Asleep"
                            let totalMeditationTime = tmpResult?.map(self.calculateTotalTime).reduce(0, { $0 + $1 }) ?? 0
                            let minutes = Int(totalMeditationTime / 60)
                            
                            print(sample.endDate)
                            let formatter = DateComponentsFormatter()
                            let now = Date()
                            formatter.unitsStyle = .full
                            formatter.allowedUnits = [ .hour, .minute, .second]
                            formatter.maximumUnitCount = 2   // often, you don't care about seconds if the elapsed time is in months, so you'll set max unit to whatever is appropriate in your case
                            print("formatted Hourrs*********")
                            
                            let formatterHours = DateComponentsFormatter()
                            formatterHours.unitsStyle = .full
                            formatterHours.allowedUnits = [.hour]
                            formatterHours.maximumUnitCount = 2
                            let hour = formatterHours.string(from:sample.startDate,to: sample.endDate)
                            print("print")
                            print(hour)
                            
                            
                            let string = formatter.string(from: sample.startDate, to: sample.endDate)
                            //print("Healthkit sleep: \(sample.startDate) \(sample.endDate) - value: \(value)")
                            print("this is the value of date")
                            print(string)
                            
                            
                            
                            
                            DispatchQueue.main.async(execute : {() -> Void in
                                let myCalendar = Calendar(identifier: .gregorian)
                                let weekDayFromHealthKkit = myCalendar.component(.weekday, from: sample.endDate)
                                
                                let weekDayNow = myCalendar.component(.weekday, from: sample.endDate)
                                //
                                if weekDayFromHealthKkit == weekDayNow {
                                    print("******** if called *********")
                                    self.firstLabel.text = string
                                    print("sleep success animation************************************")
                                    
                                }
                            });
                            
                        }
                    }
                }
                
                
                
            }
            
            // finally, we execute our query
            healthKitStore.execute(query)
        }
    }
    
    //retrieving the mindfullSession
    func retrieveMindFullSessio() {
        //showing the spinner
        
        // first, we define the object type we want
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession) {
            let endDate = Date()
            let startDate = endDate.addingTimeInterval(-1.0 * 60.0 * 60.0 * 24.0)
            print(endDate)
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
            // Use a sortDescriptor to get the recent data first
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            
            // we create our query with a block completion to execute
            let query = HKSampleQuery(sampleType: sleepType, predicate:predicate, limit: 30, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
                
                if error != nil {
                    
                    // something happened
                    print("errorOccured")
                    print("mindfullness failure animation************************************")
                    return
                    
                    
                    
                }
                let totalMeditationTime = tmpResult?.map(self.calculateTotalTime).reduce(0, { $0 + $1 }) ?? 0
                
                let minutes = Int(totalMeditationTime / 60)
                DispatchQueue.main.async {
                   
                    if minutes < 10 {
                        self.meditationAdvice.text = "MEDITATE MORE"
                    }
                    else {
                        self.meditationAdvice.text = "MEDITATION IS ENOUGH"
                    }
                    let labelText = "\(minutes) Minutes"
                    self.mindFullnessMinutes.text = labelText
                                    }
            }
            
            // finally, we execute our query
            healthKitStore.execute(query)
        }
    }
    func calculateTotalTime(sample: HKSample) -> TimeInterval {
        let totalTime = sample.endDate.timeIntervalSince(sample.startDate)
        let wasUserEntered = sample.metadata?[HKMetadataKeyWasUserEntered] as? Bool ?? false
        
        print("\nHealthkit mindful entry: \(sample.startDate) \(sample.endDate) - value: \(totalTime) quantity: \(totalTime) user entered: \(wasUserEntered)\n")
        
        return totalTime
    }
    
}









