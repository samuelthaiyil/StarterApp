//
//  Comments.swift
//  StarterApp
//
//  Created by Sam Thaiyil on 2021-05-26.
//

import UIKit
import Firebase

class Comment {
    var commentText: String
    var commenterUID: String
    var postID: String
    var posterUID: String
    var commenterUsername: String?
    
    init(commentText: String, commenterUID: String, postID: String, posterUID: String, commenterUsername: String?) {
        self.commentText = commentText
        self.commenterUID = commenterUID
        self.postID = postID
        self.posterUID = posterUID
        self.commenterUsername = commenterUsername
    }
}

class Comments: UIViewController, UITableViewDelegate, UITableViewDataSource {

   @IBOutlet weak var commentTV: UITableView!
   @IBOutlet weak var commentField: UITextField!
   var post: DiscoverPage.Post? = nil
   var comments: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTV.delegate = self
        commentTV.dataSource = self
        
        downloadComments(amount: 8)
    }
    
    func downloadComments(amount: Int)
    {
        guard let post = post else{
            print("failed to get post")
            return
        }
        Firestore.firestore().collection("Users").document(post.posterUID).collection("Posts").document(post.postID).collection("Comments").whereField("postID", isEqualTo: post.postID).limit(to: amount).getDocuments() {
                querySnapshot, error in
                if error != nil {
                    print("error")
                }else{
                    for document1 in querySnapshot!.documents {
                    let data = document1.data()
                        Firestore.firestore().collection("Users").document(data["commenterUID"] as! String).getDocument { (document, error) in
                            if let document = document, document.exists {
                                let usernameData = document.data()
                                let comment = Comment(commentText: data["commentText"] as! String, commenterUID: data["commenterUID"] as! String, postID: data["postID"] as! String, posterUID: data["posterUID"] as! String, commenterUsername: usernameData?["username"] as? String)
                                self.comments.append(comment)
                                self.commentTV.reloadData()
                            } else {
                                print("commenter username does not exist")
                            }
                        }
                        
                      }
                   }
                }
            }
        
    func uploadComment(comment: Comment)
    {
        guard !comment.commentText.isEmpty else{
            print("comment is empty")
            return
        }
        Functions.functions().httpsCallable("commentedOnPost").call(["commentText":comment.commentText,
                                                                     "posterUID":comment.posterUID,
                                                                     "postID":comment.postID,
                                                                     "commenterUID":comment.commenterUID]) { (result, error) in
          if let error = error as NSError? {
            if error.domain == FunctionsErrorDomain {
              let message = error.localizedDescription
              print(message)
            }
           
          }
       }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentCell
        
        cell!.comment.text = comments[indexPath.row].commentText
        cell!.username.text = comments[indexPath.row].commenterUsername
       
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    @IBAction func post(_ sender: Any) {
        
        guard let commentText = commentField.text, let commenterUID = Auth.auth().currentUser?.uid, let postID = post?.postID, let posterUID = post?.posterUID else {
            print("comment attributes failed")
            return
        }
        
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let usernameData = document.data()
                let comment = Comment(commentText: commentText, commenterUID: commenterUID, postID: postID, posterUID: posterUID, commenterUsername: usernameData?["username"] as? String)
                self.uploadComment(comment: comment)
                self.comments.append(comment)
             } else {
                print("commenter username does not exist")
            }
        }
        self.commentTV.reloadData()
     
    }
}
