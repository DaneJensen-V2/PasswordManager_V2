//
//  Hashes.swift
//  PasswordManager
//
//  Created by Dane Jensen on 4/10/22.
//

import Foundation
struct Hashes : Codable{
    let hash : String
    let value : Int



enum CodingKeys: String, CodingKey {
     case  hash
     case  value
   }

}
