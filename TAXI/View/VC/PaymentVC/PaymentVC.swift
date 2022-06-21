//
//  PaymentVC.swift
//  TAXI
//
//  Created by Shahzod Ashirov on 2/3/21.
//

import UIKit

class PaymentVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        containerView.layer.shadowColor = #colorLiteral(red: 0.9210622907, green: 0.02257506922, blue: 0.5500977039, alpha: 1)
        containerView.layer.shadowOffset = CGSize(width: -1, height: 1)
        containerView.layer.shadowRadius = 20
        containerView.layer.shadowOpacity = 0.5
        backView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        backView.layer.borderWidth = 1
        
    }


    
}
