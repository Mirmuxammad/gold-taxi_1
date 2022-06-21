// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 27/02/21
//  

import UIKit

class SafetyVC: UIViewController {

    @IBOutlet weak var dimView: UIView!{
        didSet{
            dimView.alpha = 0
            
        }
    }
    
    @IBOutlet weak var contentView: UIView!{
        didSet{
            contentView.layer.cornerRadius = 20
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet weak var trustedContacts: UILabel!{
        didSet{
            trustedContacts.text = Lang.getString(type: .trusted_contacts)
        }
    }
    @IBOutlet weak var emergencycallLbl: UILabel!{
        didSet{
            emergencycallLbl.text = Lang.getString(type: .emergency_call)
        }
    }
    @IBOutlet weak var ambulanceLbl: UILabel!{
        didSet{
            ambulanceLbl.text = Lang.getString(type: .ambulance_police)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.view.transform = .identity

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.dimView.alpha = 1
        }
    }
    
    @IBAction func dismissPressed(_ sender: Any) {
        dimView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        } completion: { (_) in
            self.dismiss(animated: false, completion: nil)
        }
    }

    @IBAction func trustedContactPressed(_ sender: Any) {
        
        
    }
    
    @IBAction func emergencyPressed(_ sender: Any) {
        makePhoneCall(phoneNumber: "1004")
    }
    
    @IBAction func ambulancePressed(_ sender: Any) {
        makePhoneCall(phoneNumber: "1003")
    }
    
    func makePhoneCall(phoneNumber: String) {
        let phoneURL = NSURL(string: ("tel://" + phoneNumber))
        UIApplication.shared.open(phoneURL! as URL, options: [:], completionHandler: nil)
    }

}
