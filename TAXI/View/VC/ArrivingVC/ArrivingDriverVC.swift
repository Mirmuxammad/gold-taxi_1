// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 05/02/21
//  

import UIKit

protocol ArrivedVCDelegate {
    func didChatPressed()
    func didCallBtnPressed()
    func didIAmComingPressed()
    func didOrderDetailPressed()
    func didCancelOrderPressed()
    func didShareRoutePressed()
    func didSafetyPressed()
    
}

class ArrivingDriverVC: UIViewController {
    
    public var minimumVelocityToHide: CGFloat = 1500
    public var minimumScreenRatioToHide: CGFloat = 0.4
    public var animationDuration: TimeInterval = 0.2
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var contentView: UIView!{
        didSet{
            contentView.layer.cornerRadius = 20
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            contentView.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
            contentView.layer.shadowRadius = 5
            contentView.layer.shadowOpacity = 0.4
            contentView.clipsToBounds = true
        }
    }
    @IBOutlet weak var mainView: UIStackView!
    @IBOutlet weak var iamcomingView: UIView!{
        didSet{
            iamcomingView.isHidden = true
        }
    }
    @IBOutlet weak var inProgressView: UIView!{
        didSet{
            inProgressView.isHidden = true
        }
    }
    @IBOutlet weak var mainLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var howsgoingRideLbl: UILabel!{
        didSet{
            howsgoingRideLbl.text = Lang.getString(type: .how_is_going_ride)
        }
    }
    
    @IBOutlet weak var badgeView: UIView!{
        didSet{
            badgeView.isHidden = true
        }
    }
    @IBOutlet weak var callLbl: UILabel!{
        didSet{
            callLbl.text = Lang.getString(type: .call)
        }
    }
    @IBOutlet weak var chatLbl: UILabel!{
        didSet{
            chatLbl.text = Lang.getString(type: .chat)
        }
    }
    @IBOutlet weak var iamcomingLbl: UILabel!{
        didSet{
            iamcomingLbl.text = Lang.getString(type: .i_am_coming)
        }
    }
    @IBOutlet weak var numInBadgeViewLbl: UILabel!{
        didSet{
            numInBadgeViewLbl.text = ""
        }
    }
    
    
    @IBOutlet weak var startLocationMainLbl: UILabel!
    
    @IBOutlet weak var startLocationDetailLbl: UILabel!
    
    @IBOutlet weak var destinationMainLbl: UILabel!
    
    @IBOutlet weak var destinationDetailLbl: UILabel!
    
    @IBOutlet weak var paymentMainLbl: UILabel!{
        didSet{
            paymentMainLbl.text = Lang.getString(type: .l_choose_payment_type)
        }
    }
    
    @IBOutlet weak var paymentDetailLbl: UILabel!
    
    @IBOutlet weak var orderMainLbl: UILabel!{
        didSet{
            orderMainLbl.text = Lang.getString(type: .order_details)
        }
    }
    @IBOutlet weak var orderDetailLbl: UILabel!
    
    
    @IBOutlet weak var cancelOrderLbl: UILabel!{
        didSet{
            cancelOrderLbl.text = Lang.getString(type: .cancel_ride)
        }
    }
    @IBOutlet weak var shareRouteLbl: UILabel!{
        didSet{
            shareRouteLbl.text = Lang.getString(type: .share_route)
        }
    }
    
    @IBOutlet weak var safetyLbl: UILabel!{
        didSet{
            safetyLbl.text = Lang.getString(type: .safety)
        }
    }
    
   
    
    var rate = 0
    
    var delegate : ArrivedVCDelegate?
    
    
    @IBOutlet var ratingBtns: [UIButton]!{
        didSet{
            for i in 0..<ratingBtns.count{
                ratingBtns[i].setImage(UIImage(named: "star_not_filled"), for: .normal)
            }
        }
    }
    
