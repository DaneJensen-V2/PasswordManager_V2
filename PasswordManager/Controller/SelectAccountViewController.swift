//
//  SelectAccountViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 5/5/22.
//

import UIKit
var selectedUsername = ""
var selectedPassword2 = ""
class SelectAccountViewController: UIViewController, UITableViewDelegate  {

    @IBOutlet weak var accountTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        accountTable.delegate = self
        accountTable.dataSource = self
        accountTable.register(UINib(nibName : "PasswordTableViewCell", bundle: nil) , forCellReuseIdentifier: "PasswordCell")
        accountTable.rowHeight = 70
    }
    

  
    

}

extension SelectAccountViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser.hashedPasswords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = accountTable.dequeueReusableCell(withIdentifier: "PasswordCell", for : indexPath) as! PasswordTableViewCell
        
        let imageString = currentUser.hashedPasswords[indexPath.row].WebsiteName
        let object = currentUser.hashedPasswords[indexPath.row]
        cell.passImage.image = UIImage(named: imageString)
        cell.websiteName.text = object.WebsiteName
        cell.usernameLabel.text = object.Username
        if(currentUser.hashedPasswords[indexPath.row].passwordType == "Memorable"){
            cell.passTypeImage.image = UIImage(systemName: "brain.head.profile")?.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
        }
        else if(currentUser.hashedPasswords[indexPath.row].passwordType == "Custom"){
            cell.passTypeImage.image = UIImage(systemName: "gearshape")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        }
        else if(currentUser.hashedPasswords[indexPath.row].passwordType == "Secure"){
            cell.passTypeImage.image = UIImage(systemName: "lock")?.withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUsername = currentUser.hashedPasswords[indexPath.row].Username
        selectedPassword2 = currentUser.hashedPasswords[indexPath.row].Password

        rowSelected = indexPath.row
        self.navigationController?.popViewController(animated: true)

    }
    
}
