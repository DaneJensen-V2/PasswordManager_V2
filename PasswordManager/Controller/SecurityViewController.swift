//
//  SecurityViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/10/22.
//

import UIKit
import Foundation

var tempImage = UIImage(named: "Twitter")
var hashedList = [Hashes]()
var imageList = [Image]()

class SecurityViewController: UIViewController {
    
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var buttonBackground: UIView!
    
    @IBOutlet weak var borderview: UIView!
    @IBOutlet weak var view4: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageList = []
        buttonBackground.layer.cornerRadius = 10
        view2.layer.cornerRadius = 10
        view3.layer.cornerRadius = 10
        view4.layer.cornerRadius = 10
        borderview.layer.borderWidth = 5
        borderview.layer.borderColor = UIColor.black.cgColor



        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    @IBAction func passwordGenerate(_ sender: UIButton) {
        
    }
    
}
