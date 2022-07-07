//
//  PracticeViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 5/5/22.
//

import UIKit

class PracticeViewController: UIViewController {
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textBOx: UITextField!
    @IBOutlet weak var passImage: UIImageView!
    @IBOutlet weak var outputLabel: UILabel!
    var count = 0.0
    var currentName = ""
    var currentImage = ""
    let passSelected = currentUser.memorablePasswords[selectedPassword.memIndex]

    override func viewDidLoad() {
        count = 0
        super.viewDidLoad()
        passImage.image = convertBase64StringToImage(imageBase64String: passSelected.Image[0])
        currentName = passSelected.Name[0]
        button.layer.cornerRadius = 10
    }
    
    @IBAction func nextClicked(_ sender: UIButton) {
        if(currentName == textBOx.text){
            count+=1
            if(count < 4){
            currentName = passSelected.Name[Int(count)]
            currentImage = passSelected.Image[Int(count)]
            updateUI()
                outputLabel.text = "Correct!"
            }
            else{
                
                outputLabel.text = "Done!"
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    self.progressBar.setProgress(Float(self.count/4), animated: true)
                  })
            }
        }
        else{
            outputLabel.text = "Incorrect"
        }
        
        
    }
    
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
    func updateUI(){
        textBOx.text = ""
        passImage.image = convertBase64StringToImage(imageBase64String: currentImage)
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.progressBar.setProgress(Float(self.count/4), animated: true)
          })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
