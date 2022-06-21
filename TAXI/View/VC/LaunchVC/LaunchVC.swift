//
//  LaunchVC.swift
//  TAXI
//
//  Created by rakhmatillo topiboldiev on 28/03/21.
//

import UIKit

class LaunchVC: UIViewController {
    
    @IBOutlet weak var greetingLbl: UILabel!{
        didSet{
            if let username = Cache.getUser()?.firstName{
                greetingLbl.text = Lang.getString(type: .greeting) + ", \(username)"
            }else{
                greetingLbl.text = Lang.getString(type: .greeting)
            }
            
        }
    }
   
    var totalNum = 0
    var lastPage = 0
    var beforeLastPage = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let window = UIApplication.shared.keyWindow
            let navVC = UINavigationController(rootViewController: LoginVC(nibName: "LoginVC", bundle: nil))
            navVC.navigationBar.isHidden = true
            
            if Cache.isUserLogged(){
                //MySocket.default.openConnection()
                window?.rootViewController = MainViewController()
            }else{
                window?.rootViewController = navVC
            }
            window?.makeKeyAndVisible()
        }
        
    }
   
    
}
