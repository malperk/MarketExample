//
//  HUD.swift
//  LastFMSample
//
//  Created by Alper KARATAS on 10/2/18.
//  Copyright © 2018 Alper KARATAS. All rights reserved.
//

import UIKit

let animateDuration = 0.25
let defaultSize = 40.0
let defaultColor = UIColor.white
// MARK:UIApplicationExtension for getting top view
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
// MARK: - Animation
func animationInLayer(layer: CALayer, size: CGSize, tintColor: UIColor) {
    let duration: CGFloat = 1
    let beginTimes: [CGFloat] = [0.1, 0.2, 0.3, 0.4, 0.5]
    let timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.68, 0.18, 1.08)
    let lineSize = size.width / 9
    let x = (layer.bounds.size.width - size.width) / 2
    let y = (layer.bounds.size.height - size.height) / 2
    
    let animation = CAKeyframeAnimation(keyPath: "transform.scale.y")
    animation.isRemovedOnCompletion = false
    
    animation.keyTimes = [0.0, 0.5, 1.0]
    animation.values = [1.0, 0.4, 1.0]
    animation.timingFunctions = [timingFunction, timingFunction]
    animation.repeatCount = Float.infinity
    animation.duration = CFTimeInterval(duration)
    
    for i in 0..<5 {
        let line = CAShapeLayer(layer: layer)
        let linePath = UIBezierPath(roundedRect: CGRect.init(x: 0, y: 0, width: lineSize, height: size.height), cornerRadius: lineSize / 2)
        animation.beginTime = CFTimeInterval(beginTimes[i])
        line.fillColor = tintColor.cgColor
        line.path = linePath.cgPath
        line.add(animation, forKey: "animation")
        line.frame = CGRect(x: x + lineSize * 2.0 * CGFloat(i), y: y, width: lineSize, height: size.height)
        layer.addSublayer(line)
    }
}
// MARK: - HUD
class HUD {
    let view: UIView
    let backView: UIView
    static let shared = HUD()
    private init() {
        self.view = UIView.init(frame: UIScreen.main.bounds)
        self.backView = UIView.init(frame: self.view.frame)
        self.backView.backgroundColor = UIColor.black
        self.backView.alpha = 0
        self.view.addSubview(self.backView)
        animationInLayer(layer: self.view.layer, size: CGSize.init(width: defaultSize, height: defaultSize), tintColor: defaultColor)
    }
    
    func show(animate: Bool) {
        guard let activeView = UIApplication.topViewController() else{
            return
        }
        DispatchQueue.main.async {
            activeView.view.addSubview(self.view)
            if animate {
                UIView.animate(withDuration: animateDuration, animations: {
                    self.backView.alpha = 0.5
                })
            } }
    }
    func dismiss(animate: Bool) {
        DispatchQueue.main.async {
            guard let _ = self.view.superview else {
                return
            }
            if animate {
                UIView.animate(withDuration: animateDuration, animations: {
                    self.backView.alpha = 0
                }, completion: { done in
                    if done {
                        self.view.removeFromSuperview()
                    }
                })
            } else {
                self.view.removeFromSuperview()
            } }
    }
}


