//
//  MenuViewController.swift
//  CharismaOnCommand
//
//  Created by Oliver Morland on 19/01/2018.
//  Copyright © 2018 Oliver Morland. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MessageUI

var Streak = 1
var LastActionDate = Date()
var NowActionDate = Date()

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    //2D Video Array
    /*
     First Immpressions
     
    */
    var SelectedModule : String = "First Impressions"
    var ModuleTitles = ["First Impressions", "Confidence", "Expert Conversation", "Storytelling", "Magnetic Presence", "Leadership"]
    var ModuleIcons = ["Icon1", "Icon2", "Icon3", "Icon4", "Icon5", "Icon6"]
    var DaysOfTheWeekArray = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    var VideoNameArray = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    
    @IBOutlet weak var ScrollView: UIScrollView!
    let StreakLabel = UILabel()
    let PlayButton = UIButton()
    let SegmentControl = UISegmentedControl(items: ["Mon", "Tue", "Wed", "Thu", "Fri"])
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configure Scroll View
        ScrollView.contentSize = CGSize(width: view.frame.width*3, height: ScrollView.frame.height)
        
        ConfiguringTableView()
        ConfigureSegmentControl(Width: 280, Height: 50, yOffset: 0)
        ConfigureButton(Width: 280, Height: 280, CornerRadius: 2, yOffset: 60, Title: "")
        ConfigureHabitLoopButton(Width: 280, Height: 50, CornerRadius: 5, yOffset: 350, Title: "Execute Action")
        ConfiguringStreakLabel()
        UpdateVideo()
        
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        //Updating Label
        StreakLabel.text = "\(Streak)"
        
        //Skip to Action Pending View
        if UserDefaults.standard.bool(forKey: "MissionIsPending") == true{
            performSegue(withIdentifier: "JumpToPendingView", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Animation to Video Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ModuleTitles.count
    }
    
    
    //Configures the Table View Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell : UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "MyCell")
        Cell.imageView?.image = UIImage(named: "\(ModuleIcons[indexPath.row])")
        Cell.textLabel?.text = ModuleTitles[indexPath.row]
        Cell.textLabel?.textColor = UIColor.white
        Cell.backgroundColor = UIColor.clear
        Cell.selectionStyle = .none
        
        return Cell
    }
    
    
    //Reduces the opacity of all unselected table view cells.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Cells = tableView.visibleCells
        
        for CurrentCell in Cells{
            
            //Unwrapping string
            let CurrentCellTitle : String = (CurrentCell.textLabel?.text)!
            
            //Make Cells Clear
            CurrentCell.alpha = 1.0
            
            //Make unselected cells Transparent
            if CurrentCellTitle != ModuleTitles[indexPath.row]{
                CurrentCell.alpha = 0.4
            }
        }
        
        //Updating Selected Module
        SelectedModule = ModuleTitles[indexPath.row]
        
        //Setting the video and thumbnail
        UpdateVideo()
        
        //Animating to next View
        UIView.animate(withDuration: 1) {
            self.ScrollView.contentOffset.x = self.view.frame.width * 2
        }
    }
    
    
    // Configuring Streak View Label
    func ConfiguringStreakLabel(){
        
        //Streak Label Description
        let DescriptionWidth : CGFloat = 200
        let DescriptionHeight : CGFloat = 40
        let DescriptionLabel = UILabel()
        DescriptionLabel.frame = CGRect(x: (view.frame.width/2)-(DescriptionWidth/2), y: 60, width: DescriptionWidth, height: DescriptionHeight)
        DescriptionLabel.textAlignment = .center
        DescriptionLabel.textColor = UIColor.white
        DescriptionLabel.font = UIFont(name: "Avenir", size: 25)
        DescriptionLabel.text = "Your streak"
        ScrollView.addSubview(DescriptionLabel)
        
        //Streak Label
        let Width : CGFloat = 100
        let Height : CGFloat = 100
        StreakLabel.frame = CGRect(x: (view.frame.width/2)-(Width/2), y: 120, width: Width, height: Height)
        StreakLabel.textAlignment = .center
        StreakLabel.textColor = UIColor.white
        StreakLabel.font = UIFont(name: "Avenir", size: 60)
        StreakLabel.text = "\(Streak)"
        StreakLabel.layer.borderColor = UIColor.white.cgColor
        StreakLabel.layer.borderWidth = 2
        ScrollView.addSubview(StreakLabel)
        
        //Days Label Description
        let DaysLabel = UILabel()
        DaysLabel.frame = CGRect(x: (view.frame.width/2)-(DescriptionWidth/2), y: 240, width: DescriptionWidth, height: DescriptionHeight)
        DaysLabel.textAlignment = .center
        DaysLabel.textColor = UIColor.white
        DaysLabel.font = UIFont(name: "Avenir", size: 25)
        DaysLabel.text = "Days"
        ScrollView.addSubview(DaysLabel)
        
    }
    
    
    //Configuring the details of the Table View
    func ConfiguringTableView(){
        
        let Table1 = UITableView()
        let Spacing : CGFloat = 20
        Table1.frame = CGRect(x: (view.frame.width), y: 0, width: ScrollView.frame.width, height: ScrollView.frame.height)
        Table1.backgroundColor = UIColor.clear
        Table1.separatorStyle = .none
        Table1.rowHeight = 100
        Table1.delegate = self
        Table1.dataSource = self
        Table1.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        ScrollView.addSubview(Table1)
        
    }
    
    
    //Configure the Play Button
    func ConfigureButton(Width: CGFloat, Height: CGFloat, CornerRadius: CGFloat, yOffset: CGFloat, Title: String){
        
        //Button setup
        PlayButton.frame.size = CGSize(width: Width, height: Height)
        PlayButton.frame = CGRect(x: (view.frame.width * 5/2)-(Width/2), y: yOffset, width: Width, height: Height)
        PlayButton.layer.borderColor = UIColor.white.cgColor
        PlayButton.layer.borderWidth = 1
        PlayButton.setTitle(Title, for: .normal)
        PlayButton.setTitleColor(UIColor.white, for: .normal)
        PlayButton.imageView?.image = UIImage(named: "First_Impressions_Monday")
        PlayButton.layer.cornerRadius = CornerRadius
        ScrollView.addSubview(PlayButton)
        
        //Button Action
        PlayButton.addTarget(self, action: #selector(LaunchVideoPlayer), for: .touchUpInside)
    }
    
    
    //Configuring the AV Video Player
    @objc func LaunchVideoPlayer(){
        
        /*
        guard let path = Bundle.main.path(forResource: VideoNameArray[SegmentControl.selectedSegmentIndex], ofType:"mp4") else {
            debugPrint("Video not found")
            return
        }
 */
        
        let ModuleNameWithoutSpaces : String = SelectedModule.replacingOccurrences(of: " ", with: "")
        let Day : String = DaysOfTheWeekArray[SegmentControl.selectedSegmentIndex]
        let VideoName = "\(ModuleNameWithoutSpaces)_\(Day)"
        let VideoURL = URL(string: "https://www.oliviermorlandblog.com/wp-content/uploads/2018/02/\(VideoName).mp4")
        
        
        //let Player = AVPlayer(url: URL(fileURLWithPath: path))
        let Player = AVPlayer(url: VideoURL!)
        let PlayerViewController = AVPlayerViewController()
        PlayerViewController.player = Player
        
        self.present(PlayerViewController, animated: true) {
            PlayerViewController.player?.play()
        }
        
    }
    
    
    //Configure the Habit Loop Button
    func ConfigureHabitLoopButton(Width: CGFloat, Height: CGFloat, CornerRadius: CGFloat, yOffset: CGFloat, Title: String){
        
        //Button setup
        let Button = UIButton()
        Button.frame.size = CGSize(width: Width, height: Height)
        Button.frame = CGRect(x: (view.frame.width * 5/2)-(Width/2), y: yOffset, width: Width, height: Height)
        Button.layer.borderColor = UIColor.white.cgColor
        Button.layer.borderWidth = 2
        Button.setTitle(Title, for: .normal)
        Button.setTitleColor(UIColor.white, for: .normal)
        Button.layer.cornerRadius = CornerRadius
        ScrollView.addSubview(Button)
        
        //Button Action
        Button.addTarget(self, action: #selector(SegueToHabitLoop), for: .touchUpInside)
    }
    
    
    //Function to segue to Habit Loop View Controller
    @objc func SegueToHabitLoop(){
        performSegue(withIdentifier: "ToHabitLoopView", sender: self)
    }
    
    
    //Configure Segment Control
    func ConfigureSegmentControl(Width: CGFloat, Height: CGFloat, yOffset: CGFloat){
        
        SegmentControl.frame = CGRect(x: (view.frame.width * 5/2)-(Width/2), y: yOffset, width: Width, height: Height)
        SegmentControl.backgroundColor = UIColor.clear
        SegmentControl.tintColor = UIColor.white
        SegmentControl.layer.borderColor = UIColor.white.cgColor
        ScrollView.addSubview(SegmentControl)
        
        
        SegmentControl.addTarget(self, action: #selector(UpdateVideo), for: .valueChanged)
        SegmentControl.selectedSegmentIndex = 0
        
    }
    
    
    //Segment Control Action
    @objc func UpdateVideo(){
        
        print("Selected Module: \(SelectedModule)")
        
        //Finding the image name
        let ModuleNameWithoutSpaces : String = SelectedModule.replacingOccurrences(of: " ", with: "")
        let Day : String = DaysOfTheWeekArray[SegmentControl.selectedSegmentIndex]
        let ImageName = "\(ModuleNameWithoutSpaces)_\(Day)"
        print("Image Name: \(ImageName)")
        
        //Setting the image
        let Image = UIImage(named: ImageName)
        
        PlayButton.setBackgroundImage(Image, for: .normal)
        
    }
    
    
    //Send feedback email
    @IBAction func FeedbackForm(_ sender: Any) {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["oliversimonedward@hotmail.co.uk"])
            mail.setSubject("Feedback on App")
            mail.setMessageBody("<p>Thank you form making this awesome app! I think it could be better by...</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    

}
