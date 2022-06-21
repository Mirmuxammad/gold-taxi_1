// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 08/03/21
//  

import UIKit

class EntranceVC: UIViewController {
    
    public var minimumVelocityToHide: CGFloat = 1500
    public var minimumScreenRatioToHide: CGFloat = 0.2
    public var animationDuration: TimeInterval = 0.2

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
    @IBOutlet weak var donebtn: UIButton!{
        didSet{
            donebtn.setTitle(Lang.getString(type: .b_done), for: .normal)
        }
    }
    
    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.text = Lang.getString(type: .entrance)
        }
    }
    @IBOutlet weak var entranceTF: UITextField!{
        didSet{
            entranceTF.placeholder = Lang.getString(type: .p_enter_entrance_number)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
            view.addGestureRecognizer(panGesture)
        
        registerKeyboardNotifications()
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

    @IBAction func donePressed(_ sender: UIButton) {
        EntranceRideOptionCommentNotification.postEntranceNotification(str: entranceTF.text!)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func dismissPressed(_ sender: Any) {
        dimView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        } completion: { (_) in
            self.dismiss(animated: false, completion: nil)
        }
    }

}

extension EntranceVC {
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
//MARK: - Keyboard
extension EntranceVC{
    
    func registerKeyboardNotifications() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        
        UIView.animate(withDuration: 0.5) {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height - 30)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5) {
            self.contentView.transform = .identity
        }
    }
    
}
