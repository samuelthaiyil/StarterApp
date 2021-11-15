//
//  SignUp.swift
//  StarterApp
//
//  Created by Sam Thaiyil on 2021-05-03.
//

import UIKit
import Firebase
import PopupDialog

class SignUp: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView?
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var username: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UILabel.appearance().font = UIFont(name: "Raleway", size: 15)
        UITextField.appearance().font = UIFont(name: "Raleway", size: 15)
       
        profileImage?.layer.borderWidth = 0
        profileImage?.layer.masksToBounds = false
        profileImage?.layer.cornerRadius = profileImage!.frame.height
        profileImage?.clipsToBounds = true
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           self.dismiss(animated: true, completion: { () -> Void in
           })
           let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
               
           profileImage?.image = selectedImage
       }
    
      @IBAction func signUp(_ sender: Any) {
        guard let email = email.text, let password = password.text, let confirmPassword = confirmPassword.text, let username = username.text, let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        
        if(password == confirmPassword) {
        Auth.auth().createUser(withEmail: email, password: password){ authResult, error in
            if error != nil{
                let popup = PopupDialog(title: "Uh oh", message: "We couldn't create your account")
               
                let ok = DefaultButton(title: "OK")
                {
                    return
                }
                popup.addButton(ok)
                self.present(popup, animated: true)
            }else{
                Firestore.firestore().collection("Users").document((authResult?.user.uid)!).setData([
                   "email": email,
                   "username": username
                ]) { error in
                    if error != nil{
                        let popup = PopupDialog(title: "Uh oh", message: "We couldn't create your account (Firestore)")
                       
                        let ok = DefaultButton(title: "OK")
                        {
                            return
                        }
                        popup.addButton(ok)
                        self.present(popup, animated: true)
                    }else{
                        self.performSegue(withIdentifier: "toSignIn", sender: nil)
                    }
                }
            }
        
          }
            let ref = Storage.storage().reference().child("Users/"+Auth.auth().currentUser!.uid+"/ProfilePic.jpeg")
                   
            if let uploadData = profileImage?.image!.jpegData(compressionQuality: 0.6){
                        ref.putData(uploadData, metadata: nil, completion:{ (metaData, error) in
                            if error != nil{
                                let popup = PopupDialog(title: "Uh oh", message: "Your profile picture could not be uploaded to the server")
                               
                                let ok = DefaultButton(title: "OK")
                                {
                                    return
                                }
                                popup.addButton(ok)
                                self.present(popup, animated: true)
                                return
                            }else{
                                return
                            }
                        })
                    }
        }
    }
}
