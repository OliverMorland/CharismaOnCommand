//
//  RewardViewController.swift
//  CharismaOnCommand
//
//  Created by Oliver Morland on 10/01/2018.
//  Copyright © 2018 Oliver Morland. All rights reserved.
//

import UIKit
import AVFoundation

class RewardViewController: UIViewController {
    
    let DisplayLabel = UILabel()
    var DisplayText = String()
    var ImageView = UIImageView()
    var TimerCount = 0
    var GifNameArray = [String]()
    let Button1 = UIButton()
    let Button2 = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        GifNameArray = ["Victory", "SmallBombGif", "MissionAccomplished", "ObamaClaps", "Leo"]
        
        
        ConfigureDisplayLabel(Height: 200, yOffset: 30)
        ConfigureButtons(Height: 60, Width: 100, xOffset: 80, yOffset: -100)
        
        //Configuring Image View
        ImageView.frame = view.frame
        ImageView.isHidden = true
        ImageView.contentMode = .scaleAspectFit
        ImageView.backgroundColor = UIColor.black
        view.addSubview(ImageView)
        
        //Configuring Action Description
        ActionDescription = UserDefaults.standard.string(forKey: "ActionDescription")!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ConfigureDisplayLabel(Height: CGFloat, yOffset: CGFloat){
        
        let FrameWidth = view.frame.width
        let FrameHeight = Height
        DisplayLabel.frame = CGRect(x: 0, y: (view.frame.height/2)-(FrameHeight/2)-(yOffset), width: FrameWidth, height: FrameHeight)
        let Action = String(describing: UserDefaults.standard.string(forKey: "ActionDescription")!)
        DisplayLabel.text = "Did you succeed in your mission to \n\(Action)"
        DisplayLabel.font = UIFont(name: "Avenir", size: 22)
        DisplayLabel.textColor = UIColor.white
        DisplayLabel.textAlignment = .center
        DisplayLabel.numberOfLines = 3
        view.addSubview(DisplayLabel)
        
    }
    
    func ConfigureButtons(Height: CGFloat, Width: CGFloat, xOffset: CGFloat, yOffset: CGFloat){
        
        //Configuring Button 1
        Button1.frame = CGRect(x: (view.frame.width/2)-(Width/2)-xOffset, y: (view.frame.height/2)-(Height/2)-(yOffset), width: Width, height: Height)
        Button1.setTitle("I failed", for: .normal)
        Button1.layer.borderColor = UIColor.white.cgColor
        Button1.layer.borderWidth = 2
        Button1.layer.cornerRadius = 4
        Button1.addTarget(self, action: #selector(ShowReward(sender:)), for: .touchUpInside)
        view.addSubview(Button1)
        
        
        //Configuring Button 2
        Button2.frame = CGRect(x: (view.frame.width/2)-(Width/2)+xOffset, y: (view.frame.height/2)-(Height/2)-(yOffset), width: Width, height: Height)
        Button2.setTitle("I did it!", for: .normal)
        Button2.layer.borderColor = UIColor.white.cgColor
        Button2.layer.borderWidth = 2
        Button2.layer.cornerRadius = 4
        Button2.addTarget(self, action: #selector(ShowReward(sender:)), for: .touchUpInside)
        view.addSubview(Button2)
        
    }
    
    
    @objc func ReturnToMainView(sender: UIButton){
        
        performSegue(withIdentifier: "ReturnToMainView", sender: self)
        
        UserDefaults.standard.set(false, forKey: "MissionIsPending")
    }
    
    
    @objc func ShowReward(sender: UIButton){
        
        //Hide the Buttons
        Button1.isHidden = true
        Button2.isHidden = true
        
        //Update Streak
        UpdateStreak()
        
        //The Gif
        ImageView.isHidden = false
        UserDefaults.standard.set(false, forKey: "MissionIsPending")
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerCode), userInfo: nil, repeats: true)
        
        if sender.title(for: .normal) == "I did it!"{
            ImageView.loadGif(name: RandomlySelectingAGif())
        }
        else{
            ImageView.loadGif(name: "Failed")
        }
        
    }
    
    
    @objc func TimerCode(){
        TimerCount = TimerCount + 1
        if TimerCount > 6{
            performSegue(withIdentifier: "ReturnToMainView", sender: self)
        }
    }
    
    //Random selection of gif
    func RandomlySelectingAGif()->String{

        let Range = GifNameArray.count
        let RandomNumber = Int(arc4random_uniform(UInt32(Range)))
        let SelectedGif = GifNameArray[RandomNumber]
        
        return SelectedGif
    }
    
    
    //Updating the Streak
    func UpdateStreak(){
        
        //Setting NowActionDate to be the current time
        NowActionDate = Date()
        
        //Calculating the difference in seconds between the times
        let TimeDifference = NowActionDate.timeIntervalSince(LastActionDate)
        print("Time Difference: \(TimeDifference)")
        
        //Setting the limit
        let TimeLimit : Double = 129600
        let MinimumTimeLimit : Double = 54000
        
        if TimeDifference < TimeLimit && TimeDifference > MinimumTimeLimit {
            Streak = Streak + 1
        }
        if TimeDifference > TimeLimit{
            Streak = 1
        }
        
        //Resetting LastActionDate
        LastActionDate = NowActionDate
        
        //Save new Action Date as Last Action Date for next time
        UserDefaults.standard.set(NowActionDate, forKey: "LastActionDate")
        
        //Save the new streak count
        UserDefaults.standard.set(Streak, forKey: "Streak")
        
    }

}
