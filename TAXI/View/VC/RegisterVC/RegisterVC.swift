// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 25/01/21
//  

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var containerStack: UIStackView!
    
    @IBOutlet weak var phonenumberLbl: UILabel!{
        didSet{
            phonenumberLbl.text = Lang.getString(type: .l_phone_number)
        }
    }
    @IBOutlet weak var phoneNumberTF: UITextField!{
        didSet{
            phoneNumberTF.placeholder = "90 123 45 67"
            phoneNumberTF.delegate = self
        }
    }
    
    @IBOutlet weak var firstnameLbl: UILabel!{
        didSet{
            firstnameLbl.text = Lang.getString(type: .l_firstname)
        }
    }
    @IBOutlet weak var firstNameTF: UITextField!{
        didSet{
            firstNameTF.placeholder = Lang.getString(type: .l_firstname)
            firstNameTF.delegate = self
        }
    }
    @IBOutlet weak var lastnameLbl: UILabel!{
        didSet{
            lastnameLbl.text = Lang.getString(type: .l_lastname)
        }
    }
    
    @IBOutlet weak var lastNameTF: UITextField!{
        didSet{
            lastNameTF.placeholder = Lang.getString(type: .l_lastname)
            lastNameTF.delegate = self
        }
    }
    
    @IBOutlet weak var registerBtn: UIButton!{
        didSet{
            registerBtn.setTitle(Lang.getString(type: .b_register), for: .normal)
            registerBtn.layer.cornerRadius = 20
            registerBtn.clipsToBounds = true
        }
    }
    @IBOutlet weak var goToLoginBtn: UIButton!{
        didSet{
            goToLoginBtn.setTitle(Lang.getString(type: .b_already_have_an_account), for: .normal)
            goToLoginBtn.layer.cornerRadius = 20
            goToLoginBtn.layer.borderWidth = 1
            goToLoginBtn.layer.borderColor = #colorLiteral(red: 0, green: 0.6850994825, blue: 0.9793123603, alpha: 1)
        }
    }

    @IBOutlet weak var agreeLbl: UILabel!{
        didSet{
            agreeLbl.text = Lang.getString(type: .agree_lbl)
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: Lang.getString(type: .agree_lbl))
            
            let range = attributedString.mutableString.range(of: Lang.getString(type: .agree_attributed), options: NSString.CompareOptions.caseInsensitive)
            
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: range)
            
            agreeLbl.isUserInteractionEnabled = true
                  
            agreeLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(agreeLblPressed(_:))))
       
            agreeLbl.attributedText = attributedString
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerKeyboardNotifications()
    }

    @objc func agreeLblPressed(_ sender: UITapGestureRecognizer) {
        
        let termsRange = (agreeLbl.text! as NSString).range(of: Lang.getString(type: .agree_attributed))
        if sender.didTapAttributedTextInLabel(label: self.agreeLbl, inRange: termsRange) {

            openSafariView(url: "https://docs.google.com/document/d/e/2PACX-1vQTi7-wy0uE8tAI9z2eFx2M6wX258veNBLnfHxGOjAo_rl_VczG1uY_bCPOYWofSRGeW6AjEQBE4WQ6/pub")
            
            
        } else {
        }

        
    }
   
    @IBAction func backBtnPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @IBAction func registerBtnPressed(_ sender: UIButton) {
        let phoneNum = phoneNumberTF.text?.replacingOccurrences(of: " ", with: "")
        
        if !phoneNumberTF.text!.isEmpty{
            if !firstNameTF.text!.isEmpty{
                if !lastNameTF.text!.isEmpty{
                    
                    API.register(phone_number: phoneNum ?? "", first_name: firstNameTF.text!, last_name: lastNameTF.text!) { (done) in
                        if done{
                            let vc = OTPVC(nibName: "OTPVC", bundle: nil)
                            vc.phoneNumber = phoneNum ?? ""
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                    
                }else{
                    Alert.showAlert(forState: .error, message: Lang.getString(type: .please_fill_the_fields))
                }
                
            }else{
                Alert.showAlert(forState: .error, message: Lang.getString(type: .please_fill_the_fields))
            }
            
        }else{
            Alert.showAlert(forState: .error, message: Lang.getString(type: .please_fill_the_fields))
        }
        
        
    }
    @IBAction func goToLoginPage(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - Textfield delegate
extension RegisterVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case phoneNumberTF:
            phoneNumberTF.resignFirstResponder()
            firstNameTF.becomeFirstResponder()
        case firstNameTF:
            firstNameTF.resignFirstResponder()
            lastNameTF.becomeFirstResponder()

        default:
            lastNameTF.resignFirstResponder()
        }
        return true
    }


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
             if textField == phoneNumberTF{
                guard let text = textField.text else {return false}
                
                let newString = (text as NSString).replacingCharacters(in: range, with: string)
                    textField.text = format(with: "XX XXX XX XX", phone: newString)
                    
                return false
             }else{
                 return true
             }
             
         }
         
 
         override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
             view.endEditing(true)
         }
         
}


//MARK:- Keyboard Handling
extension RegisterVC{
    
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
            self.containerStack.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height/2)
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5) {
            self.containerStack.transform = .identity
        }
    }
    
}