    var currentStateYPoint : CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        view.addGestureRecognizer(panGesture)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabels), name: Notification.Name(rawValue: CONSTANTS.LANGUAGE_NOTIFICATION), object: nil)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        currentStateYPoint = self.view.frame.height - 260
    }
    
    @objc func updateLabels() {
        mainLbl.text = Lang.getString(type: .arriving_mins)
        callLbl.text = Lang.getString(type: .call)
        chatLbl.text = Lang.getString(type: .chat)
        iamcomingLbl.text = Lang.getString(type: .i_am_coming)
        
        howsgoingRideLbl.text = Lang.getString(type: .how_is_going_ride)
        
        paymentMainLbl.text = Lang.getString(type: .payment)
        
        orderMainLbl.text = Lang.getString(type: .order_details)
        cancelOrderLbl.text = Lang.getString(type: .l_cancel_order)
        shareRouteLbl.text = Lang.getString(type: .share_route)
        safetyLbl.text = Lang.getString(type: .safety)
    }
    
    @IBAction func iamcomingPressed(_ sender: Any) {
        delegate?.didIAmComingPressed()
    }
    
    @IBAction func startMessagePressed(_ sender: Any) {
        delegate?.didChatPressed()
        
    }
    
    @IBAction func callToDriverPressed(_ sender: Any) {
        delegate?.didCallBtnPressed()
    }
    
    
    @IBOutlet var expandBtns: [UIButton]!
    
    @IBAction func expandBtnPressed(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5) {
            if sender.currentImage == UIImage(named: "up"){
                
                sender.setImage(UIImage(named: "down"), for: .normal)
                
                self.currentStateYPoint = self.view.frame.height - self.contentView.frame.height - 10
                self.view.transform = CGAffineTransform(translationX: 0, y: self.currentStateYPoint )
                
                
            }else{
                sender.setImage(UIImage(named: "up"), for: .normal)
                self.currentStateYPoint =  self.view.frame.height - 260
                self.view.transform = CGAffineTransform(translationX: 0, y: self.currentStateYPoint)
            }
        }
        
    }
    
    
    @IBAction func expandBtn1Pressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            if sender.currentImage == UIImage(named: "up"){
                
                sender.setImage(UIImage(named: "down"), for: .normal)
                self.currentStateYPoint = self.view.frame.height - self.contentView.frame.height - 10
                self.view.transform = CGAffineTransform(translationX: 0, y: self.currentStateYPoint )
                
                
            }else{
                sender.setImage(UIImage(named: "up"), for: .normal)
                self.currentStateYPoint =  self.view.frame.height - 260
                self.view.transform = CGAffineTransform(translationX: 0, y: self.currentStateYPoint)
            }
        }
    }
    
    
    @IBAction func destLocationPressed(_ sender: UIButton) {
    }
    
    @IBAction func paymentPressed(_ sender: Any) {
    }
    
    @IBAction func orderPressed(_ sender: Any) {
        
        delegate?.didOrderDetailPressed()
    }
    
    @IBAction func cancelOrderPressed(_ sender: Any) {
        delegate?.didCancelOrderPressed()
    }
    
    @IBAction func shareRoutePressed(_ sender: Any) {
        delegate?.didShareRoutePressed()
    }
    @IBAction func safetyPressed(_ sender: Any) {
        delegate?.didSafetyPressed()
    }
    
    
    
    @IBAction func ratingBtnsPressed(_ sender: UIButton) {
        rate = sender.tag + 1
        for i in ratingBtns{
            i.setImage(UIImage(named: "star_not_filled"), for: .normal)
        }
        for i in 0...sender.tag{
            ratingBtns[i].setImage(UIImage(named: "star"), for: .normal)
        }
        
    }
    
}



//MARK: - Swipe Methods
extension ArrivingDriverVC {
    
    func slideViewVerticallyTo(_ y: CGFloat) {
        self.view.frame.origin = CGPoint(x: 0, y: y)
    }
    
    
    @objc func onPan(_ panGesture: UIPanGestureRecognizer) {
        
        switch panGesture.state {
        case .began, .changed:
            // If pan started or is ongoing then
            // slide the view to follow the finger
            if self.currentStateYPoint == self.view.frame.height - self.contentView.frame.height - 10{
                //expanded state
                
                if panGesture.translation(in: view).y > 0  {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.currentStateYPoint + panGesture.translation(in: view).y)
                }else{
                   
                }
            }else{
                //shrinked state
                
                
                
                self.view.transform = CGAffineTransform(translationX: 0, y: self.currentStateYPoint + panGesture.translation(in: view).y)
            }
            
            
        case .ended:
            // If pan ended, decide it we should close or reset the view
            // based on the final position and the speed of the gesture
            let translation = panGesture.translation(in: view)
           // let velocity = panGesture.velocity(in: view)
            let expand = (translation.y < -80)
                //|| (velocity.y > 1500)
            let shrink = (translation.y > 80)
                //|| (velocity.y > 1500)

            if expand {
                UIView.animate(withDuration: animationDuration) {
                    self.expandBtns[0].setImage(UIImage(named: "down"), for: .normal)
                    self.expandBtns[1].setImage(UIImage(named: "down"), for: .normal)
                    
                    self.currentStateYPoint = self.view.frame.height - self.contentView.frame.height - 10
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.currentStateYPoint)
                }
            }else if shrink{
                
                UIView.animate(withDuration: animationDuration) {
                    self.expandBtns[0].setImage(UIImage(named: "up"), for: .normal)
                    self.expandBtns[1].setImage(UIImage(named: "up"), for: .normal)
                    self.currentStateYPoint =  self.view.frame.height - 260
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.currentStateYPoint)
                }
            }else{
                self.view.transform = CGAffineTransform(translationX: 0, y: self.currentStateYPoint)
            }
            
        default:
            break
            
        }
    }
   
}




