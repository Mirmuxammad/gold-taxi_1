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
    
    
    class func save(profileImage path: URL) {
        UserDefaults.standard.set(path, forKey: "profileImagePath")
    }
    
    class func getProfileImagePath() -> URL? {
        UserDefaults.standard.url(forKey: "profileImagePath")
    }
    
}
