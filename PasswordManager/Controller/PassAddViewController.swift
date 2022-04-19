//
//  PassAddViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/15/22.
//

import UIKit
import Firebase
class PassAddViewController: UIViewController {
    let db = Firestore.firestore()

    @IBOutlet weak var usernameBox: UITextField!
    @IBOutlet weak var URLBox: UITextField!
    @IBOutlet weak var nameBox: UITextField!
    @IBOutlet weak var passwordBox: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentUser.hashedPasswords.count)

        var email = ""
        let user = Auth.auth().currentUser
        if let user = user {
          let uid = user.uid
            email = user.email!
        }
        
        // Do any additional setup after loading the view.
        nameBox.text = currentPassword.WebsiteName
        URLBox.text = currentPassword.WebsiteURL.absoluteString
        usernameBox.text = email
        
        
        self.hideKeyboardWhenTappedAround()
 
    }
    

    @IBAction func saveClicked(_ sender: UIButton) {
        let newPassword = passwordStruct(WebsiteName: nameBox.text!, WebsiteURL: URL(string: URLBox.text!)!, Image: currentPassword.WebsiteName, Username: usernameBox.text!, Password: passwordBox.text!)
        
        
        let user = Auth.auth().currentUser

        let currentuserID = user?.uid
        let currentUserDB = self.db.collection("Users").document(currentuserID!)


        
        let encoded: [String: Any]
                do {
                    // encode the swift struct instance into a dictionary
                    // using the Firestore encoder
                    encoded = try Firestore.Encoder().encode(newPassword)
                } catch {
                    // encoding error
                    print(error)
                    return
                }
        
        currentUser.hashedPasswords.append(newPassword)
        // Set the "capital" field of the city 'DC'
        currentUserDB.updateData([
            "hashedPasswords" : FieldValue.arrayUnion([encoded])
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                let customViewController = self.presentingViewController as? NewPasswordViewController

                self.dismiss(animated: true) {

                   customViewController?.dismiss(animated: true, completion: nil)

            }


            }
        }
    }
    @IBAction func eyeClicked(_ sender: UIButton) {
        passwordBox.isSecureTextEntry = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
