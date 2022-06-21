// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 06/02/21
//  

import UIKit


struct ChatDM : Codable{
    var ride_id: String
    var message_text: String
    var time: Double
    var created_at : String
    var from: String
    var to: String
    var from_user : String
    var from_image: String
    var to_image: String
}
