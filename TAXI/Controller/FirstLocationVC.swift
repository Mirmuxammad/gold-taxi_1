//
//  FirstLocationView.swift
//  TAXI
//
//  Created by iMac_DM on 2/2/21.
//

import UIKit
import SnapKit

protocol FirstLocationVCDelegate {
    func whereBtnPressed()
    func nextBtnPressed()
    func gpsBtnPressed()
    func didRideHistoryCellPressed(rideHistory: RideHistoryDM)
}


class FirstLocationVC: UIViewController {
    
    enum PositionState {
        case full
        case middle
        case low
        case lowest
        case hide
    }
    
    var lastValidState: PositionState = .low
    
    static var topVisibleBarHeigh: CGFloat = 100
    
    private var bottomContainer: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 15
        v.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.634140621)
        v.layer.shadowOffset = CGSize(width: 0, height: 0)
        v.layer.shadowRadius = 5
        v.layer.shadowOpacity = 0.5
        return v
    }()
    
    private var bottomBtnsStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.distribution = .fill
        stack.axis = .horizontal
        stack.spacing = 0
        
        return stack
    }()
    
    private lazy var flexibleSpace : UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.isUserInteractionEnabled = false
        return v
    }()
    
    
    private lazy var gpsBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.9882352941, blue: 0.9882352941, alpha: 1)
        btn.setImage(UIImage(named: "gps"), for: .normal)
        btn.tintColor = #colorLiteral(red: 0.04705882353, green: 0.6156862745, blue: 0.9725490196, alpha: 1)
        btn.contentEdgeInsets = UIEdgeInsets(top: 7, left: 9, bottom: 9, right: 7)
        btn.layer.cornerRadius = 19
        btn.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5077914813)
        btn.layer.shadowOffset = CGSize(width: 0, height: 0)
        btn.layer.shadowRadius = 4
        btn.layer.shadowOpacity = 0.4
        btn.snp.makeConstraints { (make) in
            make.height.equalTo(38)
            make.width.equalTo(38)
        }
        
        btn.addTarget(self, action: #selector(gpsPressed(_:)), for: .touchUpInside)
        return btn
        
    }()
    
    private lazy var nextBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.9882352941, blue: 0.9882352941, alpha: 1)
        btn.setTitle(Lang.getString(type: .b_next), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        btn.setTitleColor(#colorLiteral(red: 0.3450980392, green: 0.3450980392, blue: 0.3450980392, alpha: 1), for: .normal)
        btn.layer.cornerRadius = 19
        btn.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4923478689)
        btn.layer.shadowOffset = CGSize(width: 2, height: 2)
        btn.layer.shadowRadius = 4
        btn.layer.shadowOpacity = 0.5
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom:8 , right: 10)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.widthAnchor.constraint(greaterThanOrEqualToConstant: 70).isActive = true

        
        btn.addTarget(self, action: #selector(nextPressed(_:)), for: .touchUpInside)
        return btn
        
    }()
    
    
    
    
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = .clear
        return v
    }()
    
    // private var collectionViewFlowLayout: UICollectionViewFlowLayout  = UICollectionViewFlowLayout()
    
    private var whereToGoBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = #colorLiteral(red: 0.537254902, green: 0.537254902, blue: 0.537254902, alpha: 0.1)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        btn.contentHorizontalAlignment = .left
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle(Lang.getString(type: .l_where_r_u_going), for: .normal)
        btn.layer.cornerRadius = 13
        btn.addTarget(self, action: #selector(whereBtnPressed(_:)), for: .touchUpInside)
        btn.snp.makeConstraints { (make) in
            make.height.equalTo(44)
        }
        return btn
        
    }()
    
    private var containerStack: UIStackView = {
        let s = UIStackView()
        s.alignment = .fill
        s.distribution = .fill
        s.spacing = 5
        s.axis = .vertical
        return s
        
    }()
    
    
    private var lastcontainerStack: UIStackView = {
        let s = UIStackView()
        s.alignment = .fill
        s.distribution = .fill
        s.spacing = 5
        s.axis = .vertical
        return s
        
    }()
    
    
    var delegate : FirstLocationVCDelegate
    var rideHistoryData : [RideHistoryDM] = [] {
        didSet {
            self.collectionView.reloadData()
            if rideHistoryData.isEmpty {
                self.lastValidState = .low
            } else if rideHistoryData.count <= 3 {
                self.lastValidState = .middle
            } else {
                self.lastValidState = .full
            }
            
        }
    }
    
    var isThisViewActive: Bool = true
    
    
    var animationCount = 0
    
    override func viewDidLoad() {
        
        commonInit()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabels), name: Notification.Name(rawValue: CONSTANTS.LANGUAGE_NOTIFICATION), object: nil)
    }
    
    
    init(delegate: FirstLocationVCDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        
        self.view.addSubview(containerStack)
        
        containerStack.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(13)
            make.bottom.equalTo(self.view).offset(-30)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        
        let v = UIView()
        v.backgroundColor = .clear
        
        containerStack.addArrangedSubview(v)
        v.addSubview(bottomBtnsStackView)
        
        bottomBtnsStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-13)
        }
        
        bottomBtnsStackView.addArrangedSubview(gpsBtn)
        bottomBtnsStackView.addArrangedSubview(flexibleSpace)
        bottomBtnsStackView.addArrangedSubview(nextBtn)
        
        containerStack.addArrangedSubview(bottomContainer)
        
        bottomContainer.addSubview(lastcontainerStack)
        
        lastcontainerStack.snp.makeConstraints { (make) in
            make.top.equalTo(bottomContainer).offset(13)
            make.bottom.equalTo(bottomContainer).offset(-30)
            make.left.equalTo(bottomContainer).offset(13)
            make.right.equalTo(bottomContainer).offset(-13)
            
        }
        
        
        lastcontainerStack.addArrangedSubview(whereToGoBtn)
        lastcontainerStack.addArrangedSubview(collectionView)
        
        
        self.collectionView.delegate = self
        self.collectionView.reloadData()
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FirstLocationViewCVC", bundle: nil), forCellWithReuseIdentifier: "FirstLocationViewCVC")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        self.view.backgroundColor = .clear
        
    }
    
    @objc func updateLabels() {
        whereToGoBtn.setTitle(Lang.getString(type: .l_where_r_u_going), for: .normal)
        nextBtn.setTitle(Lang.getString(type: .b_next), for: .normal)
    }
    
    @objc private func whereBtnPressed(_ sender: UIButton) {
        delegate.whereBtnPressed()
    }
    
    
    @objc private func gpsPressed(_ sender: UIButton) {
        delegate.gpsBtnPressed()
    }
    
    @objc private func nextPressed(_ sender: UIButton) {
        delegate.nextBtnPressed()
        
    }
    
    
    
}

