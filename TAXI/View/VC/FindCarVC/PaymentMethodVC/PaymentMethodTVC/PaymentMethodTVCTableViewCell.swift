//
//  PaymentMethodTVCTableViewCell.swift
//  TAXI
//
//  Created by iMac_DM on 3/24/21.
//

import UIKit

class PaymentMethodTVCTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var tickImgView: UIImageView!
    @IBOutlet weak var label: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateCell(data: PaymentMethodDM){
        if data.isSelected {
            tickImgView.isHidden = false
        }else{
            tickImgView.isHidden = true
        }
        tickImgView.image = #imageLiteral(resourceName: "tick")
        imgView.image = data.card_cash_image
        if data.label != Lang.getString(type: .cash){
            label.text = "**** **** **** " + data.label.suffix(4)
        }else{
            label.text = data.label
        }
        
        
    }
}
