//
//  MindFullNessViewController.swift
//  BEABoxer
//
//  Created by Vishwas on 09/12/18.
//  Copyright © 2018 apollo INC. All rights reserved.
//

import UIKit
import AVFoundation
import HealthKit
import Comets

class MindFullNessViewController: UIViewController {
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    let healthStore = HKHealthStore()
    let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession)
    var player: AVAudioPlayer?
    var startTime = Date()
    @IBOutlet weak var windBlurView: UIVisualEffectView!
    @IBOutlet weak var ambienceBlurView: UIVisualEffectView!
    @IBOutlet weak var riverBlurView: UIVisualEffectView!
    @IBOutlet weak var rainBlurView: UIVisualEffectView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = windBlurView.bounds.width
        let height = ambienceBlurView.bounds.height
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
            windBlurView.layer.addSublayer(comet.drawLine())
            windBlurView.layer.addSublayer(comet.animate())
            ambienceBlurView.layer.addSublayer(comet.drawLine())
            ambienceBlurView.layer.addSublayer(comet.animate())
            riverBlurView.layer.addSublayer(comet.drawLine())
            riverBlurView.layer.addSublayer(comet.animate())
            rainBlurView.layer.addSublayer(comet.drawLine())
            rainBlurView.layer.addSublayer(comet.animate())
            
            
        }
        windBlurView.layer.cornerRadius = 20.0
        ambienceBlurView.layer.cornerRadius = 20.0
        riverBlurView.layer.cornerRadius = 20.0
        rainBlurView.layer.cornerRadius = 20.0
        
        
        self.activateHealthKit()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "clouds.jpg")!)
       // Do any additional setup after loading the view.
        // 1. create a gesture recognizer (tap gesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleRain(sender:)))
        let tapGestureForAmbience = UITapGestureRecognizer(target: self, action: #selector(handleAmbience(sender:)))
         let tapGestureForRiver = UITapGestureRecognizer(target: self, action: #selector(handleRiver(sender:)))
        let tapGestureForWind = UITapGestureRecognizer(target: self, action: #selector(handleWind(sender:)))

        
        // 2. add the gesture recognizer to a view
       rainBlurView.addGestureRecognizer(tapGesture)
       ambienceBlurView.addGestureRecognizer(tapGestureForAmbience)
        riverBlurView.addGestureRecognizer(tapGestureForRiver)
        windBlurView.addGestureRecognizer(tapGestureForWind)

    }
    
    
    
    // GestureRecognizer
    @objc func handleWind(sender: UITapGestureRecognizer) {
        startTime = Date()
        print("tapped")
        self.playWind()
    }
    @objc func handleRain(sender: UITapGestureRecognizer) {
        startTime = Date()
        print("tapped")
        self.playRain()
    }
    @objc func handleRiver(sender: UITapGestureRecognizer) {
        startTime = Date()
        print("tapped")
        self.playRiver()
    }
    @objc func handleAmbience(sender: UITapGestureRecognizer) {
        startTime = Date()
        print("tapped")
        self.playAmbience()
    }
    func playWind() {
        guard let url = Bundle.main.url(forResource: "Wind", withExtension: "mp3") else { return }
        
        do {
            
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            
            guard let player = player else { return }
            player.numberOfLoops = -1
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func playRiver() {
        guard let url = Bundle.main.url(forResource: "River", withExtension: "mp3") else { return }
        
        do {
            
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            
            guard let player = player else { return }
            player.numberOfLoops = -1
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func playRain() {
        guard let url = Bundle.main.url(forResource: "rain", withExtension: "mp3") else { return }
        
        do {
           
            try AVAudioSession.sharedInstance().setActive(true)
     
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
       
            
            guard let player = player else { return }
            player.numberOfLoops = -1
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func playAmbience() {
        guard let url = Bundle.main.url(forResource: "rural_ambience", withExtension: "mp3") else { return }
        
        do {
            
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            
            guard let player = player else { return }
            player.numberOfLoops = -1
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    @IBAction func updateMindfullTime(_ sender: Any) {
        player?.stop()
        let endTime = Date()
        print(endTime)
        let mindfullSample = HKCategorySample(type:mindfulType!, value: 0, start: startTime, end: endTime)
        
        // Save it to the health store
        healthStore.save(mindfullSample, withCompletion: { (success, error) -> Void in
            if error != nil {
                
                print("data get Failes")
                let alert = UIAlertController(title: "Error", message: "Try again", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                return
                
            }
            let alert = UIAlertController(title: "Added", message: "Mindfulness added SuccessFully", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            print("New data was saved in HealthKit: \(success)")
        })
        
    }
    func activateHealthKit() {
        // Define what HealthKit data we want to ask to read
        let typestoRead = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!
            ])
        
        // Define what HealthKit data we want to ask to write
        let typestoShare = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!
            ])
        
        // Prompt the User for HealthKit Authorization
        self.healthStore.requestAuthorization(toShare: typestoShare, read: typestoRead) { (success, error) -> Void in
            if !success{
                print("HealthKit Auth error\(error)")
            }
        }
    }
}
