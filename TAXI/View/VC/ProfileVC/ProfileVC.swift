// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 25/01/21
//  

import UIKit
import SDWebImage

class ProfileVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    @IBOutlet weak var containerStack: UIStackView!
    @IBOutlet weak var firstNameTF: UITextField!{
        didSet{
            firstNameTF.placeholder = Lang.getString(type: .l_firstname)
            firstNameTF.delegate = self
            firstNameTF.text = userData?.firstName
        }
    }
    @IBOutlet weak var lastNameTF: UITextField!{
        didSet{
            lastNameTF.placeholder = Lang.getString(type: .l_lastname)
            lastNameTF.delegate = self
            lastNameTF.text = userData?.lastName
        }
    }
    @IBOutlet weak var phoneNumTF: UITextField!{
        didSet{
            phoneNumTF.placeholder = Lang.getString(type: .l_phone_number)
            phoneNumTF.delegate = self
            phoneNumTF.text = format(with: "+XXX XX XXX XX XX", phone: "998" + "\(userData!.phoneNumber)")
        }
    }
    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.text = Lang.getString(type: .profile)
        }
    }
    @IBOutlet weak var firstnameLbl: UILabel!{
        didSet{
            firstnameLbl.text = Lang.getString(type: .l_firstname)
        }
    }
    
    @IBOutlet weak var lastnameLbl: UILabel!{
        didSet{
            lastnameLbl.text = Lang.getString(type: .l_lastname)
        }
    }
    
    @IBOutlet weak var phonenumberLbl: UILabel!{
        didSet{
            phonenumberLbl.text = Lang.getString(type: .l_phone_number)
        }
    }
    
    @IBOutlet weak var updateBtn: UIButton!{
        didSet{
            updateBtn.setTitle(Lang.getString(type: .b_update), for: .normal)
        }
    }
    let datePicker = UIDatePicker()
    var userData = Cache.getUser()
    var imagePicker = UIImagePickerController()
    var newImg: UIImage?
    
    @IBOutlet weak var profileImageView: UIImageView!
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerKeyboardNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabels), name: Notification.Name(CONSTANTS.LANGUAGE_NOTIFICATION), object: nil)
        self.profileImageView.sd_setImage(with: URL(string: API.baseURL + "/api" + (Cache.getUser()?.image ?? "")) , placeholderImage: UIImage(named: "profilePhoto"))
    }
    

   
    @objc func updateLabels() {
        titleLbl.text = Lang.getString(type: .profile)
        
        firstnameLbl.text = Lang.getString(type: .l_firstname)
        firstNameTF.placeholder = Lang.getString(type: .l_firstname)
        
        lastnameLbl.text = Lang.getString(type: .l_lastname)
        lastNameTF.placeholder = Lang.getString(type: .l_lastname)
        
        phonenumberLbl.text = Lang.getString(type: .l_phone_number)
        phoneNumTF.placeholder = Lang.getString(type: .l_phone_number)
        
        updateBtn.setTitle(Lang.getString(type: .b_update), for: .normal)
    }

    @IBAction func cameraBtnPressed(_ sender: UIButton) {
        
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self, btn: sender)
        AttachmentHandler.shared.imagePickedBlock = {
            (image) in
            self.profileImageView.image = image
            self.newImg = image
        }
        

    }
    

   
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func updateBtnPressed(_ sender: UIButton) {
        let token = Cache.getUser()?.token
        let id = Cache.getUser()?.id
        let state = Cache.getUser()?.state
        let currentRide = Cache.getUser()?.currentRide
        
        userData = Cache.getUser()
        userData?.firstName = firstNameTF.text!
        userData?.lastName = lastNameTF.text!
        userData?.phoneNumber = "\(phoneNumTF.text!.replacingOccurrences(of: " ", with: "").dropFirst(4))"
        userData?.token = token
        userData?.id = id
        userData?.state = state
        userData?.currentRide = currentRide
        activityIndicator.startAnimating()
        
        if let img = self.newImg {
            
            API.uploadFile(image: img) { (imgUrl) in
                API.updateUserInfo(firstname: self.firstNameTF.text!, lastname: self.lastNameTF.text!, image: imgUrl, phone_number: "\(self.phoneNumTF.text!.replacingOccurrences(of: " ", with: "").dropFirst(4))")
                self.userData?.image = imgUrl
                Cache.saveUser(data: self.userData!) { (done) in
                    if done{
                        self.activityIndicator.stopAnimating()
                    }else{
                        Alert.showAlert(forState: .error, message: "Could not update user info")
                    }
                }
                self.profileImageView.sd_setImage(with: URL(string: API.baseURL + "/api" + imgUrl) , placeholderImage: UIImage(named: "profilePhoto"))
            }
        }else{
            API.updateUserInfo(firstname: self.firstNameTF.text!, lastname: self.lastNameTF.text!, image: Cache.getUser()?.image ?? "", phone_number: "\(self.phoneNumTF.text!.replacingOccurrences(of: " ", with: "").dropFirst(4))")
            Cache.saveUser(data: self.userData!) { (done) in
                if done{
                    self.activityIndicator.stopAnimating()
                }else{
                    Alert.showAlert(forState: .error, message: "Could not update user info")
                }
            }
        }
        
      
        
        
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
  
}



//MARK: - TextField
extension ProfileVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case firstNameTF:
            firstNameTF.resignFirstResponder()
            lastNameTF.becomeFirstResponder()
        case lastNameTF:
            lastNameTF.resignFirstResponder()
            phoneNumTF.becomeFirstResponder()
        default:
            phoneNumTF.resignFirstResponder()
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
        if textField == phoneNumTF{
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

//MARK: - Keyboard Handling
extension ProfileVC{
    
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
            self.containerStack.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height/3)
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5) {
            self.containerStack.transform = .identity
        }
    }
    
}

