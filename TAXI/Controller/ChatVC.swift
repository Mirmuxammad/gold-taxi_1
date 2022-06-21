// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 05/02/21

import UIKit
import SDWebImage
protocol ChatVCDelegate{
    func didcloseChatBtnPressed()
}

class CellIds {
    
    static let senderCellId = "senderCellId"
    
    static let receiverCellId = "receiverCellId"
}


class ChatVC: UIViewController {
    
    var bottomHeight: CGFloat {
        guard #available(iOS 11.0, *),
            let window = UIApplication.shared.keyWindow else {
                return 0
        }
        return window.safeAreaInsets.bottom
    }
    
    var driver_id : String!
    var delegate : ChatVCDelegate?
    
    var topView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var titleLabel : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var tableView: UITableView = {
        let v = UITableView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var inputTextView: InputTextView = {
        let v = InputTextView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var inputTextViewBottomConstraint: NSLayoutConstraint!
    var data : RideFullInfo?
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        self.setupViews()
        API.getFullRideInfo { (data) in
            self.data = data
        }
    }
    
    func setupViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(topView)
        
        topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        topView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        topView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        topView.backgroundColor = .clear
        
        topView.addSubview(titleLabel)
        titleLabel.text = Lang.getString(type: .chat_with_driver)
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor, constant: 0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 0).isActive = true
        
        self.view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: self.topView.bottomAnchor, constant: 0).isActive = true
        tableView.edges([.left, .right], to: self.view, offset: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CellIds.receiverCellId)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CellIds.senderCellId)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        
        
        let button = UIButton()
        button.setImage(UIImage(named: "cancel"), for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(closeBtnTapped), for: .touchUpInside)
        self.topView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 0).isActive = true
        button.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -7).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(inputTextView)
        inputTextView.edges([.left, .right, .bottom], to: self.view, offset: .zero)
        inputTextViewBottomConstraint = inputTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        inputTextViewBottomConstraint.isActive = true
        inputTextView.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        inputTextView.delegate = self
        
        MessageNotification.createMessageObservers { (chatdm) in
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: chatData.count - 1, section: 0), at: .bottom, animated: true)
        }
        if !chatData.isEmpty{
            self.tableView.scrollToRow(at: IndexPath(row: chatData.count - 1, section: 0), at: .bottom, animated: true)
        }
        
        
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo!
        if var keyboardFrame  = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let keyboardAnimationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)
            let oldOffset = self.tableView.contentOffset
            self.inputTextViewBottomConstraint.constant = -keyboardFrame.height + bottomHeight
            UIView.animate(withDuration: keyboardAnimationDuration) {
                self.view.layoutIfNeeded()
                if !chatData.isEmpty{
                    self.tableView.scrollToRow(at: IndexPath(row: chatData.count - 1, section: 0), at: .bottom, animated: true)
                }
                
            }
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let userInfo = notification.userInfo!
        if var keyboardFrame  = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let keyboardAnimationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval, let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)
            self.inputTextViewBottomConstraint.constant = -15
            let oldOffset = self.tableView.contentOffset
            UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
                self.view.layoutIfNeeded()
                //self.tableView.setContentOffset(CGPoint(x: oldOffset.x, y: oldOffset.y - keyboardFrame.height + self.bottomHeight), animated: false)
            //self.tableView.scrollToRow(at: IndexPath(row: chatData.count - 1, section: 0), at: .none, animated: false)
            }, completion: nil)
        }
    }
    
    
    @objc func closeBtnTapped(){
        delegate?.didcloseChatBtnPressed()
        self.dismiss(animated: true, completion: nil)
    }
}

extension ChatVC: UITableViewDataSource {
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !chatData.isEmpty {
            if chatData[indexPath.row].from_user == "rider"{
                if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.senderCellId, for: indexPath) as? CustomTableViewCell {
                    cell.selectionStyle = .none
                    cell.textView.text = chatData[indexPath.row].message_text
                    cell.bottomLabel.text = chatData[indexPath.row].created_at.getDateValue().getStringOfClock()
                    return cell
                }
            }else{
                if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.receiverCellId, for: indexPath) as? CustomTableViewCell {
                    cell.selectionStyle = .none
                    cell.textView.text = chatData[indexPath.row].message_text
                    cell.bottomLabel.text = chatData[indexPath.row].created_at.getDateValue().getStringOfClock()
                    cell.showTopLabel = false
                    cell.imgView.sd_setImage(with: URL(string: API.baseURL + "/api" + chatData[indexPath.row].from_image ), placeholderImage: #imageLiteral(resourceName: "profilePhoto"))
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
}

extension ChatVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ChatVC: InputTextViewDelegate {
    func didPressSendButton(_ text: String, _ sender: UIButton, _ textView: UITextView) {
        if let d = data{
            MySocket.default.sendMessage(with: textView.text!, ride_id: d._id, to: d.driver_id)
            self.tableView.reloadData()
            textView.text = ""
            self.inputTextView.textViewHeightConstraint.constant = InputTextView.textViewHeight
            textView.isScrollEnabled = false
        }
        
    }
}

