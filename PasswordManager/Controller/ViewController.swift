//
//  ViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/5/22.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
      
  
        loginButton.layer.cornerRadius = 10
        registerButton.layer.cornerRadius = 10
        
        if Auth.auth().currentUser != nil {
            print("USER IS LOGGED IN")
            AuthManager().loadCurrentUser(user: Auth.auth().currentUser!){ success in
                self.changeView()
            }
        
        } else {
            Auth.auth().addStateDidChangeListener { auth, user in
              if let user = user {
                print("SIGNED IN")
                  
                print(user.uid)

              } else {
                print("NOT SIGNED IN")
                  //print(Auth.auth().currentUser!.uid)
              }
            }        }
    }
    
    func changeView(){
        print("Changing View...")
        DispatchQueue.main.async(){
           self.performSegue(withIdentifier: "test", sender: self)
        }

    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

