// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 25/01/21
//  

import UIKit

class RequestSupportVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleTF: UITextField!{
        didSet{
            titleTF.placeholder = Lang.getString(type: .request_view_title)
        }
    }
    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.text = Lang.getString(type: .request_view_title)
        }
    }
    @IBOutlet weak var detailLbl: UILabel!{
        didSet{
            detailLbl.text = Lang.getString(type: .request_view_detail)
            
        }
    }
    @IBOutlet weak var detailTV: UITextView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var submitBtn: UIButton!{
        didSet{
            submitBtn.setTitle(Lang.getString(type: .request_submit), for: .normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTF.delegate = self
        setupToolbarForTextFields()
        registerKeyboardNotifications()
    }
    func setupToolbarForTextFields() {
            let toolbar = UIToolbar()
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: Lang.getString(type: .b_done), style: .done,
                                             target: self, action: #selector(doneButtonTapped))
            
            toolbar.setItems([flexSpace, doneButton], animated: true)
            toolbar.sizeToFit()
            
            detailTV.inputAccessoryView = toolbar
           
        }
        
        @objc func doneButtonTapped() {
            view.endEditing(true)
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTF.resignFirstResponder()
        return true
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func submitBtnPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - Keyboard handling
extension RequestSupportVC{
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
            self.containerView.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height/2)
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5) {
            self.containerView.transform = .identity
        }
    }
}
