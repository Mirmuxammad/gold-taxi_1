//
//  PayCVCell.swift
//  TAXI
//
//  Created by Shahzod Ashirov on 2/5/21.
//

import UIKit

class PayCVCell: UICollectionViewCell {

    
    static let identifier = "PayCVCell"
    static func nib() -> UINib {
        return UINib(nibName: "PayCVCell", bundle: nil)
    }
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var carsLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
