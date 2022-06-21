//
//  DeliveryVC.swift
//  TAXI
//
//  Created by rakhmatillo topiboldiev on 01/04/21.
//

import UIKit
import RAGTextField

protocol DeliveryVCDelegate {
    func orderBtnPressed(order_from_phone_number: String, order_from_name: String, order_from_entrance : String, order_from_apartment: String, order_from_floor: String, order_from_door_phone : String, order_from_comment: String, order_to_phone_number: String, order_to_name: String, order_to_entrance: String, order_to_apartment: String, order_to_floor : String, order_to_door_phone: String, order_to_comments: String, door_to_door: Bool)
}

class DeliveryVC: UIViewController , UITextFieldDelegate {
    public var minimumVelocityToHide: CGFloat = 1500
    public var minimumScreenRatioToHide: CGFloat = 0.2
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
    @IBOutlet weak var sender_entranceTF: RAGTextField!{
        didSet{
           setUnderLine(textfield: sender_entranceTF)
            sender_entranceTF.placeholder = Lang.getString(type: .entrance)
            
        }
    }
    
    @IBOutlet weak var sender_apartment_office_TF: RAGTextField!{
        didSet{
            setUnderLine(textfield: sender_apartment_office_TF)
            sender_apartment_office_TF.placeholder = Lang.getString(type: .apartment_office)
        }
    }
    @IBOutlet weak var sender_floor_TF: RAGTextField!{
        didSet{
            setUnderLine(textfield: sender_floor_TF)
            sender_floor_TF.placeholder = Lang.getString(type: .floor)
        }
    }
    @IBOutlet weak var sender_door_phone_TF: RAGTextField!{
        didSet{
            setUnderLine(textfield: sender_door_phone_TF)
            sender_door_phone_TF.placeholder = Lang.getString(type: .door_phone)
        }
    }
    @IBOutlet weak var sender_comment_TF: RAGTextField!{
        didSet{
            setUnderLine(textfield: sender_comment_TF)
            sender_comment_TF.placeholder = Lang.getString(type: .comments)
        }
    }
    
    @IBOutlet weak var reciever_entrance_TF: RAGTextField!{
        didSet{
            setUnderLine(textfield: reciever_entrance_TF)
            reciever_entrance_TF.placeholder = Lang.getString(type: .entrance)
        }
    }
    
    @IBOutlet weak var reciever_appartment_office_TF: RAGTextField!{
        didSet{
            setUnderLine(textfield: reciever_appartment_office_TF)
            reciever_appartment_office_TF.placeholder = Lang.getString(type: .apartment_office)
        }
    }
    
    @IBOutlet weak var reciever_floor_TF: RAGTextField!{
        didSet{
            setUnderLine(textfield: reciever_floor_TF)
            reciever_floor_TF.placeholder = Lang.getString(type: .floor)
        }
    }
    
    @IBOutlet weak var reciever_door_phone_TF: RAGTextField!{
        didSet{
            setUnderLine(textfield: reciever_door_phone_TF)
            reciever_door_phone_TF.placeholder = Lang.getString(type: .door_phone)
        }
    }
    
    @IBOutlet weak var reciever_comment_TF: RAGTextField!{
        didSet{
            setUnderLine(textfield: reciever_comment_TF)
            reciever_comment_TF.placeholder = Lang.getString(type: .comments)
        }
    }
    
    @IBOutlet weak var door_to_door_toggle: UISwitch!
    
    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.text = Lang.getString(type: .sender_and_reciever)
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var frome_where_to_pick_LBL: UILabel!{
        didSet{
            frome_where_to_pick_LBL.text = Lang.getString(type: .pickup_location)
        }
    }
    @IBOutlet weak var who_is_sender_LBL: UILabel!{
        didSet{
            who_is_sender_LBL.text = Lang.getString(type: .package_sender)
        }
    }
    @IBOutlet weak var sender_infoLBL: UILabel!{
        didSet{
            sender_infoLBL.text = Cache.getUser()!.firstName  + "\n" +  Cache.getUser()!.phoneNumber
        }
    }
    @IBOutlet weak var start_address_LBL: UILabel!{
        didSet{
            start_address_LBL.text = startAddressData.name
        }
    }
    
    @IBOutlet weak var to_where_to_deliver_LBL: UILabel!{
        didSet{
            to_where_to_deliver_LBL.text = Lang.getString(type: .delivery_destination)
        }
    }
    
    @IBOutlet weak var who_will_recieve_LBL: UILabel!{
        didSet{
            who_will_recieve_LBL.text = Lang.getString(type: .package_recipient)
        }
    }
    
    @IBOutlet weak var reciever_info_LBL: UILabel!
    
    @IBOutlet weak var dest_address_LBL: UILabel!{
        didSet{
            dest_address_LBL.text = destinationAddressData.name
        }
    }
    
