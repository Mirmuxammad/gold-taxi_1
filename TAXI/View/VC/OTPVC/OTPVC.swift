// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 07/02/21
//  

import UIKit
import Alamofire
class OTPVC: UIViewController {
    
    @IBOutlet var textFields: [UITextField]! {
        didSet {
            for i in textFields {
                i.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                if #available(iOS 12.0, *) {
                    i.textContentType = .oneTimeCode
                }
                i.delegate = self
                i.addTarget(self, action: #selector(edit(_:)), for: .editingChanged)
            }
        }
    }
    
    @IBOutlet weak var progressView: UIView!
    
    @IBOutlet weak var refreshBtn: UIButton!
    
    @IBOutlet weak var secondLbl: UILabel!
    let shapeLayer = CAShapeLayer()
    
    
    
    
    @IBOutlet weak var confirmBtn: UIButton!{
        didSet{
            confirmBtn.setTitle(Lang.getString(type: .b_verify), for: .normal)
            confirmBtn.layer.cornerRadius = 20
            confirmBtn.clipsToBounds = true
        }
    }
    
    var phoneNumber = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        addProgress()
        
    }

    @IBAction func confitmBtnPressed(_ sender: Any) {
        
        let otp: String = (textFields[0].text! + textFields[1].text! + textFields[2].text! + textFields[3].text!)
        if otp.count == 4 {
            API.verify(phone: self.phoneNumber, otp: otp) { (done) in
                if done {
                    //GO TO MAIN SCREEN
                    let window = UIApplication.shared.keyWindow
                    window?.rootViewController = UINavigationController(rootViewController: MainViewController())
                    window?.makeKeyAndVisible()

                }
            }
        } else {
            Alert.showAlert(forState: .error, message: "OTP is not enough")
        }
    }
    
    
    func addProgress() {
        let center = secondLbl.center
        let trackLayer = CAShapeLayer()
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 30, startAngle: -CGFloat.pi / 2, endAngle: -CGFloat.pi / 2 + 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.white.cgColor
        trackLayer.lineWidth = 5
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        progressView.layer.addSublayer(trackLayer)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = #colorLiteral(red: 0.3607843137, green: 0.6941176471, blue: 0.4705882353, alpha: 1)
        shapeLayer.backgroundColor = #colorLiteral(red: 0.3607843137, green: 0.6941176471, blue: 0.4705882353, alpha: 0.2466211382)
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        progressView.layer.addSublayer(shapeLayer)
        
        self.startTimer()
    }
    
    
    func startTimer() {
        
        self.refreshBtn.isHidden = true
        self.progressView.isHidden = false
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        
        basicAnimation.duration = 120
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
        var second = 120
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            second -= 1
            self.secondLbl.text = String(second)
            if second == 0 {
                timer.invalidate()
                self.progressView.layer.removeAllAnimations()
                self.refreshBtn.isHidden = false
                self.progressView.isHidden = true
            }
        }
    }
    
    @IBAction func refreshBtnPressed(_ sender: Any) {
        API.login(phoneNumber: self.phoneNumber) { (isDone) in
            guard let isDone = isDone else {return}
            if isDone {
                self.startTimer()
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

}

//MARK:- TextFieldDelegate
extension OTPVC: UITextFieldDelegate {
    
    @objc func editingStop() {
        view.endEditing(true)
    }
    
    @objc func edit(_ sender: UITextField) {
        
        #warning("BUG FIX REQUIRED")
        if sender.text!.isEmpty {

            for textField in textFields.reversed() {
                if !textField.text!.isEmpty {
                    textField.becomeFirstResponder()
                    break
                }
                (textFields[0] as UITextField).becomeFirstResponder()
            }
        } else {
            for textField in textFields {
                if textField.text!.isEmpty {
                    textField.becomeFirstResponder()
                    break
                }
                if !textFields[3].text!.isEmpty {
                    self.view.endEditing(true)

                }
            }
        }
    }
}


