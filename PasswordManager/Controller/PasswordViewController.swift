//
//  PasswordViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/7/22.
//

import UIKit
var selectedPassword = passwordStruct(WebsiteName: "", WebsiteURL: URL(string: "www.google.com")!, Image: "", Username: "", Password: "", passwordType: "", memIndex: 0)
var rowSelected = 0

class PasswordViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var passwordTable: UITableView!
    var data : [passwordStruct] = [passwordStruct]()

    override func viewDidLoad() {
        

        data = currentUser.hashedPasswords
        super.viewDidLoad()
        passwordTable.delegate = self
        passwordTable.dataSource = self
        
        
       // passwordTable.register(UINib.init(nibName: "PasswordCell", bundle: nil), forCellReuseIdentifier: "PasswordCell")
        passwordTable.register(UINib(nibName : "PasswordTableViewCell", bundle: nil) , forCellReuseIdentifier: "PasswordCell")
        
        passwordTable.rowHeight = 70
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            self.passwordTable.reloadData()
        }
    }
   
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func addButton(_ sender: UIButton) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.passwordTable.reloadData() // a refresh the tableView.

        }

  
   public func updateTable(){
       print("update Table ran" )
        data = currentUser.hashedPasswords
       print(currentUser.hashedPasswords.count)
       if let passwordTable = passwordTable{
           passwordTable.reloadData()
           print("Table Reloaded")
       }
    }
    
}


extension PasswordViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser.hashedPasswords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = passwordTable.dequeueReusableCell(withIdentifier: "PasswordCell", for : indexPath) as! PasswordTableViewCell
        
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
        selectedPassword = currentUser.hashedPasswords[indexPath.row]
        rowSelected = indexPath.row
        performSegue(withIdentifier: "passSelected", sender: nil)
    }
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
