// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 25/01/21
//  

import UIKit
import MessageUI

struct ReferFriendDM {
    var img: UIImage
    var text: String
    var img1: UIImage = #imageLiteral(resourceName: "forward")
}

class ReferFriendVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.register(UINib(nibName: "ReferFrienTVC", bundle: nil), forCellReuseIdentifier: "ReferFriendTVC")
        }
    }
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.clipsToBounds = true
            containerView.layer.cornerRadius = 10
            
        }
        
    }
    
    @IBOutlet weak var contentView: UIView!{
        didSet{
            contentView.layer.cornerRadius = 10
            contentView.clipsToBounds = true
            containerView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3738401244)
            containerView.layer.shadowOffset = CGSize(width: 0, height: 5)
            containerView.layer.shadowRadius = 5
            containerView.layer.shadowOpacity = 0.3
            
        }
    }
    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.text = Lang.getString(type: .l_refer_friend)
        }
    }
    
    
    
    

    
    var data = [ReferFriendDM(img: #imageLiteral(resourceName: "share_text"), text: Lang.getString(type: .l_share_by_text)),ReferFriendDM(img: #imageLiteral(resourceName: "share_email"), text: Lang.getString(type: .l_share_by_email)),ReferFriendDM(img: #imageLiteral(resourceName: "share_facebook"), text: Lang.getString(type: .l_share_by_facebook)),ReferFriendDM(img: #imageLiteral(resourceName: "share"), text: Lang.getString(type: .l_share_by_other_way))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func backBtnPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
}
//MARK: - extensions

extension ReferFriendVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReferFriendTVC", for: indexPath) as? ReferFrienTVC else {return UITableViewCell()}
        cell.selectionStyle = .none
        cell.imgview.image = data[indexPath.row].img
        cell.textLbl.text = data[indexPath.row].text
        cell.imgview1.image = data[indexPath.row].img1
        if indexPath.row == data.count - 1{
            cell.lineView.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height / 4
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            //share by text
            displayMessageInterface()
        case 1:
            //share by emai;
            displayEmailInterface()
            break
        case 2:
            //share by facebook
            shareApp(ttl: Lang.getString(type: .l_message_about_sharing_refferal_code))
            break
        case 3:
            //share by other ways
            shareApp(ttl: Lang.getString(type: .l_message_about_sharing_refferal_code))
            break
        default:
            break
        }
    }
}


extension ReferFriendVC: MFMessageComposeViewControllerDelegate{
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            dismiss(animated: true, completion: nil)
        case .failed:
            dismiss(animated: true, completion: nil)
        case .sent:
            dismiss(animated: true, completion: nil)
        default:
            break
        }
        
    }
    
    
    func displayMessageInterface() {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        //composeVC.recipients = [""]
        composeVC.body = "\(Lang.getString(type: .l_message_about_sharing_refferal_code))"
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
    
    
}

extension ReferFriendVC: MFMailComposeViewControllerDelegate{
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: \(error?.localizedDescription ?? "")")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func displayEmailInterface() {
        if MFMailComposeViewController.canSendMail(){
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject("Referral Code")
            mc.setMessageBody("\(Lang.getString(type: .l_message_about_sharing_refferal_code))", isHTML: false)
            
            
            self.present(mc, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Error", message: "Could not share referral code by email", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
}


extension ReferFriendVC{
    
    func shareApp(ttl: String)->Void{
       
            let sharedObjects:[AnyObject] = [ttl as AnyObject]
            let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.mail, UIActivity.ActivityType.message ]
            
        self.present(activityViewController, animated: true, completion: nil)
        }

}

