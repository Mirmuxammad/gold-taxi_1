//
//  MainViewController.swift
//  TAXI
//
//  Created by iMac_DM on 2/28/21.
//

import UIKit
import YandexMapsMobile
import Lottie
import CoreLocation

var chatData : [ChatDM] = []


class MainViewController: UIViewController {
    
    enum ChildrenState {
        case firstLocation
        case findCars //Once you click next from firstLocation
        case confirmAddress
    }
    
    
    
    
    //MARK: - Children
    private lazy var searchViewController: SearchVC = SearchVC(nibName: "SearchVC", bundle: nil)
    private lazy var firstLocationVC: FirstLocationVC = FirstLocationVC(delegate: self)
    private lazy var confirmAddressVC: ConfirmAddressVC = ConfirmAddressVC(nibName: "ConfirmAddressVC", bundle: nil)
    private lazy var findCarVC: FindCarVC = FindCarVC(nibName: "FindCarVC", bundle: nil)
    private lazy var lookingForCars : LookingForCarsVC = LookingForCarsVC(nibName: "LookingForCarsVC", bundle: nil)
    private lazy var arrivingVC = ArrivingDriverVC(nibName: "ArrivingDriverVC", bundle: nil)
    
    //MARK: VC
    private lazy var chatVC = ChatVC()
    ///Yandex map declarations
    let mapKit = YMKMapKit.sharedInstance()
    lazy var mapView: YMKMapView = {
        let m = YMKMapView(frame: self.view.frame)
        return m
    }()
    var drivingSession: YMKDrivingSession?
    
    ///CoreLocation declaration
    var locationManager: LocationManager = LocationManager()
    
    
    var currentUserPlaceMark: YMKPlacemarkMapObject?
    var userCurrentLocation: LocationDM? {
        didSet {
            guard let loc = userCurrentLocation else {return}
            guard let mark = currentUserPlaceMark else {
                addCurrentUserPlaceMark()
                return;
            }
            mark.geometry = YMKPoint(latitude: loc.latitude, longitude: loc.longitude)
            mark.direction = Float(loc.course)
        }
    }
    
    var userCurrentLocationData: AddressDM?
    
    
    
    
    ///Menu button
    private lazy var menuBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        btn.setImage(UIImage(named: "menu"), for: .normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        btn.layer.cornerRadius = 10
        btn.layer.shadowRadius = 2
        btn.layer.shadowOffset = CGSize(width: 0, height: 0)
        btn.layer.shadowOpacity = 0.5
        btn.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4602947624)
        
        btn.snp.makeConstraints { (make) in
            make.size.equalTo(40)
        }
        
        btn.addTarget(self, action: #selector(menuPressed(_:)), for: .touchUpInside)
        return btn
        
    }()
    
    ///Top title for current location
    private lazy var currentLocationTitleLbl : UILabel = {
        let l = UILabel()
        l.text = Lang.getString(type: .l_top_label_in_main_view)
        l.font = UIFont(name: "poppins-regular", size: 13)
        l.textAlignment = .center
        l.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.761947528)
        
        return l
    }()
    
    ///Top subtitle for current location
    private lazy var currentLocationSubtitleLbl : UILabel = {
        let l = UILabel()
        l.text = Lang.getString(type: .l_top_subtitle_main_view)
        l.font = UIFont(name: "poppins-semibold", size: 15)
        l.numberOfLines = 3
        l.textAlignment = .center
        l.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        l.translatesAutoresizingMaskIntoConstraints = false
        l.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.65).isActive = true
        
        return l
    }()
    
    
    
    /// Title inside center pin
    var lblForCenterPin: UILabel = {
        let l = UILabel()
        l.text = "5 min"
        l.numberOfLines = 2
        l.textAlignment = .center
        l.textColor = .white
        l.backgroundColor = #colorLiteral(red: 0.1724541485, green: 0.1726643741, blue: 0.163882494, alpha: 1)
        l.font = UIFont(name: "poppins-semibold", size: 10)
        return l
    }()
    
    /// Pin for center location
    var centerPin: AnimationView = {
        let v = AnimationView(name: "pin")
        v.isUserInteractionEnabled = false
        v.play()
        return v
    }()
    
    ///lottie, pin in center of screen
    var searchingAnimation: AnimationView = {
        let v = AnimationView(name: "searching_anim")
        v.play(fromFrame: 0, toFrame: 180, loopMode: .loop, completion: nil)
        v.isUserInteractionEnabled = true
        
        return v
    }()
    
    
    var no_network_connectionView : UIView = {
        let v = UIView()
        let subView = UIView()
        v.addSubview(subView)
        subView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(100)
        }
        subView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        
        let label = UILabel()
        
        label.text = Lang.getString(type: .no_internet_connection)
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        subView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        
        return v
        
    }()
    
    
    //MARK: - Data
    var rideHistoryData: [RideHistoryDM] = []
    
    ///this turns to true only when change destination address button was pressed from find car vc,
    var isFromFindCarVC : Bool = false
    var startAddress : AddressDM?
    var destination : AddressDM?
    var nearCarsData : [NearCarsDM] = []
    var rideFullInfo : RideFullInfo!
    var isChatViewActive = false
    var isLookingForCarsViewActive = false
    var incomingMessageCount = 0
    var total_page_count = 0
    var current_page = 1
    
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        //1
        setupYandexMap()
        setupInitialViews()
        getRideHistoryData()
        
        MySocket.default.openConnection()
        MySocket.default.socketDelegate = self
        
        
        setupNotifications()
        setupNetworkObserver()
        checkForApplicationTerminatedState()
        
        
        
    }
    
    
    //MARK: - VIEW WILL APPEAR
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Cache.isRoutesSaved(){
            #warning("NEED TO BE CHANGE TO API, Price when air conditioner on")
            
            UserDefaults.standard.setValue(false, forKey: CONSTANTS.IS_AIR_CONDITIONER_ON)
            
            
            startAddress = try! UserDefaults.standard.get(objectType: AddressDM.self, forKey: CONSTANTS.START_ADDRESS_DATA)
            destination = try! UserDefaults.standard.get(objectType: AddressDM.self, forKey: CONSTANTS.DESTINATION_ADDRESS_DATA)
            moveFirstLocationViewFor(state: .hide)
            self.firstLocationVC.isThisViewActive = false
            showFindCarsVC(startAddress: startAddress!, destAddress: destination)
            zoomOutToFitTwoPoints()
        }else{
            zoomToCurrentLocation()
        }
        
        //self.moveFirstLocationViewFor(state: self.firstLocationVC.lastValidState)
    }
    
    
}


//MARK: - Initial Setups
extension MainViewController {
    
    private func setupInitialViews() {
        navigationController?.navigationBar.isHidden = true
        self.view.addSubview(menuBtn)
        menuBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(20)
        }
        
