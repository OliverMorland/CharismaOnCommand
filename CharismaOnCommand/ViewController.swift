//
//  ViewController.swift
//  CharismaOnCommand
//
//  Created by Oliver Morland on 19/12/2017.
//  Copyright © 2017 Oliver Morland. All rights reserved.
//

import UIKit
import UserNotifications

//Key Variables
var ActionDescription = String()
var When = String()
var SelectedTime = Date()

class ViewController: UIViewController, UITextFieldDelegate {
    
    //Storyboard Connector
    @IBOutlet weak var HorizontalScrollView: UIScrollView!
    @IBOutlet weak var VerticalScrollView: UIScrollView!
    
    let AnimationDuration : Double = 1
    
    //UI Objects
    var ConfirmationText = UILabel()
    var ActionDescriptionLabel = UILabel()
    var ActionDescriptionTextField = UITextField()
    var WhenLabel = UILabel()
    var WhenTextField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setting Defaults
        print(UserDefaults.standard.bool(forKey: "MissionIsPending"))
        
        //Setting up Vertical Scroll View
        VerticalScrollView.contentSize.height = view.frame.height + 100
        
        //Setting up Horizontal Scroll View
        let ScreenWidth = view.frame.width
        HorizontalScrollView.contentSize = CGSize(width: ScreenWidth*3, height: 250)
        
