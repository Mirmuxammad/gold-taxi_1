// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 07/02/21
//  

import Foundation
import Alamofire
import SwiftyJSON

class Net {
    
    class private func multiTokenHeader() -> HTTPHeaders {
            let header: HTTPHeaders = [
                "Accept" : "application/json",
                "Content-Type": "application/json",
                "Authorization" : Cache.getUser()?.token ?? "",
                "Content-type": "multipart/form-data",
                "Content-Disposition" : "form-data"
            ]
            return header
        }
    
    
    class func request(url: String, method: HTTPMethod, params: [String:Any]?, headers: HTTPHeaders?, withLoader: Bool, completion: @escaping (JSON?)->Void) {
        if Reachability.isConnectedToNetwork() {
            if withLoader {
                Loader.start()
            }
            
            AF.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                Loader.stop()
                guard let data = response.data else {
                    completion(nil)
                    Alert.showAlert(forState: .error, message: "Unknown error occured, please try again later.")
                    return
                }
                
                let json = JSON(data)
                mylog(json)
                completion(json)
            }
        } else {
            //Not connected to the internet
            completion(nil)
            
            Alert.showAlert(forState: .error, message: "No internet connection", duration: 3, userInteration: true)
        }
        
        
    }
    
    class func requestNearCars(url: String, method: HTTPMethod, params: [String:Any]?, headers: HTTPHeaders?, withLoader: Bool, completion: @escaping (JSON?)->Void) {
        
        if Reachability.isConnectedToNetwork() {
            if withLoader {
                Loader.start()
            }
            
            AF.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                Loader.stop()
                guard let data = response.data else {
                    completion(nil)
                    Alert.showAlert(forState: .error, message: "Unknown error occured, please try again later.")
                    return
                }
                
                let json = JSON(data)
                completion(json)
            }
        } else {
            //Not connected to the internet
            Alert.showAlert(forState: .error, message: "No internet connection", duration: 3, userInteration: true)
            completion(nil)
        }
        
        
    }
    
    class func reqMultiPartForImage(urlAPi: String, img: UIImage, method: HTTPMethod, completion: @escaping (_ data: JSON?) -> ()) {
            if Reachability.isConnectedToNetwork() {
                Loader.start()
                if let imgData = img.jpegData(compressionQuality: 0.8) {
                    
                    AF.upload(multipartFormData: { multipartFormData in
                        multipartFormData.append(imgData, withName: "file", fileName: "\(Date().timeIntervalSince1970).png", mimeType: "image/png")
                    }, to: urlAPi, method: method, headers: self.multiTokenHeader())
                        .responseJSON { (response) in
                            Loader.stop()
                            switch response.result {
                            case .success:
                                completion(JSON(response.data!))
                            case let .failure(error):
                                print(error.localizedDescription)
                                completion(nil)
                                Alert.showAlert(forState: .error, message: "Unknown error occured")
                            }
                    }
                }
            } else {
                //Not connected
                completion(nil)

            }
            
        }
    
    
    class func reqMultiPart(url: String, params: [String:String], method: HTTPMethod, withLoader: Bool, headers: HTTPHeaders?, completion: @escaping (_ data: JSON?) -> ()) {
        if Reachability.isConnectedToNetwork() {
            if withLoader {Loader.start()}
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            let head = headers
            AF.upload(multipartFormData: { multipartFormData in
                for (key, value) in params {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }, to: url, method: method, headers: head)
            .responseJSON { (response) in
                Loader.stop()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                switch response.result {
                case .success:
                    completion(JSON(response.data!))
                case let .failure(error):
                    completion(nil)
                    Alert.showAlert(forState: .error, message: "Unknown error occured")
                    print(error)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    
    
}
