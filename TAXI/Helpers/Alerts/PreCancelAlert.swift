// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 23/02/21
//  

import UIKit
import Lottie

class PreCancelAlert  {
    
    static var completion: ((Bool) -> Void)?
    
    static let xAnimation : AnimationView  = {
        let v = AnimationView(name: "canceled")
        v.play(fromFrame: 0, toFrame: 100, loopMode: .playOnce, completion: nil)
        return v
    }()
    
    class func showSimpleAlert(title: String, isRetryPresed: @escaping (Bool) -> Void ){
        
        self.completion = isRetryPresed
        
        let backView = UIView(frame: UIScreen.main.bounds)
        backView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 20
        
        backView.tag = 9797
        
        backView.addSubview(containerView)
        
        containerView.snp.makeConstraints { (make) in
            make.center.equalTo(backView)
            make.width.equalTo(backView.frame.width-32)
            
        }
        
        
        
        
        
        containerView.addSubview(xAnimation)
        
        xAnimation.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.size.equalTo(200)
            xAnimation.play(fromFrame: 0, toFrame: 100, loopMode: .playOnce, completion: nil)
        }
        
        let label = UILabel()
        label.text = title
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(name: "poppins-semibold", size: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        containerView.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(xAnimation.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
     
        
       
        
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 10

       
        
        
        containerView.addSubview(verticalStackView)
        
        verticalStackView.snp.makeConstraints { (make) in
         make.top.equalTo(label.snp.bottom).offset(40)
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
   
        let retryBtn = UIButton()
        retryBtn.setTitle(Lang.getString(type: .a_b_retry), for: .normal)
        retryBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        retryBtn.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.3803921569, blue: 0.4549019608, alpha: 1)
        retryBtn.layer.cornerRadius = 10
        retryBtn.addTarget(self, action: #selector(retryTapped(_:)), for: .touchUpInside)

        verticalStackView.addArrangedSubview(retryBtn)
        
        retryBtn.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
        
        let okBtn = UIButton()
        okBtn.setTitle(Lang.getString(type: .a_b_cancel), for: .normal)
        okBtn.setTitleColor(#colorLiteral(red: 0.04705882353, green: 0.6156862745, blue: 0.9725490196, alpha: 1), for: .normal)
        okBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        okBtn.layer.borderColor = #colorLiteral(red: 0.04705882353, green: 0.6156862745, blue: 0.9725490196, alpha: 1)
        okBtn.layer.borderWidth = 1.5
        okBtn.layer.cornerRadius = 10
        okBtn.addTarget(self, action: #selector(okTapped(_:)), for: .touchUpInside)
        
        verticalStackView.addArrangedSubview(okBtn)
        
        okBtn.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
        
        
        
        
        if let window = UIApplication.shared.keyWindow {
            if let vi = UIApplication.shared.keyWindow?.viewWithTag(9797) {
                vi.removeFromSuperview()
            }
            window.addSubview(backView)
        }
        
        containerView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseIn]) {
            containerView.transform = .identity
        } completion: { (_) in }
        
    }
        
            
    @objc class func retryTapped(_ sender: UIButton){
      
        completion?(true)
        removeFromSuperView()
    }
    
     @objc class func okTapped(_ sender: UIButton){
        
        completion?(false)
        removeFromSuperView()
    }
    
    private class func removeFromSuperView() {
        if let _ = UIApplication.shared.keyWindow {
            if let vi = UIApplication.shared.keyWindow?.viewWithTag(9797) {
                vi.removeFromSuperview()
                self.completion = nil
            }
        }
    }
}
