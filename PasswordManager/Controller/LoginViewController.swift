//
//  LoginViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/9/22.
//

import UIKit
import Firebase

var currentUser = UserData(UserID: "", firstName: "", lastName: "", hashedPasswords: [], phoneNumber: ""){
    didSet {
        print("arrayUpdated")
        PasswordViewController().updateTable()
    }
}
let db = Firestore.firestore()

class LoginViewController: UIViewController {
   
    @IBOutlet weak var passwordBox: UITextField!
    @IBOutlet weak var usernameBox: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBAction func loginButton(_ sender: UIButton) {
        if let email = usernameBox.text, let password = passwordBox.text{
        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
            
            if let e = error{
                let alert = UIAlertController(title: "Registration Error", message: e.localizedDescription, preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

                self.present(alert, animated: true)
                print(e.localizedDescription)
            }else{
                let currentID = Auth.auth().currentUser
                AuthManager().loadCurrentUser(user: currentID!) { success in
                    print("User Loaded")
                    self.performSegue(withIdentifier: "loginToHome", sender: nil)

                }
            }
        }
                print("Success")
               // signedIn = true

                //dismissParent = true
                
            }
        }
    
   
    }
    
    

