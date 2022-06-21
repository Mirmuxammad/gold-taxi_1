// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 05/02/21
//  

import UIKit

class UserBubbleTVC: UITableViewCell {

    
    
    @IBOutlet weak var bodyLbl: UILabel!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    
    
    var message : ChatDM!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func updateCell(from: String, message_text: String){
       
        backView.translatesAutoresizingMaskIntoConstraints = false
        
        if from == "rider"{
            mylog("RIDER")
            backView.backgroundColor = #colorLiteral(red: 0.2543623064, green: 0.7300672198, blue: 0.46098413, alpha: 1)
            bodyLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            bodyLbl.text = message_text
            
           
            
            
            
            bodyLbl.textAlignment = .right
        }else{
            mylog("DRIVER")
            bodyLbl.text = message_text
            backView.backgroundColor = #colorLiteral(red: 1, green: 0.9530388892, blue: 0.5599837937, alpha: 1)
            bodyLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
           
            
            bodyLbl.textAlignment = .left
        }
    }
}
