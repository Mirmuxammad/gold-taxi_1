// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 24/01/21
//  

import UIKit
import YandexMapsMobile

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
   
    
    var ride_id : String?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        window = UIWindow()
        YMKMapKit.setLocale("uz_UZ")
        YMKMapKit.setApiKey(CONSTANTS.YANDEX_MAP_KEY)
        
        window?.rootViewController = LaunchVC(nibName: "LaunchVC", bundle: nil)
        
        window?.makeKeyAndVisible()
       
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }

    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
       
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.setValue(true, forKey: CONSTANTS.IS_APP_TERMINATED)
        Cache.savePreSearchAnimation(bool: false)
        Cache.saveSearchAnimation(bool: false)
        Cache.savePaymentType(bool: false, item_position: 0)
        #warning("NEED TO BE CHANGE TO API, Price when air conditioner on")
        UserDefaults.standard.setValue(false, forKey: CONSTANTS.IS_AIR_CONDITIONER_ON)
    }
    
    
}




