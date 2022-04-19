//
//  checkPasswordViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/19/22.
//

import UIKit
import CryptoKit

class checkPasswordViewController: UIViewController {
    @IBOutlet weak var passwordBox: UITextField!
    
    @IBOutlet weak var outputLbel: UILabel!
    var hashedPassword = ""
    var passwordFound = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        let urlString = "https://api.pwnedpasswords.com/range/5BAA6"
        performRequest(urlString: urlString) { sucess in
            self.CheckForMatches(password: String(self.hashedPassword.suffix(35)))

        }
    }
    func hashPassword(password : String) -> String {
        guard let data = password.data(using: .utf8) else { return "fail"}
        let digest = Insecure.SHA1.hash(data: data)
        print(digest.data) // 20 bytes
        print(digest.hexStr) // 2AAE6C35C94FCFB415DBE95F408B9CE91EE846ED
        return digest.hexStr
    }
    
    // Create URL
    func performRequest(urlString : String,  completion: @escaping (Bool) -> Void){
        
         hashedPassword = hashPassword(password: passwordBox.text!)
        
        let firstFive = hashedPassword.prefix(5)
        let url = URL(string: "https://api.pwnedpasswords.com/range/" + firstFive)!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            let dataString = String(data: data, encoding: .utf8)!
            let listItems = dataString.split(whereSeparator: \.isNewline)
            for value in listItems{
                let singleHash = value.split(separator: ":")
                let newItem = Hashes(hash: String(singleHash[0]), value: Int(singleHash[1])!)
                hashedList.append(newItem)
            }
            completion(true)
            print(hashedList.count)
        }

        task.resume()
        
  }
    func updateTextFound(number : String){
        let stringSize = number.count
        DispatchQueue.main.async { [self] in
            if let numberInt = Int(number){
            
            switch numberInt{
            case 1...10 :
                var myMutableString = NSMutableAttributedString()
                let myString = "Password Found! This password has been in " + number + " data leaks."
                myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Futura", size: 18.0)!])
             
                myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange, range: NSRange(location:42,length:stringSize))
                
                outputLbel.attributedText = myMutableString
                
            case 11...:
                var myMutableString = NSMutableAttributedString()
                let myString = "Password Found! This password has been in " + number + " data leaks."
                myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Futura", size: 18.0)!])
             
                myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:42,length:stringSize))
                
                outputLbel.attributedText = myMutableString
            case 0:
                var myMutableString = NSMutableAttributedString()
                let myString = "Password not found in any data leaks."
                myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Futura", size: 18.0)!])
             
                myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: NSRange(location:0,length:37))
                
                outputLbel.attributedText = myMutableString
            default:
                print("not found")
            }
            }
    }
    }
    func CheckForMatches(password : String){
        DispatchQueue.main.async { [self] in

        passwordFound = false
        print(password)
        if (hashedList.isEmpty){
            usleep(5000)
        }
        else{
        for value in hashedList{
            if(password == value.hash){
                updateTextFound(number : String(value.value))
                passwordFound = true
                print("Found!")
            }
            
        }
            usleep(5000)
        updateTextFound(number : String(0))
        print("Finished")
    }
    }
    }
}

extension Digest {
    var bytes: [UInt8] { Array(makeIterator()) }
    var data: Data { Data(bytes) }

    var hexStr: String {
        bytes.map { String(format: "%02X", $0) }.joined()
    }
}


