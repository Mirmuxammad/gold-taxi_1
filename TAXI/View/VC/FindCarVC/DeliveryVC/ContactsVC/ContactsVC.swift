//
//  ContactsVC.swift
//  TAXI
//
//  Created by rakhmatillo topiboldiev on 02/04/21.
//

import UIKit
import Contacts

protocol ContactsVCDelegate {
    func didPhoneNumberSelected(phone_number: String, name: String)
}

class ContactsVC: UIViewController, UITextFieldDelegate {
    public var minimumVelocityToHide: CGFloat = 1500
    public var minimumScreenRatioToHide: CGFloat = 0.15
    public var animationDuration: TimeInterval = 0.2
    
    @IBOutlet weak var dimview: UIView!{
        didSet{
            dimview.alpha = 0
            
        }
    }
    @IBOutlet weak var cardView: UIView!{
        didSet{
            cardView.layer.cornerRadius = 20
            cardView.clipsToBounds = true
            
            cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }
    
    @IBOutlet weak var phone_TF: UITextField!{
        didSet{
            phone_TF.placeholder = "99 999 99 99"
            phone_TF.delegate = self
        }
    }
    @IBOutlet weak var okBtn: UIButton!{
        didSet{
            okBtn.isHidden = true
        }
    }
    var contacts = [Contacts(firstName: Lang.getString(type: .me), lastName: "", telephone: Cache.getUser()?.phoneNumber ?? "")]
    var delegate : ContactsVCDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
        self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
            view.addGestureRecognizer(panGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.view.transform = .identity

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
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
    
    @IBAction func okBtnPressed(_ sender: Any) {
        let phone = phone_TF.text!.replacingOccurrences(of: " ", with: "")
        delegate?.didPhoneNumberSelected(phone_number: "\(phone)", name: "")
        dimview.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        } completion: { (_) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    private func fetchContacts() {
        // 1.
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("failed to request access", error)
                return
            }
            if granted {
                // 2.
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    // 3.
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        self.contacts.append(Contacts(firstName: contact.givenName, lastName: contact.familyName, telephone: contact.phoneNumbers.first?.value.stringValue ?? ""))
                        self.tableView.reloadData()
                    })
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
                self.openSettingsAlert()
            }
        }
    }

}

//MARK:- TABLEVIEW DELEGATE
extension ContactsVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        
        cell.textLabel?.text = contacts[indexPath.row].firstName + contacts[indexPath.row].lastName
        cell.detailTextLabel?.text = contacts[indexPath.row].telephone
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let phone = contacts[indexPath.row].telephone.replacingOccurrences(of: " ", with: "").suffix(9)
        delegate?.didPhoneNumberSelected(phone_number: "\(phone)", name: contacts[indexPath.row].firstName)
        dimview.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        } completion: { (_) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    
}

//MARK: - OPEN SETTING
extension ContactsVC{
    
    private func openSettingsAlert() {
        let alertController = UIAlertController(title: "Contact Permission Required", message: "Please enable contact permissions in settings.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
            //Redirect to Settings app
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

//MARK: - FORMAT PHONE NUMBER
extension ContactsVC{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count == 12{
            UIView.animate(withDuration: 0.3) {
                self.okBtn.isHidden = false
            }
            textField.resignFirstResponder()
        }else{
            UIView.animate(withDuration: 0.3) {
                self.okBtn.isHidden = true
            }
        }
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
        if textField == phone_TF{
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

//MARK: - Swipe Methods

extension ContactsVC{
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
                UIView.animate(withDuration: 0.5, animations: {
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
                UIView.animate(withDuration: 0.5, animations: {
                    self.slideViewVerticallyTo(0)
                })
            }
            
        default:
            // If gesture state is undefined, reset the view to the top
            UIView.animate(withDuration: 0.5, animations: {
                self.slideViewVerticallyTo(0)
            })
            
        }
    }
  

}
