//
//  LanguageVC.swift
//  TAXI
//
//  Created by iMac_DM on 3/11/21.
//

import UIKit

class LanguageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    public var minimumVelocityToHide: CGFloat = 1500
    public var minimumScreenRatioToHide: CGFloat = 0.4
    public var animationDuration: TimeInterval = 0.2

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.register(UINib(nibName: "CommentTVC", bundle: nil), forCellReuseIdentifier: "CommentTVC")
        }
    }
    
    @IBOutlet weak var dimview: UIView!{
        didSet{
            dimview.alpha = 0
            
        }
    }
    
    @IBOutlet weak var contentView: UIView!{
        didSet{
            contentView.layer.cornerRadius = 20
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
            view.addGestureRecognizer(panGesture)
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.view.transform = .identity

        }
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.dimview.alpha = 1
        }
    }
    @IBAction func dismissBtnPressed(_ sender: UIButton) {
        dimview.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        } completion: { (_) in
            self.dismiss(animated: false, completion: nil)
        }

        
    }

    
    //MARK: - TableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTVC", for: indexPath) as? CommentTVC else {
            return UITableViewCell()
        }
        
        if indexPath.row == 0{
            cell.label.text = "O'zbek tili"
        }else if indexPath.row == 1{
            cell.label.text = "Русский язык"
        }else{
            cell.label.text = "English"
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == 0{
            Cache.setAppLanguage(to: .uz)
            NotificationCenter.default.post(name: Notification.Name(CONSTANTS.LANGUAGE_NOTIFICATION), object: nil)
            self.dismiss(animated: true, completion: nil)
            
        }else if  indexPath.row == 1{
            Cache.setAppLanguage(to: .ru)
            NotificationCenter.default.post(name: Notification.Name(CONSTANTS.LANGUAGE_NOTIFICATION), object: nil)
            self.dismiss(animated: true, completion: nil)
            
        }else{
            Cache.setAppLanguage(to: .en)
            NotificationCenter.default.post(name: Notification.Name(CONSTANTS.LANGUAGE_NOTIFICATION), object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}


//MARK: SWIPE METHODS

extension LanguageVC{
    
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

