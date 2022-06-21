// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 19/02/21
//  

import UIKit
protocol ConfirmAddressVCDelegate {
    func donePressed()
    func backPressed()
}
class ConfirmAddressVC: UIViewController {
    
    static var cardViewHeight: CGFloat = 230

    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    var delegate : ConfirmAddressVCDelegate?
    
    
    var forStartLocation = true {
        didSet {
            guard let img = imgView else {return}
            img.image = forStartLocation ? UIImage(named: "startLocation") : UIImage(named: "destinationLocation")
        }
    }
    var isThisViewActive: Bool = false
    
    var choosenAddress: AddressDM? {
        didSet {
            guard let choosen = choosenAddress else {return}
            guard let lbl = locationLbl else {return}
            lbl.text = choosen.name
        }
    }
    
    var addressName: String?{
        didSet{
            guard let lbl = locationLbl else {return}
            lbl.text = addressName
           
        }
    }
    @IBOutlet weak var doneBtn: UIButton!{
        didSet{
            doneBtn.setTitle(Lang.getString(type: .b_done), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabels), name: Notification.Name(rawValue: CONSTANTS.LANGUAGE_NOTIFICATION), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let choosen = choosenAddress else {return}
        locationLbl.text = addressName //choosen.name
        imgView.image = forStartLocation ? UIImage(named: "startLocation") : UIImage(named: "destinationLocation")

    }
    @objc func updateLabels() {
        doneBtn.setTitle(Lang.getString(type: .b_done), for: .normal)
    }

    @IBAction func doneBtnPressed(_ sender: Any) {
        
        delegate?.donePressed()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        delegate?.backPressed()
    }
}
