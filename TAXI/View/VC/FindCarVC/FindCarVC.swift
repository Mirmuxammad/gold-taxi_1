//
//  FindCarVC.swift
//  TAXI
//
//  Created by Shahzod Ashirov on 2/3/21.
//

import UIKit
import Lottie

//MARK: - Protocols
protocol FindCarDelegate {
    func didBackBtnPressed()
    func didRideCreated()
    func didClearDestAddressPressed()
    func didChangeDestinationAddressPressed()
    func didChangeStartAddressPressed()
}


class FindCarVC: UIViewController {
    
    //check did appear method too
    lazy var cardHeight: CGFloat = self.containerView.frame.height
    
    var delegate: FindCarDelegate?
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
            containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
            containerView.layer.shadowOpacity = 0.4
            containerView.layer.shadowRadius = 5
            
            containerView.layer.cornerRadius = 20
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
    }
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(CarsCVC.nib(), forCellWithReuseIdentifier: CarsCVC.identifier)
        }
    }
    
    
    
    var preSearchAnimation : AnimationView = {
        let v = AnimationView(name: "pre_searching")
        v.play(fromFrame: 0, toFrame: 45, loopMode: .loop, completion: nil)
        v.isUserInteractionEnabled = true
        return v
        
    }()
    
    @IBOutlet weak var currentLocationLbl: UILabel!
    
    @IBOutlet weak var destinationLbl: UILabel!
    
    
    var selectedCarClass = ""
    var selectedCarestimatedAndTotalCost = 0
    var selectedCartotalDistance = 0.0
    var isCorporativeRide = false
    
    //in this vc we need ride pols to create ride
    var ridePols : [[String : Double]] = []
    
    var startAddressData : AddressDM?
    var destinationAddressData : AddressDM?
    var estimatedPrice : [EstimatedPriceDM] = [] {
        didSet {
            self.collectionView.reloadData()
            if estimatedPrice.isEmpty{
                self.findRideBtn.isEnabled = false
            }else{
                self.findRideBtn.isEnabled = true
            }
            
            
        }
    }
    
    var comment : String = ""
    var isAirConditionerEnabled = false
    var entrance = ""
    var cardnumber = ""
    var rider_phone = ""
    var rider_type = "self"
    var payment_method = ""
    var is_delivery = false
    
    @IBOutlet weak var clearDestAddressBtn: UIButton!
    
    @IBOutlet weak var entranceBtn: UIButton!
    
    @IBOutlet weak var entranceLbl: UILabel!{
        didSet{
            entranceLbl.text = Lang.getString(type: .b_entrance)
        }
        
    }
    @IBOutlet weak var optionLbl: UILabel!{
        didSet{
            optionLbl.text = Lang.getString(type: .l_options)
        }
    }
    @IBOutlet weak var payment_type_lbl: UILabel!{
        didSet{
            if Cache.isPaymentTypeSaved(){
                payment_type_lbl.text = Lang.getString(type: .card)
            }else{
                payment_type_lbl.text = cardnumber.isEmpty ? Lang.getString(type: .cash) :  Lang.getString(type: .card)
            }
            
            
        }
    }
    @IBOutlet weak var findRideBtn: UIButton!{
        didSet{
            findRideBtn.isEnabled = false
            findRideBtn.setTitle(Lang.getString(type: .b_create_ride ), for: .normal)
        }
    }
    
    @IBOutlet weak var cashOrCardBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNotificationObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cardHeight = self.containerView.frame.height + 55
        
    }
    
    private func createNotificationObservers(){
        EntranceRideOptionCommentNotification.createRideOptionObservers { (isOn) in
            #warning("NEED TO BE CHANGE TO API, Price when air conditioner on")
            self.isAirConditionerEnabled = isOn
            if self.destinationAddressData != nil {
                if self.isAirConditionerEnabled {
                    for i in 0..<self.estimatedPrice.count{
                        self.estimatedPrice[i].price += 2000
                        self.collectionView.reloadData()
                    }
                }else{
                    for i in 0..<self.estimatedPrice.count{
                        self.estimatedPrice[i].price -= 2000
                    }
                    UserDefaults.standard.setValue(false, forKey: CONSTANTS.IS_AIR_CONDITIONER_ON)
                }
                
            }
            self.collectionView.reloadData()
        }
        EntranceRideOptionCommentNotification.createEntranceObservers { (entrance) in
            self.entrance = entrance
        }
        EntranceRideOptionCommentNotification.createCommentObservers { (comment) in
            self.comment = comment
        }
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabels), name: Notification.Name(rawValue: CONSTANTS.LANGUAGE_NOTIFICATION), object: nil)
    }
    
    @objc func appBecomeActive(){
        
        if Cache.isPreSearchAnimationSaved(){
            setupPreSearchAnimation()
        }else{
            removePreSearchAnimation()
        }
    }
    
    @objc func updateLabels() {
        entranceBtn.setTitle(Lang.getString(type: .b_entrance), for: .normal)
        optionLbl.text = Lang.getString(type: .l_options)
        payment_type_lbl.text = cardnumber.isEmpty ? Lang.getString(type: .cash) :  Lang.getString(type: .card)
        findRideBtn.setTitle(Lang.getString(type: .b_create_ride), for: .normal)
        
        collectionView.reloadData()
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        delegate?.didBackBtnPressed()
        #warning("NEED TO BE CHANGE TO API, Price when air conditioner on")
        UserDefaults.standard.setValue(false, forKey: CONSTANTS.IS_AIR_CONDITIONER_ON)
    }
    
    
    @IBAction func entrancePressed(_ sender: UIButton) {
        let vc = EntranceVC(nibName: "EntranceVC", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func optionBtnPressed(_ sender: Any) {
        let vc = RideOptionsVC(nibName: "RideOptionsVC", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func paymentMethodPressed(_ sender: UIButton) {
        let vc = PaymentMethodVC(nibName: "PaymentMethodVC", bundle: nil)
        vc.delegate = self
        vc.cardNumber = self.cardnumber
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func clearFieldBtn(_ sender: UIButton) {
        delegate?.didClearDestAddressPressed()
        destinationLbl.text = Lang.getString(type: .l_where_r_u_going)
        sender.isHidden = true
        destinationAddressData = nil
        isCorporativeRide = true
        #warning("NEED TO BE CHANGE TO API, Price when air conditioner on")
        UserDefaults.standard.setValue(false, forKey: CONSTANTS.IS_AIR_CONDITIONER_ON)
    }
    @IBAction func changeDestinationAddressBtnPressed(_ sender: UIButton) {
        delegate?.didChangeDestinationAddressPressed()
    }
    
    @IBAction func changeStartAddressPressed(_ sender: UIButton) {
        delegate?.didChangeStartAddressPressed()
    }
    
    @IBAction func finRideBtnPressed(_ sender: Any) {
        createRide(isCorporativeRide: isCorporativeRide)
        
        UserDefaults.standard.setValue("", forKey: CONSTANTS.ORDER_SOMEONE_PHONE_NUMBER)
        #warning("NEED TO BE CHANGE TO API, Price when air conditioner on")
        UserDefaults.standard.setValue(false, forKey: CONSTANTS.IS_AIR_CONDITIONER_ON)
        print("\(selectedCarestimatedAndTotalCost)")
    }
    func setupPreSearchAnimation(){
        self.view.addSubview(preSearchAnimation)
        preSearchAnimation.snp.makeConstraints { (make) in
            make.centerX.equalTo(UIScreen.main.bounds.width / 2)
            make.centerY.equalTo(UIScreen.main.bounds.height / 2).offset(-130)
            make.size.equalTo(350)
        }
        preSearchAnimation.play()
        Cache.savePreSearchAnimation(bool: true)
        
    }
    
    func removePreSearchAnimation() {
        preSearchAnimation.stop()
        preSearchAnimation.removeFromSuperview()
        Cache.savePreSearchAnimation(bool: false)
    }
    
}



//MARK: - Get Data
extension FindCarVC{
    
    private func createRide(isCorporativeRide : Bool){
        if let phone = UserDefaults.standard.string(forKey: CONSTANTS.ORDER_SOMEONE_PHONE_NUMBER){
            if phone.isEmpty {
                rider_phone = ""
            }else{
                rider_phone = phone
            }
        }else{
            rider_phone = ""
        }
        if cardnumber != ""{
            payment_method = "card"
        }else{
            payment_method = "cash"
        }
        
        if rider_phone != ""{
            rider_type = "someone"
        }else{
            rider_type = "self"
        }
        
        //check if selected tarif is delivery then check for destination, if no destination address then open map to select dest address
        //if there is dest address then open DeliverycVC
        
        if estimatedPrice.first?.isPressed ?? false {
            
            if destinationAddressData == nil{
                SimpleAlert.showSimpleAlert(title: Lang.getString(type: .please_choose_dest_address), detail: nil) { (isOk) in
                    if isOk{
                        self.delegate?.didChangeDestinationAddressPressed()
                    }
                }
            }else{
                let vc = DeliveryVC(nibName: "DeliveryVC", bundle: nil)
                vc.modalPresentationStyle = .overFullScreen
                vc.delegate = self
                vc.startAddressData = startAddressData
                vc.destinationAddressData = destinationAddressData
                vc.price = estimatedPrice[0].price
                present(vc, animated: false, completion: nil)
            }
            
            
            
            
        }else{
            self.setupPreSearchAnimation()
            self.preSearchAnimation.play()
            if !isCorporativeRide{
                API.createRide(
                    car_class: selectedCarClass,
                    payment_method: payment_method,
                    card_number: cardnumber,
                    estimated_price: selectedCarestimatedAndTotalCost,
                    total_cost: selectedCarestimatedAndTotalCost,
                    total_distance: selectedCartotalDistance,
                    entrance: entrance,
                    air_conditioner: isAirConditionerEnabled,
                    start_location: [
                        "latitude" : startAddressData?.latitude,
                        "longitude" : startAddressData?.longitude,
                        "location_name" : startAddressData?.name],
                    destination_location: [
                        "latitude" : destinationAddressData?.latitude,
                        "longitude" : destinationAddressData?.longitude,
                        "location_name" : destinationAddressData?.name],
                    ride_pols: ridePols,
                    comment: comment,
                    rider_type: rider_type,
                    rider_phone: rider_phone, order_from: nil, order_to: nil, door_to_door: false)  { (isDone) in
                    if isDone{
                        self.removePreSearchAnimation()
                        self.delegate?.didRideCreated()
                    }else{
                        self.removePreSearchAnimation()
                    }
                }
            }else{
                
                API.createCorporativeRide(
                    air_conditioner: isAirConditionerEnabled,
                    entrance: entrance,
                    comment: comment,
                    car_class_id: selectedCarClass,
                    estimated_price: Double(selectedCarestimatedAndTotalCost).rounded(),
                    payment_method: payment_method,
                    card_number: cardnumber,
                    ride_pols: [],
                    start_location: [
                        "latitude" : startAddressData?.latitude,
                        "longitude" : startAddressData?.longitude,
                        "location_name" : startAddressData?.name],
                    total_cost: Double(selectedCarestimatedAndTotalCost).rounded(),
                    rider_type: rider_type,
                    rider_phone: rider_phone)  { (isDone) in
                    
                    if isDone{
                        self.removePreSearchAnimation()
                        self.delegate?.didRideCreated()
                        
                    }else{
                        self.removePreSearchAnimation()
                    }
                }
            }
        }
    }
}


//MARK: - Payment method delegate

extension FindCarVC : ChoosePaymentDelegate{
    func paymentType(number: String) {
        cardnumber = number
        if cardnumber != ""{
            payment_type_lbl.text = Lang.getString(type: .card)
            cashOrCardBtn.setImage(#imageLiteral(resourceName: "credit_card"), for: .normal)
        }else{
            payment_type_lbl.text = Lang.getString(type: .cash)
            cashOrCardBtn.setImage(#imageLiteral(resourceName: "cash"), for: .normal)
        }
        
    }
    
    
}


//MARK: - Delivery Delegate
extension FindCarVC : DeliveryVCDelegate{
    func orderBtnPressed(order_from_phone_number: String, order_from_name: String, order_from_entrance: String, order_from_apartment: String, order_from_floor: String, order_from_door_phone: String, order_from_comment: String, order_to_phone_number: String, order_to_name: String, order_to_entrance: String, order_to_apartment: String, order_to_floor: String, order_to_door_phone: String, order_to_comments: String, door_to_door : Bool) {
        
        API.createRide(
            car_class: selectedCarClass,
            payment_method: payment_method,
            card_number: cardnumber,
            estimated_price: selectedCarestimatedAndTotalCost,
            total_cost: selectedCarestimatedAndTotalCost,
            total_distance: selectedCartotalDistance,
            entrance: "",
            air_conditioner: isAirConditionerEnabled,
            start_location: [
                "latitude" : startAddressData?.latitude,
                "longitude" : startAddressData?.longitude,
                "location_name" : startAddressData?.name],
            destination_location: [
                "latitude" : destinationAddressData?.latitude,
                "longitude" : destinationAddressData?.longitude,
                "location_name" : destinationAddressData?.name],
            ride_pols: ridePols,
            comment: comment,
            rider_type: rider_type,
            rider_phone: rider_phone,
            order_from: [
                "phone_number" : order_from_phone_number,
                "name" : order_from_name,
                "entrance" : order_from_entrance,
                "apartment" : order_from_apartment,
                "floor" : order_from_floor,
                "door_phone" : order_from_door_phone,
                "comments" : order_from_comment],
            order_to: [
                "phone_number" : order_to_phone_number,
                "name" : order_to_name,
                "entrance" : order_to_entrance,
                "apartment" : order_to_apartment,
                "floor" : order_to_floor,
                "door_phone" : order_to_door_phone,
                "comments" : order_to_comments], door_to_door: door_to_door )  { (isDone) in
            if isDone{
                self.removePreSearchAnimation()
                self.delegate?.didRideCreated()
            }else{
                self.removePreSearchAnimation()
            }
        }
        
        
    }
    
}

//MARK: - CollectionView delegate

extension FindCarVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return estimatedPrice.count == 0 ? 5 : estimatedPrice.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarsCVC.identifier, for: indexPath) as? CarsCVC else {return UICollectionViewCell()}
        if !estimatedPrice.isEmpty{
            
            if estimatedPrice[indexPath.item].isPressed!{
                cell.layer.shadowOpacity = 0.5
                cell.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                cell.layer.shadowOffset = CGSize(width: 0, height: 0)
                cell.layer.shadowRadius = 3
                
                cell.priceLbl.alpha = 1
                cell.carImg.alpha = 1
                cell.category.alpha = 1
                
                
                selectedCarClass = estimatedPrice[indexPath.row]._id
                #warning("NEED TO BE CHANGE TO API, Price when air conditioner on")
//                if UserDefaults.standard.bool(forKey: CONSTANTS.IS_AIR_CONDITIONER_ON){
//                    estimatedPrice[indexPath.row].price += 2000
//                }
                selectedCarestimatedAndTotalCost = estimatedPrice[indexPath.row].price
                selectedCartotalDistance = estimatedPrice[indexPath.row].total_distance ?? 0.0
                
            }else{
                //this makes the rest of cells automatically unselected once data becomes available
                cell.layer.shadowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.priceLbl.alpha = 0.5
                cell.carImg.alpha = 0.5
                cell.category.alpha = 0.5
            }
            
            if destinationAddressData == nil{
                cell.priceLbl.text = "\(Lang.getString(type: .l_from)) \(estimatedPrice[indexPath.item].price) \(Lang.getString(type: .l_sum))"
            }else{
                #warning("NEED TO BE CHANGE TO API, Price when air conditioner on")
//                if UserDefaults.standard.bool(forKey: CONSTANTS.IS_AIR_CONDITIONER_ON){
//                    estimatedPrice[indexPath.row].price += 2000
//                }
                cell.priceLbl.text = "\(estimatedPrice[indexPath.item].price) \(Lang.getString(type: .l_sum))"
            }
            
            cell.chaqmoqImgView.isHidden = !estimatedPrice[indexPath.row].is_lightning
            cell.category.text = estimatedPrice[indexPath.item].name
            cell.carImg.sd_setImage(with: URL(string: API.baseURL + estimatedPrice[indexPath.row].image))
            
        }
        cell.skeletonView.isHidden = !estimatedPrice.isEmpty
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !estimatedPrice.isEmpty{
            if estimatedPrice[indexPath.row].isPressed!{
                let vc = AboutTariffVC(nibName: "AboutTariffVC", bundle: nil)
                vc.modalPresentationStyle = .overFullScreen
                vc.imgUrl = "\(estimatedPrice[indexPath.row].image)"
                vc.ttle = "\(estimatedPrice[indexPath.row].name)"
                vc.start_price = "\(estimatedPrice[indexPath.row].starting_value)"
                vc.per_km_value = "\(estimatedPrice[indexPath.row].per_km_value)"
                vc.waiting_time = "\(estimatedPrice[indexPath.row].waiting_time)"
                vc.per_minute = "\(estimatedPrice[indexPath.row].per_minute_value)"
                self.present(vc, animated: false, completion: nil)
            }else{
                for i in 0..<estimatedPrice.count{
                    estimatedPrice[i].isPressed = false
                    
                }
                estimatedPrice[indexPath.item].isPressed = !(estimatedPrice[indexPath.item].isPressed ?? false)
                if indexPath.row == 0{
                    //delivery cell is first item of collectionview
                    is_delivery = true
                }else{
                    is_delivery = false
                }
                collectionView.reloadData()
            }
        }
        
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height + 30, height: collectionView.frame.height - 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
}


