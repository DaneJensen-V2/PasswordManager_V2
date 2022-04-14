//
//  UserData.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/9/22.
//

import Foundation
struct UserData : Codable{
    let  UserID : String
    let firstName : String
    let lastName : String
    var hashedPasswords : [passwordStruct]
    let phoneNumber : String



enum CodingKeys: String, CodingKey {
       case UserID
       case firstName
       case lastName
       case hashedPasswords
       case phoneNumber

   }

}
