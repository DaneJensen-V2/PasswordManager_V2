//
//  CheckAccountViewController.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/25/22.
//

import UIKit

class CheckAccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let headers = [
            "hibp-api-key:": "79217b8e9cfd4b6895b2b187d6d76a48"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://haveibeenpwned.com/api/v3/breachedaccount/danejensen8")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
            }
        })

        dataTask.resume()
        // Do any additional setup after loading the view.
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
