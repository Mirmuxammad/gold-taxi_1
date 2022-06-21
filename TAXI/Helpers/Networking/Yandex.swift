//
//  Yandex.swift
//  TAXI
//
//  Created by iMac_DM on 2/28/21.
//

import UIKit
import YandexMapsMobile
import Alamofire
import SwiftyJSON
import CoreLocation

class Yandex {
    
    static var startPlacemark : YMKPlacemarkMapObject?
    static var endPlacemark : YMKPlacemarkMapObject?
    static var polyline : YMKColoredPolylineMapObject?
    static var polylineArr : [YMKColoredPolylineMapObject] = []
    static var nearcarsPlacemark: YMKPlacemarkMapObject?
    static var nearcarsArr : [YMKPlacemarkMapObject] = []
    
    static var driverLocations : [YMKPoint] = []
    
    class func geocodeLocation(for coordinates: YMKPoint, completion: @escaping (AddressDM) -> Void) {
        
        let key : String = CONSTANTS.YANDEX_SEARCH_KEY
        let postParameters:[String: Any] = [
            "format": "json",
            "apikey": key,
            "geocode" : "\(coordinates.longitude),\(coordinates.latitude)"
        ]
        let url : String = "https://geocode-maps.yandex.ru/1.x/"
        
        AF.request(url, method: .get, parameters: postParameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let data = response.data{
                
                let jsonData = JSON(data)
                guard let prefixOfData  =
                        jsonData["response"]["GeoObjectCollection"]["featureMember"].arrayValue.first?["GeoObject"] else{return}
                
                //it takes only region not country name
                let description = prefixOfData["description"].stringValue
                let name = prefixOfData["name"].stringValue
                
                let pickedLocationAddress = AddressDM(name: name, fullName: description, longitude: coordinates.longitude, latitude: coordinates.latitude)
                completion(pickedLocationAddress)
            }
        }
    }
    
    
    //MARK: - Get suggested result
    class func geocodeLocation(for addressName: String, completion: @escaping ([AddressDM]) -> Void) {
        
        let key : String = CONSTANTS.YANDEX_SEARCH_KEY1
        let postParameters:[String: Any] = [ "text": addressName,
                                             "apikey": key,
                                             "type" : "geo",
                                             "lang" : "uz_UZ",
                                             "bbox" : "55.9289172707,37.1449940049~73.055417108,45.5868043076",
                                             "rspn" : "1"]
        let url : String = "https://search-maps.yandex.ru/v1"
        
        AF.request(url, method: .get, parameters: postParameters, encoding: URLEncoding.default, headers: nil).responseJSON {  response in
            if let data = response.data {
                let jdata = JSON(data)
                if !jdata["features"].arrayValue.isEmpty {
                    var adds: [AddressDM] = []
                    for ad in jdata["features"].arrayValue {
                        let adr = AddressDM.init(name: ad["properties"]["name"].stringValue, fullName: ad["properties"]["description"].stringValue, longitude: ad["geometry"]["coordinates"][0].doubleValue, latitude: ad["geometry"]["coordinates"][1].doubleValue)
                        adds.append(adr)
                    }
                    completion(adds)
                } else {
                    //no results
                    completion([])
                }
            } else {
                print(response.error.debugDescription)
            }
        }
    }
    
    enum PlaceMarkStyle: String {
        case startLocation = "startLocation"
        case pin_ = "placemark_current"
        case destinationLocation = "destinationLocation"
        case driverLocation = "taxi_car"
        case near_car = "near_car"
    }
    
    
    //MARK: - Adding two points
    class func addPoint(for location: Locationable, to map: YMKMap, type: PlaceMarkStyle, bearing: Double? = nil) {
        let mapObj = map.mapObjects
        let point = YMKPoint.init(latitude: location.latitude, longitude: location.longitude)
        
        let placemark = mapObj.addPlacemark(with: point, image: UIImage(named: type.rawValue)!, style: YMKIconStyle(anchor: CGPoint(x: 0, y: 0) as NSValue, rotationType:YMKRotationType.rotate.rawValue as NSNumber, zIndex: 100, flat: true, visible: true, scale: 1, tappableArea: nil))
                
        if let bearing = bearing{
            placemark.direction = Float(bearing)
            placemark.geometry = point
        }
        
        
        if type == PlaceMarkStyle.startLocation || type == PlaceMarkStyle.pin_{
            startPlacemark = placemark
        }else if type == PlaceMarkStyle.driverLocation || type == PlaceMarkStyle.destinationLocation{
            endPlacemark = placemark
        }else if type == .near_car{
            nearcarsPlacemark = placemark
            placemark.zIndex = 1
            nearcarsArr.append(nearcarsPlacemark!)
        }
    }
    
    //MARK: - Drawing Route
    class func drawRoute(startLocation: Locationable, destinationLocation: Locationable, to map: YMKMap, completion: @escaping ([[String:Double]]?) -> Void, session: @escaping (YMKDrivingSession?)->Void) {
        
        
        
        let ROUTE_START_POINT = YMKPoint(latitude: startLocation.latitude, longitude: startLocation.longitude)
        let ROUTE_END_POINT = YMKPoint(latitude: destinationLocation.latitude, longitude: destinationLocation.longitude)
        
