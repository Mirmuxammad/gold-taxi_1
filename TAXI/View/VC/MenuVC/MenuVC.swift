//
//  MenuVC.swift
//  TAXI
//
//  Created by Shahzod Ashirov on 2/1/21.
//

import UIKit
import Alamofire
import SDWebImage
class MenuVC: UIViewController {
    
    var transform: CGAffineTransform!
    var data = [Lang.getString(type: .l_home), Lang.getString(type: .l_ride_history), Lang.getString(type: .l_settings),
                Lang.getString(type: .l_log_out)]
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "MenuTVC", bundle: nil), forCellReuseIdentifier: "MenuTVC")
            tableView.tableFooterView = UIView()
            
        }
        
    }
    @IBOutlet weak var viewProfileBtn: UIButton!{
        didSet{
            viewProfileBtn.setTitle(Lang.getString(type: .b_view_profile), for: .normal)
        }
    }
    @IBOutlet weak var referFriendBtn: UIButton!{
        didSet{
            referFriendBtn.setTitle(Lang.getString(type: .b_refer_friend), for: .normal)
            referFriendBtn.layer.borderWidth = 2
            referFriendBtn.layer.borderColor = #colorLiteral(red: 0.04705882353, green: 0.6156862745, blue: 0.9725490196, alpha: 1)
        }
    }
    @IBOutlet weak var dismissBtn: UIButton!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
        dismissBtn.alpha = 0
        self.view.backgroundColor = .clear
        self.view.transform = transform
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabels), name: Notification.Name(rawValue: CONSTANTS.LANGUAGE_NOTIFICATION), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userNameLbl.text = Cache.getUser()!.firstName + " " + Cache.getUser()!.lastName
        
        UIView.animate(withDuration: 0.5) {
            self.view.transform = .identity
        }completion: { (_) in
            UIView.animate(withDuration: 0.2) {
                self.dismissBtn.alpha = 1
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        self.profileImageView.sd_setImage(with: URL(string: API.baseURL + "/api" + (Cache.getUser()?.image ?? "")) , placeholderImage: UIImage(named: "profilePhoto"))
    }
    
    @objc func updateLabels(){
        
        viewProfileBtn.setTitle(Lang.getString(type: .b_view_profile), for: .normal)
        referFriendBtn.setTitle(Lang.getString(type: .b_refer_friend), for: .normal)
        data = [
            Lang.getString(type: .l_home),
            Lang.getString(type: .l_ride_history),
            Lang.getString(type: .l_settings),
            Lang.getString(type: .l_log_out)]
        tableView.reloadData()
    }
    
    @IBAction func viewProfilePressed(_ sender: Any) {
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func referToFriendPressed(_ sender: Any) {
        let vc = ReferFriendVC(nibName: "ReferFriendVC", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismissBtn.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.view.transform = self.transform
        } completion: { _ in
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    
    
}


//MARK: - TableViewDelegate
extension MenuVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTVC", for: indexPath) as? MenuTVC else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.label.text = data[indexPath.row]
        cell.label.font = UIFont(name: "poppins-regular.ttf", size: 14)
        cell.label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        if indexPath.row == data.count - 1{
            
            cell.label.textColor = #colorLiteral(red: 0.04705882353, green: 0.6156862745, blue: 0.9725490196, alpha: 1)
            cell.label.font = UIFont(name: "poppins-semibold.ttf", size: 14)
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            self.dismissBtn.alpha = 0
            UIView.animate(withDuration: 0.5) {
                self.view.transform = self.transform
            } completion: { _ in
                self.dismiss(animated: false, completion: nil)
            }
        case 1:
            let vc = RideHistoryVC(nibName: "RideHistoryVC", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = SettingsVC(nibName: "SettingsVC", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            SimpleAlert.showSimpleAlert(title: Lang.getString(type: .log_out_alert_title), detail: Lang.getString(type: .log_out_alert_desc)) { (bool) in
                if bool{
                    Cache.deleteUser()
                    UserDefaults.standard.setValue(false, forKey: CONSTANTS.SHOULD_OPEN_FINDVC)
                    let vc = LoginVC(nibName: "LoginVC", bundle: nil)
                    let window = UIApplication.shared.keyWindow
                    window?.rootViewController = UINavigationController(rootViewController: vc)
                    window?.makeKeyAndVisible()
                }
            }
        default:
            break
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height / 11
    }
    
    
}