        self.view.addSubview(currentLocationTitleLbl)
        currentLocationTitleLbl.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(self.view)
        }
        
        self.view.addSubview(currentLocationSubtitleLbl)
        currentLocationSubtitleLbl.snp.makeConstraints { (make) in
            make.top.equalTo(currentLocationTitleLbl.snp.bottom).offset(5)
            make.centerX.equalTo(self.view)
        }
        
        setupChildren()
        setupCenterPin()
        setupUIEdgeGesture()
        //setupNetworkObserver()
    }
    
    
    //MARK: - Center Pin
    private func setupCenterPin() {
        
        self.view.addSubview(centerPin)
        self.centerPin.addSubview(lblForCenterPin)
        
        centerPin.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-40)
            make.size.equalTo(300)
        }
        
        
        lblForCenterPin.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(self.centerPin.frame.width/10)
            
        }
        
        
    }
    
    private func handleCenterPinAnimation(finishedDragging: Bool){
        if self.firstLocationVC.isThisViewActive || self.confirmAddressVC.isThisViewActive {
            
            self.currentLocationSubtitleLbl.isHidden = false
            self.currentLocationTitleLbl.isHidden = false
            self.centerPin.isHidden = false
            
            if !finishedDragging {
                //when touches begin with map animates and tries to hide firstlocationview
                self.currentLocationSubtitleLbl.text = Lang.getString(type: .l_top_subtitle_main_view)
                self.lblForCenterPin.alpha = 0
                self.centerPin.play(fromFrame: 15, toFrame: 75, loopMode: .loop, completion: nil)
            } else {
                self.centerPin.play(fromFrame: 100, toFrame: 180, loopMode: .playOnce) { (_) in
                    UIView.animate(withDuration: 0.3) {
                        self.lblForCenterPin.alpha = 1
                        
                    }
                }
                
            }
        } else {
            self.currentLocationSubtitleLbl.isHidden = true
            self.currentLocationTitleLbl.isHidden = true
            self.centerPin.isHidden = true
        }
    }
    
    /// Updates Current Location Name when pinner dropped to some location
    private func updateLocationTitles(address: String) {
        if self.firstLocationVC.isThisViewActive || self.confirmAddressVC.isThisViewActive {
            self.currentLocationSubtitleLbl.isHidden = false
            self.currentLocationTitleLbl.isHidden = false
            self.centerPin.isHidden = false
        } else {
            self.currentLocationSubtitleLbl.isHidden = true
            self.currentLocationTitleLbl.isHidden = true
            self.centerPin.isHidden = true
        }
        self.currentLocationTitleLbl.text = Lang.getString(type: .l_top_label_in_main_view)
        self.currentLocationSubtitleLbl.text = address//address.name
    }
    
    private func setupUIEdgeGesture(){
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
    }
    
    
    private func setupNotifications() {
        
        ///Message notification
        MessageNotification.createMessageObservers { (chatdm) in
            chatData.append(chatdm)
            if !self.isChatViewActive{
                self.incomingMessageCount += 1
                self.arrivingVC.badgeView.isHidden = self.incomingMessageCount == 0 ? true : false
                self.arrivingVC.numInBadgeViewLbl.text = "\(self.incomingMessageCount)"
            }
            
        }
        
        ///Application state notification
        NotificationCenter.default.addObserver(self, selector: #selector(appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appEnteredBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        ///Language notification
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabels), name: Notification.Name(rawValue: CONSTANTS.LANGUAGE_NOTIFICATION), object: nil)
        
    }
    
    
    func setupNetworkObserver(){
        self.no_network_connectionView.transform = CGAffineTransform.init(translationX: 0, y: 0)
        self.view.addSubview(self.no_network_connectionView)
        self.no_network_connectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.no_network_connectionView.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 0.0541895178)
        self.no_network_connectionView.isHidden = true
        self.view.bringSubviewToFront(self.no_network_connectionView)
        var shouldReloadRideHistoryData = false
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            if !Reachability.isConnectedToNetwork() {
                UIView.animate(withDuration: 0.2) {
                    self.no_network_connectionView.transform = .identity
                    self.no_network_connectionView.isHidden = false
                }
                shouldReloadRideHistoryData = true
            }else {
                
                UIView.animate(withDuration: 0.2) {
                    self.no_network_connectionView.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.no_network_connectionView.isHidden = true
                }
                if shouldReloadRideHistoryData{
                    self.getRideHistoryData()
                    shouldReloadRideHistoryData = false
                }
            }
            
        }
    }
    
}





//MARK: - Actions
extension MainViewController {
    
    @objc private func menuPressed(_ sender: UIButton) {
        let menuVC = MenuVC(nibName: "MenuVC", bundle: nil)
        let navVC = UINavigationController(rootViewController: menuVC)
        navVC.modalPresentationStyle = .overCurrentContext
        self.present(navVC, animated: false, completion: nil)
    }
    
    @objc private func screenEdgeSwiped() {
        let menuVC = MenuVC(nibName: "MenuVC", bundle: nil)
        let navVC = UINavigationController(rootViewController: menuVC)
        navVC.modalPresentationStyle = .overCurrentContext
        self.present(navVC, animated: false, completion: nil)
    }
    
    
    @objc func appBecomeActive() {
        if Cache.isSearchAnimationSaved(){
            self.setupSearchingAnimation()
            self.playSearchAnimation()
        }else{
            stopSearchAnimation()
            if Cache.isPreCancelledAnimationSaved(){
                PreCancelAlert.xAnimation.play()
            }
        }
        
        if let ride_id = Cache.getLastOrderID(){
            getFullRideInfo {
                if ride_id == self.rideFullInfo._id{
                    MySocket.default.listenSocket(for: ride_id)
                    self.centerPin.isHidden = true
                    self.currentLocationTitleLbl.isHidden = true
                    self.currentLocationSubtitleLbl.isHidden = true
                    self.currentUserPlaceMark?.opacity = 0
                    self.firstLocationVC.isThisViewActive = false
                    
                    switch self.rideFullInfo.state {
                    case "ordered":
                        self.didOrdered()
                    case "waitingRider":
                        self.didWaitingRider()
                    case "waitingDriver":
                        self.hideLookingForCarsVC {
                            self.didWaitingRiderState {
                                self.didWaitingRiderState()
                            }
                        }
                    case "in_progress", "waiting":
                        self.hideLookingForCarsVC {
                            self.didWaitingRiderState {
                                self.didInProgressState()
                            }
                        }
                        
                    case "finished":
                        self.hideLookingForCarsVC {
                            self.didFinishedState()
                        }
                    case "canceled":
                        self.hideLookingForCarsVC {
                            self.didCancelled()
                        }
                    case "pre_cancelled":
                        break
                        
                    default:
                        break
                    }
                }
                
            }
            
            
        }
        
        
        
    }
    
    @objc func appEnteredBackground() {
        locationManager.stopUpdatingUserCurrentLocation()
    }
    
    @objc func updateLabels() {
        currentLocationTitleLbl.text = Lang.getString(type: .l_top_label_in_main_view)
        currentLocationSubtitleLbl.text = Lang.getString(type: .l_top_subtitle_main_view)
    }
    
    
    func getNearCarsArrivingTime(lat: Double, lon: Double) {
        API.getNearCars(location_name: "", long: lon, lat: lat) { (data) in
            guard let data = data else{return}
            
            if !data.isEmpty{
                let p1 = CLLocation(latitude: data.first!.latitude, longitude: data.first!.longitude )
                let p2 = CLLocation(latitude: lat, longitude: lon)
                let distance = p2.distance(from: p1)
                
                let distanceInKM = distance / 1000
                var time = ((distanceInKM / 50) * 60)
                if time < 1 {
                    time = 1
                }
                self.lblForCenterPin.text = "\(Int(time)) \(Lang.getString(type: .mins))"
                
                Yandex.clearNearCarObjects(from: self.mapView.mapWindow.map)
                
                for i in data {
                    Yandex.addPoint(for: AddressDM(name: "", fullName: "", longitude: i.longitude, latitude: i.latitude) , to: self.mapView.mapWindow.map, type: .near_car, bearing: Double.random(in: 1...50))
                }
            }
            
        }
    }
    
    func getDriversArrivingTime(lat: Double, lon: Double, speed: Double) -> String{
        var speed = speed
        var time = 1.0
        getFullRideInfo {
            let p1 = CLLocation(latitude: self.rideFullInfo.start_location.latitude, longitude: self.rideFullInfo.start_location.longitude )
            let p2 = CLLocation(latitude: lat, longitude: lon)
            let distance = p2.distance(from: p1)
            
            let distanceInKM = distance / 1000
            if speed < 5 {
                speed = 35
            }
            time = ((distanceInKM / speed) * 60)
            if time < 1 {
                time = 1
            }
            
        }
        return "\(Int(time))"
        
        
    }
    
    //if application was terminated when order is not finished
    //then qayta tikledi orderni state bo'yicha
    func checkForApplicationTerminatedState(){
        if UserDefaults.standard.bool(forKey: CONSTANTS.IS_APP_TERMINATED){
            Cache.saveRoutes(bool: false)
            UserDefaults.standard.setValue(false, forKey: CONSTANTS.IS_APP_TERMINATED)
            if let ride_id = Cache.getLastOrderID(){
                getFullRideInfo {
                    if ride_id == self.rideFullInfo._id{
                        MySocket.default.listenSocket(for: ride_id)
                        self.centerPin.isHidden = true
                        self.currentLocationTitleLbl.isHidden = true
                        self.currentLocationSubtitleLbl.isHidden = true
                        self.currentUserPlaceMark?.opacity = 0
                        self.firstLocationVC.isThisViewActive = false
                        
                        switch self.rideFullInfo.state {
                        case "ordered":
                            self.didOrdered()
                        case "waitingRider":
                            self.didWaitingRiderState()
                        case "waitingDriver":
                            self.hideLookingForCarsVC {
                                self.didWaitingRiderState {
                                    self.didWaitingDriverState()
                                }
                            }
                        case "in_progress", "waiting":
                            self.hideLookingForCarsVC {
                                self.didWaitingRiderState {
                                    self.didInProgress()
                                }
                            }
                            
                        case "finished":
                            self.hideLookingForCarsVC {
                                self.stopSearchAnimation()
                                self.didFinished()
                            }
                        case "canceled":
                            self.hideLookingForCarsVC {
                                self.didCancelled()
                            }
                        case "pre_cancelled":
                            break
                            
                        default:
                            break
                        }
                    }
                    
                }
            }
            
        }
    }
    
}