        let requestPoints : [YMKRequestPoint] = [
            YMKRequestPoint(point: ROUTE_START_POINT, type: .waypoint, pointContext: nil),
            YMKRequestPoint(point: ROUTE_END_POINT, type: .waypoint, pointContext: nil),
        ]
        
        
        let responseHandler = { (routesResponse: [YMKDrivingRoute]?, error: Error?) -> Void in
            if let routes = routesResponse {
                
                let mapObjects = map.mapObjects
                for route in routes {
                    mapObjects.addPolyline(with: route.geometry)
                }

//                self.onRoutesReceived(routes, map: map) { (newRoutes) in
//                    completion(newRoutes
//                }
//
                
                
            } else {
//                self.onRoutesError(error!)
                completion(nil)
            }
        }
        
        
        let options = YMKDrivingDrivingOptions()
        options.routesCount = 1
        options.avoidTolls = 1
        
        let drivingRouter = YMKDirections.sharedInstance().createDrivingRouter()
        
        let vehicalOptions = YMKDrivingVehicleOptions()
        vehicalOptions.vehicleType = NSNumber(value: YMKDrivingVehicleType.taxi.rawValue)
        
        session(drivingRouter.requestRoutes(
                    with: requestPoints,
                    drivingOptions: options,
                    vehicleOptions: vehicalOptions,
                    routeHandler: responseHandler))
    }
                               
                               

    
    
    //MARK: - Clear Map Objects
    class func clearPlacemark(from: YMKMap, shouldKeepStartPoint: Bool) {
        if !shouldKeepStartPoint{
            if let startPlacemark = startPlacemark{
                from.mapObjects.remove(with: startPlacemark)
                self.startPlacemark = nil
                
                if let endPlacemark = endPlacemark{
                    from.mapObjects.remove(with: endPlacemark)
                    self.endPlacemark = nil
//
//                    if !polylineArr.isEmpty{
//                        for i in 0..<polylineArr.count{
//                            from.mapObjects.remove(with: polylineArr[i])
//                        }
//                    }
                   
                    
                    if let polyline = self.polyline{
                        from.mapObjects.remove(with: polyline)
                        self.polyline = nil
                    }
                }
            }
 
        }else{
            if let endPlacemark = endPlacemark{
                from.mapObjects.remove(with: endPlacemark)
                self.endPlacemark = nil

                if let polyline = polyline{
                    from.mapObjects.remove(with: polyline)
                    self.polyline = nil
                }
            }
        }
    }
    
    //MARK: - Clear Near Car Objects
    
    class func clearNearCarObjects(from: YMKMap) {
        if nearcarsPlacemark != nil && !nearcarsArr.isEmpty{
            for i in nearcarsArr {
                mylog("NEAR CARS OBJECTS REMOVE FUNC IS WORKING", "😎", nearcarsArr.count)
                
                from.mapObjects.remove(with: i)
            }
            nearcarsArr.removeAll()
            self.nearcarsPlacemark = nil
        }
    }
    
    class func moveDriverMarker(coordinates: YMKPoint, bearing: Double, speed: Double) {
        
        driverLocations.append(coordinates)
        var betweenPoints = [CLLocationCoordinate2D]()
        betweenPoints = calculateBetweenCoordinates()
        
        if !betweenPoints.isEmpty{
            for i in 0..<betweenPoints.count{
                if let car = endPlacemark{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        mylog(i)
                        car.geometry = YMKPoint(latitude: betweenPoints[i].latitude, longitude: betweenPoints[i].longitude)
                        if i % 20 == 0{
                            car.direction = Float(bearing)
                            if !polylineArr.isEmpty{
                                for i in 0..<polylineArr.count - 1{
                                    polylineArr.remove(at: i)
                                }
                            }
                            
                        }
                    }
                    
                }
            }
        }
        
    }

    class func calculateBetweenCoordinates() -> [CLLocationCoordinate2D]{
        var coordinatesBetweenPoints = [CLLocationCoordinate2D]()
        if driverLocations.count > 1{
            for i in 0..<driverLocations.count - 1{
                let startPoint = CLLocationCoordinate2D(latitude: driverLocations[i].latitude, longitude: driverLocations[i].longitude)
                
                let endPoint = CLLocationCoordinate2D(latitude: driverLocations[i+1].latitude, longitude: driverLocations[i+1].longitude)
                
                let totalCoordinates = Double(20)
                let latitudeDiff = startPoint.latitude - endPoint.latitude
                let longitudeDiff = startPoint.longitude - endPoint.longitude
                let latMultiplier = latitudeDiff / (totalCoordinates + 1)
                let longMultiplier = longitudeDiff / (totalCoordinates + 1)
                
                for index in 1...Int(totalCoordinates) {
                    
                    let lat  = startPoint.latitude - (latMultiplier * Double(index))
                    let long = startPoint.longitude - (longMultiplier * Double(index))
                    let point = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    coordinatesBetweenPoints.append(point)
                }
            }
            driverLocations.removeAll()
        }
        
        mylog(coordinatesBetweenPoints, "Coordinates")
        return coordinatesBetweenPoints
    }
                               
   
    
}



