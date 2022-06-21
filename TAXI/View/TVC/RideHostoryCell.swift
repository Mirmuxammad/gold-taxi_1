// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 25/01/21
//  

import UIKit

class RideHostoryCell: UITableViewCell {

    @IBOutlet weak var startLbl: UILabel!
    @IBOutlet weak var destLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var total_costLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func updateCell(data: RideHistoryDM){
        startLbl.text = data.start_location_name
        destLbl.text = data.location_name
        detailLbl.text = data.ride_date.getDateValue().getStringOf()
        total_costLbl.text = "\(Double(data.total_cost).rounded()) \(Lang.getString(type: .l_sum))"
        
    }
   
    
}
