//
//  CheckAccountViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/25/22.
//

import UIKit

var selectedBreach = Breaches(Name: "", Domain: "", BreachDate: "", Description: "", LogoPath: "")

class CheckAccountViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var accountText: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var accountTable: UITableView!
    var breaches = [Breaches]()
    override func viewDidLoad() {
        super.viewDidLoad()
        accountTable.delegate = self
        accountTable.dataSource = self
        accountTable.register(UINib(nibName : "BreachTableViewCell", bundle: nil) , forCellReuseIdentifier: "breachCell")
        accountTable.rowHeight = 70
        spinner.isHidden = true
        self.hideKeyboardWhenTappedAround()
        selectedUsername = ""
    }
    override func viewWillAppear(_ animated: Bool) {
        accountText.text = selectedUsername
    }
    @IBAction func returnPushed(_ sender: UITextField) {
        breaches = []
        dismissKeyboard()
        accountTable.isHidden = true
        spinner.isHidden = false
        spinner.startAnimating()
        getData(completion: {  [self]success in
            DispatchQueue.main.async {
            print("return Completion ran")
            spinner.isHidden = true
            accountTable.isHidden = false
            print(breaches)
            
                self.accountTable.reloadData()
            }
        })

    }
    func reloadTable(){
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
            self.accountTable.reloadData()
            }
 
    }
    @IBAction func enterPushed(_ sender: UIButton) {
        breaches = []
        accountTable.isHidden = true
        spinner.isHidden = false
        spinner.startAnimating()
        getData(completion: { success in
            DispatchQueue.main.async {
            print("enter Completion ran")
            self.accountTable.isHidden = false
            self.spinner.isHidden = true
            self.spinner.stopAnimating()
            print(self.breaches)
           
                self.accountTable.reloadData()
            }
        })

    }


    func getData(completion: @escaping (Bool) -> Void){
        print("getData Ran")


    let headers = [
        "hibp-api-key": "09167546760f48c68f2f0537704c7ba7",
        "user-agent": "PasswordManager"
    ]

    let request = NSMutableURLRequest(url: NSURL(string: "https://haveibeenpwned.com/api/v3/breachedaccount/" + accountText.text! + "?truncateResponse=false")! as URL,
                                            cachePolicy: .useProtocolCachePolicy,
                                        timeoutInterval: 10.0)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers

    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error)
            completion(false)
        } else {
            self.parseJSON(safeData: data!, completion: { success in
                print("Completion Get Ran")
                completion(true)
            })
        }
    })

    dataTask.resume()
    // Do any additional setup after loading the view.
}
func parseJSON(safeData : Data, completion: @escaping (Bool) -> Void){
    print("Parse JSON ran")
    let decoder = JSONDecoder()
    //print("parseRun")
  //  print(runNumber)
    do {
        let decodedData = try decoder.decode([Breaches].self, from: safeData)
        for item in decodedData{
            breaches.append(item)
        }
        print("Completion Parse Ran")
        completion(true)

    }
    catch{
    print(error)
        completion(false)


    }
}
}

extension CheckAccountViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breaches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("table view ran")
        
        let cell = accountTable.dequeueReusableCell(withIdentifier: "breachCell") as! BreachTableViewCell
        cell.cellLabel.text = breaches[indexPath.row].Name
        let url = URL(string: breaches[indexPath.row].LogoPath)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        
        
        cell.cellImage.image = UIImage(data: data!)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        selectedBreach = breaches[indexPath.row]
        performSegue(withIdentifier: "accountInfo", sender: nil)
        accountTable.deselectRow(at: indexPath, animated: true)
    }
    
}