//MARK: - SETUP ANIMATIONS
extension MainViewController{
    
    //MARK: - Searching Animation
    private func setupSearchingAnimation(){
        self.view.addSubview(searchingAnimation)
        searchingAnimation.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
            make.size.equalTo(500)
        }
        
        self.view.bringSubviewToFront(self.lookingForCars.view)
    }
    
    private func playSearchAnimation() {
        searchingAnimation.play()
        Cache.saveSearchAnimation(bool: true)
    }
    
    private func stopSearchAnimation() {
        searchingAnimation.stop()
        searchingAnimation.removeFromSuperview()
        Cache.saveSearchAnimation(bool: false)
    }
    
}




//MARK: - CHILDRENS ----------------
extension MainViewController {
    
    private func setupChildren() {
        setUpSearchController()
        setUpFirstLocationView()
        setUpConfirmAddressVC()
        setUpFindCarVC()
        setUpLookingForCarsVC()
        setUpArrivingVC()
    }
}


//MARK: - SEARCH VC
extension MainViewController: SearchVCDelegate {
    
    private func setUpSearchController() {
        searchViewController.delegate = self
        add(searchViewController)
        guard let v = searchViewController.view else {return}
        v.transform =  CGAffineTransform(translationX: 0, y: self.view.frame.height)
        v.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        self.view.bringSubviewToFront(v)
    }
    
    private func showSearchViewController(firstTime: Bool, shouldStartAddressFieldBecomeFirstResponder: Bool = false) {
        
        self.centerPin.isHidden = true
        self.currentUserPlaceMark?.opacity = 0
        self.searchViewController.userLocation = userCurrentLocationData
        self.moveFirstLocationViewFor(state: .hide) {
            if firstTime {
                self.searchViewController.startAddress = self.userCurrentLocationData
            }else{
                self.searchViewController.startAddress = self.startAddress
                
            }
            if shouldStartAddressFieldBecomeFirstResponder{
                self.searchViewController.firstTF.becomeFirstResponder()
            }else{
                self.searchViewController.secondTF.becomeFirstResponder()
            }
            UIView.animate(withDuration: .cardDefaultTransitionTime) {
                self.searchViewController.view.transform = .init(translationX: 0, y: 0)
            }
        }
        self.firstLocationVC.isThisViewActive = false
        
    }
    
    private func hideSearchViewController(completion: (()->Void)? = nil) {
        self.view.endEditing(true)
        UIView.animate(withDuration: .cardDefaultTransitionTime) {
            self.searchViewController.view.transform = .init(translationX: 0, y: UIScreen.main.bounds.height)
        } completion: { (_) in
            completion?()
        }
    }
    
    
    func didAddressSelected(startLocation: AddressDM?, destinationLocation: AddressDM) {
        Yandex.clearPlacemark(from: self.mapView.mapWindow.map, shouldKeepStartPoint: false)
        hideSearchViewController()
        self.startAddress = startLocation
        self.destination = destinationLocation
        showFindCarsVC(startAddress: self.startAddress!, destAddress: self.destination)
        
        zoomOutToFitTwoPoints()
        
    }
    
    func didMapBtnPressed(forStartLocation: Bool) {
        hideSearchViewController {
            self.confirmAddressVC.forStartLocation = forStartLocation
            if self.isFromFindCarVC{
                //mobodo destination ni tanlamasdan nextni bosib keyn destinationni tanlamoqchi bo'lsa otvormasligi uchun.
                if !forStartLocation{
                    if let destination = self.destination{
                        self.mapView.mapWindow.map.move(
                            with: YMKCameraPosition(target: YMKPoint(latitude: destination.latitude, longitude: destination.longitude) , zoom: 18, azimuth: 0, tilt: 0),
                            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1.5),
                            cameraCallback: nil)
                    }
                    
                }else{
                    if let start = self.startAddress{
                        self.mapView.mapWindow.map.move(
                            with: YMKCameraPosition(target: YMKPoint(latitude: start.latitude, longitude: start.longitude) , zoom: 18, azimuth: 0, tilt: 0),
                            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1.5),
                            cameraCallback: nil)
                    }
                    
                }
                
                
            }else{
                self.moveFirstLocationViewFor(state: .hide) {
                    self.confirmAddressVC.choosenAddress = self.userCurrentLocationData
                    
                }}
            self.showConfirmAddressVC(completion: nil)
            
        }
        
    }
    
    func didSearchVCDismissed() {
        
        hideSearchViewController {
            if self.isFromFindCarVC{
                Yandex.clearPlacemark(from: self.mapView.mapWindow.map, shouldKeepStartPoint: false)
                self.showFindCarsVC(startAddress: self.startAddress! , destAddress: self.destination)
                self.isFromFindCarVC = false
            }else{
                self.currentUserPlaceMark?.opacity = 1
                self.firstLocationVC.isThisViewActive = true
                self.moveFirstLocationViewFor(state: self.firstLocationVC.lastValidState)
                
            }
        }
        
    }
    
    func didTellTheDriverPressed() {
        hideSearchViewController {
            Yandex.clearPlacemark(from: self.mapView.mapWindow.map, shouldKeepStartPoint: false)
            
            if self.isFromFindCarVC{
                self.showFindCarsVC(startAddress: self.startAddress ?? AddressDM(name: "", fullName: "", longitude: 0.0, latitude: 0.0), destAddress: nil)
                
            }else{
                self.showFindCarsVC(startAddress: self.userCurrentLocationData ?? AddressDM(name: "", fullName: "", longitude: 0.0, latitude: 0.0), destAddress: nil)
            }
        }
    }
}



//MARK: - FirstLocation VC
extension MainViewController: FirstLocationVCDelegate {
    
    
    func setUpFirstLocationView() {
        add(firstLocationVC)
        guard let v = firstLocationVC.view else {return}
        v.transform =  CGAffineTransform(translationX: 0, y: self.view.frame.height)
        v.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(view.frame.height)
            make.bottom.equalToSuperview()
        }
        
        moveFirstLocationViewFor(state: .low, saveLastState: true)
        
        
    }
    
    private func moveFirstLocationViewFor(state: FirstLocationVC.PositionState, saveLastState: Bool = false, completion: (()->Void)? = nil) {
        
        if !self.firstLocationVC.isThisViewActive {completion?(); return}
        if saveLastState {self.firstLocationVC.lastValidState = state}
        guard let v = firstLocationVC.view else {return}
        var transform: CGAffineTransform!
        
        switch state {
        case .full:
            transform = CGAffineTransform(translationX: 0, y: self.view.frame.height - FirstLocationVC.topVisibleBarHeigh - (firstLocationVC.collectionView.frame.width/3)*2)
            
        case .middle:
            transform = CGAffineTransform(translationX: 0, y: self.view.frame.height - FirstLocationVC.topVisibleBarHeigh - firstLocationVC.collectionView.frame.width/3 - 15)
            
        case .low:
            transform = CGAffineTransform(translationX: 0, y: self.view.frame.height - FirstLocationVC.topVisibleBarHeigh - 30)
            
        case .lowest:
            transform = CGAffineTransform(translationX: 0, y: self.view.frame.height - 70)
        case .hide:
            transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        }
        
        UIView.animate(withDuration: 0.3) {
            v.transform = transform
        } completion: { (_) in
            self.menuBtn.isHidden = false
            completion?()
        }
        
        
    }
    
    
    
    // Delegate methods
    func whereBtnPressed() {
        showSearchViewController(firstTime: true)
    }
    
    func nextBtnPressed() {
        //
        moveFirstLocationViewFor(state: .hide) {
            if let userLocData = self.userCurrentLocationData{
                self.firstLocationVC.isThisViewActive = false
                self.startAddress = userLocData
                self.showFindCarsVC(startAddress: userLocData, destAddress: nil, completion: nil)
                
            }
            
        }
        
        
    }
    
    func gpsBtnPressed() {
        //1.detects the user location
        self.locationManager.getUserCurrentLocation(fromVC: self) { (location) in
            self.userCurrentLocation = location
        }
        //2.zooms in to current user location
        self.zoomToCurrentLocation()
        
    }
    
    func didRideHistoryCellPressed(rideHistory: RideHistoryDM) {
        let destination = AddressDM(name: rideHistory.location_name , fullName: "", longitude: Double(rideHistory.lon)!, latitude: Double(rideHistory.lat)!)
        self.startAddress = userCurrentLocationData
        self.destination = destination
        moveFirstLocationViewFor(state: .hide, saveLastState: false) {
            self.showFindCarsVC(startAddress: self.userCurrentLocationData ?? AddressDM(name: "", fullName: "", longitude: self.userCurrentLocation!.longitude, latitude: self.userCurrentLocation!.latitude), destAddress: destination)
            self.firstLocationVC.isThisViewActive = false
            
        }
        zoomOutToFitTwoPoints()
    }
    
}


