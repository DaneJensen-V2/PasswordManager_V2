//
//  File.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/12/22.
//

import Foundation
struct passwordStruct : Codable{
    let  WebsiteName : String
    let  WebsiteTitle : String
    let  Image: String
    let  Username : String
    var  Password : [String]



enum CodingKeys: String, CodingKey {
       case WebsiteName
       case WebsiteTitle
       case Image
       case Username
       case Password

   }

}
