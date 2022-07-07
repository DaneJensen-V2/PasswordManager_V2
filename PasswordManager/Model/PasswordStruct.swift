//
//  File.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/12/22.
//

import Foundation
import UIKit
struct passwordStruct : Codable{
    let  WebsiteName : String
    let  WebsiteURL : URL
    let  Image: String
    let  Username : String
    var  Password : String
    var  passwordType : String
    var memIndex : Int
    
    init(WebsiteName : String, WebsiteURL : URL, Image : String, Username : String, Password : String, passwordType : String, memIndex : Int){
        self.WebsiteName = WebsiteName
        self.WebsiteURL = WebsiteURL
        self.Image = WebsiteName
        self.Username = Username
        self.Password = Password
        self.passwordType = passwordType
        self.memIndex = memIndex
    }

enum CodingKeys: String, CodingKey {
       case WebsiteName
       case WebsiteURL
       case Image
       case Username
       case Password
       case passwordType
       case memIndex
   }

}
