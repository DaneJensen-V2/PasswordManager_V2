import Foundation
import UIKit

struct memorablePassword : Codable{

    var Name: [String]
    var Image: [String]
    

enum CodingKeys: String, CodingKey {
       case Name
       case Image

   }

}
