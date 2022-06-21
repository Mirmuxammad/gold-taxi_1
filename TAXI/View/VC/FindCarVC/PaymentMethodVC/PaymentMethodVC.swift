// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 27/02/21
//  

import UIKit
protocol ChoosePaymentDelegate {
    func paymentType(number: String)
}
class PaymentMethodVC: UIViewController {
    
    public var minimumVelocityToHide: CGFloat = 1500
    public var minimumScreenRatioToHide: CGFloat = 0.2
    public var animationDuration: TimeInterval = 0.2
    
    @IBOutlet weak var dimView: UIView!{
        didSet{
            dimView.alpha = 0
            
        }
    }
    
    @IBOutlet weak var contentView: UIView!{
        didSet{
            contentView.layer.cornerRadius = 20
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet weak var viewForGesture: UIView!
    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.text = Lang.getString(type: .l_choose_payment_type)
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate =  self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "PaymentMethodTVCTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentMethodTVCTableViewCell")
            tableView.tableFooterView = UIView()
            
        }
    }
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var doneBtn: UIButton!{
        didSet{
            doneBtn.setTitle(Lang.getString(type: .b_done), for: .normal)
        }
    }
    @IBOutlet weak var addCardBtn: UIButton!{
        didSet{
            addCardBtn.setTitle(Lang.getString(type: .b_add_card), for: .normal)
        }
    }
    var data = [PaymentMethodDM(card_cash_image: #imageLiteral(resourceName: "cash"), label: Lang.getString(type: .cash), isSelected: false)]
    var delegate : ChoosePaymentDelegate?
    var cardNumber = ""
    override func viewDidLoad() {
        
        self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        viewForGesture.addGestureRecognizer(panGesture)
        getCards()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCards), name: NSNotification.Name(rawValue: "cards.update"), object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.view.transform = .identity
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.dimView.alpha = 1
        }
    }
    @objc func updateCards() {
        data = [PaymentMethodDM(card_cash_image: #imageLiteral(resourceName: "cash"), label: Lang.getString(type: .cash), isSelected: false)]
        getCards()
    }
    
    func getCards(){
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        API.getCards { (cardData) in
            for i in cardData{
                let newData = PaymentMethodDM(card_cash_image: #imageLiteral(resourceName: "credit_card"), label: i.number, isSelected: false)
//                if self.cardNumber == i.number{
//                    newData.isSelected = true
//                }
                self.data.append(newData)
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
            }
            
            if Cache.isPaymentTypeSaved() {
                self.data[Cache.getPaymentTypePosition()].isSelected = true
               
            }else{
                self.data[0].isSelected = true
                Cache.savePaymentType(bool: true, item_position: 0)
                self.tableView.reloadData()
            }
        }
       
        self.activityIndicatorView.stopAnimating()

        
    }
    
    @IBAction func dissmissBtnPressed(_ sender: Any) {
        dimView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        } completion: { (_) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        var cardnumber = ""
        for (i, j) in data.enumerated() where i != 0 && j.isSelected {
            cardnumber = j.label
        }
        for i in 0..<data.count where data[i].isSelected {
            Cache.savePaymentType(bool: true, item_position: i)
        }
        
        delegate?.paymentType(number: cardnumber )
        dimView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        } completion: { (_) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func addCardBtnPressed(_ sender: Any) {
        let vc = AddCardVC(nibName: "AddCardVC", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
}

extension PaymentMethodVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodTVCTableViewCell", for: indexPath) as? PaymentMethodTVCTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.updateCell(data: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<data.count{
            data[i].isSelected = false
        }
        data[indexPath.row].isSelected = true
        tableView.reloadData()
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row != 0{
            let deleteAction = UIContextualAction(style: .destructive, title: Lang.getString(type: .delete)) { _, _, complete in
                
                API.deleteCard(number: self.data[indexPath.row].label) { (isDone) in
                    self.data.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    complete(true)
                    self.data[0].isSelected = true
                    self.tableView.reloadData()
                }
                
            }
            deleteAction.backgroundColor = .red
            
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            configuration.performsFirstActionWithFullSwipe = true
            return configuration
        }
        return UISwipeActionsConfiguration()
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//MARK: - Swipe methods
extension PaymentMethodVC{
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