//MARK: - ConfirmAddress VC

extension MainViewController: ConfirmAddressVCDelegate {
    
    private func setUpConfirmAddressVC() {
        self.confirmAddressVC.delegate = self
        self.add(self.confirmAddressVC)
        self.confirmAddressVC.view.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview()
        }
        self.confirmAddressVC.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
    }
    
    
    private func showConfirmAddressVC(completion: (()->Void)?) {
        self.firstLocationVC.isThisViewActive = false
        self.confirmAddressVC.isThisViewActive = true
        UIView.animate(withDuration: TimeInterval.cardDefaultTransitionTime) {
            self.confirmAddressVC.view.transform = .init(translationX: 0, y: self.view.frame.height-ConfirmAddressVC.cardViewHeight)
        } completion: { (_) in
            completion?()
        }
        
    }
    
    private func hideConfirmAddressVC(temporary: Bool, completion: (()->Void)?) {
        if self.confirmAddressVC.isThisViewActive {
            if !temporary {self.confirmAddressVC.isThisViewActive = false}
            UIView.animate(withDuration: 0.3) {
                self.confirmAddressVC.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
            } completion: { (_) in
                self.confirmAddressVC.choosenAddress = nil
                completion?()
            }
        }
        
        
    }
    
    
    
    func donePressed() {
        if let choosen = self.confirmAddressVC.choosenAddress {
            if self.confirmAddressVC.forStartLocation {
                self.searchViewController.startAddress = choosen
            } else {
                self.searchViewController.destinationAddress = choosen
            }
        }
        
        
        if let startLoc = self.searchViewController.startAddress, let destLoc = self.searchViewController.destinationAddress {
            //TODO:  Open Car Searching VC
            hideConfirmAddressVC(temporary: false) {
                if self.isFromFindCarVC{
                    Yandex.clearPlacemark(from: self.mapView.mapWindow.map, shouldKeepStartPoint: false)
                }
                self.startAddress = startLoc
                self.destination = destLoc
                self.showFindCarsVC(startAddress: startLoc, destAddress: destLoc, completion: nil)
                self.firstLocationVC.isThisViewActive = false
                self.zoomOutToFitTwoPoints()
            }
            
        } else {
            hideConfirmAddressVC(temporary: false) {
                self.showSearchViewController(firstTime: false)
            }
        }
    }
    
    func backPressed() {
        hideConfirmAddressVC(temporary: false) {
            self.showSearchViewController(firstTime: false)
        }
    }
    
    
}

//MARK: - FIND CAR VC
extension MainViewController: FindCarDelegate {
    
    
    
    private func setUpFindCarVC() {
        self.add(self.findCarVC)
        self.findCarVC.delegate = self
        self.findCarVC.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        self.findCarVC.view.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func showFindCarsVC(startAddress: AddressDM, destAddress: AddressDM?, completion: (()->Void)? = nil) {
        
        self.centerPin.isHidden = true
        self.currentLocationTitleLbl.isHidden = true
        self.currentLocationSubtitleLbl.isHidden = true
        self.menuBtn.isHidden = true
        self.currentUserPlaceMark?.opacity = 0
        self.findCarVC.startAddressData = startAddress
        self.findCarVC.destinationAddressData = destAddress
        self.findCarVC.currentLocationLbl.text = startAddress.name
        self.findCarVC.destinationLbl.text = destAddress?.name ?? Lang.getString(type: .l_where_r_u_going)
        self.findCarVC.clearDestAddressBtn.isHidden = false
        self.findCarVC.estimatedPrice = []
        self.findCarVC.isCorporativeRide = true
        if self.findCarVC.cardnumber != ""{
            self.findCarVC.payment_type_lbl.text = Lang.getString(type: .card)
            self.findCarVC.cashOrCardBtn.setImage(#imageLiteral(resourceName: "credit_card"), for: .normal)
        }else{
            self.findCarVC.payment_type_lbl.text = Lang.getString(type: .cash)
            self.findCarVC.cashOrCardBtn.setImage(#imageLiteral(resourceName: "cash"), for: .normal)
        }
        UIView.animate(withDuration: .cardDefaultTransitionTime) {
            if UIScreen.main.bounds.height > 750{
                //greater than 8plus device
                self.findCarVC.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height -  self.findCarVC.cardHeight)
            }else{
                //smaller than 8plus including 8plus
                self.findCarVC.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height -  (self.findCarVC.cardHeight - 15))
            }
            
        } completion: { (_) in
            completion?()
        }
        
        Yandex.addPoint(for: startAddress, to: mapView.mapWindow.map, type: .startLocation)
        
        if let dest = destAddress {
            // Ikkisi ham bor
            Yandex.addPoint(for: dest, to: mapView.mapWindow.map, type: .destinationLocation)
            Yandex.drawRoute(startLocation: startAddress, destinationLocation: dest, to: mapView.mapWindow.map) { (ride_polls) in
                guard let ride_polls = ride_polls else {return}
                self.getEstimatedPrices(start: startAddress, dest: dest, ridePolls: ride_polls)
                self.findCarVC.isCorporativeRide = false
                
                do{
                    try UserDefaults.standard.set(object: startAddress, forKey: CONSTANTS.START_ADDRESS_DATA)
                    try UserDefaults.standard.set(object: dest, forKey: CONSTANTS.DESTINATION_ADDRESS_DATA)
                }catch{}
                
                //saves the route and points
                Cache.saveRoutes(bool: true)
                
            } session: { (session) in
                self.drivingSession = session
            }
            
            
        } else {
            // One way
            self.getEstimatedPriceFrom()
            self.findCarVC.clearDestAddressBtn.isHidden = true
            
            
            //saves the route and pointrues
            Cache.saveRoutes(bool: false)
            
        }
        
        
    }
    
    private func hideFindCarVC(completion: (()->Void)? = nil) {
        UIView.animate(withDuration: .cardDefaultTransitionTime) {
            self.findCarVC.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
            
            
        } completion: { (_) in
            completion?()
        }
    }
    
    
    func didBackBtnPressed() {
        isFromFindCarVC = false
        hideFindCarVC {
            self.firstLocationVC.isThisViewActive = true
            self.moveFirstLocationViewFor(state: self.firstLocationVC.lastValidState)
            Yandex.clearPlacemark(from: self.mapView.mapWindow.map, shouldKeepStartPoint: false)
        }
        self.destination = nil
        self.centerPin.isHidden = false
        self.currentLocationSubtitleLbl.isHidden = false
        self.currentLocationTitleLbl.isHidden = false
        self.zoomToCurrentLocation()
        self.currentUserPlaceMark?.opacity = 1
        Cache.saveRoutes(bool: false)
        
    }
    
    
    func didRideCreated() {
        isFromFindCarVC = false
        self.centerPin.isHidden = true
        self.currentLocationTitleLbl.isHidden = true
        self.currentLocationSubtitleLbl.isHidden = true
        firstLocationVC.isThisViewActive = false
        self.hideFindCarVC {
            self.setupSearchingAnimation()
            self.playSearchAnimation()
            self.showLookingForCarsVC()
            self.getFullRideInfo {
                Cache.saveLastOrderID(id: self.rideFullInfo._id)
            }
        }
        
        
        
        self.getNearCars { (nearcars) in
            for i in nearcars{
                Yandex.addPoint(for: AddressDM(name: "", fullName: "", longitude: i.longitude, latitude: i.latitude) , to: self.mapView.mapWindow.map, type: .near_car)
            }
        }
        
        //zooming to start location
        zoomToStartLocationAndZoomOut(isWaitingRider_state: false)
        
        
    }
    
    func didClearDestAddressPressed() {
        Yandex.clearPlacemark(from: self.mapView.mapWindow.map, shouldKeepStartPoint: true)
        self.getEstimatedPriceFrom()
    }
    
    func didChangeDestinationAddressPressed() {
        isFromFindCarVC = true
        startAddress = self.findCarVC.startAddressData
        destination = self.findCarVC.destinationAddressData
        self.hideFindCarVC {
            if self.isFromFindCarVC{
                self.showSearchViewController(firstTime: false)
            }
        }
    }
    
    func didChangeStartAddressPressed() {
        isFromFindCarVC = true
        startAddress = self.findCarVC.startAddressData
        destination = self.findCarVC.destinationAddressData
        self.hideFindCarVC {
            if self.isFromFindCarVC{
                self.showSearchViewController(firstTime: false, shouldStartAddressFieldBecomeFirstResponder: true)
            }
        }
    }
}


//MARK: - Look for Cars VC
extension MainViewController: LookingForCarsVCDelegate{
    
