// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 07/02/21
//  

import Foundation
import Alamofire
import SwiftyJSON



class API {
    
    static let baseURL: String = "http://157.245.149.115:8080"
    public static var ride_id = ""
    public static var isUserTokenExpired = false
    struct Endpoints {
        static let login: String = API.baseURL + "/rider/login"
        static let verify: String = API.baseURL + "/rider/verify"
        static let register: String = API.baseURL + "/rider/register"
        static let firebase_token = API.baseURL + "/rider/firebase-token/set"
        static let ride_history : String = API.baseURL + "/rider/ride/history-pagin"
        static let estimated_price : String = API.baseURL + "/ride/estimate-price"
        static let get_near_car : String = API.baseURL + "/near-cars/get"
        static let create_ride : String = API.baseURL + "/rider/ride/create"
        static let cancel_ride : String = API.baseURL + "/rider/ride/cancel"
        static let rate_ride : String = API.baseURL + "/rider/ride/rate"
        static let retry_ride : String = API.baseURL + "/ride/retry"
        static let message_history : String = API.baseURL + "/messages/history"
        static let ride_full_info : String = API.baseURL + "/rider/ride/last"
        static let i_am_coming : String = API.baseURL + "/ride/rider/i-am-coming"
        static let corporative_ride : String = API.baseURL + "/rider/corporative-ride/create"
        static let estimated_price_from : String = API.baseURL + "/ride/estimate-price-from"
        static let get_cards : String = API.baseURL + "/rider/card/get"
        static let upload_file : String = API.baseURL + "/upload-file"
        static let update_user_info : String = API.baseURL + "/rider/update"
        
        static let create_card : String = API.baseURL + "/rider/card/create"
        static let card_verify : String = API.baseURL + "/rider/card/verify"
        static let card_get : String = API.baseURL + "/rider/card/get"
        static let card_delete : String = API.baseURL + "/rider/card/delete"
        static let place_get_by_loc : String = API.baseURL + "/place/get-by-location"
        static let search_place : String = API.baseURL + "/places/search"
        
    }
    
    
    //MARK: - Login
    class func login(phoneNumber: String, completion: @escaping (Bool?) -> Void ) {
        
        let param: [String : String] = [
            "phone_number" : phoneNumber
        ]
        
        Net.request(url: Endpoints.login, method: .post, params: param, headers: nil, withLoader: true) { (data) in
            guard let data = data else {completion(nil); return}
            
            let statusCode: Int = data["code"].intValue
            
            switch statusCode {
            case 0:
                completion(true)
            case 60002, 56001:
                completion(false)
            case 55001:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .validation_error))
            case 100:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .too_many_attempts))
            default:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .unknown_error_occured))
            }
        }
        
    }
    
    //MARK: - Verify
    class func verify(phone: String, otp: String, succeed: @escaping (Bool) -> Void) {
        let param: [String : String] = [
            "phone_number" : phone,
            "otp" : otp
        ]
        Net.reqMultiPart(url: Endpoints.verify, params: param, method: .post, withLoader: true, headers: nil) { (data) in
            guard let data = data else {succeed(false); return}
            
            let statusCode = data["code"].intValue
            
            switch statusCode{
            case 0:
                let user = UserDM(state: data["data"]["state"].stringValue, id: data["data"]["_id"].stringValue, firstName: data["data"]["first_name"].stringValue, lastName: data["data"]["last_name"].stringValue, phoneNumber: data["data"]["phone_number"].stringValue, token: data["data"]["token"].stringValue, image: data["data"]["image"].stringValue)
                Cache.saveUser(data: user) { (done) in
                    if done {
                        succeed(true)
                    } else {
                        succeed(false)
                        Alert.showAlert(forState: .error, message: "User not saved")
                    }
                }
            case 100:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .too_many_attempts))
            case 55000:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .unknown_error_occured))
            case 55001:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .invalid_phone_number))
            case 56003:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .code_does_not_match))
            case 56005:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .code_expired))
            case 60002:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .driver_not_found))
            default:
                break
            }
        }
        
    }
    
    class func register(phone_number: String, first_name:String, last_name : String, completion: @escaping (Bool) -> Void) {
        
        let param : [String : String] = [
            "first_name" : first_name,
            "last_name" : last_name,
            "phone_number" : phone_number
        ]
        
        Net.request(url: Endpoints.register, method: .post, params: param, headers: nil, withLoader: true) { (data) in
            guard let data = data else {completion(false); return}
            
            let statusCode = data["code"].intValue
            
            switch statusCode{
            case 0:
                completion(true)
            case 55000:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .unknown_error_occured))
            case 55001:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .validation_error))
            case 57001:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .couldnt_send_sms))
            case 60001, 5600:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .user_already_exist))
                completion(false)
            default:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .unknown_error_occured))
            }
        }
        
    }
    
