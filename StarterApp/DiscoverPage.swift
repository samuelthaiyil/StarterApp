//
//  DiscoverPage.swift
//  StarterApp
//
//  Created by Sam Thaiyil on 2021-05-04.
//

import UIKit
import AVKit
import Firebase
import SkeletonView

class Sport{
    var displayName: String
    var positions: [String]
    var sportName: String
    var isSelected: Bool
    
    init(displayName: String, positions: [String], sportName: String) {
        self.displayName = displayName
        self.positions = positions
        self.sportName = sportName
        self.isSelected = false
    }
}



class DiscoverPage: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    class Post{
        var desc: String
        var playerSchool: String
        var video: Data?
        var postID: String
        var likes: Int
        var comments: Int
        var position: String
        var posterUID: String
        var sport: String
        var isLiked: Bool
        
        init(desc: String, playerSchool: String, video: Data?, postID: String, likes: Int, comments: Int, position: String, posterUID: String, sport: String, isLiked: Bool)
        {
            self.desc = desc
            self.playerSchool = playerSchool
            self.video = video
            self.comments = comments
            self.likes = likes
            self.postID = postID
            self.position = position
            self.posterUID = posterUID
            self.sport = sport
            self.isLiked = isLiked
        }
    }
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var searchBarTV: UITableView!
    @IBOutlet weak var discoverPageCV: UICollectionView!
    @IBOutlet weak var basketball: UIButton!
    @IBOutlet weak var baseball: UIButton!
    @IBOutlet weak var tennis: UIButton!
    @IBOutlet weak var hockey: UIButton!
    @IBOutlet weak var football: UIButton!
    
    @IBOutlet weak var sportCV: UICollectionView!
    var usernames: [String] = []
    var feedPosts: [Post] = []
    var selectedPost: Post? = nil
    var sports: [Sport] = []
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return feedPosts.count
        }else{
            return usernames.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 1 {
            return CGFloat(600)
        }else{
            return  CGFloat(50)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchBarCell", for: indexPath) as? SearchBarCell
            guard usernames.indices.contains(indexPath.row) else {
                return cell!
            }
            
            cell?.username.text = usernames[indexPath.row]
    
            
            return cell!
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return self.sports.count
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sportSelectorCell", for: indexPath) as? SportSelectorCell
            
            cell!.sport.text = self.sports[indexPath.item].displayName
            
            return cell!
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "discoverPageCell", for: indexPath) as? DiscoverPageCell
            
            cell!.position.text = "Power Forward"
            
            return cell!
        }
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            let cell = collectionView.cellForItem(at: indexPath) as? SportSelectorCell
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            cell?.setLayout(isSelected: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            let cell = collectionView.cellForItem(at: indexPath) as? SportSelectorCell
            cell?.setLayout(isSelected: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            return CGSize(width: 124, height: 52)
        }
    return CGSize(width: 416, height: 589)
        
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 1 {
            return 0.0
        }
        
        return 40.0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 1 {
            return 0.0
        }
        
        return 40.0
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            searchBarTV.isHidden = false
            Firestore.firestore().collection("Users").whereField("username", isGreaterThanOrEqualTo: searchText.lowercased()).whereField("username", isLessThanOrEqualTo: searchText.lowercased() + "\u{f8ff}").limit(to: 6).getDocuments() {
                querySnapshot, error in
                if error != nil {
                    print("error")
                }else{
                    self.usernames.removeAll()
                    for document in querySnapshot!.documents {
                        self.usernames.append(document.data()["username"] as! String)
                    }
                    self.searchBarTV.reloadData()
                }
            }
        }else{
            searchBarTV.isHidden = true
            self.usernames.removeAll()
            self.searchBarTV.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Auth.auth().currentUser!.uid)
        UILabel.appearance().font = UIFont(name: "Raleway", size: 13)
        UITextField.appearance().font = UIFont(name: "Raleway", size: 13)
      
       
       
        searchBarTV.isHidden = true
        search.delegate = self
        discoverPageCV.delegate = self
        discoverPageCV.dataSource = self
        discoverPageCV.showsHorizontalScrollIndicator = false
        sportCV.showsHorizontalScrollIndicator = false
       // discoverPageCV.tag = 1
        searchBarTV.delegate = self
        searchBarTV.dataSource = self
        searchBarTV.tag = 2
        sportCV.delegate = self
        sportCV.dataSource = self
        
        //downloadPosts()
        downloadSports()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    func downloadSports()
    {
        Firestore.firestore().collection("Sports").getDocuments()
        { (querySnapshot, err) in
            if let err = err {
                print(err.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    let sport = Sport(displayName: data["displayName"] as! String, positions: data["positions"] as! [String], sportName: data["sportName"] as! String)
                    self.sports.append(sport)
                    self.sportCV.reloadData()
                }
                print(self.sports.count)
            }
        }
    }
    
    func playVideo(videoName: String, playerView: UIView)
    {
        var player: AVPlayer?
        var playerLayer: AVPlayerLayer?
        var playerItemContext = 0
        
        let download = Storage.storage().reference().child(videoName)
        
        download.downloadURL { [self]url, error in
          if let error = error {
            print(error.localizedDescription)
          } else {
            print("complete")
            player = AVPlayer()
            
            playerLayer = AVPlayerLayer(player: player)
        
            playerLayer?.frame.size.height = 400
            playerLayer?.frame.size.width = view.bounds.width
            
            playerLayer?.videoGravity = .resizeAspectFill
            let playerItem = AVPlayerItem(url: url!)
            playerItem.addObserver(self,
                                       forKeyPath: #keyPath(AVPlayerItem.status),
                                       options: [.old, .new],
                                       context: &playerItemContext)
            player?.replaceCurrentItem(with: playerItem)

            let timeScale = CMTimeScale(NSEC_PER_SEC)
            let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)

            player?.addPeriodicTimeObserver(forInterval: time,
                                                               queue: .main) {
                 [weak self] time in
                if let currentItem = player?.currentItem {
                    if currentItem.status == AVPlayerItem.Status.readyToPlay {
                        print(time.seconds)
                           if currentItem.isPlaybackLikelyToKeepUp {
                               print("Playing ")
                           } else if currentItem.isPlaybackBufferEmpty {
                               player?.play()
                               print("Buffer empty")
                                
                           }  else if currentItem.isPlaybackBufferFull {
                               print("Buffer full")
                           } else {
                              // player?.pause()
                               print("Buffering")
                           }
                       } else if currentItem.status == AVPlayerItem.Status.failed {
                           print("Failed ")
                       } else if currentItem.status == AVPlayerItem.Status.unknown {
                           print("Unknown ")
                       }
                   } else {
                       print("avPlayer.currentItem is nil")
                   }
             }
            player?.isMuted = true
            player?.automaticallyWaitsToMinimizeStalling = false
            playerItem.preferredForwardBufferDuration = TimeInterval(5.0)
            
            playerView.layer.addSublayer(playerLayer!)
          }
        }
     }
    func downloadPosts()
    {
        Firestore.firestore().collection("Users").document("sPgWm73m24OjK7EXpLPyCTYCTke2").collection("Posts").whereField("posterUID", isEqualTo: "sPgWm73m24OjK7EXpLPyCTYCTke2").limit(to: 6).getDocuments() {
                querySnapshot, error in
                if error != nil {
                    print("error")
                }else{
                    for qdocument in querySnapshot!.documents {
                    let data = qdocument.data()
//                        Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("Posts").document(data["id"] as! String).collection("Likes").document(Auth.auth().currentUser!.uid).getDocument() { doc, error in
//                            if let doc = doc, doc.exists {
//                                print("is Liked")
//                        let post = Post(desc: data["description"] as! String,playerSchool: data["school"] as! String, video: nil ,postID: data["id"] as! String,likes: data["likes"] as! Int, comments: data["comments"] as! Int, position: data["position"] as! String, posterUID: data["posterUID"] as! String, sport: data["sport"] as! String, isLiked: true)
//                                self.feedPosts.append(post)
//                            }else if !(doc!.exists){
//                                print("is not Liked")
                                let post = Post(desc: data["description"] as! String,playerSchool: data["school"] as! String, video: nil ,postID: data["id"] as! String,likes: data["likes"] as! Int, comments: data["comments"] as! Int, position: data["position"] as! String, posterUID: data["posterUID"] as! String, sport: data["sport"] as! String, isLiked: false)
                                        self.feedPosts.append(post)
//                                }else{
//                                    print("failed")
                                }
                            self.discoverPageCV.reloadData()
                        }
                    }
                    
            }
            
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let comments = segue.destination as? Comments{
            comments.post = selectedPost
        }
    }
  
  }

