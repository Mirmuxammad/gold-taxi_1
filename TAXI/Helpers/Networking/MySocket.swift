// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 21/02/21
//  

import Foundation
import SocketIO
import SwiftyJSON

//['ordered', 'waitingDriver', 'waitingRider', 'in_progress', 'finished', 'canceled', 'upcoming', 'pre_cancelled']

public protocol MySocketDelegate {
    func didOrdered()
    func didWaitingDriver()
    func didWaitingRider()
    func didInProgress()
    func didFinished()
    func didCancelled()
    func didIAmComing()
    func didPreCancelled()
    func didDriverLocationChanged(location_name: String, latitude: Double, longitude: Double, bearing: Double, speed: Double)
    func didRideCostChange(total_cost: Int)
    
}

public class MySocket {
    

    var socketDelegate: MySocketDelegate?
    
    public static let `default` = MySocket()
    
    private let manager: SocketManager = SocketManager(socketURL: URL(string: API.baseURL)!, config: [ .path("/api/socket.io/"), .extraHeaders(["Authorization" : "Bearer \(Cache.getUser()?.token ?? "")"]), .forcePolling(true), .compress])

    
    
     private init() {
        manager.defaultSocket.on(clientEvent: .connect) { (a, b) in
            mylog("CONNECTED")
//            if let ride_id = Cache.getLastOrderID() {
//                print("RECONNECT-----")
//                self.listenSocket(for: ride_id)
//            }
        }
        

    }
   
    
    public func openConnection() {
        manager.defaultSocket.connect()
    }
    
   
    
    
    public func listenSocket(for id: String) {
        
        manager.defaultSocket.on(id) { (data, emiter) in
            let st = data.first as! NSDictionary
            let jsonData = JSON(st)
            print("SOCKET JSONDATA: ", jsonData)
            switch jsonData["type"].stringValue{
            case "ordered":
                print("ordered🥰🥰")
                self.socketDelegate?.didOrdered()
            case "waitingDriver":
                self.socketDelegate?.didWaitingDriver()
                
            case "waitingRider":
                self.socketDelegate?.didWaitingRider()
            case "in_progress":
                print("in progreesss🥰🥰")
                self.socketDelegate?.didInProgress()
            case "finished":
                print("finished🥰🥰")
                self.socketDelegate?.didFinished()
            case "canceled":
                print("cancelled🥰🥰")
                self.socketDelegate?.didCancelled()
            case "i_am_coming":
                print("i am coming🥰🥰")
                self.socketDelegate?.didIAmComing()
            case "pre_cancelled":
                print("pre_cancelled 🥰🥰")
                self.socketDelegate?.didPreCancelled()
                
            case "driver_location_change":
                self.socketDelegate?.didDriverLocationChanged(location_name: jsonData["data"]["location"]["location_name"].stringValue, latitude: jsonData["data"]["location"]["latitude"].doubleValue, longitude: jsonData["data"]["location"]["longitude"].doubleValue, bearing: jsonData["data"]["bearing"].doubleValue, speed: jsonData["data"]["speed"].doubleValue)
            
            case "ride_cost_change":
                self.socketDelegate?.didRideCostChange(total_cost: jsonData["data"]["total_cost"].intValue)
                print("ride cost change 🥰🥰")
            case "message":
                let chatdm = ChatDM.init(
                    ride_id: jsonData["data"]["ride_id"].stringValue,
                    message_text: jsonData["data"]["message_text"].stringValue,
                    time: jsonData["data"]["time"].doubleValue,
                    created_at: jsonData["data"]["created_at"].stringValue,
                    from: jsonData["data"]["from"].stringValue,
                    to: jsonData["data"]["to"].stringValue,
                    from_user: jsonData["data"]["from_user"].stringValue,
                    from_image: jsonData["data"]["from_image"].stringValue ,
                    to_image: jsonData["data"]["to_image"].stringValue)
                
                MessageNotification.postMessageNotification(data: chatdm)
            default:
                break
            }
            
           
        }
        

    }
    
    
    public func sendMessage(with text: String, ride_id: String, to: String) {
        let userID = Cache.getUser()?.id ?? ""
        let messageString = """
{
  "from_user": "rider",
  "from": "\(userID)",
  "to": "\(to)",
  "ride_id": "\(ride_id)",
  "message_text": "\(text)"
}
"""
        manager.defaultSocket.emit("message", messageString)
    }
    
    
    public func disconnect() {
        manager.defaultSocket.disconnect()
    }
    
    
    
}
