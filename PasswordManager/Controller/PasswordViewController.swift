//
//  PasswordViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/7/22.
//

import UIKit

class PasswordViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var passwordTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTable.delegate = self
        passwordTable.dataSource = self
        
        
       // passwordTable.register(UINib.init(nibName: "PasswordCell", bundle: nil), forCellReuseIdentifier: "PasswordCell")
        passwordTable.register(UINib(nibName : "PasswordTableViewCell", bundle: nil) , forCellReuseIdentifier: "PasswordCell")
        
        passwordTable.rowHeight = 80

    }
   
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func addButton(_ sender: UIButton) {
        
    }
    
}


extension PasswordViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = passwordTable.dequeueReusableCell(withIdentifier: "PasswordCell", for : indexPath) as! PasswordTableViewCell
        
        return cell
    }
    
    
}