    private func setUpLookingForCarsVC(){
        self.add(self.lookingForCars)
        self.lookingForCars.delegate = self
        self.lookingForCars.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        self.lookingForCars.view.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func showLookingForCarsVC() {
        self.isLookingForCarsViewActive = true
        UIView.animate(withDuration: 0.5) {
            self.lookingForCars.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height - self.lookingForCars.cardViewHeight)
            
        }
        self.setupSearchingAnimation()
        self.playSearchAnimation()
    }
    
    private func hideLookingForCarsVC(completion: (() -> Void)? = nil) {
        self.isLookingForCarsViewActive = false
        UIView.animate(withDuration: 0.5) {
            self.lookingForCars.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        } completion: { (_) in
            self.stopSearchAnimation()
            completion?()
        }
        
    }
    
    
    func didOrderCancelled() {
        //
        SimpleAlert.showSimpleAlert(title: Lang.getString(type: .a_simple_alert_title), detail: Lang.getString(type: .a_simple_alert_desc)) { (yes) in
            if yes{
                self.cancelRide(ride_id: self.rideFullInfo._id) { (isDone) in
                    if isDone{
                        Yandex.clearNearCarObjects(from: self.mapView.mapWindow.map)
                        Yandex.clearPlacemark(from: self.mapView.mapWindow.map, shouldKeepStartPoint: false)
                        self.hideLookingForCarsVC {
                            self.firstLocationVC.isThisViewActive = true
                            self.moveFirstLocationViewFor(state: self.firstLocationVC.lastValidState)
                            self.stopSearchAnimation()
                            self.currentLocationSubtitleLbl.isHidden = false
                            self.currentLocationTitleLbl.isHidden = false
                            self.centerPin.isHidden = false
                            self.currentUserPlaceMark?.opacity = 1
                        }
                    }
                }
            }
        }
        
    }
    
    
}




//MARK: - ARRIVING DRIVER VC
extension MainViewController: ArrivedVCDelegate{
    
    
    
    
    
    
    private func setUpArrivingVC() {
        self.add(arrivingVC)
        self.arrivingVC.delegate = self
        self.arrivingVC.iamcomingView.isHidden = true
        self.arrivingVC.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        
        self.arrivingVC.view.snp.makeConstraints { (make) in
            make.right.left.bottom.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    private func updateLabelArrivingVC() {
        
        API.getFullRideInfo { (d) in
            self.rideFullInfo = d
            let destination_lbl = self.rideFullInfo.ride_type == "corporative" ? Lang.getString(type: .l_i_will_tell_the_driver) : self.rideFullInfo.destination_location.name
            self.arrivingVC.mainLbl.text = Lang.getString(type: .arriving_mins)
            self.arrivingVC.detailLbl.text = self.rideFullInfo.car_details
            self.arrivingVC.startLocationMainLbl.text = self.rideFullInfo.start_location.name
            self.arrivingVC.startLocationDetailLbl.text = self.rideFullInfo.entrance
            self.arrivingVC.destinationMainLbl.text = destination_lbl
            self.arrivingVC.destinationDetailLbl.text = self.rideFullInfo.destination_location.name
            self.arrivingVC.paymentDetailLbl.text = self.rideFullInfo.payment_method == "cash" ? Lang.getString(type: .cash) : Lang.getString(type: .card)
            self.arrivingVC.orderDetailLbl.text = Lang.getString(type: .cost_of_your_ride) + "\(Double(self.rideFullInfo.estimated_price)!.rounded())" + " \(Lang.getString(type: .l_sum))"
        }
        
    }
    
    private func showArrivingVC() {
        self.isLookingForCarsViewActive = false
        UIView.animate(withDuration: 0.5) {
            self.arrivingVC.view.transform = CGAffineTransform(translationX: 0, y: (self.view.frame.height - 260))
        }
    }
    
    private func showInProgressView() {
        UIView.animate(withDuration: 0.2) {
            //shows rating stars
            self.arrivingVC.inProgressView.isHidden = false
        } completion: { (_) in
            UIView.animate(withDuration: 0.3) {
                //hides main view and shows rating
                self.arrivingVC.mainView.isHidden = true
                
            }
        }
    }
    
    private func showMainViewArriving(){
        self.arrivingVC.rate = 0
        for i in arrivingVC.ratingBtns{
            i.setImage(UIImage(named: "star_not_filled"), for: .normal)
        }
        self.arrivingVC.inProgressView.isHidden = true
        self.arrivingVC.mainView.isHidden = false
        self.arrivingVC.iamcomingView.isHidden = true
    }
    
    private func hideArrivingVC(completion : (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.5) {
            self.arrivingVC.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        } completion: { (_) in
            completion?()
        }
        
    }
    
    
    func didChatPressed() {
        isChatViewActive = true
        arrivingVC.badgeView.isHidden = true
        incomingMessageCount = 0
        arrivingVC.numInBadgeViewLbl.text = "\(incomingMessageCount)"
        
        chatVC.driver_id = rideFullInfo.driver_id
        chatVC.delegate = self
        
        chatVC.modalPresentationStyle = .overCurrentContext
        self.present(chatVC, animated: true, completion: nil)
        
        
    }
    
    func didCallBtnPressed() {
        let phoneURL = NSURL(string: ("tel://" + rideFullInfo.driver_phone))
        UIApplication.shared.open(phoneURL! as URL, options: [:], completionHandler: nil)
    }
    
    func didIAmComingPressed() {
        getFullRideInfo {
            API.iAmComing(ride_id: self.rideFullInfo._id) { (isDone) in
                if isDone{
                    MySocket.default.sendMessage(with: Lang.getString(type: .i_am_coming), ride_id: self.rideFullInfo._id, to: self.rideFullInfo.driver_id)
                    self.arrivingVC.iamcomingView.isHidden = true
                }
            }
        }
        
    }
    
    func didOrderDetailPressed() {
        let orderDetailVC = OrderDetails(nibName: "OrderDetails", bundle: nil)
        getFullRideInfo {
            orderDetailVC.rideFullInfo = self.rideFullInfo
            orderDetailVC.modalPresentationStyle = .overCurrentContext
            self.present(orderDetailVC, animated: true, completion: nil)
        }
        
        
    }
    
    func didCancelOrderPressed() {
        SimpleAlert.showSimpleAlert(title: Lang.getString(type: .a_simple_alert_title), detail: Lang.getString(type: .a_simple_alert_desc)) { (isYes) in
            if isYes{
                self.cancelRide(ride_id: self.rideFullInfo._id) { (isDone) in
                    if isDone{
                        self.hideArrivingVC()
                        self.currentLocationTitleLbl.isHidden = false
                        self.currentLocationSubtitleLbl.isHidden = false
                        self.centerPin.isHidden = false
                        self.currentUserPlaceMark?.opacity = 1
                        self.firstLocationVC.isThisViewActive = true
                        self.moveFirstLocationViewFor(state: self.firstLocationVC.lastValidState)
                        
                    }else{
                        //                        Yandex.clearPlacemark(from: self.mapView.mapWindow.map, shouldKeepStartPoint: false)
                        //                        Alert.showAlert(forState: .error, message: "Error occured!")
                        //                        self.hideArrivingVC()
                        //                        self.currentLocationTitleLbl.isHidden = false
                        //                        self.currentLocationSubtitleLbl.isHidden = false
                        //                        self.centerPin.isHidden = false
                        //                        self.currentUserPlaceMark?.opacity = 1
                        //
                        //                        self.firstLocationVC.isThisViewActive = true
                        //                        self.moveFirstLocationViewFor(state: self.firstLocationVC.lastValidState)
                    }
                }
            }
        }
        
    }
    
    func didShareRoutePressed() {
        Alert.showAlert(forState: .warning, message: Lang.getString(type: .coming_soon))
    }
    
    func didSafetyPressed() {
        let vc = SafetyVC(nibName: "SafetyVC", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    
    
}


extension MainViewController: ChatVCDelegate{
    func didcloseChatBtnPressed() {
        isChatViewActive = false
    }
    
    
}


//MARK: - RATE YOUR RIDE VC
extension MainViewController: RateYourRideVCDelegate{
    func didSubmitPressed(ride_id: String, rate: Int, ride_comment: String, ride_feeds: [String]) {
        rateRide(ride_id: ride_id, rate: rate, rider_comment: ride_comment, rider_feeds: ride_feeds)
    }
    
}


//MARK: -------------------



//MARK: - Getting Data

extension MainViewController {
    
    func getRideHistoryData() {
        
        var data = [RideHistoryDM]()
        var newData = [RideHistoryDM]()
        API.getRideHistorySorted(limit: 10, page: 1) { (data1) in
            guard let data1 = data1 else {return}
            data = data1
            API.getRideHistorySorted(limit: 10, page: 2) { (secondData) in
                guard let secondData = secondData else {return}
                data.append(contentsOf: secondData)
                var shouldAdd = true
                for i in data {
                    if newData.count == 5{
                        self.firstLocationVC.rideHistoryData = newData
                        break
                    }else{
                        for j in newData {
                            if i.location_name == j.location_name{
                                shouldAdd = false
                                break
                            }else{
                                shouldAdd = true
                            }
                        }
                        if shouldAdd{
                            newData.append(i)
                        }
                        self.firstLocationVC.rideHistoryData = newData
                    }
                }
            }
        }
    }
    
    
    func getNearCars(completion: @escaping([NearCarsDM]) -> Void){
        API.getNearCars(location_name: startAddress!.name, long: startAddress!.longitude, lat: startAddress!.latitude) { (data) in
            guard let data = data else {return}
            completion(data)
        }
    }
    
    func getEstimatedPrices(start: AddressDM, dest: AddressDM, ridePolls: [[String : Double]]) {
        API.getEstimatedPrice(locationName: start.name, locLong: start.longitude, locLat: start.latitude, destination_name: dest.name, dest_long: dest.longitude, dest_lat: dest.latitude, ride_pols: ridePolls) { (data) in
            guard let data = data else {return}
            
            self.findCarVC.estimatedPrice = data
            #warning("NEED TO BE CHANGE TO API, Price when air conditioner on")
            if UserDefaults.standard.bool(forKey: CONSTANTS.IS_AIR_CONDITIONER_ON){
                for i in 0..<self.findCarVC.estimatedPrice.count{
                    self.findCarVC.estimatedPrice[i].price += 2000
                }
            }
        }
    }
    
    func getEstimatedPriceFrom(){
        API.getEstimatedPriceFrom { (data) in
            guard let data = data else {return}
            self.findCarVC.estimatedPrice = data            
        }
    }
    
    func cancelRide(ride_id: String, completion: @escaping (Bool) -> Void) {
        API.cancelRide(ride_id: ride_id, cancelled_location: [
                        "location_name" : self.rideFullInfo.start_location.fullName,
                        "latitude" : self.rideFullInfo.start_location.latitude,
                        "longitude": self.rideFullInfo.start_location.longitude,
                        "mode" : "DESTINATION"],
                       cancel_reason: "change my mind") { (done) in
            if done{
                Cache.saveLastOrderID(id: nil)
                EntranceRideOptionCommentNotification.postSomeonePhoneNotification(str: "")
                completion(true)
            }else{
                Alert.showAlert(forState: .error, message: "Could not complete the operation")
                completion(false)
            }
            
            //            EntranceRideOptionCommentNotification.postCommentNotification(str: "")
            //            EntranceRideOptionCommentNotification.postEntranceNotification(str: "")
            //            EntranceRideOptionCommentNotification.postSomeonePhoneNotification(str: "")
            //            EntranceRideOptionCommentNotification.postRideOptionNotification(isON: false)
            //                        Cache.savePaymentType(bool: false, item_position: 0)
            //            self.findCarVC.cardnumber = ""
            //
            //            Yandex.clearNearCarObjects(from: self.mapView.mapWindow.map)
            //            Yandex.clearPlacemark(from: self.mapView.mapWindow.map, shouldKeepStartPoint: false)
            //            Cache.saveRoutes(bool: false)
        }
    }
    
    func getFullRideInfo(completion: (() -> Void)? = nil) {
        API.getFullRideInfo { (data) in
            self.rideFullInfo = data
            completion?()
        }
    }
    
    func retryRide(ride_id: String, completion: ((Bool) -> Void)? = nil){
        API.retryRide(ride_id: ride_id) { (isRecreatedRide) in
            if isRecreatedRide!{
                Yandex.clearNearCarObjects(from: self.mapView.mapWindow.map)
                self.getNearCars { (nearcars) in
                    for i in nearcars{
                        Yandex.addPoint(for: AddressDM(name: "", fullName: "", longitude: i.longitude, latitude: i.latitude) , to: self.mapView.mapWindow.map, type: .near_car)
                    }
                }
                completion?(true)
            }else{
                completion?(false)
                
            }
        }
    }
    
    func rateRide(ride_id: String ,rate: Int, rider_comment : String, rider_feeds: [String]) {
        API.rateRide(ride_id: ride_id, rate: rate, rider_comment: rider_comment, rider_feeds: rider_feeds)
    }
}

//MARK: - SOCKET ----------------- SOCKET ----------------- SOCKET


extension MainViewController: MySocketDelegate{
    
    
    func didOrdered() {
        didOrderedState()
    }
    
    func didWaitingRider() {
        didWaitingRiderState()
        self.zoomToStartLocationAndZoomOut(isWaitingRider_state: true)
    }
    
    
    func didWaitingDriver() {
        didWaitingDriverState()
    }
    
    
    func didDriverLocationChanged(location_name: String, latitude: Double, longitude: Double, bearing: Double, speed: Double) {
        
        let driverLocation = AddressDM(name: location_name, fullName: "", longitude: longitude, latitude: latitude)
        if self.rideFullInfo.state == "waitingRider"{
            self.arrivingVC.mainLbl.text = Lang.getString(type: .arriving_mins) + " " + self.getDriversArrivingTime(lat: latitude, lon: longitude, speed: speed) + " " + Lang.getString(type: .mins)
        }
        
        
        getFullRideInfo {
            if self.rideFullInfo.state == "waitingRider" || self.rideFullInfo.state == "waitingDriver"{
                
                //Yandex.moveDriverMarker(coordinates: YMKPoint.init(latitude: driverLocation.latitude, longitude: driverLocation.longitude), bearing: bearing, speed: speed)
                
                
                Yandex.clearPlacemark(from: self.mapView.mapWindow.map, shouldKeepStartPoint: true)
                
                
                Yandex.addPoint(for: driverLocation, to: self.mapView.mapWindow.map, type: .driverLocation)
                
                Yandex.drawRoute(startLocation: self.rideFullInfo.start_location, destinationLocation: driverLocation, to: self.mapView.mapWindow.map) { (_) in
                    //here returns ridePolls but we dont need it
                } session: { (session) in
                    self.drivingSession = session
                    
                }
                
            }else if self.rideFullInfo.state == "in_progress"{
                
                
                
                Yandex.clearPlacemark(from: self.mapView.mapWindow.map, shouldKeepStartPoint: true)
                
                Yandex.addPoint(for: driverLocation, to: self.mapView.mapWindow.map, type: .driverLocation, bearing: bearing)
                
                Yandex.drawRoute(startLocation: driverLocation, destinationLocation: self.rideFullInfo.destination_location, to: self.mapView.mapWindow.map) { (_) in
                    ///here returns ridePolls but we dont need it
                } session: { (session) in
                    self.drivingSession = session
                }
                
            }
            
        }
    }
    
    
    
    func didInProgress() {
        didInProgressState()
    }
    
    func didRideCostChange(total_cost: Int) {
        //
        
    }
    
    func didFinished() {
        didFinishedState()
    }
    
    
    func didCancelled() {
        ///
        didCancelledState()
    }
    
    func didIAmComing() {
        ///
    }
    
    func didPreCancelled() {
        ///
        getFullRideInfo()
        stopSearchAnimation()
        Yandex.clearPlacemark(from: self.mapView.mapWindow.map, shouldKeepStartPoint: false)
        ///here saves animation to userdefaults to handle if app is terminaten before precancelling state and enters back in pre_cancelled state to handle animation
        Cache.savePreCancelledAnimation(bool: true)
        PreCancelAlert.showSimpleAlert(title: Lang.getString(type: .a_preCancelled_alert_title)) {
            (isRetyPressed) in
            if isRetyPressed{
                
                Cache.savePreCancelledAnimation(bool: false)
                self.centerPin.isHidden = true
                self.currentLocationSubtitleLbl.isHidden = true
                self.currentLocationTitleLbl.isHidden = true
                self.retryRide(ride_id: self.rideFullInfo._id) { (isRetried) in
                    if isRetried{
                        self.hideLookingForCarsVC {
                            self.showLookingForCarsVC()
                            if Cache.isRoutesSaved(){
                                // Ikkisi ham bor
                                let startLoc = try! UserDefaults.standard.get(objectType: AddressDM.self, forKey: CONSTANTS.START_ADDRESS_DATA)
                                let  destLoc = try! UserDefaults.standard.get(objectType: AddressDM.self, forKey: CONSTANTS.DESTINATION_ADDRESS_DATA)
                                
                                Yandex.addPoint(for: startLoc as! Locationable, to: self.mapView.mapWindow.map, type: .startLocation)
                                Yandex.addPoint(for: destLoc as! Locationable, to: self.mapView.mapWindow.map, type: .destinationLocation)
                                Yandex.drawRoute(startLocation: startLoc as! Locationable, destinationLocation: destLoc as! Locationable, to: self.mapView.mapWindow.map) { (_) in
                                    ///
                                } session: { (session) in
                                    self.drivingSession = session
                                }
                                
                            }else{
                                ///one point
                                Yandex.addPoint(for: self.startAddress as! Locationable, to: self.mapView.mapWindow.map, type: .startLocation)
                                self.zoomToStartLocationAndZoomOut(isWaitingRider_state: false)
                            }
                        }
                        self.setupSearchingAnimation()
                        self.playSearchAnimation()
                        
                    }else{
                        //when error from api
                        Alert.showAlert(forState: .error, message: "Could not retry ride, :(")
                        
                        self.hideLookingForCarsVC {
                            self.currentLocationSubtitleLbl.isHidden = false
                            self.currentLocationTitleLbl.isHidden = false
                            self.centerPin.isHidden = false
                            self.currentUserPlaceMark?.opacity = 1
                            self.firstLocationVC.isThisViewActive = true
                            self.moveFirstLocationViewFor(state: self.firstLocationVC.lastValidState)
                        }
                    }
                }
            }else{
                Cache.savePreCancelledAnimation(bool: false)
                self.cancelRide(ride_id: self.rideFullInfo._id) { (isDone) in
                    if isDone{
                        self.hideLookingForCarsVC {
                            self.currentLocationSubtitleLbl.isHidden = false
                            self.currentLocationTitleLbl.isHidden = false
                            self.centerPin.isHidden = false
                            self.firstLocationVC.isThisViewActive = true
                            self.moveFirstLocationViewFor(state: self.firstLocationVC.lastValidState)
                        }
                    }
                }
                
            }
        }
        
    }
    
}


//MARK: - YANDEX ----------------- YANDEX ----------------- YANDEX





//MARK: - YANDEX MAP INITIAL SETUP
extension MainViewController: YMKMapInputListener, YMKMapCameraListener, YMKUserLocationObjectListener{
    
    private func setupYandexMap() {
        
        self.view.addSubview(mapView)
        
        //setup userlocation
        mapView.mapWindow.map.isRotateGesturesEnabled = false
        
        //listeners
        mapView.mapWindow.map.addInputListener(with: self)
        mapView.mapWindow.map.addCameraListener(with: self)
        
        //MARK: - SET MAP Camera to current location
        self.locationManager.getUserCurrentLocation(fromVC: self) { (location) in
            self.userCurrentLocation = location
        }
        
        
        
    }
    
    
    
    
    
    //MARK: - Yandex Delegate Methods
    
    func onMapTap(with map: YMKMap, point: YMKPoint) {
        print("TAP")
    }
    
    func onMapLongTap(with map: YMKMap, point: YMKPoint) {
        print("LONG TAP")
    }
    
    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateReason: YMKCameraUpdateReason, finished: Bool) {
        
        handleCenterPinAnimation(finishedDragging: finished)
        // Get geocode and update it
        if finished {
            
            Yandex.geocodeLocation(for: cameraPosition.target) { (data) in
                //self.updateLocationTitles(address: data)
                self.userCurrentLocationData = data
                
                //                if self.confirmAddressVC.isThisViewActive {
                //                    self.confirmAddressVC.choosenAddress = data
                //                    self.showConfirmAddressVC(completion: nil)
                //                }
            }
            
            API.getPlaceByLocation(long: cameraPosition.target.longitude, lat: cameraPosition.target.latitude) { (placeName) in
                guard let name = placeName else {return}
                self.userCurrentLocationData?.name = name
                self.updateLocationTitles(address: name)
                if self.confirmAddressVC.isThisViewActive {
                    self.confirmAddressVC.choosenAddress = AddressDM(name: name, fullName: "", longitude: cameraPosition.target.longitude, latitude: cameraPosition.target.latitude)
                    self.confirmAddressVC.addressName = name
                    self.showConfirmAddressVC(completion: nil)
                }else{
                    self.getNearCarsArrivingTime(lat: cameraPosition.target.latitude, lon: cameraPosition.target.longitude)
                }
            }
           
            
            
        } else {
            hideConfirmAddressVC(temporary: true, completion: nil)
        }
        
        // Handle Card View
        if firstLocationVC.isThisViewActive{moveFirstLocationViewFor(state: finished ? firstLocationVC.lastValidState : .lowest)}
        
    }
    
    
    
    func onObjectAdded(with view: YMKUserLocationView) {
        //
    }
    
    func onObjectRemoved(with view: YMKUserLocationView) {
        //
    }
    
    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {
        //
    }
    
}



//MARK: - YandexMap View Helper Methods
extension MainViewController  {
    
    private func zoomToCurrentLocation() {
        //if user location is not available then uses default longitude and latitude of Amir Temur square
        guard let location = userCurrentLocation else {
            self.userCurrentLocationData = AddressDM(name: "Default location skver", fullName: "", longitude: 69.279737, latitude: 41.311151)
            self.mapView.mapWindow.map.move(
                with: YMKCameraPosition(target: YMKPoint(latitude: 41.311151, longitude: 69.279737) , zoom: 18, azimuth: 0, tilt: 0),
                animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1.5),
                cameraCallback: nil)
            return
            
        }
        self.mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: YMKPoint(latitude: location.latitude, longitude: location.longitude) , zoom: 18, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1.5),
            cameraCallback: nil)
        userCurrentLocationData = AddressDM(name: "", fullName: "", longitude: location.longitude, latitude: location.latitude)
        
        
    }
    
