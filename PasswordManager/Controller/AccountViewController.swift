//
//  AccountViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/19/22.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var helloLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        helloLabel.text = "Hello " + currentUser.firstName + " " + currentUser.lastName
        // Do any additional setup after loading the view.
    }
    

    @IBAction func logoutClicked(_ sender: UIButton) {
        AuthManager().logout()
        performSegue(withIdentifier: "logout", sender: nil)
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
