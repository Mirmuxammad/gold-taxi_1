//
//  AddCardVC.swift
//  TAXI
//
//  Created by rakhmatillo topiboldiev on 18/03/21.
//

import UIKit

class AddCardVC: UIViewController {
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
    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.text = Lang.getString(type: .b_add_card)
        }
    }
    @IBOutlet weak var cardnumberLbl: UILabel!{
        didSet{
            cardnumberLbl.text = Lang.getString(type: .card_number)
        }
    }
    @IBOutlet weak var card_number_TF: UITextField!{
        didSet{
            card_number_TF.placeholder = Lang.getString(type: .card_number_placeholder)
            card_number_TF.delegate = self
        }
    }
    
    @IBOutlet weak var expire_lbl: UILabel!{
        didSet{
            expire_lbl.text = Lang.getString(type: .expire_date)
        }
    }
    @IBOutlet weak var expire_TF: UITextField!{
        didSet{
            expire_TF.placeholder = Lang.getString(type: .expire_date_placeholder)
            expire_TF.delegate = self
        }
    }
    @IBOutlet weak var doneBtn: UIButton!{
        didSet{
            doneBtn.setTitle(Lang.getString(type: .b_add_card), for: .normal)
            doneBtn.layer.cornerRadius = 20
            doneBtn.clipsToBounds = true
        }
    }
    
    @IBOutlet var textFields: [UITextField]! {
        didSet {
            for i in textFields {
                i.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                if #available(iOS 12.0, *) {
                    i.textContentType = .oneTimeCode
                }
                i.delegate = self
                i.addTarget(self, action: #selector(edit(_:)), for: .editingChanged)
            }
        }
    }
    
    @IBOutlet weak var otpStack: UIStackView!{
        didSet{
            otpStack.isHidden = true
        }
    }
    @IBOutlet weak var indicatior: UIActivityIndicatorView!
    
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
    
    @IBAction func dismissBtnPressed(_ sender: Any) {
        dimView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        } completion: { (_) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        
        let card_number = card_number_TF.text!.replacingOccurrences(of: " ", with: "")
        let expire_number = expire_TF.text!.replacingOccurrences(of: "/", with: "")
        
        if otpStack.isHidden {
            if card_number.count < 16 || expire_number.count < 4 {
                Alert.showAlert(forState: .error, message: Lang.getString(type: .please_fill_the_fields))
            } else  {
                self.indicatior.startAnimating()
                API.createCard(card_number: card_number, expire: expire_number) { (cardnumber) in
                    self.otpStack.isHidden = false
                    self.doneBtn.setTitle(Lang.getString(type: .b_verify), for: .normal)
                    self.indicatior.stopAnimating()
                }
                self.indicatior.stopAnimating()
            }
        }else{
            let otp: String = (textFields[0].text! + textFields[1].text! + textFields[2].text! + textFields[3].text! + textFields[4].text! +  textFields[5].text!)
            if otp.count == 6 {
                self.indicatior.startAnimating()
                API.verifyCard(number: card_number, code: otp) { (isDone) in
                    if isDone{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cards.update"), object: nil)
                        self.indicatior.stopAnimating()
                        
                        self.dimView.alpha = 0
                        UIView.animate(withDuration: 0.5) {
                            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
                        } completion: { (_) in
                            self.dismiss(animated: false, completion: nil)
                        }
                    }
                }
            } else {
                Alert.showAlert(forState: .error, message: "OTP is not enough")
            }
            
        }
            
    }
    
}



//MARK: TextField
extension AddCardVC: UITextFieldDelegate{

     func format(with mask: String, card_number: String) -> String {
         let numbers = card_number.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
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
         if textField == card_number_TF{
             guard let text = textField.text else { return false }
            
             let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(with: "XXXX XXXX XXXX XXXX", card_number: newString)
             return false
         }else if textField == expire_TF {
            guard let text = textField.text else { return false }
           
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
           textField.text = format(with: "XX/XX", card_number: newString)
            return false
         }else{
             return true
         }
         
     }
     

     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         view.endEditing(true)
     }
    
    
        
        @objc func editingStop() {
            view.endEditing(true)
        }
        
        @objc func edit(_ sender: UITextField) {
            
            #warning("BUG FIX REQUIRED")
            if sender.text!.isEmpty {

                for textField in textFields.reversed() {
                    if !textField.text!.isEmpty {
                        textField.becomeFirstResponder()
                        break
                    }
                    (textFields[0] as UITextField).becomeFirstResponder()
                }
            } else {
                for textField in textFields {
                    if textField.text!.isEmpty {
                        textField.becomeFirstResponder()
                        break
                    }
                    if !textFields[3].text!.isEmpty {
                        self.view.endEditing(true)

                    }
                }
            }
        }



     
    
}


//MARK: - Swipe methods
extension AddCardVC{
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

//MARK: - Keyboard handling
extension AddCardVC{
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
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5) {
            self.contentView.transform = .identity
        }
    }
    
}
