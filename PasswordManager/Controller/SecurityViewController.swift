//
//  SecurityViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/10/22.
//

import UIKit
import CryptoKit
import Foundation

var tempImage = UIImage(named: "Twitter")
var hashedList = [Hashes]()
var imageList = [Image]()

class SecurityViewController: UIViewController {
    var hashedPassword = ""
    @IBOutlet weak var passwordBox: UITextField!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var buttonBackground: UIView!
    
    @IBOutlet weak var view4: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageList = []
        buttonBackground.layer.cornerRadius = 10
        view2.layer.cornerRadius = 10
        view3.layer.cornerRadius = 10
        view4.layer.cornerRadius = 10



        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        let urlString = "https://api.pwnedpasswords.com/range/5BAA6"
        performRequest(urlString: urlString) { sucess in
            self.CheckForMatches(password: String(self.hashedPassword.suffix(35)))

        }
    }
    
    @IBAction func passwordGenerate(_ sender: UIButton) {
        getImages { success in
            self.performSegue(withIdentifier: "toPassGenerator", sender: nil)

        }
    }
    func  getImages(completion: @escaping (Bool) -> Void){
        let semaphore = DispatchSemaphore(value: 4)

        if let bundleURL = Bundle.main.url(forResource: "Words", withExtension: "txt"),
           let contentsOfFile = try? String(contentsOfFile: bundleURL.path, encoding: .utf8) {
            let components = contentsOfFile.components(separatedBy: .newlines)

            for i in 1...4 {
                print(imageList.count)
                let randomInt = Int.random(in: 1..<1426)
                print(components[randomInt])
                var returnedImage = UIImage(named: "Twitter")
                 returnedImage = self.imageSearch(image: components[randomInt]){ success in
                     let newImage = Image(imageName: components[randomInt], image: returnedImage!)
                    imageList.append(newImage)
                    print(i)
                    semaphore.signal()
                }
               

                 }
           // semaphore_wait(semaphore)
            semaphore.wait()
            while(imageList.count == 4){
                completion(true)

            }

            
            

            
            
        }
        
    }
    func imageSearch(image: String, completion: @escaping (Bool) -> Void) -> UIImage{
        
        var newImage = UIImage(named: "Twitter")
        let headers = [
            "X-RapidAPI-Host": "google-image-search1.p.rapidapi.com",
            "X-RapidAPI-Key": "b1d23830cfmsh0296e66a07ace30p13e768jsnc5df9ffe1438"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://google-image-search1.p.rapidapi.com/v2/?q=" + image + "&hl=en")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else { return }

                    do {
                        // make sure this JSON is in the format we expect
                        // convert data to json
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            // try to read out a dictionary
                         //   print(json)
                            if let data = json["response"] as? [String:Any] {
                               // print(data)
                                if let images = data["images"] as? [[String:Any]] {
                                   // print(images)
                                  
                                    let dict = images[0]
                                   // print(dict)
                                    if let image = dict["image"] as? [String:Any]{
                                    //    print(image)
                                        if let url = image["url"] as? String{
                                            //                        print(url)
                                            print("FOUND")
                                            newImage = self.getImageFromUrl(urlString: url) { success in
                                                completion(true)

                                            }
                                        }
                                    }
                                
                            }
                        }
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                        completion(false)
                    }

        })

        dataTask.resume()
        return newImage!
    }
    func getImageFromUrl(urlString : String, completion: @escaping (Bool) -> Void) -> UIImage{
        var newImage = UIImage(named: "Twitter")
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async { /// execute on main thread
                    newImage = UIImage(data: data)!
                  
                }
            }
            
            task.resume()
        }
        completion(true)

        return newImage!

    }
    func hashPassword(password : String) -> String {
        guard let data = password.data(using: .utf8) else { return "fail"}
        let digest = Insecure.SHA1.hash(data: data)
        print(digest.data) // 20 bytes
        print(digest.hexStr) // 2AAE6C35C94FCFB415DBE95F408B9CE91EE846ED
        return digest.hexStr
    }
    @IBAction func memorablePass(_ sender: UIButton) {

        let headers = [
            "X-RapidAPI-Host": "wordsapiv1.p.rapidapi.com",
            "X-RapidAPI-Key": "b1d23830cfmsh0296e66a07ace30p13e768jsnc5df9ffe1438"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://wordsapiv1.p.rapidapi.com/words/?lettersmin=5&lettersMax=6&partofspeech=noun&limit=100&frequencymin=8.03&page=2&random=true")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                let dataString = String(data: data!, encoding: .utf8)!

                print(dataString)
            }
        })

        dataTask.resume()
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
