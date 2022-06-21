// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 10/02/21
//  

import UIKit

class RideOptionsVC: UIViewController {
    
    public var minimumVelocityToHide: CGFloat = 1500
    public var minimumScreenRatioToHide: CGFloat = 0.2
    public var animationDuration: TimeInterval = 0.2
    
    @IBOutlet weak var dimview: UIView!{
        didSet{
            dimview.alpha = 0
            
        }
    }
    
    @IBOutlet weak var contentView: UIView!{
        didSet{
            contentView.layer.cornerRadius = 20
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet weak var doneBtn: UIButton!{
        didSet{
            doneBtn.setTitle(Lang.getString(type: .b_done), for: .normal)
        }
    }
    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.text = Lang.getString(type: .l_ride_options)
        }
    }
    
    @IBOutlet weak var air_condLbl: UILabel!{
        didSet{
            air_condLbl.text = Lang.getString(type: .l_air_conditioner)
        }
    }
    
    @IBOutlet weak var airConLbl: UILabel!
    {
        didSet{
            airConLbl.text = Lang.getString(type: .l_air_conditioner)
        }
    }
    @IBOutlet weak var commentLbl: UILabel!{
        didSet{
            commentLbl.text = Lang.getString(type: .l_comment)
        }
    }
    
    @IBOutlet weak var tickImg: UIImageView!{
        didSet{
            if UserDefaults.standard.bool(forKey: CONSTANTS.IS_AIR_CONDITIONER_ON){
                tickImg.image = UIImage(named: "tick")
            }else{
                tickImg.image = UIImage()
            }
        }
    }
    
   
    
    @IBOutlet weak var orderForSomeoneLbl: UILabel!{
        didSet{
            orderForSomeoneLbl.text = Lang.getString(type: .order_for_someone)
        }
    }
    
    @IBOutlet weak var orderForSomeoneDetailLbl: UILabel!{
        didSet{
            if let phone = UserDefaults.standard.string(forKey: CONSTANTS.ORDER_SOMEONE_PHONE_NUMBER){
                orderForSomeoneDetailLbl.text = phone
            }else{
                orderForSomeoneDetailLbl.text = ""
            }
            
        }
    }
    var isAirconditionerOn = UserDefaults.standard.bool(forKey: CONSTANTS.IS_AIR_CONDITIONER_ON)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
            view.addGestureRecognizer(panGesture)
        
        EntranceRideOptionCommentNotification.createSomeonePhoneObservers { (phone) in
            if phone != ""{
                self.orderForSomeoneDetailLbl.text = "+998" + phone
            }else{
                self.orderForSomeoneDetailLbl.text = phone

            }
        }
        
    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.view.transform = .identity

        }
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.dimview.alpha = 1
        }
    }
    @IBAction func dismissBtnPressed(_ sender: UIButton) {
        dimview.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        } completion: { (_) in
            self.dismiss(animated: false, completion: nil)
        }

        
    }
    
    @IBAction func airConditionerBtnPressed(_ sender: Any) {
        isAirconditionerOn = !isAirconditionerOn
        if isAirconditionerOn{
            tickImg.image = UIImage(named: "tick")
        }else{
            tickImg.image = UIImage()
        }
    }
    
    @IBAction func commentPressed(_ sender: Any) {
        let vc = CommentVC(nibName: "CommentVC", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func orderForSomeoneBtnPressed(_ sender: Any) {
        let vc = RideForSomeoneVC(nibName: "RideForSomeoneVC", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
        
    }
    @IBAction func donePressed(_ sender: Any) {
        UserDefaults.standard.setValue(orderForSomeoneDetailLbl.text?.suffix(9), forKey: CONSTANTS.ORDER_SOMEONE_PHONE_NUMBER)
        
        EntranceRideOptionCommentNotification.postRideOptionNotification(isON: isAirconditionerOn)
        UserDefaults.standard.setValue(isAirconditionerOn, forKey: CONSTANTS.IS_AIR_CONDITIONER_ON)
        dimview.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        } completion: { (_) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
}

extension RideOptionsVC{
    func slideViewVerticallyTo(_ y: CGFloat) {
        self.view.frame.origin = CGPoint(x: 0, y: y)
    }
    
    
    @objc func onPan(_ panGesture: UIPanGestureRecognizer) {
        
        switch panGesture.state {
        case .began, .changed:
            // If pan started or is ongoing then
            // slide the view to follow the finger
            let translation = panGesture.translation(in: view)
            let y = max(0, translation.y)
            slideViewVerticallyTo(y)
            
        case .ended:
            // If pan ended, decide it we should close or reset the view
            // based on the final position and the speed of the gesture
            let translation = panGesture.translation(in: view)
            let velocity = panGesture.velocity(in: view)
            let closing = (translation.y > self.view.frame.size.height * minimumScreenRatioToHide) ||
                (velocity.y > minimumVelocityToHide)
            
            if closing {
                UIView.animate(withDuration: animationDuration, animations: {
                    // If closing, animate to the bottom of the view
                    self.slideViewVerticallyTo(self.view.frame.size.height)
                }, completion: { (isCompleted) in
                    if isCompleted {
                        // Dismiss the view when it dissapeared
                        self.dismiss(animated: false, completion: nil)
                    }
                })
            } else {
                // If not closing, reset the view to the top
                UIView.animate(withDuration: animationDuration, animations: {
                    self.slideViewVerticallyTo(0)
                })
            }
            
        default:
            // If gesture state is undefined, reset the view to the top
            UIView.animate(withDuration: animationDuration, animations: {
                self.slideViewVerticallyTo(0)
            })
            
        }
    }
  

}
