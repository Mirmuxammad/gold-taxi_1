// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 09/02/21
//  

import Foundation

struct EstimatedPriceDM : Codable{
    
    var price: Int
    var total_distance : Double?
    var name: String
    var image: String
    var _id: String
    var isPressed : Bool? = false
    var is_lightning : Bool = false
    var is_delivery: Bool
    var delivery_cost : Int
    var waiting_time : Int
    var per_km_value : Int
    var per_minute_value : Int
    var starting_value : Int
}
