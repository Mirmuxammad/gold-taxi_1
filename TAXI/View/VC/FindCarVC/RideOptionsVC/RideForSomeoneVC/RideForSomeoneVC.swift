
// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 08/03/21
//

import UIKit

class RideForSomeoneVC: UIViewController {
    
    public var minimumVelocityToHide: CGFloat = 1500
    public var minimumScreenRatioToHide: CGFloat = 0.4
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
            titleLbl.text = Lang.getString(type: .enter_rider_phone_number)
        }
    }
    
    @IBOutlet weak var phonenumTF: UITextField!{
        didSet{
            if let phone = UserDefaults.standard.string(forKey: CONSTANTS.ORDER_SOMEONE_PHONE_NUMBER){
                if phone.isEmpty{
                    phonenumTF.placeholder = "99 890 XXX XX XX"
                }else{
                    phonenumTF.text = phone
                }
                
               
            }else{
                phonenumTF.placeholder = "99 890 XXX XX XX"
            }
            
            phonenumTF.delegate = self
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
        if phonenumTF.text!.hasPrefix("+998") && phonenumTF.text!.replacingOccurrences(of: " ", with: "").count == 13{
            let phone = "\(phonenumTF.text!.replacingOccurrences(of: " ", with: "").suffix(9))"
            EntranceRideOptionCommentNotification.postSomeonePhoneNotification(str: phone)
            self.dismiss(animated: false, completion: nil)
        }else{
            EntranceRideOptionCommentNotification.postSomeonePhoneNotification(str: "")
            UserDefaults.standard.setValue("", forKey: CONSTANTS.ORDER_SOMEONE_PHONE_NUMBER)
            self.dismiss(animated: false, completion: nil)
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

}

extension RideForSomeoneVC {
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
extension RideForSomeoneVC{
    
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


//MARK: TextField
    extension RideForSomeoneVC: UITextFieldDelegate{

         func format(with mask: String, phone: String) -> String {
             let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
             var result = ""
             var index = numbers.startIndex // numbers iterator

             // iterate over the mask characters until the iterator of numbers ends
             for ch in mask where index < numbers.endIndex {
                 if ch == "X" {
                     // mask requires a number in this place, so take the next one
                     result.append(numbers[index])

                     // move numbers iterator to the next index
                     index = numbers.index(after: index)

                 } else {
                     result.append(ch) // just append a mask character
                 }
             }
             return result
         }
         
         func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
             if textField == phonenumTF{
                 guard let text = textField.text else { return false }
                
                 let newString = (text as NSString).replacingCharacters(in: range, with: string)
                textField.text = format(with: "+XXX XX XXX XX XX", phone: newString)
                 return false
             }else{
                 return true
             }
             
         }
         
 
         override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
             view.endEditing(true)
         }
         
        
    }
