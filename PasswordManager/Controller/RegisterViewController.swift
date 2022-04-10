//
//  RegisterViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/9/22.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import PhoneNumberKit

class RegisterViewController: UIViewController {
    var currentUser : UserData = UserData(UserID: "", firstName: "", lastName: "", hashedPasswords: [], phoneNumber: "")
    @IBOutlet weak var firstNameBox: UITextField!
    @IBOutlet weak var lastNameBox: UITextField!
    @IBOutlet weak var emailBox: UITextField!
    @IBOutlet weak var passwordBox: UITextField!
    @IBOutlet weak var phoneNumberBox: PhoneNumberTextField!
    
    @IBOutlet weak var confirmBox: UITextField!
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.phoneNumberBox.maxDigits = 9
        // Do any additional setup after loading the view.
    }
    
    func addNewUser(newUser : UserData ){
        let user = Auth.auth().currentUser

        try! self.db.collection("Users").document(user!.uid).setData(from : newUser)
             { (error) in
             if let e = error{
                 print("There was an issue saving data to firestore, \(e)")
             }
             else{
                 print("Successfully saved data.")
             }
         }
    }
   
    @IBAction func registerClicked(_ sender: UIButton) {
        if let email = emailBox.text, let password = passwordBox.text {
      
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    let alert = UIAlertController(title: "Registration Error", message: e.localizedDescription, preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

                    self.present(alert, animated: true)
                    print(e.localizedDescription)
                }
                else{
                    //Navigate to the ChatViewController
                    self.performSegue(withIdentifier: "registerToHome", sender: nil)
                  //  signedIn = true
                    let user = Auth.auth().currentUser

                    let newUser = UserData(UserID: user!.uid, firstName: self.firstNameBox.text!, lastName: self.lastNameBox.text!, hashedPasswords: [], phoneNumber: self.phoneNumberBox.text!)
                     
                    self.addNewUser(newUser: newUser)
                    self.currentUser = newUser
              
                    
                }
                
                }
            }
    }
    
}
