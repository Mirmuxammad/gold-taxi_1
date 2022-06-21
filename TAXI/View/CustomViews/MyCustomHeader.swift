// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 26/01/21
//  

import UIKit

class MyCustomHeader: UITableViewHeaderFooterView {
    
    let title = UILabel()

    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        title.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        title.translatesAutoresizingMaskIntoConstraints = false

        contentView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        contentView.addSubview(title)
        NSLayoutConstraint.activate([
        
            // Center the label vertically, and use it to fill the remaining
            // space in the header view.
            title.heightAnchor.constraint(equalToConstant: 15),
            title.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo:
                   contentView.layoutMarginsGuide.trailingAnchor, constant: 20),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}
