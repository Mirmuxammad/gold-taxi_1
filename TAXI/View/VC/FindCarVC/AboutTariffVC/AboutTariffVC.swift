//
//  AboutTariffVC.swift
//  TAXI
//
//  Created by rakhmatillo topiboldiev on 01/04/21.
//

import UIKit

class AboutTariffVC: UIViewController {
    public var minimumVelocityToHide: CGFloat = 1500
    public var minimumScreenRatioToHide: CGFloat = 0.2
    public var animationDuration: TimeInterval = 0.2
    
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
   
    
    var ttle : String = ""
    var start_price : String = ""
    var waiting_time : String = ""
    var per_km_value : String = ""
    var per_minute : String = ""
    var imgUrl : String = ""
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var carImgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = ttle
        descLabel.text = "\(Lang.getString(type: .start_price))\(start_price) \(Lang.getString(type: .l_sum))\n\(Lang.getString(type: .waiting_time))\(waiting_time) \(Lang.getString(type: .minute))\n\(Lang.getString(type: .per_minute_value)) \(per_minute) \(Lang.getString(type: .l_sum))\n\(Lang.getString(type: .per_km_value))\(per_km_value) \(Lang.getString(type: .l_sum))/\(Lang.getString(type: .km))\n\n\(Lang.getString(type: .suburb))\(per_km_value) \(Lang.getString(type: .l_sum))/\(Lang.getString(type: .km))\n\(Lang.getString(type: .in_ride_waiting)) \(waiting_time) \(Lang.getString(type: .l_sum))\n\(Lang.getString(type: .l_air_conditioner)) - 2000 \(Lang.getString(type: .l_sum))"
        
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
    
    @IBAction func donePressed(_ sender: Any) {
        dimview.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        } completion: { (_) in
            self.dismiss(animated: false, completion: nil)
        }
    }
}


extension AboutTariffVC{
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
