// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 27/02/21
//  

import UIKit

class OrderDetailTVC: UITableViewCell {

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func updateCell(shouldImgShow: Bool, text: String, image: UIImage){
        
        if shouldImgShow{
            imgView.isHidden = !shouldImgShow
           
        }else{
            imgView.isHidden = !shouldImgShow
        }
        imgView.image = image
        lbl.text = text
        
        
    }

  
}
