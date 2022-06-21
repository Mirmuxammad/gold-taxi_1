// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 15/02/21
//  

import UIKit
import YandexMapsMobile
import Alamofire
import SwiftyJSON

protocol SearchVCDelegate{
    func didAddressSelected(startLocation: AddressDM?, destinationLocation: AddressDM)
    func didMapBtnPressed(forStartLocation: Bool)
    func didSearchVCDismissed()
    func didTellTheDriverPressed()
}



class SearchVC: UIViewController {
    

    public var minimumVelocityToHide: CGFloat = 1500
    public var minimumScreenRatioToHide: CGFloat = 0.4
    public var animationDuration: TimeInterval = 0.2
    
    
    
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.cornerRadius = 25
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.layer.shadowRadius = 10
            containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
            containerView.layer.shadowOpacity = 0.4
            containerView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4676131683)
        }
    }
    
    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.text = Lang.getString(type: .l_where_r_u_going)
        }
    }
    @IBOutlet weak var firstBtnView: UIView! {
        didSet{
            firstBtnView.isHidden = true
        }
    }
    @IBOutlet weak var mapBtn1: UIButton!{
        didSet{
            mapBtn1.setTitle(Lang.getString(type: .map), for: .normal)
        }
    }
    
    @IBOutlet weak var mapBtn2: UIButton!{
        didSet{
            mapBtn2.setTitle( Lang.getString(type: .map), for: .normal)
        }
    }
    
    @IBOutlet weak var secondBtnView: UIView! {
        didSet{
            secondBtnView.isHidden = true
        }
    }
    
    @IBOutlet weak var firstTF: UITextField! {
        didSet{
            firstTF.placeholder = Lang.getString(type: .where_from)
            firstTF.delegate = self
            firstTF.text = ""
        }
    }
    @IBOutlet weak var secondTF: UITextField! {
        didSet{
            secondTF.placeholder = Lang.getString(type: .where_to)
            secondTF.delegate = self
            secondBtnView.isHidden = false
        }
    }
    @IBOutlet weak var tellTheDriverBtn: UIButton!{
        didSet{
            tellTheDriverBtn.setTitle(Lang.getString(type: .l_i_will_tell_the_driver), for: .normal)
        }
    }
    
    
    
    @IBOutlet weak var firstClearBtn: UIButton!
    @IBOutlet weak var secondClearBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "SearchTVC", bundle: nil), forCellReuseIdentifier: "SearchTVC")
            tableView.tableFooterView = UIView()
        }
        
    }
   
    var searchAddressData: [AddressDM] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    var startAddress : AddressDM? {
        didSet {
            guard let firstTF = self.firstTF else {return}
            firstTF.text = startAddress?.name
        }
    }
    var destinationAddress : AddressDM? {
        didSet {
            guard let secondTF = self.secondTF else {return}
            secondTF.text = destinationAddress?.name
        }
    }
    
    var userLocation : AddressDM?

    var delegate : SearchVCDelegate?

    var isFirstFieldActive: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateAddresses()

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        view.addGestureRecognizer(panGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabels), name: Notification.Name(rawValue: CONSTANTS.LANGUAGE_NOTIFICATION), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        firstTF.text = startAddress?.name
        secondTF.text = destinationAddress?.name
    }
    
    @objc func updateLabels() {
        titleLbl.text = Lang.getString(type: .l_where_r_u_going)
        firstTF.placeholder = Lang.getString(type: .where_from)
        secondTF.placeholder = Lang.getString(type: .where_to)
        
        mapBtn1.setTitle(Lang.getString(type: .map), for: .normal)
        mapBtn2.setTitle(Lang.getString(type: .map), for: .normal)
        tellTheDriverBtn.setTitle(Lang.getString(type: .l_i_will_tell_the_driver), for: .normal)
    }
    
    private func updateAddresses() {
        firstTF.placeholder = Lang.getString(type: .where_from)
        secondTF.placeholder = Lang.getString(type: .where_to)

        firstTF.text = startAddress?.name
        firstBtnView.isHidden = true
        
        secondTF.text = destinationAddress?.name
        secondBtnView.isHidden = false

    }
    
    


    
    @IBAction func dismissTapped(_ sender: Any) {
        self.delegate?.didSearchVCDismissed()
    }
    
    
    @IBAction func mapBtnsTapped(_ sender: UIButton) {
        self.delegate?.didMapBtnPressed(forStartLocation: sender.tag == 0)
    }
    
    
    @IBAction func clearBtnsTapped(_ sender: UIButton) {
        if sender.tag == 1 {
            firstTF.text = ""
        } else {
            secondTF.text = ""
        }
        sender.isHidden = true

    }
    @IBAction func tellTheDriverBtnPressed(_ sender: UIButton) {
        delegate?.didTellTheDriverPressed()
    }
}

//MARK: - TableView delegate
extension SearchVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchAddressData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTVC", for: indexPath) as? SearchTVC else { return UITableViewCell()}
        cell.selectionStyle = .none
        cell.titleLbl.text = searchAddressData[indexPath.row].fullName
        cell.descLbl.text = searchAddressData[indexPath.row].name
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
       
        if isFirstFieldActive {
            firstTF.resignFirstResponder()
            secondTF.becomeFirstResponder()
            self.startAddress = self.searchAddressData[indexPath.row]
        } else {
            self.destinationAddress = self.searchAddressData[indexPath.row]
            
            self.delegate?.didAddressSelected(startLocation: startAddress, destinationLocation: self.searchAddressData[indexPath.row])
        }
        
    }
    
}



//MARK: - Textfield delegate
extension SearchVC: UITextFieldDelegate{
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        if sender == firstTF {
            self.firstClearBtn.isHidden = firstTF.text!.isEmpty
        } else {
            self.secondClearBtn.isHidden = secondTF.text!.isEmpty
        }
        
        self.isFirstFieldActive = sender == firstTF
        
//        Yandex.geocodeLocation(for: sender.text!) { (data) in
//            self.searchAddressData = data
//        }
        
        API.getPlaceNameByLetter(search: sender.text!, location: userLocation) { [self] (data) in
            mylog("SEARCH USERLOC: \(userLocation)")
            guard let data = data else{return}
            self.searchAddressData = data
            self.tableView.reloadData()
        }
       
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == firstTF{
            firstBtnView.isHidden = false
            secondBtnView.isHidden = true
        }else{
            firstBtnView.isHidden = true
            secondBtnView.isHidden = false
        }
        
        return true
        
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == firstTF {
            self.firstClearBtn.isHidden = textField.text!.isEmpty
        } else {
            self.secondClearBtn.isHidden = textField.text!.isEmpty
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.firstClearBtn.isHidden = true
        self.secondClearBtn.isHidden = true
    }
    
  
}

//MARK: - Swipe Method
extension SearchVC {
    
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
                            self.delegate?.didSearchVCDismissed()
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
