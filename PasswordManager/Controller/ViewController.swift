//
//  ViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/5/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        loginButton.layer.cornerRadius = 10
        registerButton.layer.cornerRadius = 10
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

