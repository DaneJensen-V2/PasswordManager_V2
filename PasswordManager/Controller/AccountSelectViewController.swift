//
//  AccountSelectViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 5/5/22.
//

import UIKit

class AccountSelectViewController: UIViewController {


    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: selectedBreach.LogoPath)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        
        
        logoImage.image = UIImage(data: data!)
        logoLabel.text = selectedBreach.Name
        articleLabel.text = selectedBreach.Description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        dateLabel.text = "Date: " + selectedBreach.BreachDate
        // Do any additional setup after loading the view.
    }
    
    @IBAction func linkClici(_ sender: UIButton) {
        
        guard let url = URL(string: "https://" + selectedBreach.Domain) else {
             return
        }

        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
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
