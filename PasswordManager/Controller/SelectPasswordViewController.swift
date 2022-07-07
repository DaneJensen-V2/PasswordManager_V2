//
//  SelectPasswordViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/18/22.
//

import Firebase
import UIKit

class SelectPasswordViewController: UIViewController {
    let db = Firestore.firestore()

    @IBOutlet weak var websiteLabel: UILabel!
    
    @IBOutlet weak var practice: UIButton!
    @IBOutlet var largerView: UIView!
    @IBOutlet weak var sucessView: UIView!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var webImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sucessView.layer.cornerRadius = 10
        sucessView.isHidden = true
        // Do any additional setup after loading the view.
        webImage.image = UIImage(named: selectedPassword.Image)
        websiteLabel.text = selectedPassword.WebsiteName
        if(selectedPassword.passwordType != "Memorable"){
            practice.isEnabled = false
        }
        else{
            practice.isEnabled = true
        }
    }
    
    @IBAction func tappedOutside(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func copyPassword(_ sender: Any) {
        print("Password Copied")
        successLabel.text = "Password Copied"
        sucessView.alpha = 1

        UIPasteboard.general.string = selectedPassword.Password
            UIView.transition(with: largerView, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                print("Transition ran")
                self.sucessView.isHidden = false
                          })
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (_) in
            UIView.animate(withDuration: 0.3, animations: { [self] in
                sucessView.alpha = 0
            }) { (finished) in
                print("Timer ran")
                self.sucessView.isHidden = finished
            }
            
        }
    }
    @IBAction func deletePassword(_ sender: UIButton) {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this password?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.passwordDelete()
        }))

        self.present(alert, animated: true)
    }
    func passwordDelete(){
        currentUser.hashedPasswords.remove(at: rowSelected)
        let user = Auth.auth().currentUser

        let currentuserID = user?.uid
        let currentUserDB = self.db.collection("Users").document(currentuserID!)


        
        let encoded: [String: Any]
                do {
                    // encode the swift struct instance into a dictionary
                    // using the Firestore encoder
                    encoded = try Firestore.Encoder().encode(selectedPassword)
                } catch {
                    // encoding error
                    print(error)
                    return
                }
        
        // Set the "capital" field of the city 'DC'
        currentUserDB.updateData([
            "hashedPasswords" : FieldValue.arrayRemove([encoded])
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
    
    @IBAction func copyUsername(_ sender: UIButton) {
        successLabel.text = "Username Copied"
        sucessView.alpha = 1

        UIPasteboard.general.string = selectedPassword.Username
            UIView.transition(with: largerView, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                self.sucessView.isHidden = false
                          })
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (_) in
            UIView.animate(withDuration: 0.3, animations: { [self] in
                sucessView.alpha = 0
            }) { (finished) in
                self.sucessView.isHidden = finished
            }
            
        }
        
        
        
    }
    @IBAction func launchClicked(_ sender: UIButton) {
        let url = selectedPassword.WebsiteURL
             
        if UIApplication.shared.canOpenURL(url) {

          UIApplication.shared.open(url)
      }
      else {
          UIApplication.shared.open(URL(string: "https://apps.apple.com/us/app/uber/id368677368")!)
      }
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