        //Configure Tap Gesture
        let Tap = UITapGestureRecognizer(target: self, action: #selector(CloseKeyboard))
        view.addGestureRecognizer(Tap)
        
        //Setting Animation Time
        let AnimationTime : Double = 0.5
        
        //Requesting permission for User Notifications
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
        
        //Enter Intro Text
        //AnimateMissionImpossibleLetter()
        ConfigureActionText(FontSize: 25, FontFamily: "Avenir", Message: "What will you do?", Elevation: 45)
        ConfigureWhenSection(FontSize: 25, FontFamily: "Avenir", Message: "When will you do it?", Elevation: 45)
        ConfigureConfirmationText(FontSize: 20, FontFamily: "Avenir", Message: "Complete all fields before setting a notification", Elevation: 20, ButtonElevation: -50, ButtonWidth: 100, ButtonHeight: 60)
        view.bringSubview(toFront: VerticalScrollView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        /*
        if UserDefaults.standard.bool(forKey: "MissionIsPending") == true{
            performSegue(withIdentifier: "ToActionPendingView", sender: self)
        }
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Configuring Confirmation Text
    func ConfigureConfirmationText(FontSize: CGFloat, FontFamily: String, Message: String, Elevation: CGFloat, ButtonElevation: CGFloat, ButtonWidth: CGFloat, ButtonHeight: CGFloat){
        
        //Configuring Dimensions
        let ParentFrame = HorizontalScrollView.frame
        let ViewWidth = view.frame.width
        let LabelHeight : CGFloat = 100
        let LabelWidth : CGFloat = view.frame.width-20
        ConfirmationText.frame = CGRect(x: ((ViewWidth)*5/2)-(LabelWidth/2), y: (ParentFrame.height/2)-(LabelHeight/2)-(Elevation), width: LabelWidth, height: LabelHeight)
        HorizontalScrollView.addSubview(ConfirmationText)
        
        //Configuring Content
        ConfirmationText.text = Message
        ConfirmationText.textColor = UIColor.white
        //IntroText.backgroundColor = UIColor.red
        ConfirmationText.textAlignment = NSTextAlignment.center
        ConfirmationText.numberOfLines = 3
        ConfirmationText.font = UIFont(name: FontFamily, size: FontSize)
        
        //Configuring Confirmation Button
        let ConfirmationButton = UIButton()
        ConfirmationButton.frame = CGRect(x: ((ViewWidth)*5/2)-(ButtonWidth/2), y: (ParentFrame.height/2)-(ButtonHeight/2)-(ButtonElevation), width: ButtonWidth, height: ButtonHeight)
        ConfirmationButton.setTitle("Confirm", for: .normal)
        ConfirmationButton.layer.borderColor = UIColor.white.cgColor
        ConfirmationButton.layer.borderWidth = 2
        ConfirmationButton.layer.cornerRadius = 4
        ConfirmationButton.addTarget(self, action: #selector(ConfirmButtonPressed), for: .touchUpInside)
        HorizontalScrollView.addSubview(ConfirmationButton)
        
        
    }//End Configuring Of Intro Text
    
    
    //Configuring Action Section
    func ConfigureActionText(FontSize: CGFloat, FontFamily: String, Message: String, Elevation: CGFloat){
        
        //Configuring Dimensions
        let ParentFrame = HorizontalScrollView.frame
        let ViewWidth = view.frame.width
        let LabelHeight : CGFloat = 100
        let LabelWidth : CGFloat = view.frame.width
        ActionDescriptionLabel.frame = CGRect(x: ((ViewWidth)*1/2)-(LabelWidth/2), y: (ParentFrame.height/2)-(LabelHeight/2)-(Elevation), width: LabelWidth, height: LabelHeight)
        HorizontalScrollView.addSubview(ActionDescriptionLabel)
        
        //Configuring a Text Field
        let FieldHeight : CGFloat = 40
        let FieldWidth : CGFloat = view.frame.width - CGFloat(40)
        ActionDescriptionTextField.frame = CGRect(x: ((ViewWidth)*1/2)-(FieldWidth/2), y: (ParentFrame.height/2)-(FieldHeight/2), width: FieldWidth, height: FieldHeight)
        ActionDescriptionTextField.borderStyle = .roundedRect
        ActionDescriptionTextField.delegate = self
        ActionDescriptionTextField.placeholder = "I will give John a hug when I see him today"
        ActionDescriptionTextField.borderStyle = .roundedRect
        ActionDescriptionTextField.layer.borderColor = UIColor.white.cgColor
        ActionDescriptionTextField.backgroundColor = UIColor.clear
        ActionDescriptionTextField.textColor = UIColor.white
        ActionDescriptionTextField.layer.borderWidth = 2
        HorizontalScrollView.addSubview(ActionDescriptionTextField)
        
        //Configuring Content
        ActionDescriptionLabel.text = Message
        ActionDescriptionLabel.textColor = UIColor.white
        ActionDescriptionLabel.textAlignment = NSTextAlignment.center
        ActionDescriptionLabel.numberOfLines = 3
        ActionDescriptionLabel.font = UIFont(name: FontFamily, size: FontSize)
        
    }//End Configuring Of Action Text
    
    
    //Configuring When Section
    func ConfigureWhenSection(FontSize: CGFloat, FontFamily: String, Message: String, Elevation: CGFloat){
        
        //Configuring Dimensions
        let ParentFrame = HorizontalScrollView.frame
        let ViewWidth = view.frame.width
        let LabelHeight : CGFloat = 100
        let LabelWidth : CGFloat = view.frame.width
        WhenLabel.frame = CGRect(x: ((ViewWidth)*3/2)-(LabelWidth/2), y: (ParentFrame.height/2)-(LabelHeight/2)-(Elevation), width: LabelWidth, height: LabelHeight)
        HorizontalScrollView.addSubview(WhenLabel)
        
        //Configuring a Text Field
        let FieldHeight : CGFloat = 40
        let FieldWidth : CGFloat = view.frame.width - CGFloat(40)
        WhenTextField.frame = CGRect(x: ((ViewWidth)*3/2)-(FieldWidth/2), y: (ParentFrame.height/2)-(FieldHeight/2), width: FieldWidth, height: FieldHeight)
        WhenTextField.borderStyle = .roundedRect
        WhenTextField.delegate = self
        WhenTextField.placeholder = "13:45"
        WhenTextField.borderStyle = .roundedRect
        WhenTextField.layer.borderColor = UIColor.white.cgColor
        WhenTextField.layer.borderWidth = 2
        WhenTextField.backgroundColor = UIColor.clear
        WhenTextField.textColor = UIColor.white
        HorizontalScrollView.addSubview(WhenTextField)
        
        
        //Configuring Content
        WhenLabel.text = Message
        WhenLabel.textColor = UIColor.white
        WhenLabel.textAlignment = NSTextAlignment.center
        WhenLabel.numberOfLines = 3
        WhenLabel.font = UIFont(name: FontFamily, size: FontSize)
        
    }//End Configuring Of Action Text
    
    
    //Glide Left
    func GlideLeft(){
        let ScreenWidth = view.frame.width
        UIView.animate(withDuration: AnimationDuration) {
            self.HorizontalScrollView.contentOffset.x = self.HorizontalScrollView.contentOffset.x-ScreenWidth
        }
    }//End Slide Left
    
    
    //Glide Right
    func GlideRight(){
        let ScreenWidth = view.frame.width
        UIView.animate(withDuration: AnimationDuration) {
            self.HorizontalScrollView.contentOffset.x = self.HorizontalScrollView.contentOffset.x+ScreenWidth
        }
    }//End Glide Right
    

    //Tap Anywhere
    @objc func CloseKeyboard(){
        ActionDescriptionTextField.resignFirstResponder()
        WhenTextField.resignFirstResponder()
    }
    
    
    //When Text Field is tapped
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.VerticalScrollView.contentOffset.y = 100
        }
        
        //Add date picker input if it is the When text field
        if textField == WhenTextField{
            let DatePickerView : UIDatePicker = UIDatePicker()
            DatePickerView.datePickerMode = .time
            textField.inputView = DatePickerView
            DatePickerView.addTarget(self, action: #selector(DatePickerValueChanged), for: .valueChanged)
        }
    }
    
    
    //When editing finishes
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.VerticalScrollView.contentOffset.y = 0
        }) { (Bool) in
            self.GlideRight()
        }
        
        if ActionDescriptionTextField.text != "" && WhenTextField.text != ""{
            
            ActionDescription = ActionDescriptionTextField.text!
            When = WhenTextField.text!
            ConfirmationText.text = "Notification for\nAt \(When) \(ActionDescription)"
            ConfirmationText.text = "\(ActionDescription) at \(When)"
            
        }
        
        
    }
    
    
    //Date Picker Function
    @objc func DatePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        //dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.short
        WhenTextField.text = dateFormatter.string(from: sender.date)
        SelectedTime = sender.date
        print(SelectedTime)
        
    }
    
    
    //Confirm Button Pressed
    @objc func ConfirmButtonPressed(sender: UIButton){
        
        if ActionDescriptionTextField.text != "" && WhenTextField.text != ""{
            
            UserDefaults.standard.set(true, forKey: "MissionIsPending")
            UserDefaults.standard.set(ActionDescriptionTextField.text, forKey: "ActionDescription")
            
            ConfigureLocalNotification()
            performSegue(withIdentifier: "ToActionPendingView", sender: self)
        }
        
    }
    
    
    //Local Notifications
    func ConfigureLocalNotification(){
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Charisma Action Reminder"
        content.body = ActionDescription
        content.sound = UNNotificationSound.init(named: "Boom.mp3")
        
        let DateComponents = Calendar.current.dateComponents([.hour, .minute], from: SelectedTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    
    }
    
    
    //Animated Mission Impossible
    func AnimateMissionImpossibleLetter(){
        
        //Configure Letter
        let MissionLetter = UIImageView()
        MissionLetter.image = #imageLiteral(resourceName: "PaperTexture")
        
        //Configuring Envelope
        let MissionEnvelope = UIImageView()
        let EnvelopeWidth = view.frame.width-10
        MissionEnvelope.frame = CGRect(x: (view.frame.width/2)-(EnvelopeWidth/2), y: (view.frame.height)-(EnvelopeWidth * 3/4), width: EnvelopeWidth, height: EnvelopeWidth)
        MissionEnvelope.image = #imageLiteral(resourceName: "TopSecretEnvelope")
        MissionEnvelope.contentMode = .scaleAspectFit
        
        
        //Adding views in order
        view.addSubview(MissionEnvelope)
        
        
        //let MissionLetter = UIImageView()
        
    }
    
    
    
    
    
}

