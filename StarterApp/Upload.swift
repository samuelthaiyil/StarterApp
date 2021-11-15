//
//  Upload.swift
//  StarterApp
//
//  Created by Sam Thaiyil on 2021-05-07.
//

import UIKit
import PopupDialog
import Firebase
import AVKit

class Upload: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var uploadTitle: UITextField!
    @IBOutlet weak var jerseyNumber: UITextField!
    @IBOutlet weak var school: UITextField!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var uploadProgress: UIProgressView!
    var sportData: [String] = [String]()
    @IBOutlet weak var sport: UIPickerView!
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var playerLayer: AVPlayerLayer?
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var playerView: UIView!
    var selectedSport = "Baseball"
    var selectedPosition = "Pitcher"
    var positions: [String] = [String]()
    var SportSelection = (basketball: 1, baseball: 0, football : 2, hockey: 3, tennis: 4, multisport: 5)
    var videoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        UILabel.appearance().font = UIFont(name: "Raleway", size: 15)
        UITextField.appearance().font = UIFont(name: "Raleway", size: 15)
       
        self.uploadProgress.isHidden = true
        desc.text = "description of this post"
        sportData = ["Basketball", "Baseball", "Football", "Hockey", "Tennis"]
        positions = ["Pitcher", "Catcher", "First baseman", "Second baseman", "Third baseman", "Shortstop",
                             "Outfielder", "Center fielder", "Left fielder", "Right fielder", "Infielder",
                             "Designated hitter", "Starting pitcher", "Closer", "Relief pitcher", "Pinch hitter",
                             "Pinch runner","Utility player", "Middle relief pitcher","Setup man", "Point Guard", "Shooting Guard", "Small Forward", "Power Forward", "Center", "Offensive Tackle", "Offensive Guard", "Center", "Quarterback", "Running Back", "Wide Reciever", "Tight End", "Defensive Tackle", "Defensive End", "Middle Linebacker", "Outside Linebacker", "Cornerback", "Saftey", "Nickleback", "Dimeback", "Kicker", "Punter", "Right Wing", "Left Wing","Left Defence", "Right Defence", "Center", "Goalie", "N/A"]
        
        sportData = sportData.sorted(by: <)
        sport.delegate = self
        sport.dataSource = self
        desc.delegate = self
        sport.selectRow(0, inComponent: 0, animated: true)
        sport.selectRow(0, inComponent: 1, animated: true)
        
        
      if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                    imagePicker.delegate = self
                    imagePicker.sourceType = .savedPhotosAlbum
                    imagePicker.allowsEditing = false
        
                    // only allow videos to be selected
                    imagePicker.mediaTypes = ["public.movie"]

               present(imagePicker, animated: true, completion: nil)
        
                }else{
                    let popup = PopupDialog(title: "Uh oh", message: "We couldn't open your camera roll")
                   
                    let ok = DefaultButton(title: "OK")
                    {
                        return
                    }
                    popup.addButton(ok)
                    self.present(popup, animated: true)
                }

            }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
        return sportData.count
        }else{
            return positions.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
        return sportData[row]
        }else{
            return positions[row]
        }
       
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            if row == SportSelection.baseball {
                pickerView.selectRow(0, inComponent: 1, animated: true)
            }
            if row == SportSelection.basketball {
                pickerView.selectRow(20, inComponent: 1, animated: true)
            }
            if row == SportSelection.football{
                pickerView.selectRow(25, inComponent: 1, animated: true)
            }
            if row == SportSelection.hockey{
                pickerView.selectRow(42, inComponent: 1, animated: true)
            }
            if row == SportSelection.tennis{
                pickerView.selectRow(48, inComponent: 1, animated: true)
            }
        }
        selectedSport = sportData[pickerView.selectedRow(inComponent: 0)]
        selectedPosition = positions[pickerView.selectedRow(inComponent: 1)]
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            videoURL = url
            let playerItem = AVPlayerItem(url: url)
            self.player = AVPlayer()
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.playerLayer?.frame.size.height = playerView.bounds.height
            self.playerLayer?.frame.size.width = playerView.bounds.width
            self.playerLayer?.videoGravity = .resizeAspectFill
            self.player?.replaceCurrentItem(with: playerItem)
            self.player?.isMuted = true
            self.player?.automaticallyWaitsToMinimizeStalling = false
            self.playerItem?.preferredForwardBufferDuration = TimeInterval(5.0)
            self.player?.play()
            playerView.layer.addSublayer(self.playerLayer!)
            self.view.addSubview(playerView)
        }else{
            print("Failed to get url")
        }
        print("VIDEO URL: \(videoURL)")
        self.dismiss(animated: true, completion: nil)
        
    }

    func uploadDB(title: String, school: String, selectedSport: String, selectedPosition: String, description: String)
    {
        self.uploadProgress.isHidden = false
        let uid = Auth.auth().currentUser!.uid
        let date = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
        let ref =  Firestore.firestore().collection("Users").document(uid).collection("Posts").document()
        let storageRef = Storage.storage().reference().child("Users/" + uid + "/Posts/" + ref.documentID + ".mov")
        
        let uploadTask = storageRef.putFile(from: videoURL!.standardizedFileURL, metadata: nil) {
            metadata, error in
            if error != nil {
                print("UPLOAD ERROR: \(error?.localizedDescription ?? "error")")
                let popup = PopupDialog(title: "Uh oh", message: "We couldn't upload your file")
               
                let ok = DefaultButton(title: "OK")
                {
                    return
                }
                popup.addButton(ok)
                self.present(popup, animated: true)
            }else{
                ref.setData(
                ["title":title,
                 "school":school,
                 "description":description,
                 "sport":selectedSport,
                 "position":selectedPosition,
                 "date":date,
                 "id":ref.documentID,
                 "likes":0,
                 "comments":0,
                 "posterUID":uid])
            }
        }
        
        uploadTask.observe(.progress) {snapshot in
            UIView.animate(withDuration: 0.3) {
                self.uploadProgress.alpha = 1.0
            }
            let completion = Float((snapshot.progress!.completedUnitCount) / (snapshot.progress!.totalUnitCount))
            self.uploadProgress.setProgress(completion, animated: true)
            print(completion)
          }
        uploadTask.observe(.success) { snapshot in
            UIView.animate(withDuration: 0.3) {
                self.uploadProgress.alpha = 0.0
            }
        }
    }
    
    @IBAction func upload(_ sender: Any) {
        
        let selectedSport = selectedSport
        let selectedPosition = selectedPosition
        
        guard let uploadTitle = uploadTitle.text, let description = desc.text, let school = school.text else{
            let popup = PopupDialog(title: "Oops", message: "It seems you entered bad data")
            let ok = DefaultButton(title: "OK")
            {
               return
            }
           popup.addButton(ok)
           self.present(popup, animated: true)
           return
        }
      
        let popup = PopupDialog(title: "Oops", message: "Please choose a position relative to your sport")
    
        let ok = DefaultButton(title: "OK")
        {
            return
        }
        popup.addButton(ok)
       
        let baseballPositions = Array(positions[0...20])
        let basketballPositions = Array(positions[20...25])
        let footballPositions = Array(positions[25...42])
        let hockeyPositions = Array(positions[42...47])
        let other = "N/A"
        
        if selectedSport == "Baseball"
        {
            if !baseballPositions.contains(selectedPosition)
            {
                self.present(popup, animated: true)
            }else{
                uploadDB(title: uploadTitle, school: school, selectedSport: selectedSport, selectedPosition: selectedPosition, description: description)
            }
        }
        if selectedSport == "Basketball"
        {
            if !basketballPositions.contains(selectedPosition)
            {
                self.present(popup, animated: true)
            }else{
                uploadDB(title: uploadTitle, school: school, selectedSport: selectedSport, selectedPosition: selectedPosition, description: description)
            }
        }
        if selectedSport == "Football"
        {
            if !footballPositions.contains(selectedPosition)
            {
                self.present(popup, animated: true)
            }else{
                uploadDB(title: uploadTitle, school: school, selectedSport: selectedSport, selectedPosition: selectedPosition, description: description)
            }
        }
        if selectedSport == "Hockey"
        {
            if !hockeyPositions.contains(selectedPosition)
            {
                self.present(popup, animated: true)
            }else{
                uploadDB(title: uploadTitle, school: school, selectedSport: selectedSport, selectedPosition: selectedPosition, description: description)
            }
        }
        if selectedSport == "Tennis"
        {
            if selectedPosition != other
            {
                self.present(popup, animated: true)
            }else{
                uploadDB(title: uploadTitle, school: school, selectedSport: selectedSport, selectedPosition: selectedPosition, description: description)
            }
        }
      
    }
    
   
}
