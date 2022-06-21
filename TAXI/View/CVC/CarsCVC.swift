//
//  CarsCVC.swift
//  TAXI
//
//  Created by Shahzod Ashirov on 2/3/21.
//

import UIKit

class CarsCVC: UICollectionViewCell {

    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var category: UILabel!
   
    @IBOutlet weak var chaqmoqImgView: UIImageView!
    @IBOutlet weak var carImg:UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var skeletonView: SkeletonView!
    var isPressed = false
    static let identifier = "CarsCVC"
    static func nib() -> UINib {
        return UINib(nibName: "CarsCVC", bundle: nil)
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonView.startAnimating()
        
    }

}
