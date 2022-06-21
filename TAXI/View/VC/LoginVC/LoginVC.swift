    // بسم الله الرحمن الرحيم
    //  Created by rakhmatillo topiboldiev on 24/01/21
    //
    
    import UIKit
    
    class LoginVC: UIViewController {
        
        
        @IBOutlet weak var containerStack: UIStackView!
        
        @IBOutlet weak var phoneNumTF: UITextField!{
            didSet{
                phoneNumTF.delegate = self
            }
        }
        
        
        @IBOutlet weak var titleLbl: UILabel!{
            didSet{
                titleLbl.text = Lang.getString(type: .login)
            }
        }
        @IBOutlet weak var phoneLbl: UILabel!{
            didSet{
                phoneLbl.text = Lang.getString(type: .l_phone_number)
            }
        }
        @IBOutlet weak var registerBtn: UIButton!{
            didSet{
                registerBtn.setTitle(Lang.getString(type: .b_register), for: .normal)
                registerBtn.layer.cornerRadius = 20
                registerBtn.layer.borderWidth = 1
                registerBtn.layer.borderColor = #colorLiteral(red: 0, green: 0.6850994825, blue: 0.9793123603, alpha: 1)
            }
        }
        
        @IBOutlet weak var loginBtn: UIButton!{
            didSet{
                loginBtn.setTitle(Lang.getString(type: .login), for: .normal)
                loginBtn.layer.cornerRadius = 20
                loginBtn.clipsToBounds = true
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            navigationController?.navigationBar.isHidden = true
            registerKeyboardNotifications()
            

        }
        

        @IBAction func loginBtnPressed(_ sender: UIButton) {
            let phoneNum = phoneNumTF.text?.replacingOccurrences(of: " ", with: "")
            
            API.login(phoneNumber: phoneNum!) { (data) in
                guard let data = data else {return}
                if data {
                   let vc = OTPVC(nibName: "OTPVC", bundle: nil)
                    vc.phoneNumber = phoneNum ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    
                    let vc = RegisterVC(nibName: "RegisterVC", bundle: nil)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }
        
        
        @IBAction func registerBtnPressed(_ sender: Any) {
            let vc = RegisterVC(nibName: "RegisterVC", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
//MARK: TextField
    extension LoginVC: UITextFieldDelegate{

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
             if textField == phoneNumTF{
                 guard let text = textField.text else { return false }
                
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
    
    extension LoginVC{
        
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
    
