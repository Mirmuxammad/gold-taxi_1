// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 07/02/21
//  

import UIKit

struct UserDM : Codable{
    
    var state : String?
    var currentRide: Bool? = nil
    var id : String?
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var token: String?
    var image: String? = nil
}