//MARK: - CollectionView Methods
extension FirstLocationVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return rideHistoryData.count //<= 5 ? rideHistoryData.count : 5
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstLocationViewCVC", for: indexPath) as? FirstLocationViewCVC else {return UICollectionViewCell()}
        
        cell.titleLbl.text = rideHistoryData[indexPath.row].location_name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.didRideHistoryCellPressed(rideHistory: rideHistoryData[indexPath.row])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemSize = CGSize()
        
        if rideHistoryData.count == 5{
            if indexPath.item == 0 || indexPath.item == 1 || indexPath.item == 2
            {
                itemSize =  CGSize(width: ((collectionView.frame.width / 3 ) - 5), height: (collectionView.frame.width / 3 - 20))
                
            }
            if indexPath.item == 3 || indexPath.item == 4{
                itemSize =  CGSize(width: (collectionView.frame.width / 2) - 5, height: (collectionView.frame.width / 3) - 25)
                
            }
        }else if rideHistoryData.count == 4 || rideHistoryData.count == 2{
            
            itemSize =  CGSize(width: (collectionView.frame.width / 2) - 5, height: (collectionView.frame.width / 3) - 25)
            
        }else if rideHistoryData.count == 3 || rideHistoryData.count == 1{
            itemSize =  CGSize(width: ((collectionView.frame.width / 3) - 5), height: (collectionView.frame.width / 3 - 20))
        }
        
        return itemSize
    }
    
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        // splace between two cell horizonatally
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
}
