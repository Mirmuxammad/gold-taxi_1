// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 02/02/21
//  

import UIKit
import SnapKit

class SimpleAlert {
    
    static var completion: ((Bool) -> Void)?
    
    class func showSimpleAlert(title: String, detail: String?, isOkPressed: @escaping (Bool) -> Void ){
        
        self.completion = isOkPressed
        
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
        
        
        let label = UILabel()
        label.text = title
        label.textColor = #colorLiteral(red: 0.04705882353, green: 0.6156862745, blue: 0.9725490196, alpha: 1)
        label.font = UIFont(name: "poppins-semibold", size: 20)
        label.textAlignment = .center
        label.numberOfLines = 2
        containerView.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview()
        }
        
        let lineView = UIView()
        lineView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5564041657)
        
        containerView.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.top.equalTo(label.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        
        let detailLbl = UILabel()
        
        detailLbl.text = detail
        detailLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7616578186)
        detailLbl.font = UIFont(name: "poppins-regular", size: 16)
        detailLbl.textAlignment = .center
        detailLbl.numberOfLines = 2
        containerView.addSubview(detailLbl)

        detailLbl.snp.makeConstraints { (make) in
            make.top.equalTo(lineView).offset(40)
            make.left.right.equalToSuperview()

        }
        
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 10

       
        
        
        containerView.addSubview(verticalStackView)
        
        verticalStackView.snp.makeConstraints { (make) in
         make.top.equalTo(detailLbl.snp.bottom).offset(40)
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        //verticalStackView.addArrangedSubview(detailLbl)
        let okButton = UIButton()
        okButton.setTitle(Lang.getString(type: .a_b_ok), for: .normal)
        okButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        okButton.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.3803921569, blue: 0.4549019608, alpha: 1)
        okButton.layer.cornerRadius = 10
        okButton.addTarget(self, action: #selector(retryTapped(_:)), for: .touchUpInside)

        verticalStackView.addArrangedSubview(okButton)
        
        okButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
        
        let cancelButton = UIButton()
        cancelButton.setTitle("\(Lang.getString(type: .a_b_cancel))", for: .normal)
        cancelButton.setTitleColor(#colorLiteral(red: 0.04705882353, green: 0.6156862745, blue: 0.9725490196, alpha: 1), for: .normal)
        cancelButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cancelButton.layer.borderColor = #colorLiteral(red: 0.04705882353, green: 0.6156862745, blue: 0.9725490196, alpha: 1)
        cancelButton.layer.borderWidth = 1.5
        cancelButton.layer.cornerRadius = 10
        cancelButton.addTarget(self, action: #selector(cancelTapped(_:)), for: .touchUpInside)
        
        verticalStackView.addArrangedSubview(cancelButton)
        
        cancelButton.snp.makeConstraints { (make) in
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
    
     @objc class func cancelTapped(_ sender: UIButton){
        
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