    private func addCurrentUserPlaceMark() {
        let mapObj = mapView.mapWindow.map.mapObjects
        let point = YMKPoint.init(latitude: userCurrentLocation!.latitude, longitude: userCurrentLocation!.longitude)
        
        self.currentUserPlaceMark = mapObj.addPlacemark(with: point, image: UIImage(named: "userLocation")!, style: YMKIconStyle(anchor: CGPoint(x: 0, y: 0) as NSValue, rotationType:YMKRotationType.rotate.rawValue as NSNumber, zIndex: 0, flat: true, visible: true, scale: 0.65, tappableArea: nil))
    }
    
    private func zoomToStartLocationAndZoomOut(isWaitingRider_state: Bool) {
        self.getFullRideInfo {
            self.mapView.mapWindow.map.move(
                with: YMKCameraPosition(target: YMKPoint(latitude: self.rideFullInfo.start_location.latitude, longitude: self.rideFullInfo.start_location.longitude) , zoom: 18, azimuth: 0, tilt: 0),
                animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1.5),
                cameraCallback: nil)
            
            if !isWaitingRider_state {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    self.mapView.mapWindow.map.move(
                        with: YMKCameraPosition(target: YMKPoint(latitude: self.rideFullInfo.start_location.latitude, longitude: self.rideFullInfo.start_location.longitude) , zoom: 14, azimuth: 0, tilt: 0),
                        animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1.5),
                        cameraCallback: nil)
                }
            }
            
        }
        
        
    }
    
    private func zoomOutToFitTwoPoints(){
        
        if let start = startAddress, let dest = destination{
            let boundBox = YMKBoundingBox(southWest: YMKPoint(latitude: dest.latitude, longitude: dest.longitude) , northEast: YMKPoint(latitude: start.latitude, longitude: start.longitude))
            
            var cameraPosition =  mapView.mapWindow.map.cameraPosition(with: boundBox)
            cameraPosition = YMKCameraPosition(target: cameraPosition.target, zoom: cameraPosition.zoom - 2, azimuth: cameraPosition.azimuth, tilt: cameraPosition.tilt)
            self.mapView.mapWindow.map.move(
                with: cameraPosition,
                animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1.5),
                cameraCallback: nil)
            //searchda addresni qidirib cellga bosganda zoom out qilganda pinlar va title;ar korinib qolyapti. shunga pasdagi qator kodlar yozilgan. o'zi bular showfindcarvc da ham yozilgan lekin kamera move bolganda korinib qolyapti.
            self.centerPin.isHidden = true
            self.currentLocationTitleLbl.isHidden = true
            self.currentLocationSubtitleLbl.isHidden = true
        }
    }
}







