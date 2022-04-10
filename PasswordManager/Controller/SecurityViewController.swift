//
//  SecurityViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/10/22.
//

import UIKit
import CryptoKit

var hashedList = [Hashes]()

class SecurityViewController: UIViewController {
    var hashedPassword = ""
    @IBOutlet weak var passwordBox: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    
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
        DispatchQueue.main.async {
        self.outputLabel.text = "Password Found! This password has been in " + String(number) + " data leaks."
        }
    }
    func CheckForMatches(password : String){
        print(password)
        if (hashedList.isEmpty){
            usleep(5000)
        }
        else{
        for value in hashedList{
            if(password == value.hash){
                updateTextFound(number : String(value.value))
                
                print("Found!")
            }
            
        }
        print("Finished")
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
