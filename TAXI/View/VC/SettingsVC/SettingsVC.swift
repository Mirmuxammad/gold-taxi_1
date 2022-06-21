// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 25/01/21
//  

import UIKit




class SettingsVC: UIViewController {
    
    var data = [
        Lang.getString(type: .user_setting),
        Lang.getString(type: .others)]
    var sec1data = [Lang.getString(type: .l_profile)]
    var sec2data = [
        Lang.getString(type: .language),
        Lang.getString(type: .request_support),
        Lang.getString(type: .privacy_policy),
        Lang.getString(type: .terms_conditions),
        Lang.getString(type: .faq),
        Lang.getString(type: .about_us)]
    
    @IBOutlet weak var ttleLbl: UILabel!{
        didSet{
            ttleLbl.text = Lang.getString(type: .l_settings)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 30, right: 0)
            tableView.register(UINib(nibName: "SettingsTVC", bundle: nil), forCellReuseIdentifier: "SettingsTVC")
            
            tableView.register(MyCustomHeader.self,
                               forHeaderFooterViewReuseIdentifier: "sectionHeader")
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabels), name: Notification.Name(rawValue: CONSTANTS.LANGUAGE_NOTIFICATION), object: nil)
    }
    
    @objc func updateLabels() {
        ttleLbl.text  = Lang.getString(type: .l_settings)
        data = [Lang.getString(type: .user_setting), Lang.getString(type: .others)]
        sec1data = [Lang.getString(type: .l_profile)]
        sec2data = [ Lang.getString(type: .language),Lang.getString(type: .request_support), Lang.getString(type: .privacy_policy), Lang.getString(type: .terms_conditions), Lang.getString(type: .faq), Lang.getString(type: .about_us
        )]
        tableView.reloadData()
    }
    @IBAction func backBtnPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        
    }
    
}


extension SettingsVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return sec1data.count
        }else{
            return sec2data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTVC", for: indexPath) as? SettingsTVC else {return UITableViewCell()}
        cell.selectionStyle = .none
        
        if indexPath.section == 0{
            cell.textLbl.text = sec1data[indexPath.row]
            if indexPath.row == sec1data.count - 1{
                cell.lineView.isHidden = true
            }
        }else if indexPath.section == 1{
            cell.textLbl.text = sec2data[indexPath.row]
            if indexPath.row == 0{
                cell.langLbl.text = Cache.getAppLanguage().rawValue == "ru" ? "Русский язык" : Cache.getAppLanguage().rawValue == "en" ? "English" : "O'zbek"
                
            }
            if indexPath.row == sec2data.count - 1{
                cell.lineView.isHidden = true
            }
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0{
            let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.section == 1 {
            if indexPath.row == 0{
            let vc = LanguageVC(nibName: "LanguageVC", bundle: nil)
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false, completion: nil)
            }else if indexPath.row == 1{
                let vc = RequestSupportVC(nibName: "RequestSupportVC", bundle: nil)
                navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 2 {
                 let url = "https://docs.google.com/document/d/e/2PACX-1vQTi7-wy0uE8tAI9z2eFx2M6wX258veNBLnfHxGOjAo_rl_VczG1uY_bCPOYWofSRGeW6AjEQBE4WQ6/pub"

                openSafariView(url: url)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.frame.height - 60) / 9
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                                                                "sectionHeader") as! MyCustomHeader
        view.title.text = data[section]
        
        view.title.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        view.title.font = UIFont(name: "poppins.semibold.ttf", size: 15)
        view.title.font = UIFont.systemFont(ofSize: 15)
        return view
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (tableView.frame.height / 9)
    }
}
