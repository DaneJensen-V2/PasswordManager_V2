//
//  PasswordGeneratorViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/14/22.
//

import UIKit


class PasswordGeneratorViewController: UIViewController {
    
    @IBOutlet weak var image1: UIButton!
    @IBOutlet weak var image2: UIButton!
    @IBOutlet weak var image3: UIButton!
    @IBOutlet weak var image4: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
      //  imageTest.image = imageList[0].image
        // Do any additional setup after loading the view.
        spinner.startAnimating()
        image1.imageView?.contentMode = .scaleAspectFit
        image2.imageView?.contentMode = .scaleAspectFit
        image3.imageView?.contentMode = .scaleAspectFit
        image4.imageView?.contentMode = .scaleAspectFit

                getImages { success in
            print("Done")

        }
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { (_) in
            self.updateUI()
        }
        
    }
    func updateUI(){
        print("Updating UI")
        print(imageList)
        spinner.stopAnimating()
        spinner.isHidden = true
        
        image1.imageView!.image = imageList[0].image
        image2.imageView!.image = imageList[1].image
        image3.imageView!.image = imageList[2].image
    //    image4.imageView!.image = imageList[3].image

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
            semaphore.wait()
            print("Semaphore Complete")
            completion(true)

            
            
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
                    print("Looking for image")
                    newImage = UIImage(data: data)!
                    completion(true)

                }
            }
            
            task.resume()
        }

        return newImage!

    }
}
