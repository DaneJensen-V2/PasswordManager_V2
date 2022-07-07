//
//  AccountViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/19/22.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var helloLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        helloLabel.text = "Hello " + currentUser.firstName + " " + currentUser.lastName
        emailLabel.text = auth.currentUser?.email
        // Do any additional setup after loading the view.
    }
    

    @IBAction func logoutClicked(_ sender: UIButton) {
        AuthManager().logout()
        performSegue(withIdentifier: "logout", sender: nil)
    }
   

     @IBAction func changePassword(_ sender: UIButton) {
         Auth.auth().sendPasswordReset(withEmail: "dejense4@asu.edu") { error in
             print(error)
         }
         let alert = UIAlertController(title: "Confirmation", message: "Password reset Email sent.", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
         self.present(alert, animated: true)

     }
  

    @IBAction func deleteAccount(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete Account", message: "Do you want to permanantely delete your account? This action cannot be undone", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            let user = auth.currentUser
            let currentuserID2 = user?.uid

            db.collection("Users").document(currentuserID2!).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
            
            user?.delete { error in
              if let error = error {
                print(error)
              } else {
                self.performSegue(withIdentifier: "logout", sender: nil)
                  
              }
            }
        
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))


        self.present(alert, animated: true)
    }
    func deleteAccountY(){
        
    }
}