//    //MARK: Firebase token setup
//    class func sendFirebaseToken(token : String){
//
//        let param = ["firebase_token": token ]
//        let userToken = Cache.getUser()?.token ?? ""
//        let header : HTTPHeaders = ["Authorization" : "Bearer \(userToken)"]
//        Net.request(url: Endpoints.firebase_token, method: .post, params: param, headers: header, withLoader: false) { (data) in
//            guard let data = data else {return}
//
//            mylog(data, "Firebase token")
//        }
//    }
//
    
    
    //MARK: - RideHistory
    class func getRideHistorySorted(limit: Int, page: Int, completion: @escaping ([RideHistoryDM]?) -> Void) {

        let param : [String:Any] = [
            "limit" : limit,
            "page" : page,
            "state" : "finished",
            "user_type" : "rider"

        ]
        let token = Cache.getUser()?.token ?? ""


        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]

        Net.request(url: Endpoints.ride_history, method: .post, params: param, headers: header, withLoader: false) { (data) in
            guard let data = data else{ return }
            let statusCode = data["code"].intValue
            switch statusCode {
            case 0:
                var rideHistoryData : [RideHistoryDM] = []
                for i in 0..<data["data"]["data"].count  where data["data"]["data"][i]["destination_location"]["location_name"].stringValue.count != 0{

                    rideHistoryData.append(RideHistoryDM(location_name: data["data"]["data"][i]["destination_location"]["location_name"].stringValue,start_location_name: data["data"]["data"][i]["start_location"]["location_name"].stringValue, lon: data["data"]["data"][i]["destination_location"]["longitude"].stringValue, lat: data["data"]["data"][i]["destination_location"]["latitude"].stringValue, total_cost: data["data"]["data"][i]["total_cost"].doubleValue, ride_date: data["data"]["data"][i]["ride_last_time"].stringValue))

                }
                completion(rideHistoryData)
            default:
                completion(nil)
            }
        }

    }
    
    //MARK: - RideHistory
    class func getRideHistory(limit: Int, page: Int, completion: @escaping ([RideHistoryDM]?) -> Void) {
        
        let param : [String:Any] = [
            "limit" : limit,
            "page" : page,
            "state" : "finished",
            "user_type" : "rider"
            
        ]
        let token = Cache.getUser()?.token ?? ""
        
        
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        
        Net.request(url: Endpoints.ride_history, method: .post, params: param, headers: header, withLoader: false) { (data) in
            guard let data = data else{ return }
            let statusCode = data["code"].intValue
            
            switch statusCode {
            case 0:
                var rideHistoryData : [RideHistoryDM] = []
                for i in 0..<data["data"]["data"].count{

                    rideHistoryData.append(RideHistoryDM(location_name: data["data"]["data"][i]["destination_location"]["location_name"].stringValue, start_location_name: data["data"]["data"][i]["start_location"]["location_name"].stringValue, lon: data["data"]["data"][i]["destination_location"]["longitude"].stringValue, lat: data["data"]["data"][i]["destination_location"]["latitude"].stringValue, total_cost: data["data"]["data"][i]["total_cost"].doubleValue, ride_date: data["data"]["data"][i]["ride_last_time"].stringValue))
                    
                }
                completion(rideHistoryData)
            default:
                completion(nil)
            }
        }
        
    }
    
    //MARK: - Get Pagination
    class func getTotalNumberOfHistory(completion: @escaping ((Int) -> Void)){
        let param : [String:Any] = [
            "limit" : 10,
            "page" : 1,
            "state" : "finished",
            "user_type" : "rider"
            
        ]
        let token = Cache.getUser()?.token ?? ""
        
        
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        Net.request(url: Endpoints.ride_history, method: .post, params: param, headers: header, withLoader: false) { (data) in
            guard let data = data else {return}
            let statusCode = data["code"].intValue
           
            if statusCode == 0{
                completion(data["data"]["total"].intValue)
            }else{
                completion(0)
            }
        }       
    }
    
    
    
    //MARK: - Estimated price
    class func getEstimatedPrice(locationName: String, locLong: Double, locLat: Double, destination_name: String, dest_long: Double, dest_lat: Double, ride_pols : [[String:Double]]?, completion: @escaping ([EstimatedPriceDM]?) -> Void){
        let param : [String : Any] = [
            "destination": [
                "latitude": dest_lat,
                "location_name": destination_name,
                "longitude": dest_long,
                "mode" : "START"
            ],
            "location": [
                "latitude": locLat,
                "location_name": locationName,
                "longitude": locLong,
                "mode" : "START"
                
            ],
            "ride_pols": ride_pols
        ]
        
        let token = Cache.getUser()?.token ?? ""
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        
        Net.request(url: Endpoints.estimated_price, method: .post, params: param, headers: header, withLoader: false) { (data) in
            guard let data = data else { return}
            
            let statusCode = data["code"].intValue
            mylog("ESTIMATED PRICE: \(data["data"])")
            switch statusCode{
            case 0:
                var estimatedPriceData : [EstimatedPriceDM] = []
                var bool = false
                for i in 0..<data["data"].count{
                    bool = i == 1 ? true : false
                    estimatedPriceData.append(EstimatedPriceDM(price: data["data"][i]["price"].intValue, total_distance: data["data"][i]["total_distance"].doubleValue, name: data["data"][i]["name"].stringValue, image: "/api/" + data["data"][i]["image"].stringValue, _id: data["data"][i]["_id"].stringValue, isPressed: bool, is_lightning: data["data"][i]["is_lightning"].boolValue, is_delivery: data["data"][i]["is_delivery"].boolValue, delivery_cost: data["data"][i]["delivery_cost"].intValue, waiting_time: data["data"][i]["waiting_time"].intValue, per_km_value: data["data"][i]["per_km_value"].intValue, per_minute_value: data["data"][i]["per_minut_value"].intValue, starting_value: data["data"][i]["starting_value"].intValue))
                }
                completion(estimatedPriceData)
            default:
                completion(nil)
                
            }
        }
        
    }
    
    //MARK: - Estimated price for unknown destination
    
    class func getEstimatedPriceFrom(completion: @escaping (([EstimatedPriceDM])?) -> Void){
        
        let token = Cache.getUser()?.token ?? ""
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        
        Net.request(url: Endpoints.estimated_price_from, method: .post, params: nil, headers: header, withLoader: false) { (data) in
            guard let data = data else {return}
            let statusCode = data["code"].intValue
            
            switch statusCode{
            case 0:
                var estdata = [EstimatedPriceDM]()
                var bool = false
                for i in 0..<data["data"].count{
                    bool = i == 1 ? true : false
                    estdata.append(EstimatedPriceDM(price: data["data"][i]["price"].intValue, name: data["data"][i]["name"].stringValue, image: "/api" +  data["data"][i]["image"].stringValue, _id: data["data"][i]["_id"].stringValue, isPressed: bool, is_lightning: data["data"][i]["is_lightning"].boolValue, is_delivery: data["data"][i]["is_delivery"].boolValue,
                        delivery_cost: data["data"][i]["delivery_cost"].intValue,
                        waiting_time: data["data"][i]["waiting_time"].intValue,
                        per_km_value: data["data"][i]["per_km_value"].intValue,
                        per_minute_value: data["data"][i]["per_minut_value"].intValue,
                        starting_value: data["data"][i]["starting_value"].intValue))
                }
                completion(estdata)
            default:
                completion(nil)
                break
            }
        }
    }
    
    
    //MARK: - Near cars get
    class func getNearCars(location_name: String, long: Double, lat: Double, completion: @escaping ([NearCarsDM]?) -> Void) {
        
        let param : [String: Any] = [
            "location_name" : location_name,
            "latitude" : lat,
            "longitude" : long
        ]
        
        let token = Cache.getUser()?.token ?? ""
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
       
        Net.requestNearCars(url: Endpoints.get_near_car, method: .post, params: param, headers: header, withLoader: false) { (data) in
            guard let data = data else {return}
            let statusCode = data["code"].intValue
            switch statusCode{
            case 0:
                var nearCarsData : [NearCarsDM] = []
                for i in 0..<data["data"].count {
                    nearCarsData.append(NearCarsDM(location_name: data["data"][i]["current_location"]["location_name"].stringValue, longitude: data["data"][i]["current_location"]["longitude"].doubleValue, latitude: data["data"][i]["current_location"]["latitude"].doubleValue))
                    
                }
                completion(nearCarsData)
                
                
            case 55000, 55001:
                completion(nil)
                Alert.showAlert(forState: .error, message: Lang.getString(type: .unknown_error_occured))
            case 401:
                if !isUserTokenExpired{
                    Cache.deleteUser()
                    UserDefaults.standard.setValue(false, forKey: CONSTANTS.SHOULD_OPEN_FINDVC)
                    let vc = LoginVC(nibName: "LoginVC", bundle: nil)
                    let window = UIApplication.shared.keyWindow
                    window?.rootViewController = UINavigationController(rootViewController: vc)
                    window?.makeKeyAndVisible()
                    isUserTokenExpired = true
                }
                
            default:
                completion(nil)
                Alert.showAlert(forState: .error, message: data["error"].stringValue)
                
            }
        }
    }
    
    
    
    //MARK: - Create Ride
    class func createRide(car_class : String, payment_method: String, card_number : String, estimated_price: Int, total_cost : Int, total_distance : Double, entrance : String, air_conditioner: Bool, start_location : [String : Any], destination_location : [String : Any], ride_pols : [[String:Double]]?, comment: String, rider_type: String, rider_phone: String, order_from: [String: Any]?, order_to : [String : Any]?, door_to_door : Bool, completion :  @escaping (Bool) -> Void) {
        
        var param : [String: Any] = [
            "air_conditioner" : air_conditioner,
            "entrance" : entrance,
            "car_class" : car_class,
            "estimated_price" : estimated_price,
            "payment_method" : payment_method,
            "card_number" : card_number,
            "comment" : comment,
            "state" : "ordered",
            "ride_pols" : ride_pols,
            "start_location": [
                "latitude": start_location["latitude"],
                "location_name": start_location["location_name"],
                "longitude": start_location["longitude"],
                "mode" : "START"],
            "destination_location": [
                "latitude": destination_location["latitude"],
                "location_name": destination_location["location_name"],
                "longitude": destination_location["longitude"],
                "mode" : "START"
            ],
            "total_cost" : total_cost,
            "rider_type" : rider_type,
            "rider_phone" : rider_phone
        ]
        
    
        
        if payment_method == "cash"{
            param["card_number"] = nil
            if rider_type == "self"{
                param["rider_phone"] = nil
            }else{
                param["rider_phone"] = rider_phone
            }
        }else{
            param["card_number"] = card_number
            if rider_type == "self"{
                param["rider_phone"] = nil
            }else{
                param["rider_phone"] = rider_phone
            }
        }
        
        if let order_from = order_from, let order_to = order_to {
            
            param["order_from"] =  order_from
            param["order_to"] = order_to
        }
        
        let token = Cache.getUser()?.token ?? ""
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        
        Net.request(url: Endpoints.create_ride, method: .post, params: param, headers: header, withLoader: true) { (data) in
            guard let data = data else {return}
            let statusCode = data["code"].intValue
            switch statusCode{
            case 0:
                ride_id = data["data"]["_id"].stringValue
                MySocket.default.listenSocket(for: ride_id)

                completion(true)
            case 55000:
                completion(false)
                Alert.showAlert(forState: .error, message: Lang.getString(type: .unknown_error_occured))
            case 55001:
                completion(false)
                Alert.showAlert(forState: .error, message: Lang.getString(type: .validation_error))
            case 56001:
                completion(false)
                Alert.showAlert(forState: .error, message: Lang.getString(type: .user_not_found))
            case 70002:
                completion(false)
                Alert.showAlert(forState: .error, message: Lang.getString(type: .car_class_not_found))
            default:
                completion(false)
                Alert.showAlert(forState: .error, message: Lang.getString(type: .unknown_error_occured))
            }
        }
    }
    
    
    
    //MARK: - Corporative Ride
    class func createCorporativeRide(air_conditioner: Bool, entrance: String, comment: String, car_class_id: String, estimated_price: Double, payment_method : String, card_number: String, ride_pols: [[String:Any]], start_location: [String: Any], total_cost: Double, rider_type : String, rider_phone: String, completion: @escaping ((Bool)) -> Void){
        
        var param : [String: Any] = [
            "air_conditioner" : air_conditioner,
            "entrance" : entrance,
            "car_class" : car_class_id,
            "estimated_price" : estimated_price,
            "payment_method" : payment_method,
            "card_number" : card_number,
            "comment" : comment,
            "ride_pols" : [],
            "start_location": [
                "latitude": start_location["latitude"],
                "location_name": start_location["location_name"],
                "longitude": start_location["longitude"],
                "mode" : "START"],
            "total_cost" : total_cost,
            "rider_type" : rider_type,
            "rider_phone" : rider_phone
        ]
        
    
        
        if payment_method == "cash"{            
            param["card_number"] = nil
            if rider_type == "self"{
                param["rider_phone"] = nil
            }else{
                param["rider_phone"] = rider_phone
            }
        }else{
            param["card_number"] = card_number
            if rider_type == "self"{
                param["rider_phone"] = nil
            }else{
                param["rider_phone"] = rider_phone
            }
        }
        
        
        let token = Cache.getUser()?.token ?? ""
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        
        Net.request(url: Endpoints.corporative_ride, method: .post, params: param, headers: header, withLoader: false) { (data) in
            guard let data = data else {return}
            let statusCode = data["code"].intValue
            switch statusCode{
            
            case 0:
                ride_id = data["data"]["_id"].stringValue
                MySocket.default.listenSocket(for: ride_id)
                completion(true)
            case 55000:
                completion(false)
                Alert.showAlert(forState: .error, message: Lang.getString(type: .unknown_error_occured))
            case 55001:
                completion(false)
                Alert.showAlert(forState: .error, message: Lang.getString(type: .validation_error))
            case 56001:
                completion(false)
                Alert.showAlert(forState: .error, message: Lang.getString(type: .user_not_found))
            case 70002:
                completion(false)
                Alert.showAlert(forState: .error, message: Lang.getString(type: .car_class_not_found))
            default:
                completion(false)
                Alert.showAlert(forState: .error, message: Lang.getString(type: .unknown_error_occured))
            }
        }
        
    }
    
    
    
    
    //MARK: - I am coming
    
    class func iAmComing(ride_id: String, completion: @escaping (Bool) -> Void){
        
        let params : [String : String] = ["ride_id" : ride_id]
        
        let token = Cache.getUser()?.token ?? ""
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        
        Net.request(url: Endpoints.i_am_coming, method: .post, params: params, headers: header, withLoader: false) { (data) in
            guard let data = data else {return}
            
            let statusCode = data["code"].intValue
            
            if statusCode == 0{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    //MARK: Cancel Ride
    class func cancelRide(ride_id: String, cancelled_location: [String: Any], cancel_reason : String, completion: @escaping (Bool) -> Void){
        
        let params : [String: Any] = [
            "canceled_by" : "rider",
            "cancelled_location" : cancelled_location,
            "cancel_reason" : cancel_reason,
            "ride_id" : ride_id
        ]
        
        let token = Cache.getUser()?.token ?? ""
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        
        Net.request(url: Endpoints.cancel_ride, method: .post, params: params, headers: header, withLoader: false) { (data) in
            
            guard let data = data else {return}
            let statusCode = data["data"]["code"].intValue
            switch statusCode{
            case 0:
                completion(true)
                Cache.saveLastOrderID(id: nil)
            case 49000:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .no_enough_permission))
            case 55000:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .unknown_error_occured))
            case 55001:
                completion(false)
                Alert.showAlert(forState: .unknown, message: "\(data)")
                //Alert.showAlert(forState: .error, message: Lang.getString(type: .validation_error))
            case 56001:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .rider_not_found))
            case 60002:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .driver_not_found))
            default:
                break
            }
            
        }
        
    }
    
    //MARK:- Retry Ride
    class func retryRide(ride_id: String, completion: @escaping ((Bool)?) -> Void){
        
        let params : [String: String] = ["ride_id" : ride_id]
        let token = Cache.getUser()?.token ?? ""
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        
        Net.request(url: Endpoints.retry_ride, method: .post, params: params, headers: header, withLoader: false) { (data) in
            guard let data = data else {return}
            
            let statusCode = data["code"].intValue
            
            switch statusCode{
            case 0:
                completion(true)
            default:
                completion(false)
                break
            }
        }
    }
    
    
    
    //MARK: Rate Ride
    class func rateRide(ride_id: String, rate: Int, rider_comment: String, rider_feeds: [String]){
        
        
        let params : [String : Any] = [
            "ride_id" : ride_id,
            "rate" : rate,
            "rider_comment" : rider_comment,
            "rider_feeds" : rider_feeds
        ]
        
        let token = Cache.getUser()?.token ?? ""
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        
        Net.request(url: Endpoints.rate_ride, method: .post, params: params, headers: header, withLoader: false) { (data) in
            guard let data = data else {return}
            print(data, "Rate Response data")
            let statusCode = data["code"].intValue
            
            switch statusCode{
            case 0:
                Alert.showAlert(forState: .success, message: Lang.getString(type: .thanks_for_rating))
            case 49000:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .no_enough_permission))
            case 55000:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .unknown_error_occured))
            case 55001:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .validation_error))
                
            case 56001:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .rider_not_found))
            case 60002:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .driver_not_found))
                
            default:
                break
            }
            
        }
    }
    
    //MARK: - Message History
    
    class func getMessageHistory(completion: @escaping ([ChatDM]?) -> Void){
        
        let param : [String : String] = ["ride_id" : ride_id]
        
        let token = Cache.getUser()?.token ?? ""
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        
        Net.request(url: Endpoints.message_history, method: .post, params: param, headers: nil, withLoader: false) { (data) in
            
            guard let data = data else {return}
            
            let statusCode = data["code"].intValue
            switch statusCode{
            case 0:
                var arrData = [ChatDM]()
                for i in 0..<data["data"].count{
                    arrData.append(ChatDM(ride_id: data["data"][i]["ride_id"].stringValue, message_text: data["data"][i]["message_text"].stringValue, time: data["data"][i]["time"].doubleValue, created_at: data["data"][i]["created_at"].stringValue, from: data["data"][i]["from"].stringValue, to: data["data"][i]["to"].stringValue, from_user: data["data"][i]["from_user"].stringValue, from_image: data["data"][i]["from_image"].stringValue, to_image: data["data"][i]["to_image"].stringValue))
                }
                completion(arrData)
            case 55000:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .unknown_error_occured))
                completion(nil)
            case 57000:
                Alert.showAlert(forState: .error, message: "Ride not found")
                completion(nil)
            default:
                break
            }
        }
    }
    
    //MARK: - GET RIDE INFOs
    class func getFullRideInfo(comletion: @escaping (RideFullInfo) -> Void){
        
        let token = Cache.getUser()?.token ?? ""
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        
        Net.request(url: Endpoints.ride_full_info, method: .post, params: nil, headers: header, withLoader: false) { (data) in
            guard let data = data else {return}
            let statusCode = data["code"].intValue
            //mylog(data["data"], "rideFullInfo✅")
            switch statusCode{
            case 0:
                let full_data = RideFullInfo(
                    _id: data["data"]["_id"].stringValue,
                    ride_type: data["data"]["ride_type"].stringValue,
                    driver_id: data["data"]["driver_id"].stringValue,
                    car_class_name: data["data"]["car_class_name"].stringValue,
                    state: data["data"]["state"].stringValue,
                    payment_method: data["data"]["payment_method"].stringValue,
                    card_number: data["data"]["card_number"].stringValue,
                    payment_state: data["data"]["payment_state"].stringValue,
                    estimated_price: data["data"]["estimated_price"].stringValue,
                    total_cost: data["data"]["total_cost"].stringValue,
                    total_distance: data["data"]["total_distance"].stringValue,
                    entrance: data["data"]["entrance"].stringValue,
                    air_conditioner: data["data"]["air_conditioner"].stringValue,
                    start_location: AddressDM(
                        name: data["data"]["start_location"]["location_name"].stringValue,
                        fullName: "", longitude: data["data"]["start_location"]["longitude"].doubleValue,
                        latitude: data["data"]["start_location"]["latitude"].doubleValue),
                    driver_location: AddressDM(
                        name: data["data"]["driver_location"]["location_name"].stringValue,
                        fullName: "",
                        longitude: data["data"]["driver_location"]["longitude"].doubleValue,
                        latitude: data["data"]["driver_location"]["latitude"].doubleValue),
                    destination_location: AddressDM(
                        name: data["data"]["destination_location"]["location_name"].stringValue,
                        fullName: "",
                        longitude: data["data"]["destination_location"]["longitude"].doubleValue,
                        latitude: data["data"]["destination_location"]["latitude"].doubleValue),
                    cancel_reason: data["data"]["cancel_reason"].stringValue,
                    driver_name: data["data"]["driver_name"].stringValue,
                    driver_phone: data["data"]["driver_phone"].stringValue,
                    scheduled_time: data["data"]["scheduled_time"].stringValue,
                                             
                    ordered_time: data["data"]["ordered_time"].stringValue,
                    car_details: data["data"]["car_details"].stringValue,
                    driver_image: data["data"]["driver_image"].stringValue)
                
                comletion(full_data)
                
            default:
                break
            }
            
        }
    }
    
    
    //MARK: - Update Profile info
    class func updateUserInfo(firstname: String, lastname: String, image: String, phone_number: String){
        
        let params : [String:String] = [
            "first_name" : firstname,
            "last_name" : lastname,
            "phone_number" : phone_number,
            "image" : image ]
        
        let token = Cache.getUser()?.token ?? ""
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        
        Net.request(url: Endpoints.update_user_info, method: .post, params: params, headers: header, withLoader: true) { (data) in
            guard let data = data else {return}
            let statusCode = data["code"].intValue
            switch statusCode{
            case 0:
                Alert.showAlert(forState: .success, message: Lang.getString(type: .succesfully_updated))
            default:
                break
            }
        }
    }
    
    
    //MARK: - Upload file
    class func uploadFile(image: UIImage, imgUrl: @escaping (String) -> Void){
        
        Net.reqMultiPartForImage(urlAPi: Endpoints.upload_file, img: image, method: .post) { (data) in
            guard let data = data else{return}
            
            let statusCode = data["code"].intValue
            switch statusCode{
            case 0:
                imgUrl(data["data"].stringValue)
            default:
                break
            }
        }
    }
    
    //MARK: - Create Card
    class func createCard(card_number: String, expire: String, completion:@escaping (String) -> Void){
        
        let params : [String:String] = [
            "number" : card_number,
            "expire" : expire]
        
        let token = Cache.getUser()?.token ?? ""
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        
        Net.request(url: Endpoints.create_card, method: .post, params: params, headers: header, withLoader: true) { (data) in
            guard let data = data else {return}
            
            let statusCode = data["code"].intValue
            
            switch statusCode{
            case 0:
                completion(data["data"].stringValue)
            default:
                Alert.showAlert(forState: .error, message: Lang.getString(type: .check_entered_info))
                break
            }
        }
    }
    
    //MARK: - Verify Card

    class func verifyCard(number: String, code: String, completion: ((Bool) -> Void)?){
        
        let params : [String : String] = [
            "number" : number,
            "code" : code
        ]
        
        let token = Cache.getUser()?.token ?? ""
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        
        Net.request(url: Endpoints.card_verify, method: .post, params: params, headers: header, withLoader: true) { (data) in
            guard let data = data else {return}
            
            let statusCode = data["code"].intValue
            
            switch statusCode {
            case 0:
                completion?(true)
                
            case 55000:
                completion?(false)
                Alert.showAlert(forState: .error, message: Lang.getString(type: .unknown_error_occured))
            case 55001:
                completion?(false)
                Alert.showAlert(forState: .error, message: Lang.getString(type: .validation_error))
            case 429:
                completion?(false)
                Alert.showAlert(forState: .error, message: Lang.getString(type: .too_many_attempts))
            case 56001:
                completion?(false)
                Alert.showAlert(forState: .error, message: Lang.getString(type: .user_not_found))
            case 58000:
                completion?(false)
                Alert.showAlert(forState: .error, message: Lang.getString(type: .card_not_found))
            case 56006:
                completion?(false)
                Alert.showAlert(forState: .error, message: Lang.getString(type: .card_not_found_in_rider))
            default:
                break
            }
        }
    }
    
    //MARK: - Get Card

    class func getCards(completion: @escaping([CardDM]) -> Void){
        let token = Cache.getUser()?.token ?? ""
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        
        Net.request(url: Endpoints.get_cards, method: .get, params: nil, headers: header, withLoader: false) { (data) in
            guard let data = data else {return}
            
            let statusData = data["code"].intValue
            switch statusData {
            case 0:
                var cardData = [CardDM]()
                for i in 0..<data["data"].count{
                    cardData.append(CardDM(number: data["data"][i]["number"].stringValue, expire: data["data"][i]["expire"].stringValue))
                }
                completion(cardData)
                
            default:
                break
            }
        }
    }
    
    //MARK: - Create Card

    class func deleteCard(number: String, completion: @escaping((Bool)) -> Void){
        let param : [String : String] = [
            "number" : number
        ]
        let token = Cache.getUser()?.token ?? ""
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        
        Net.request(url: Endpoints.card_delete, method: .post, params: param, headers: header, withLoader: false) { (data) in
            guard let data = data else {return}
            
            let statusCode = data["code"].intValue
            
            switch statusCode{
            case 0:
                Alert.showAlert(forState: .success, message: Lang.getString(type: .succesfully_deleted_card))
                completion(true)
            default:
                break
            }
        }
        
    }
    
    
    
    //MARK: - Get Place name by Location
    class func getPlaceByLocation(long: Double, lat: Double, completion : @escaping ((String?) -> Void)){
        
        let param : [String : Double] = [
                "latitude" : lat,
                "longitude" : long
        ]
        let token = Cache.getUser()?.token ?? ""
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        
        Net.request(url: Endpoints.place_get_by_loc, method: .post, params: param, headers: header, withLoader: false) { (data) in
            guard let data = data else {return}
            let statusCode = data["code"].intValue
            
            switch statusCode{
                case 0:
                    completion(data["data"]["location_name"].stringValue)
                default:
                    completion(nil)
                    break
                
            }
        }
    }
    
    
    
    class func getPlaceNameByLetter(search: String, location: AddressDM?, completion: @escaping (([AddressDM]?) -> Void) ){
        var param : [String : Any] = ["search" : search]
        
        if let l = location{
            param["location"] = [
            "latitude" : l.latitude,
            "longitude" : l.longitude]
        }
        
        let token = Cache.getUser()?.token ?? ""
        let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        
        
        Net.request(url: Endpoints.search_place, method: .post, params: param, headers: header, withLoader: false) { (data) in
            guard let data = data else {return}
            mylog("Search response: 𝌮 ",data)
            let statusCode = data["code"].intValue
            switch statusCode{
                case 0:
                    var locations : [AddressDM] = []
                    for i in 0..<data["data"].count{
                        locations.append(AddressDM(name: data["data"][i]["location_name"].stringValue, fullName: "", longitude: data["data"][i]["longitude"].doubleValue, latitude: data["data"][i]["latitude"].doubleValue))
                    }
                    completion(locations)
            default:
                completion(nil)
                break
            }
        }
        
    }
    
}

