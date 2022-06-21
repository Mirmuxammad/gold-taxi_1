// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 05/02/21
//  

import UIKit

protocol RateYourRideVCDelegate {
    func didSubmitPressed(ride_id: String, rate: Int, ride_comment: String, ride_feeds: [String] )
}

class RateYourRideVC: UIViewController , UITextViewDelegate{
    
    var transform: CGAffineTransform!
    var delegate : RateYourRideVCDelegate?
    var total_cost =  ""
    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.alpha = 0
        }
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.delegate = self
        }
    }
    @IBOutlet weak var titleLbl: UILabel!{
        didSet{titleLbl.text = Lang.getString(type: .l_how_was_ride)}
    }
    @IBOutlet weak var comfortableDriveLbl: UILabel!{
        didSet{
            comfortableDriveLbl.text = Lang.getString(type: .l_comfortable_drive)
        }
    }
    
    @IBOutlet weak var greatNavLbl: UILabel!{
        didSet{
            greatNavLbl.text = Lang.getString(type: .l_great_navigation)
        }
    }
    @IBOutlet weak var cleanLbl: UILabel!{
        didSet{
            cleanLbl.text = Lang.getString(type: .l_clean)
        }
    }
    @IBOutlet weak var smoothDriveLbl: UILabel!{
        didSet{
            smoothDriveLbl.text = Lang.getString(type: .l_smooth_drive)
        }
    }
    @IBOutlet weak var you_arrivedLbl: UILabel!{
        didSet{
            you_arrivedLbl.text = Lang.getString(type: .l_you_have_arrived_at_your_destination)
        }
    }
    @IBOutlet weak var howwasRideLbl: UILabel!{
        didSet{
            howwasRideLbl.text = Lang.getString(type: .l_how_was_ride)
        }
    }
    
    @IBOutlet weak var totalCostLbl: UILabel!{
        didSet{
            totalCostLbl.text = "\(Double(total_cost)!.rounded()) \(Lang.getString(type: .l_sum))"
        }
    }
    
   
    @IBOutlet var comfortBtn: [UIButton]!{
        didSet{
            let images = [UIImage(named: "car"), UIImage(named: "compass"), UIImage(named: "spray"), UIImage(named: "brake")]
            for i in 0..<comfortBtn.count{
                comfortBtn[i].backgroundColor = #colorLiteral(red: 0.8195154071, green: 0.8196598291, blue: 0.8195170164, alpha: 1)
                comfortBtn[i].tag = 0
                comfortBtn[i].setImage(images[i], for: .normal)
                comfortBtn[i].tintColor = #colorLiteral(red: 0.3450556993, green: 0.3451217413, blue: 0.3450564146, alpha: 1)
            }
            
        }
    }
    
    @IBOutlet var ratingBtns: [UIButton]!{
        didSet{
            for i in 0..<rate{
                ratingBtns[i].setBackgroundImage(UIImage(named: "star"), for: .normal)
            }
        }
    }
    
    @IBOutlet weak var totalPaymentStack: UIStackView!
    
    
    @IBOutlet weak var submit: UIButton!{
        didSet{
            submit.setTitle(Lang.getString(type: .request_submit), for: .normal)
        }
    }
    var rate = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        self.view.transform = transform
        registerKeyboardNotifications()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }completion: { (_) in
            UIView.animate(withDuration: 0.2) {
                self.backView.alpha = 1
            }
        }
        
    }
    
    @IBAction func dissmissBtnPressed(_ sender: Any) {
        self.backView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.view.transform = self.transform
        }completion: { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    let ride_feeds_ = [Lang.getString(type: .l_comfortable_drive), Lang.getString(type: .l_great_navigation), Lang.getString(type: .l_clean), Lang.getString(type: .l_smooth_drive)]
    
    var ride_feeds = [String]()
    
    @IBAction func comfortBtnsPressed(_ sender: UIButton) {
        if sender.tag == 0{
            sender.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            sender.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            sender.tag = 1
        }else{
            sender.tintColor = #colorLiteral(red: 0.3450556993, green: 0.3451217413, blue: 0.3450564146, alpha: 1)
            sender.backgroundColor = #colorLiteral(red: 0.8195154071, green: 0.8196598291, blue: 0.8195170164, alpha: 1)
            sender.tag = 0
        }
        
        ride_feeds = []
        for i in 0..<comfortBtn.count where comfortBtn[i].tag == 1{
            ride_feeds.append(ride_feeds_[i])
        }
        
        
    }
    
    @IBOutlet weak var impressionLbl: UILabel!
    @IBAction func ratingBtnsPressed(_ sender: UIButton) {
        rate = sender.tag + 1
        for i in ratingBtns{
            i.setBackgroundImage(UIImage(named: "star_not_filled"), for: .normal)
        }
        for i in 0...sender.tag{
            ratingBtns[i].setBackgroundImage(UIImage(named: "star"), for: .normal)
        }
        
        switch sender.tag {
        case 0:
            impressionLbl.text = Lang.getString(type: .l_awful)
        case 1:
            impressionLbl.text = Lang.getString(type: .l_not_bad)
        case 2:
            impressionLbl.text = Lang.getString(type: .l_good)
        case 3:
            impressionLbl.text = Lang.getString(type: .l_very_good)
        default:
            impressionLbl.text = Lang.getString(type: .l_excellent)
        }
        
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        let ride_comment = textView.text! == Lang.getString(type: .p_enter_comment) ?  "" : textView.text!
        API.getFullRideInfo { (data) in
            self.delegate?.didSubmitPressed(ride_id: data._id ,rate: self.rate, ride_comment: ride_comment, ride_feeds: self.ride_feeds )
            Cache.saveLastOrderID(id: nil)
            self.dismiss(animated: false, completion: nil)
        }
        
        
        
    }
  
}

//MARK:- Keyboard Handling
extension RateYourRideVC{
    
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
