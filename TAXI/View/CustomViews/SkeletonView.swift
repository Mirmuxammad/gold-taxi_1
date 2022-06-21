//
//  SkeletonView.swift
//  PetzoneUZ
//
//  Created by Nodirbek Asqarov on 8/23/19.
//  Copyright © 2019 Nodirbek Asqarov. All rights reserved.
//


import UIKit

class SkeletonView: UIView {
    
    var startLocations : [NSNumber] = [-1.0,-0.5, 0.0]
    var endLocations : [NSNumber] = [1.0,1.5, 2.0]
    
    var gradientBackgroundColor : CGColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    var gradientMovingColor : CGColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.02973585064) //UIColor(white: 0.90, alpha: 1.0).cgColor
    
    var movingAnimationDuration : CFTimeInterval = 1.2
    var delayBetweenAnimationLoops : CFTimeInterval = 0.5
    
    
    var gradientLayer : CAGradientLayer!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [
            gradientBackgroundColor,
            gradientMovingColor,
            gradientBackgroundColor
        ]
        gradientLayer.locations = self.startLocations
        self.layer.addSublayer(gradientLayer)
        self.gradientLayer = gradientLayer
    }
    
    
    
    func startAnimating(){
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            let animation = CABasicAnimation(keyPath: "locations")
            animation.fromValue = self.startLocations
            animation.toValue = self.endLocations
            animation.duration = self.movingAnimationDuration
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            
            
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = self.movingAnimationDuration + self.delayBetweenAnimationLoops
            animationGroup.animations = [animation]
            animationGroup.repeatCount = .infinity
            self.gradientLayer.add(animationGroup, forKey: animation.keyPath)
        }
    }
    
    func stopAnimating() {
        self.gradientLayer.removeAllAnimations()
//        self.gradientLayer.removeFromSuperlayer()
    }
    
}
