//
//  NewPasswordViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/14/22.
//

import UIKit
var currentPassword = passwordStruct(WebsiteName: "", WebsiteURL: URL(string: "www.google.com")!, Image: "", Username: "", Password: "")


class NewPasswordViewController: UIViewController {
    @IBOutlet weak var searchcController: UISearchBar!

    let Twitter = passwordStruct(WebsiteName: "Twitter", WebsiteURL: URL(string: "https://twitter.com/login?lang=en")!, Image: "Twitter", Username: "", Password: "")
    let Facebook = passwordStruct(WebsiteName: "Facebook", WebsiteURL: URL(string: "https://www.facebook.com/login/")!, Image: "Facebook", Username: "", Password: "")
    let Instagram = passwordStruct(WebsiteName: "Instagram", WebsiteURL: URL(string: "https://www.instagram.com/login")!, Image: "Instagram", Username: "", Password: "")
    let Google = passwordStruct(WebsiteName: "Google", WebsiteURL: URL(string: "https://accounts.google.com/login")!, Image: "Google", Username: "", Password: "")
    let ASU = passwordStruct(WebsiteName: "ASU", WebsiteURL: URL(string: "https://weblogin.asu.edu/cas/login")!, Image: "ASU", Username: "", Password: "")
    let LinkedIn = passwordStruct(WebsiteName: "LinkedIn", WebsiteURL: URL(string: "https://www.linkedin.com/login")!, Image: "LinkedIn", Username: "", Password: "")
    let Amazon = passwordStruct(WebsiteName: "Amazon", WebsiteURL: URL(string: "https://www.amazon.com/log")!, Image: "Amazon", Username: "", Password: "")
    let Netflix = passwordStruct(WebsiteName: "Netflix", WebsiteURL: URL(string: "https://www.netflix.com/login")!, Image: "Netflix", Username: "", Password: "")
    let Hulu = passwordStruct(WebsiteName: "Hulu", WebsiteURL: URL(string: "https://www.hulu.com/account/signin")!, Image: "Hulu", Username: "", Password: "")
    

    
    
    var data : [passwordStruct] = [passwordStruct]()
    var filteredData : [passwordStruct] = [passwordStruct]()
    
    //var filteredData : [String]!
    @IBOutlet weak var websiteTable: UITableView!
    override func viewDidLoad() {
        data.append(Twitter)
        data.append(Facebook)
        data.append(Instagram)
        data.append(Google)
        data.append(ASU)
        data.append(LinkedIn)
        data.append(Amazon)
        data.append(Netflix)
        data.append(Hulu)
        super.viewDidLoad()
        filteredData = data
        websiteTable.delegate = self
        websiteTable.dataSource = self
        
        searchcController.delegate = self
        // Do any additional setup after loading the view.
        websiteTable.rowHeight = 70

    }
    
    
    @IBAction func touchedOutside(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
   

}
extension NewPasswordViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WebsiteTableViewCell
        let imageString = filteredData[indexPath.row].WebsiteName
        cell.websiteImage.image = UIImage(named: imageString)
        cell.websiteLabel.text = imageString
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPassword = filteredData[indexPath.row]
        performSegue(withIdentifier: "passClicked", sender: nil)
        print(filteredData[indexPath.row].WebsiteName)
    }
}
extension NewPasswordViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        
        if searchText == ""{
            filteredData = data
        }
        for value in data{
            
            if  value.WebsiteName.uppercased().contains(searchText.uppercased())
            {
                filteredData.append(value)
            }
        }
        self.websiteTable.reloadData()
    }
}