//MARK: - Socket State Functions
extension MainViewController {
    
    
    func didFinishedState(){
        
        if isChatViewActive{
            self.chatVC.dismiss(animated: true, completion: nil)
        }
        chatData.removeAll()
        getFullRideInfo()
        Yandex.clearPlacemark(from: self.mapView.mapWindow.map, shouldKeepStartPoint: false)
        Yandex.clearNearCarObjects(from: self.mapView.mapWindow.map)
        hideArrivingVC {
            self.currentLocationTitleLbl.isHidden = false
            self.currentLocationSubtitleLbl.isHidden = false
            self.centerPin.isHidden = false
            self.firstLocationVC.isThisViewActive = true
            self.currentUserPlaceMark?.opacity = 1
            
            self.moveFirstLocationViewFor(state: self.firstLocationVC.lastValidState)
        }
        
        let vc = RateYourRideVC(nibName: "RateYourRideVC", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.rate = self.arrivingVC.rate
        vc.total_cost = self.rideFullInfo.total_cost
        self.present(vc, animated: false, completion: nil)
        showMainViewArriving()
        
        //posts notification to defaults
        EntranceRideOptionCommentNotification.postCommentNotification(str: "")
        EntranceRideOptionCommentNotification.postEntranceNotification(str: "")
        EntranceRideOptionCommentNotification.postSomeonePhoneNotification(str: "")
        EntranceRideOptionCommentNotification.postRideOptionNotification(isON: false)
        Cache.saveRoutes(bool: false)
        //        Cache.savePaymentType(bool: false, item_position: 0)
        //self.findCarVC.cardnumber = ""
        
        //
        getRideHistoryData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.firstLocationVC.collectionView.reloadData()
        }
        Cache.saveLastOrderID(id: nil)
    }
    
