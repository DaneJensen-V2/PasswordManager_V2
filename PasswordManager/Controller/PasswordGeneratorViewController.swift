//
//  PasswordGeneratorViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/14/22.
//

import UIKit


class PasswordGeneratorViewController: UIViewController {
    
  
   
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
      //  imageTest.image = imageList[0].image
        // Do any additional setup after loading the view.
        spinner.startAnimating()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
               
       
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        beginProcess()

    }
    func beginProcess(){
        getImages { success in
            self.updateUI()
        }
    }
    func updateUI(){
        print("Updating UI")
        print(imageList)
        spinner.stopAnimating()
        spinner.isHidden = true
        collectionView.isHidden = false
        collectionView.reloadData()
  

     //   image2.image = imageList[1].image
       
    //    image4.imageView!.image = imageList[3].image

    }

    func  getImages(completion: @escaping (Bool) -> Void){
        let group = DispatchGroup()
    //    let semaphore = DispatchSemaphore(value: 4)

        if let bundleURL = Bundle.main.url(forResource: "Words", withExtension: "txt"),
           let contentsOfFile = try? String(contentsOfFile: bundleURL.path, encoding: .utf8) {
            let components = contentsOfFile.components(separatedBy: .newlines)

            for i in 1...16 {
                group.enter()
                print(imageList.count)
                let randomInt = Int.random(in: 1..<1426)
                print(components[randomInt])
                 self.imageSearch(image: components[randomInt]){ image in
                     let newImage = Image(imageName: components[randomInt], image: image)
                    imageList.append(newImage)
                    print(i)
                  //  semaphore.signal()
                     group.leave()
                }

                 }
            group.wait()
          //  semaphore.wait()
            print("Semaphore Complete")
            completion(true)

            
            
        }
        
    }
    func imageSearch(image: String, completion: @escaping (UIImage) -> Void){
        
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
                                             self.getImageFromUrl(urlString: url) { image in
                                                completion(image)
                                                 

                                            }
                                        }
                                    }
                                
                            }
                        }
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                        completion(UIImage(named: "Twitter")!)
                    }

        })

        dataTask.resume()
    }
    func getImageFromUrl(urlString : String, completion: @escaping (UIImage) -> Void){

        print("getting image")
        var newImage = UIImage(named: "Instagram")
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { imageData, response, error in
                if let error = error {
                          print("Error -> \(error)")
                        completion(UIImage(named: "Twitter")!)
                      }
                
                    print("Looking for image")
                if imageData == nil{
                    completion(UIImage(named: "Twitter")!)
                }
                else{
                    
                    newImage = UIImage(data: imageData!)
                    completion(newImage!)
                }
               
                
            }
            
            task.resume()
        }


    }
}
extension PasswordGeneratorViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.cellImage.image = imageList[indexPath.row].image
        cell.cellLabel.text = imageList[indexPath.row].imageName
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(imageList[indexPath.row].imageName)
    }
    
}

extension PasswordGeneratorViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 300)
    }
}
