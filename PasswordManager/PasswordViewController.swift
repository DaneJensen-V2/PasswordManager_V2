//
//  PasswordViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/7/22.
//

import UIKit

class PasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func callAPI(_ sender: UIButton) {
        
    }
    func performRequest(urlString : String){
        let urlString = "https://api.pwnedpasswords.com/range/5BAA6"
        
        
            if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
           let task =  session.dataTask(with: url, completionHandler: handle(data:response:error:))
            
            task.resume()
        }
        
    }

    func handle(data: Data?, response: URLResponse?, error:  Error?){
        
        if error != nil {
            print(error!)
            return
        }
        if let safeData = data {
            

        }
    }
        func parseJSON(safeData : Data){
            let decoder = JSONDecoder()
            
            }
        }