    @IBOutlet weak var door_to_door_LBL: UILabel!{
        didSet{
            door_to_door_LBL.text = Lang.getString(type: .door_to_door)
        }
    }
    
    @IBOutlet weak var orderBtn: UIButton!{
        didSet{
            orderBtn.titleLabel?.numberOfLines = 2
            orderBtn.titleLabel?.textAlignment = .center
            
            orderBtn.setTitle(Lang.getString(type: .order) + "\n\(price) \(Lang.getString(type: .l_sum))", for: .normal)
        }
    }
    
    var delegate : DeliveryVCDelegate?
    
    var startAddressData : AddressDM!
    var destinationAddressData : AddressDM!
    var price = 0
    private var sender_phone = Cache.getUser()?.phoneNumber
    private var sender_name = Cache.getUser()?.firstName
    private var recipient_phone = ""
    private var recipient_name = ""
    private var isSenderPhone = false
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
            view.addGestureRecognizer(panGesture)
        scrollView.keyboardDismissMode = .onDrag
        scrollView.contentOffset.x = 150
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.view.transform = .identity

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        registerKeyboardNotifications()
        UIView.animate(withDuration: 0.5) {
            self.dimview.alpha = 1
        }
        
    }
    
    
    @IBAction func dismissBtnPressed(_ sender: Any) {
        dimview.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        } completion: { (_) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func chooseSenderBtnPressed(_ sender: UIButton) {
        //open contanct
        isSenderPhone = true
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillShowNotification , object: nil)
        let vc = ContactsVC(nibName: "ContactsVC", bundle: nil)
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func chooseRecieverBtnPressed(_ sender: UIButton) {
        //open contact
        isSenderPhone = false
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillShowNotification , object: nil)
        let vc = ContactsVC(nibName: "ContactsVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func orderBtnPressed(_ sender: UIButton) {
        
        if reciever_info_LBL.text! != " " {
            
            delegate?.orderBtnPressed(
                order_from_phone_number: sender_phone ?? "",
                order_from_name: sender_name ?? "",
                order_from_entrance: sender_entranceTF.text!,
                order_from_apartment: sender_apartment_office_TF.text!,
                order_from_floor: sender_floor_TF.text!,
                order_from_door_phone: sender_door_phone_TF.text!,
                order_from_comment: sender_comment_TF.text!,
                order_to_phone_number: recipient_phone,
                order_to_name: recipient_name,
                order_to_entrance: reciever_entrance_TF.text!,
                order_to_apartment: reciever_appartment_office_TF.text!,
                order_to_floor: reciever_floor_TF.text!,
                order_to_door_phone: reciever_door_phone_TF.text!,
                order_to_comments: reciever_comment_TF.text!, door_to_door: door_to_door_toggle.isOn)
            
            
            
            dimview.alpha = 0
            UIView.animate(withDuration: 0.5) {
                self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
            } completion: { (_) in
                self.dismiss(animated: false, completion: nil)
            }
            
            
        }else{
            Alert.showAlert(forState: .error, message: Lang.getString(type: .please_choose_recipient_info))
        }
        
    }
    
    private func setUnderLine(textfield: RAGTextField){
        textfield.delegate = self
        let bgView = UnderlineView(frame: .zero)
        bgView.textField = textfield
        bgView.backgroundLineColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 0)
        bgView.foregroundLineColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        bgView.foregroundLineWidth = 2.0
        bgView.expandDuration = 0.2
        
        textfield.textBackgroundView = bgView
    }

}
//MARK: - ContactsDelegate
extension DeliveryVC: ContactsVCDelegate{
    func didPhoneNumberSelected(phone_number: String, name: String) {
        if isSenderPhone{
            sender_name = name
            sender_phone = phone_number
            self.sender_infoLBL.text = name + "\n" + phone_number
        }else{
            recipient_name = name
            recipient_phone = phone_number
            self.reciever_info_LBL.text = name + "\n" + phone_number
        }
    }
    
    
}


//MARK: - Swipe Methods

extension DeliveryVC{
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
            print(self.view.frame.size.height * minimumScreenRatioToHide)
            print(y)
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



//MARK: - Keyboard handling
extension DeliveryVC{
  
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
            mylog("asdfghjkuli")
            self.cardView.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height / 1.5)
        }
    }
    
    
//    @objc func keyboardWillHide(notification: NSNotification) {
//        UIView.animate(withDuration: 0.5) {
//            let userInfo: NSDictionary = notification.userInfo! as NSDictionary
//            let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
//            let keyboardSize = keyboardInfo.cgRectValue.size
//            self.cardView.transform = .identity
//
//        }
//    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5) {
            self.cardView.transform = .identity
        }
    }
    
}
