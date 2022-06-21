// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 22/02/21
//  

import UIKit

protocol LookingForCarsVCDelegate{
    func didOrderCancelled()
}

class LookingForCarsVC: UIViewController {
    
    @IBOutlet weak var contanierView: UIView!{
        didSet{
            contanierView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3832879099)
            contanierView.layer.shadowOffset = CGSize(width: 0, height: 0)
            contanierView.layer.shadowRadius = 4
            contanierView.layer.shadowOpacity = 0.4
            contanierView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    @IBOutlet weak var mainLbl: UILabel!{
        didSet{
            mainLbl.text = Lang.getString(type: .l_searching)
        }
    }
    @IBOutlet weak var descLbl: UILabel!{
        didSet{
            descLbl.text = Lang.getString(type: .l_searching_desc)
        }
    }
    
    @IBOutlet weak var cancelLbl: UILabel!{
        didSet{
            cancelLbl.text = Lang.getString(type: .l_cancel_order)
        }
    }
    
 
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    var delegate : LookingForCarsVCDelegate?
    var cardViewHeight : CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabels), name: Notification.Name(rawValue: CONSTANTS.LANGUAGE_NOTIFICATION), object: nil)
    }

    @IBAction func cancelOrder(_ sender: Any) {
        delegate?.didOrderCancelled()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UIScreen.main.bounds.height > 750{
            cancelBtn.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
           
        }else{
            cancelBtn.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
           
        }
        cancelBtn.layer.cornerRadius = cancelBtn.frame.height / 2
        cardViewHeight = contanierView.frame.height
    }
    
    @objc func updateLabels() {
        mainLbl.text = Lang.getString(type: .l_searching)
        descLbl.text = Lang.getString(type: .l_searching_desc)
        cancelLbl.text = Lang.getString(type: .l_cancel_order)
    }
    

}
