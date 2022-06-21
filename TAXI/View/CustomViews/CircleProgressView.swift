//
//  CircleProgressView.swift
//  TAXI
//
//  Created by rakhmatillo topiboldiev on 29/03/21.
//

import Foundation
import UIKit


class CirclularProgressBarView: UIView {
    
    private let shapeLayer = CAShapeLayer()
    private let trackLayer = CAShapeLayer()


    var backLineColor: UIColor = .lightGray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var frontLineColor: UIColor = .darkGray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var lineWidth: CGFloat = 12 {
        didSet {
            
        }
    }
    
    var progress: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    private func commonInit() {
        self.layer.addSublayer(trackLayer)
        self.layer.addSublayer(shapeLayer)
        layer.transform = CATransform3DMakeRotation(CGFloat(90 * Double.pi / 180), 0, 0, -1)

    }
    
    override func draw(_ rect: CGRect) {
        let circularPath = UIBezierPath(ovalIn: rect.insetBy(dx: lineWidth, dy: lineWidth))
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = backLineColor.cgColor
        trackLayer.lineWidth = self.lineWidth
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = frontLineColor.cgColor
        shapeLayer.lineWidth = self.lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        shapeLayer.strokeEnd = self.progress

    }
}

