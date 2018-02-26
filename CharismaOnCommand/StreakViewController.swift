//
//  StreakViewController.swift
//  CharismaOnCommand
//
//  Created by Oliver Morland on 07/02/2018.
//  Copyright © 2018 Oliver Morland. All rights reserved.
//

import UIKit

class StreakViewController: UIViewController {
    
    var Streak = 1
    var LastActionDate = Date()
    var NowActionDate = Date()
    let StreakLabel = UILabel()


    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        //Loading the last time the user performed an action from the app
        guard let TheLastActionDate = UserDefaults.standard.object(forKey: "LastActionDate") else{
            print("No date present")
            return
        }
        LastActionDate = TheLastActionDate as! Date
 */
        //Configuring the Label
        let Width : CGFloat = 100
        let Height : CGFloat = 100
        StreakLabel.frame = CGRect(x: (view.frame.width/2)-(Width/2), y: (view.frame.height/2)-(Height/2), width: Width, height: Height)
        StreakLabel.textAlignment = .center
        StreakLabel.textColor = UIColor.white
        StreakLabel.font = UIFont(name: "Avenir", size: 60)
        StreakLabel.text = "\(Streak)"
        view.addSubview(StreakLabel)
        
        //Configuring the button
        let Button = UIButton()
        let ButtonWidth : CGFloat = 100
        let ButtonHeight : CGFloat = 30
        Button.frame = CGRect(x: (view.frame.width/2)-(ButtonWidth/2), y: (view.frame.height * 3/4)-(ButtonHeight/2), width: ButtonWidth, height: ButtonHeight)
        Button.setTitle("Button", for: .normal)
        Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
        view.addSubview(Button)
        
        
        //Loading the  User streak count
        Streak = UserDefaults.standard.integer(forKey: "Streak")
        StreakLabel.text = "\(Streak)"
        
        
        //Loading the last date-time the user performed an action from the app
        guard let TheLastActionDate = UserDefaults.standard.object(forKey: "LastActionDate") else{
            print("No date present")
            return
        }
         
        LastActionDate = TheLastActionDate as! Date
        print("LastActionDate:\(LastActionDate)")
        
            
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func ButtonAction(){
        
        //Setting NowActionDate to be the current time
        NowActionDate = Date()
        
        //Calculating the difference in seconds between the times
        let TimeDifference = NowActionDate.timeIntervalSince(LastActionDate)
        print("Time Difference: \(TimeDifference)")
        
        //Setting the limit
        let TimeLimit : Double = 120
        
        if TimeDifference < TimeLimit{
            Streak = Streak + 1
        }
        else{
            Streak = 1
        }
        
        //Update Streak Label
        StreakLabel.text = "\(Streak)"
        
        //Resetting LastActionDate
        LastActionDate = NowActionDate
        
        //Save new Action Date as Last Action Date for next time
        UserDefaults.standard.set(NowActionDate, forKey: "LastActionDate")
        
        //Save the new streak count
        UserDefaults.standard.set(Streak, forKey: "Streak")
        
        
    }
    

}
