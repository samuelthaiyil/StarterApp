//
//  ViewController.swift
//  StarterApp
//
//  Created by Sam Thaiyil on 2021-05-03.
//

import UIKit
import Firebase
import PopupDialog

class ViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var noAccount: UIButton!
    @IBOutlet weak var signIn: UIButton!
    
    let auth = Auth.auth()
    let firestore = Firestore.firestore()
    let functions = Functions.functions()
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       
        UILabel.appearance().font = UIFont(name: "Raleway", size: 15)
        UITextField.appearance().font = UIFont(name: "Raleway", size: 15)
        signIn.backgroundColor = UIColor.black
        signIn.titleLabel?.textColor = UIColor.white
        
        
        noAccount.layer.borderColor = UIColor.black.cgColor
        noAccount.layer.borderWidth = 0.5
        
     
        // Do any additional setup after loading the view.
    }

    @IBAction func signIn(_ sender: Any) {
        guard let email = email.text?.trimmingCharacters(in: [" "]), let password = password.text else{
            return
        }
        
        auth.signIn(withEmail: email, password: password) { user, error in
           if(error != nil)
           {
            if(error?.localizedDescription == "The email address is badly formatted.") {
                let popup = PopupDialog(title: "Can't sign you in", message: "Please enter a valid email")
                let ok = DefaultButton(title: "OK")
                {
                    return
                }
                popup.addButton(ok)
                self.present(popup, animated: true)
            }
            if(error?.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted."){
                
                let popup = PopupDialog(title: "Can't sign you in", message: "We don't have an account with this email in our records")
                let ok = CancelButton(title: "OK")
                {
                    return
                }
                let signUp = DefaultButton(title: "MAKE AN ACCOUNT")
                {
                    return
                }
                popup.addButtons([signUp, ok])
                self.present(popup, animated: true)
            }
            if(error?.localizedDescription == "The password is invalid or the user does not have a password.")
            {
                let popup = PopupDialog(title: "Can't sign you in", message: "Wrong password")
                let ok = DefaultButton(title: "OK")
                {
                    return
                }
                popup.addButton(ok)
                self.present(popup, animated: true)
            }
           }else{
            self.performSegue(withIdentifier: "toDiscoverPage", sender: nil)
           }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        performSegue(withIdentifier: "toSignUp", sender: nil)
    }
}

