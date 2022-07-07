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
import PSMeter

class RegisterViewController: UIViewController {
   // var currentUser : UserData = UserData(UserID: "", firstName: "", lastName: "", hashedPasswords: [], phoneNumber: "")
    @IBOutlet weak var firstNameBox: UITextField!
    @IBOutlet weak var lastNameBox: UITextField!
    @IBOutlet weak var emailBox: UITextField!
    @IBOutlet weak var passwordBox: UITextField!
    @IBOutlet weak var phoneNumberBox: PhoneNumberTextField!
    
    @IBOutlet weak var psMeter: PSMeter!
    @IBOutlet weak var confirmPasswordBox: UITextField!
    @IBOutlet weak var confirmBox: UITextField!
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.phoneNumberBox.maxDigits = 9
        // Do any additional setup after loading the view.
        
          psMeter.tintColor = .red
          psMeter.font = UIFont.boldSystemFont(ofSize: 18)
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
   
    @IBAction func passwordChanged(_ sender: UITextField) {
        let password = passwordBox.text ?? ""
            psMeter.updateStrengthIndication(password: password)
    }
    @IBAction func registerClicked(_ sender: UIButton) {
        if(passwordBox.text != confirmBox.text){
            let alert = UIAlertController(title: "Error", message: "Passwords do not match.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

            self.present(alert, animated: true)
        }
        else{
        if let email = emailBox.text, let password = passwordBox.text {
      
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    let alert = UIAlertController(title: "Registration Error", message: e.localizedDescription, preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

                    self.present(alert, animated: true)
                    print(e.localizedDescription)
                }
                else{

                    let user = Auth.auth().currentUser

                    let newUser = UserData(UserID: user!.uid, firstName: self.firstNameBox.text!, lastName: self.lastNameBox.text!, hashedPasswords: [], phoneNumber: self.phoneNumberBox.text!, memorablePasswords: [])
                    currentUser = newUser

                    self.addNewUser(newUser: newUser)

                    self.performSegue(withIdentifier: "registerToHome", sender: nil)

                    
                }
                
                }
            }
        }
    }
    
}
