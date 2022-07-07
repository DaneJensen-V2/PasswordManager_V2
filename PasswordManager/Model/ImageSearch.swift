import Foundation
import UIKit

struct Image {

    var imageName: String
    var image: UIImage
    
enum CodingKeys: String, CodingKey {
       case imageName
       case image

   }

}
