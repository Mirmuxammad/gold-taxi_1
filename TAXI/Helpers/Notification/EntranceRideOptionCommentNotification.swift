// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 10/03/21
//  

import UIKit


class EntranceRideOptionCommentNotification{
    
    //RIDE OPTION
    class func createRideOptionObservers(listener: @escaping (Bool) -> Void){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "ride_option.notification"), object: nil, queue: .main) { (n) in
            guard let b = n.userInfo?["data"] as? Bool else {return}
            listener(b)
        }
        
    }
    
    
    
    class func postRideOptionNotification(isON: Bool){
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ride_option.notification"), object: nil, userInfo: ["data": isON])
    }
    
    
    //COMMENT
    class func createCommentObservers(listener : @escaping (String) -> Void){
        NotificationCenter.default.addObserver(forName : NSNotification.Name(rawValue: "comment.notification"), object: nil, queue: .main) { (n) in
            guard let str = n.userInfo?["data"] as? String else {return}
            listener(str)
        }
    }
    
    class func postCommentNotification(str: String){
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "comment.notification"), object: nil, userInfo: ["data":str])
    }
    
    
    
    //ENTRANCE
    class func createEntranceObservers(listener: @escaping (String) -> Void){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "entrance.notification"), object: nil, queue: .main) { (n) in
            guard let str = n.userInfo?["data"] as? String else {return}
            listener(str)
        }
        
    }
    
    
    
    class func postEntranceNotification(str: String){
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "entrance.notification"), object: nil, userInfo: ["data":str])
    }
    //ENTRANCE
    class func createSomeonePhoneObservers(listener: @escaping (String) -> Void){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "someone.notification"), object: nil, queue: .main) { (n) in
            guard let str = n.userInfo?["data"] as? String else {return}
            listener(str)
        }
        
    }
    
    
    
    class func postSomeonePhoneNotification(str: String){
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "someone.notification"), object: nil, userInfo: ["data":str])
    }
    
    
}
