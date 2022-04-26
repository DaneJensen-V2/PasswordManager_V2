//
//  PasswordGeneratorViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/14/22.
//

import UIKit


class PasswordGeneratorViewController: UIViewController {
    
  
   
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var capitalSwitch: UISwitch!
    @IBOutlet weak var popupText: UILabel!
    @IBOutlet weak var ExclamationSwitch: UISwitch!
    @IBOutlet weak var DashSwitch: UISwitch!
    @IBOutlet weak var outputText: UITextField!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var finalView: UIView!
    var exclamantionAdded = false
    var dashesAdded = false
    var counter = 0
    var wordList = [String]()
    var originalString = ""
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
        imageList = []
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
        print("image search")
     
        if let url = URL(string: "https://source.unsplash.com/featured/?" + image) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { print(error?.localizedDescription); return }
                
                //DispatchQueue.main.async { /// execute on main thread
                    completion(UIImage(data: data)!)
                //}
            }
            
            task.resume()
        }
    }
    func updateTable(newWord : String){
        if counter < 12{
        counter = counter + 4
        collectionView.reloadData()
            print("reload ran")
            wordList.append(newWord.lowercased())
        }
        else{
            wordList.append(newWord.lowercased())
            passwordComplete()
        }
    }
    func passwordComplete(){
        collectionView.isHidden = true
        print(wordList)
        finalView.isHidden = false
   
        outputText.text = wordList[0] + wordList[1] + wordList[2] + wordList[3]
            originalString = wordList[0] + wordList[1] + wordList[2] + wordList[3]
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        updateText()
    }
    func updateText(){
        var newString = originalString
        if capitalSwitch.isOn{
            var i = -1
            for word in wordList{
                i += 1
                wordList[i] = word.lowercased().capitalized
            }
            newString = wordList[0] + wordList[1] + wordList[2] + wordList[3]
        }
        if capitalSwitch.isOn == false{
            newString = newString.lowercased()
        }
        
        if ExclamationSwitch.isOn && exclamantionAdded == false{
            var i = -1
            for word in wordList{
                i += 1
                wordList[i] = word + "!"
            }
            newString = wordList[0] + wordList[1] + wordList[2] + wordList[3]
            exclamantionAdded = true
        }
        if ExclamationSwitch.isOn == false && exclamantionAdded == true{
            var i = -1
            for word in wordList{
                i += 1
                let trimmedString = word.replacingOccurrences(of: "!", with: "", options: .regularExpression)

                wordList[i] = trimmedString
            }
            newString = wordList[0] + wordList[1] + wordList[2] + wordList[3]
            exclamantionAdded = false
        }
        
        if DashSwitch.isOn && dashesAdded == false{
            var i = -1
            for word in wordList{
                i += 1
                if(i != 3){
                wordList[i] = word + "-"
                }
            }
            newString = wordList[0] + wordList[1] + wordList[2] + wordList[3]
            dashesAdded = true
        }
        if DashSwitch.isOn == false && dashesAdded == true{
            var i = -1
            for word in wordList{
                i += 1
                let trimmedString = word.replacingOccurrences(of: "-", with: "", options: .regularExpression)

                wordList[i] = trimmedString
            }
            newString = wordList[0] + wordList[1] + wordList[2] + wordList[3]
            dashesAdded = false
        }
        
        outputText.text = newString
    }

    @IBAction func copyPressed(_ sender: UIButton) {
        print("Password Copied")
        popupText.text = "Password Copied"
        popupView.alpha = 1

        UIPasteboard.general.string = outputText.text
            UIView.transition(with: finalView, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                print("Transition ran")
                self.popupView.isHidden = false
                          })
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (_) in
            UIView.animate(withDuration: 0.3, animations: { [self] in
                popupView.alpha = 0
            }) { (finished) in
                print("Timer ran")
                self.popupView.isHidden = finished
            }
            
        }
    }
}
extension PasswordGeneratorViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number Ran")
        return imageList.count / 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Cell for  Ran")

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.cellImage.image = imageList[indexPath.row + counter].image
        cell.cellLabel.text = imageList[indexPath.row + counter].imageName
        cell.layer.cornerRadius = 10
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateTable(newWord: imageList[indexPath.row + counter].imageName)
    }
    
}

extension PasswordGeneratorViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 175, height: 300)
    }
}
