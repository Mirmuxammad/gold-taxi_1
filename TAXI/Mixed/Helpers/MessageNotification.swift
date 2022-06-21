// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 25/02/21
//  

import UIKit


class MessageNotification{
    
    
    class func createMessageObservers(listener: @escaping (ChatDM) -> Void){
    NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "message.notification"), object: nil, queue: .main) { (n) in
        guard let chatData = n.userInfo?["data"] as? ChatDM else {return}
        listener(chatData)
    }
    }
    

    
    class func postMessageNotification(data: ChatDM){

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "message.notification"), object: nil, userInfo: ["data":data])
    }
    
}
