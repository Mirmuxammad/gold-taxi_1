// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 25/01/21
//  

import UIKit


class RideHistoryVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var ttleLbl: UILabel!{
        didSet{
            ttleLbl.text = Lang.getString(type: .l_ride_history)
        }
    }
    var rideHistoryData : [RideHistoryDM] = []
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!{
        didSet{
            rideHistoryData.isEmpty ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }
    
    var current_page_of_history = 1
    var total_page_count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RideHostoryCell", bundle: nil), forCellReuseIdentifier: "RideHistoryCell")
        tableView.tableFooterView = UIView()
        tableView.register(MyCustomHeader.self,
              forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
        activityIndicator.startAnimating()
        API.getTotalNumberOfHistory { (totalnum) in
            if totalnum <= 10 {
                self.total_page_count = 1
            }else{
                self.total_page_count = totalnum / 10
            }
            if self.current_page_of_history <= self.total_page_count{
                API.getRideHistory(limit: 10, page: self.current_page_of_history ) { (data) in
                    guard let data = data else {return}
                    self.rideHistoryData = data
                    self.tableView.reloadData()
                    
                    self.current_page_of_history += 1
                    API.getRideHistory(limit: 10, page: self.current_page_of_history) { (data) in
                        guard let data = data else {return}
                        self.rideHistoryData.append(contentsOf: data)
                        self.tableView.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
                   
                }
            }
            
        }
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

  

}

extension RideHistoryVC: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rideHistoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RideHistoryCell", for: indexPath) as? RideHostoryCell else {return UITableViewCell()}
        
        if indexPath.row == rideHistoryData.count - 1{
            if current_page_of_history <= total_page_count{
                current_page_of_history += 1
                self.activityIndicator.startAnimating()
                API.getRideHistory(limit: 10, page: self.current_page_of_history) { (data) in
                    guard let data = data else {return}
                    self.rideHistoryData.append(contentsOf: data)
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }

        }
        cell.selectionStyle = .none
        cell.updateCell(data: rideHistoryData[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 60
//    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
//                       "sectionHeader") as! MyCustomHeader
//        if !rideHistoryData.isEmpty{
//            view.title.text = rideHistoryData[0].ride_date.getDateValue().getStringOfDateMonthYear()
//        }
//
//        view.title.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7538774568)
//        view.title.font = UIFont(name: "poppins.regular.ttf", size: 14)
//        view.title.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
//
//        return view
//    }
    
    
}
