// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 27/02/21
//  

import UIKit

class OrderDetails: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    public var minimumVelocityToHide: CGFloat = 1500
    public var minimumScreenRatioToHide: CGFloat = 0.4
    public var animationDuration: TimeInterval = 0.2
    
    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.text = Lang.getString(type: .order_details)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "OrderDetailTVC", bundle: nil), forCellReuseIdentifier: "OrderDetailTVC")
            tableView.register(UINib(nibName: "DriverInfoCell", bundle: nil), forCellReuseIdentifier: "DriverInfoCell")
            tableView.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.cornerRadius = 25
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
            containerView.layer.shadowOpacity = 0.4
            containerView.layer.shadowRadius = 5
        }
    }
    
    var sectionData = [Lang.getString(type: .driver_info), Lang.getString(type: .route), Lang.getString(type: .time), Lang.getString(type: .l_choose_payment_type)]
    var rideFullInfo : RideFullInfo!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        view.addGestureRecognizer(panGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabels), name: Notification.Name(rawValue: Lang.getString(type: .order_details)), object: nil)
        
    }
    
    @objc func updateLabels() {
        titleLbl.text = Lang.getString(type: .order_details)
        sectionData = [Lang.getString(type: .driver_info), Lang.getString(type: .route), Lang.getString(type: .time), Lang.getString(type: .payment)]
        tableView.reloadData()
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1{
            return 2
        }
        if section == 2{
            return 1
        }
        if section == 3{
            return 3
        }
        return 5
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        guard let driverInfoCell = tableView.dequeueReusableCell(withIdentifier: "DriverInfoCell") as? DriverInfoCell else {return UITableViewCell()}
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTVC") as? OrderDetailTVC else {return UITableViewCell()}
        let nameAndSurname = rideFullInfo.driver_name.split(separator: " ")
        
        if indexPath.section == 0{
            if indexPath.row == 0{
                driverInfoCell.driverImageView.sd_setImage(with: URL(string: API.baseURL + "/api" + rideFullInfo.driver_image), placeholderImage: #imageLiteral(resourceName: "profilePhoto"))
                driverInfoCell.driverNameLbl.text = "\(nameAndSurname[0])"
                driverInfoCell.driverSurnameLbl.text = "\(nameAndSurname[1])"
                
                return driverInfoCell
                
            }else{
                cell.updateCell(shouldImgShow: false, text: rideFullInfo.driver_phone, image: UIImage(named: "startLocation.png")!)
            }
        }
        
        if indexPath.section == 1{
            if indexPath.row == 0{
                cell.updateCell(shouldImgShow: true, text: rideFullInfo.start_location.name, image: UIImage(named: "startLocation.png")!)
                
            }else{
                var text = ""
                if rideFullInfo.ride_type == "corporative"{
                    text = Lang.getString(type: .l_i_will_tell_the_driver)
                }else{
                    text = rideFullInfo.destination_location.name
                }
                cell.updateCell(shouldImgShow: true, text: text , image: UIImage(named: "destinationLocation.png")!)
            }
        }
        
        if indexPath.section == 2{

            cell.updateCell(shouldImgShow: false, text: (rideFullInfo.ordered_time.getDateValue().getStringOf()), image: UIImage(named: "destinationLocation.png")!)
        }
        
        if indexPath.section == 3{

            if indexPath.row == 0{
                
                cell.updateCell(shouldImgShow: false, text: rideFullInfo.car_class_name, image: UIImage(named: "destinationLocation.png")!)
            }else if indexPath.row == 1{
                
                cell.updateCell(shouldImgShow: false, text: "\((Double(rideFullInfo.estimated_price)?.rounded())!) \(Lang.getString(type: .l_sum))", image: UIImage(named: "destinationLocation.png")!)
            }else{
                
                cell.updateCell(shouldImgShow: false, text: rideFullInfo.payment_method == "cash" ? Lang.getString(type: .cash) : Lang.getString(type: .card), image: UIImage(named: "destinationLocation.png")!)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 2{
            let phoneURL = NSURL(string: ("tel://" + rideFullInfo.driver_phone))
                UIApplication.shared.open(phoneURL! as URL, options: [:], completionHandler: nil)
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionData[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0{
            return 100
        }else{
            return tableView.estimatedRowHeight
        }
        
    }
    
    
}

extension String{
    
    func getDateValue() -> Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
            let newdate = formatter.date(from: self)
        return newdate ?? Date()

        }
    
}

extension Date{
    
    func getStringOf() -> String {
            
            let formatter3 = DateFormatter()
            switch Cache.getAppLanguage(){
            case .en:
                formatter3.locale = Locale(identifier: "en_US")
            case .ru:
                formatter3.locale = Locale(identifier: "ru_RU")
            case .uz:
                formatter3.locale = Locale(identifier: "uz_Latn_UZ")
            }
            formatter3.dateFormat = "dd.MM.yyyy HH:mm"
           
            return formatter3.string(from: self)
        }
    
    func getStringOfDateMonthYear() -> String{
        let formatter3 = DateFormatter()
    
        switch Cache.getAppLanguage(){
        case .en:
            formatter3.locale = Locale(identifier: "en_US")
        case .ru:
            formatter3.locale = Locale(identifier: "ru_RU")
        case .uz:
            formatter3.locale = Locale(identifier: "uz_Latn_UZ")
        }
        formatter3.dateFormat = "dd, MMMM yyyy"
       
        return formatter3.string(from: self)
    }
    func getStringOfClock() -> String {
            
            let formatter3 = DateFormatter()
            
            formatter3.dateFormat = "HH:mm"
           
            return formatter3.string(from: self)
        }
}

//MARK: - Swipe Method
extension OrderDetails{
    
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