    func didCancelledState(){
        getFullRideInfo()
        stopSearchAnimation()
        self.currentLocationTitleLbl.isHidden = false
        self.currentLocationSubtitleLbl.isHidden = false
        self.centerPin.isHidden = false
        self.currentUserPlaceMark?.opacity = 1
        
        self.firstLocationVC.isThisViewActive = true
        self.moveFirstLocationViewFor(state: self.firstLocationVC.lastValidState)
        
        Yandex.clearPlacemark(from: self.mapView.mapWindow.map, shouldKeepStartPoint: false)
        Cache.saveRoutes(bool: false)
        
        EntranceRideOptionCommentNotification.postCommentNotification(str: "")
        EntranceRideOptionCommentNotification.postEntranceNotification(str: "")
        EntranceRideOptionCommentNotification.postSomeonePhoneNotification(str: "")
        EntranceRideOptionCommentNotification.postRideOptionNotification(isON: false)
        //        Cache.savePaymentType(bool: false, item_position: 0)
        //self.findCarVC.cardnumber = ""
        
    }
    
    func didInProgressState(completion: (() -> Void )? = nil){
        Yandex.clearPlacemark(from: self.mapView.mapWindow.map, shouldKeepStartPoint: false)
        
        self.getFullRideInfo {
            //destination location is not changes that is why adds for start point
            //driver location is startLocation because always changes while driving
            let destLoc = self.rideFullInfo.destination_location
            let driverLoc = self.rideFullInfo.driver_location
            Yandex.addPoint(for: destLoc, to: self.mapView.mapWindow.map, type: .pin_)
            Yandex.addPoint(for: driverLoc, to: self.mapView.mapWindow.map, type: .driverLocation)
            Yandex.drawRoute(startLocation: driverLoc, destinationLocation: destLoc, to: self.mapView.mapWindow.map) { (_) in
                //here returns ridePolls but we dont need it
            } session: { (session) in
                self.drivingSession = session
            }
            
        }
        
        showInProgressView()
        completion?()
    }
    
    func didWaitingRiderState(completion : (() -> Void )? = nil){
        getFullRideInfo()
        chatData.removeAll()
        Yandex.clearNearCarObjects(from: self.mapView.mapWindow.map)
        self.hideLookingForCarsVC {
            self.stopSearchAnimation()
            self.showArrivingVC()
            self.showMainViewArriving()
            self.arrivingVC.inProgressView.isHidden = true
            self.updateLabelArrivingVC()
            
            //clearing all objects
            Yandex.clearPlacemark(from: self.mapView.mapWindow.map, shouldKeepStartPoint: false)
            
            Yandex.addPoint(for: self.rideFullInfo.start_location, to: self.mapView.mapWindow.map, type: .pin_)
            ///Driver location kemayapti waitingrider state da
            Yandex.addPoint(for: self.rideFullInfo.driver_location, to: self.mapView.mapWindow.map, type: .driverLocation)
            
            Yandex.drawRoute(startLocation: self.rideFullInfo.driver_location, destinationLocation: self.rideFullInfo.start_location, to: self.mapView.mapWindow.map) { (_) in
                //here returns ridePolls but we dont need it
            } session: { (session) in
                self.drivingSession = session
            }
            completion?()
            Cache.saveRoutes(bool: false)
        }
        
    }
    
    func didWaitingDriverState(){
        getFullRideInfo()
        //this shows when driver arrived and waits the rider
        self.arrivingVC.iamcomingView.isHidden = false
        self.arrivingVC.mainLbl.text = Lang.getString(type: .driver_is_here)
    }
    
    func didOrderedState(){
        if isChatViewActive{
            self.chatVC.dismiss(animated: true, completion: nil)
        }
        centerPin.isHidden = true
        if !isLookingForCarsViewActive {
            self.hideArrivingVC {
                self.setupSearchingAnimation()
                self.playSearchAnimation()
                self.showLookingForCarsVC()
            }
        }
        
        getFullRideInfo {
            Cache.saveLastOrderID(id: self.rideFullInfo._id)
        }
    }
}
