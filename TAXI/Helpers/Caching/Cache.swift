// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 07/02/21
//  

import Foundation

class Cache {
    
    class func isUserLogged() -> Bool {
        UserDefaults.standard.bool(forKey: CONSTANTS.IS_USER_LOGGED)
    }
    
    class func setUser(logged: Bool) {
        UserDefaults.standard.setValue(logged, forKey: CONSTANTS.IS_USER_LOGGED)
    }
    
    class func saveUser(data: UserDM, completion: @escaping (Bool) -> Void) {
        
        do {
            try UserDefaults.standard.set(object: data, forKey: CONSTANTS.USER_DATA)
            completion(true)
            self.setUser(logged: true)
            
        } catch  {
            completion(false)
        }
        
    }
    class func getUser() -> UserDM? {
        do {
            let data = try UserDefaults.standard.get(objectType: UserDM.self, forKey: CONSTANTS.USER_DATA)
            return data
        } catch  {
            return nil
        }
    }
    
    
    class func deleteUser() {
        self.setUser(logged: false)
        UserDefaults.standard.set(nil, forKey: CONSTANTS.USER_DATA)
    }
    
    
    
    //MARK: - LAST RIDE ID = SOCKET
    class func saveLastOrderID(id: String?) {
        UserDefaults.standard.setValue(id, forKey: CONSTANTS.RIDE_ID)
    }
    
    /// You will get last unfinished order
    class func getLastOrderID() -> String? {
        UserDefaults.standard.string(forKey: CONSTANTS.RIDE_ID)
    }
    
    
    
    
    //MARK: - Language
    enum AppLanguageType: String {
        
        case uz = "uz"
        case en = "en"
        case ru = "ru"
    }
    
    class func setAppLanguage(to: AppLanguageType) {
        UserDefaults.standard.setValue(to.rawValue, forKeyPath: "App_Default_Language")
    }
    
    class func getAppLanguage() -> AppLanguageType {
            let ln = UserDefaults.standard.string(forKey: "App_Default_Language") ?? "ru"
            switch ln {
            case "en":
                return .en
            case "ru":
                return .ru
            default:
                return .uz
            }
        }
    
    
    //MARK: - LOTTIE ANIMATION
    
    class func isPreSearchAnimationSaved() -> Bool{
        return UserDefaults.standard.bool(forKey: CONSTANTS.PRE_SEARCH_ANIMATION)
    }
    
    
    class func savePreSearchAnimation(bool: Bool){
        UserDefaults.standard.setValue(bool, forKey: CONSTANTS.PRE_SEARCH_ANIMATION)
    }
    
    class func isSearchAnimationSaved() -> Bool{
        return UserDefaults.standard.bool(forKey: CONSTANTS.SEARCH_ANIMATION)
    }
    
    
    class func saveSearchAnimation(bool: Bool){
        UserDefaults.standard.setValue(bool, forKey: CONSTANTS.SEARCH_ANIMATION)
    }
    
    class func isPreCancelledAnimationSaved() -> Bool{
        return UserDefaults.standard.bool(forKey: CONSTANTS.PRE_CANCEL_ANIMATION)
    }
    
    class func savePreCancelledAnimation(bool: Bool){
        UserDefaults.standard.setValue(bool, forKey: CONSTANTS.PRE_CANCEL_ANIMATION)
    }
    
    
    //MARK: - SAVE ROUTES
    
    class func saveRoutes(bool: Bool){
        UserDefaults.standard.setValue(bool, forKey: CONSTANTS.SHOULD_OPEN_FINDVC)
    }
    
    class func isRoutesSaved() -> Bool{
        return UserDefaults.standard.bool(forKey: CONSTANTS.SHOULD_OPEN_FINDVC)
    }
    
    
    
    //MARK: - SAVE PAYMENT TYPE
    
    class func savePaymentType(bool: Bool, item_position: Int){
        UserDefaults.standard.setValue(bool, forKey: CONSTANTS.PAYMENT_TYPE)
        UserDefaults.standard.setValue(item_position, forKey: CONSTANTS.PAYMENT_TYPE_POSITION)
    }
    class func isPaymentTypeSaved() -> Bool{
        return UserDefaults.standard.bool(forKey: CONSTANTS.PAYMENT_TYPE)
    }
    class func getPaymentTypePosition() -> Int{
        UserDefaults.standard.integer(forKey: CONSTANTS.PAYMENT_TYPE_POSITION)
    }
}
