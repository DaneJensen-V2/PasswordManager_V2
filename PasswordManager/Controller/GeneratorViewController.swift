//
//  GeneratorViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/25/22.
//

import UIKit
import Navajo_Swift
import PasswordRules

class GeneratorViewController: UIViewController {
    
    let lowercase = "abcdefghijklmnopqrstuvwxyz",
       uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
       numbers = "0123456789",
       specialChar = "!@#$%^&*()_+~`|}{[]:;?><,./-="
    var generatedPassword = ""
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderLength: UILabel!
    @IBOutlet weak var lowercaseSwitch: UISwitch!
    @IBOutlet weak var uppercaseSwitch: UISwitch!
    @IBOutlet weak var numberSwitch: UISwitch!
    @IBOutlet weak var outputButton: UIButton!
    @IBOutlet weak var digitsView: UIView!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var uppercaseView: UIView!
    @IBOutlet weak var symbolsView: UIView!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var specialSwitch: UISwitch!
    @IBOutlet weak var lowercaseView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        digitsView.layer.cornerRadius = 10
        symbolsView.layer.cornerRadius = 10
        uppercaseView.layer.cornerRadius = 10
        lowercaseView.layer.cornerRadius = 10
        outputButton.layer.cornerRadius = 10
       
     //   self.outputButton.titleLabel.textAlignment = CATextLayer;

    }
    
    @IBAction func generatePassword(_ sender: UIButton) {
        var passwordCharSet = ""
        generatedPassword = ""
      //        Reset the passwordDisplay to be empty each time action is called
        outputButton.setTitle("", for: .normal)
              
              var passwordLength = Int(slider.value)
              
              if lowercaseSwitch.isOn{
                  passwordCharSet += lowercase
              }
              
              if uppercaseSwitch.isOn {
                  passwordCharSet += uppercase
              }
              
              if numberSwitch.isOn {
                  passwordCharSet += numbers
              }
              
              if specialSwitch.isOn {
                  passwordCharSet += specialChar
              }
              
              for i in 0..<Int(slider.value){
                  generatedPassword += String(passwordCharSet.randomElement()!)
              }
        outputButton.setTitle(generatedPassword, for: .normal)
        updateOutputLabel()
    }
            
         
    @IBAction func switchChange(_ sender: UISwitch) {
        if  !lowercaseSwitch.isOn && !uppercaseSwitch.isOn && !numberSwitch.isOn && !specialSwitch.isOn{
                generateButton.isEnabled = false
              } else {
                  generateButton.isEnabled = true
              }
    }
    func updateOutputLabel(){
        if let password = (outputButton.titleLabel?.text){
            let strength = Navajo.strength(ofPassword: password)
            let output = Navajo.localizedString(forStrength: strength)
            
            
            var myMutableString = NSMutableAttributedString()
            let myString = "Password is "
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Futura", size: 17.0)!])
            var attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)]
            var attributedString = NSMutableAttributedString(string:myString)
            var boldString = NSMutableAttributedString(string: output, attributes:attrs)
            attributedString.append(boldString)

            
            outputLabel.attributedText = attributedString
        }

        
    }
    
    @IBAction func switchValueChanged(_ sender: UISlider) {
        sliderLength.text = "Length (" + String(format: "%.0f", sender.value) + ")"

          
    }

    @IBAction func passClicked(_ sender: UIButton) {
        UIPasteboard.general.string = outputButton.titleLabel?.text
        let currentoutput = outputLabel.text
        outputLabel.text = "Password Copied!"
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (_) in
            self.updateOutputLabel()

            }
    }
}


