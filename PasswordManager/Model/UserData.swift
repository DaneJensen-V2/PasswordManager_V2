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
    var memorablePasswords : [memorablePassword]



enum CodingKeys: String, CodingKey {
       case UserID
       case firstName
       case lastName
       case hashedPasswords
       case phoneNumber
       case memorablePasswords

   }

}
