//
//  WJClipsButton
//  Released under the MIT license.
//  https://github.com/jingzhilehuakai/WJClipsButton
//
//  Created by 王净 on 17/4/16.
//  Copyright © 2017年 jing&cbang. All rights reserved.
//

import UIKit

public protocol WJClipsButtonDelegate: class {
    // button tap action
    func didTapClipsButton()
    
    // button unlock action
    func clipsButtonDidUnlock()
    
    // button lock action
    func clipsButtonDidLock()
}

public class WJClipsButtonBundle {
    class func podBundleImage(named: String) -> UIImage? {
        let podBundle = Bundle(for: WJClipsButtonBundle.self)
        if let url = podBundle.url(forResource: "WJClipsButton", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            return UIImage(named: named, in: bundle, compatibleWith: nil)!
        }
        return nil
    }
}

public enum LockStatusOfButton: Int {
    case normal, highlighted, selected
}

public class WJClipsButton: UIButton {
    
    // MARK: - public properties
    
    // inner rectangle scale
    @IBInspectable
    public var scaling: CGFloat = 10.0
    
    // the highlighted state animation duration
    @IBInspectable
    public var innerScaleAnimationDuration: CGFloat = 0.15
    
    // guideImageView width
    @IBInspectable
    public let guideImageViewWidth: CGFloat = 14.0
    
    // guideImageView height
    @IBInspectable
    public let guideImageViewHight: CGFloat = 28.0
    
    // lockImageView width
    @IBInspectable
    public let lockImageViewWidth: CGFloat = 24.0
    
    // lockImageView height
    @IBInspectable
    public let lockImageViewHeight: CGFloat = 28.0
    
    // just delegate
    public weak var delegate: WJClipsButtonDelegate? = nil
    
    // button lock status
    public var lockStatus: LockStatusOfButton = .normal {
        didSet {
            if (oldValue == .highlighted || oldValue == .normal) && lockStatus == .selected {
                delegate?.clipsButtonDidLock()
            } else if (oldValue == .selected || oldValue == .normal) && lockStatus == .highlighted {
                delegate?.clipsButtonDidUnlock()
            }
        }
    }
    
    // lock image
    @IBInspectable
    public let lockImage: UIImage = WJClipsButtonBundle.podBundleImage(named: "lock_locked")!
    
    // unlock image
    @IBInspectable
    public let unlockImage: UIImage = WJClipsButtonBundle.podBundleImage(named: "lock_unlocked")!

    // guide image
    @IBInspectable
    public let guideImage: UIImage = WJClipsButtonBundle.podBundleImage(named: "lock_chevron")!
    
    // locaImgae animation duration
    @IBInspectable
    public let lockImageViewAnimationDucation: TimeInterval = 0.35;
    
    // the inner color
    @IBInspectable
    public var innerColor: UIColor = UIColor(red: 244.0 / 255.0, green: 51.0 / 255.0, blue: 50.0 / 255.0, alpha: 1.0)
    
    // inner border color
    @IBInspectable
    public var innerBorderColor: CGColor = UIColor.darkGray.cgColor {
        didSet {
            configureButton()
        }
    }
    
    // outter border color
    @IBInspectable
    public var outterBorderColor: CGColor = UIColor.white.cgColor {
        didSet {
            configureButton()
        }
    }
    
    // the inset between the outer border and inner rectangle
    @IBInspectable
    public var innerInset: CGFloat = 5 {
        didSet {
            configureButton()
        }
    }
    
    // the inset between the outer border and inner border rectangle
    @IBInspectable
    public var innerBorderInset: CGFloat = 2.5 {
        didSet {
            configureButton()
        }
    }
    
    // the cornerRadius of layer, inner and inner border
    @IBInspectable
    public var cornerRadius: CGFloat = 50 {
        didSet {
            configureButton()
        }
    }
    
    // the title of different status of button
    public func setButtonTitle(_ title: String!, for status: LockStatusOfButton) {
        switch status {
        case .normal:
            titleOfNormalStatus = title!
            break
        case .selected:
            titleOfSelectedStatus = title!
            break
        case .highlighted:
            titleOfHighLightStatus = title!
            break
        }
    }
    
    // the titleFont of different status of button
    public func setButtonFont(_ font: UIFont, for status: LockStatusOfButton) {
        switch status {
        case .normal:
            titleFontOfNormalStatus = font
            break
        case .selected:
            titleFontOfSelectedStatus = font
            break
        case .highlighted:
            titleFontOfHightLightStatus = font
            break
        }
    }
    
    // the title color of different status of button
    public func setButtonColor(_ color: UIColor, status: LockStatusOfButton) {
        switch status {
        case .normal:
            colorOfNormalStatus = color
            break
        case .selected:
            colorOfSelectedStatus = color
            break
        case .highlighted:
            colorOfHighLightStatus = color
            break
        }
    }
    
    // the selectStaus of button
    fileprivate var hightLightStatus: Bool = false {
        didSet {
            guard oldValue != hightLightStatus else { return }
            
            highlightAnimation()
        }
    }
    
    // MARK: - private properties
    
    // the shaperLayer of inner
    fileprivate var innerShape: CAShapeLayer?
    
    // the shaperLayer of inner border
    fileprivate var innerBorderShape: CAShapeLayer?
    
    // the shaperLayer of outter border
    fileprivate var outterBorderShape: CAShapeLayer?
    
    // the X scale
    fileprivate let scaleX: String = "scale.x"
    
    // the Y scale
    fileprivate let scaleY: String = "scale.y"
    
    // pan gesture
    fileprivate var panGestureReconizer: UIPanGestureRecognizer?
    
    // tap gesture
    fileprivate var tapGestureRecognizer: UITapGestureRecognizer?
    
    // icon background view
    fileprivate var iconBackgroundView: UIView?
    
    // guide image
    fileprivate var guideImageView: UIImageView?
    
    // lock image
    fileprivate var lockImageView: UIImageView?
    
    // the title of valid status
    fileprivate var titleOfSelectedStatus: String = "CLICK TO STOP"
    
    // the title of inValid status
    fileprivate var titleOfHighLightStatus: String = "SLIDE LEFT TO LOCK"
    
    // the title of normal status
    fileprivate var titleOfNormalStatus: String = "HOLD DOWN TO RECORD"
    
    // the titleFont of selected status
    fileprivate var titleFontOfSelectedStatus: UIFont = UIFont.systemFont(ofSize: 12)
    
    // the titleFont of normal status
    fileprivate var titleFontOfNormalStatus: UIFont = UIFont.systemFont(ofSize: 12)
    
    // the titleFont of highlight status
    fileprivate var titleFontOfHightLightStatus: UIFont = UIFont.systemFont(ofSize: 12)
    
    // the color of valid status
    fileprivate var colorOfSelectedStatus: UIColor = UIColor.white
    
    // the color of inValid status
    fileprivate var colorOfHighLightStatus: UIColor = UIColor.white
    
    // the color of normal status
    fileprivate var colorOfNormalStatus: UIColor = UIColor.white

    // MARK: - public initializers
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        configureButton()
        configureCoverView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureButton()
        configureCoverView()
    }
    
    // MARK: - functions
    
    // configure button style
    fileprivate func configureButton() {
        
        configureOutterShapperBorder()
        configureInnerShapeBorder()
        configureInnerShape()
        configureGestureRecognizer()
        configureInitialTitle()
    }
    
    // initial title and lock status
    fileprivate func configureInitialTitle() {
        
        clipsToBounds = true
        setTitle(titleOfNormalStatus, for: .normal)
        setTitleColor(colorOfNormalStatus, for: .normal)
        titleLabel?.font = titleFontOfNormalStatus
        lockStatus = .normal
        
        addTarget(self, action: #selector(tapAction), for: .touchUpInside)
    }
    
    // tap action method
    @objc fileprivate func tapAction() {
        self.delegate?.didTapClipsButton()
    }
    
    // set up gestureRecognizer
    fileprivate func configureGestureRecognizer() {
        
        if panGestureReconizer == nil {
            panGestureReconizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(sender:)))
            addGestureRecognizer(panGestureReconizer!)
        }
        
    }
    
    // set up innerShaper 
    fileprivate func configureInnerShape() {
        
        if let iShape = innerShape {
            iShape.path = UIBezierPath(roundedRect: bounds.insetBy(dx: innerInset, dy: innerInset), cornerRadius: cornerRadius).cgPath
            iShape.fillColor = innerColor.cgColor
        } else {
            innerShape = CAShapeLayer()
            innerShape?.path = UIBezierPath(roundedRect: bounds.insetBy(dx: innerInset, dy: innerInset), cornerRadius: cornerRadius).cgPath
            innerShape?.frame = bounds
            innerShape?.fillColor = innerColor.cgColor
            innerShape?.masksToBounds = true
            layer.addSublayer(innerShape!)
        }
    }
    
    // set up innerShape border
    fileprivate func configureInnerShapeBorder() {
        
        if let iBShape = innerBorderShape {
            iBShape.path = UIBezierPath(roundedRect: bounds.insetBy(dx: innerBorderInset, dy: innerBorderInset), cornerRadius: cornerRadius).cgPath
            iBShape.fillColor = innerBorderColor
        } else {
            innerBorderShape = CAShapeLayer()
            innerBorderShape?.frame = bounds
            innerBorderShape?.path = UIBezierPath(roundedRect: bounds.insetBy(dx: innerBorderInset, dy: innerBorderInset), cornerRadius: cornerRadius).cgPath
            innerBorderShape?.fillColor = innerBorderColor
            layer.addSublayer(innerBorderShape!)
        }
    }
    
    // set up outterShaper border
    fileprivate func configureOutterShapperBorder() {
        
        if  let oBShaper = outterBorderShape {
            oBShaper.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            oBShaper.fillColor = outterBorderColor
        } else {
            outterBorderShape = CAShapeLayer()
            outterBorderShape?.frame = bounds;
            outterBorderShape?.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            outterBorderShape?.fillColor = outterBorderColor
            layer.addSublayer(outterBorderShape!)
        }
    }
    
    // configure cover view
    fileprivate func configureCoverView() {
        
        let iconBackgroundView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width - scaling, height: self.frame.size.height))
        iconBackgroundView.layer.cornerRadius = cornerRadius / 2 + scaling
        iconBackgroundView.clipsToBounds = true
        self.addSubview(iconBackgroundView)
        
        let gImageX: CGFloat = bounds.width
        let gImageY: CGFloat = (innerShape!.frame.size.height - guideImageViewHight) / 2
        
        guideImageView = UIImageView(frame: CGRect(x: gImageX, y: gImageY, width: guideImageViewWidth, height: guideImageViewHight))
        guideImageView?.image = guideImage
        iconBackgroundView.addSubview(guideImageView!)
        
        let lImageX: CGFloat = gImageX + guideImageViewWidth
        let lImageY: CGFloat = (innerShape!.frame.size.height - lockImageViewHeight) / 2
        
        lockImageView = UIImageView(frame: CGRect(x: lImageX, y: lImageY, width: lockImageViewWidth, height: lockImageViewHeight))
        lockImageView?.image = unlockImage
        iconBackgroundView.addSubview(lockImageView!)
    }
}

// MARK: - Animation
extension WJClipsButton {
    
    // highlight animation
    func highlightAnimation() {
        
        let scalingFactorX: CGFloat = 1 - (scaling / innerShape!.bounds.width)
        let scalingFactorY: CGFloat = 1 - (scaling / innerShape!.bounds.height)
        
        let animationX = CABasicAnimation(keyPath: "transform.scale.x")
        animationX.duration = CFTimeInterval(innerScaleAnimationDuration)
        animationX.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let animationY = CABasicAnimation(keyPath: "transform.scale.y")
        animationY.duration = CFTimeInterval(innerScaleAnimationDuration)
        animationY.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        if hightLightStatus {
            
            animationX.toValue = scalingFactorX
            animationX.isRemovedOnCompletion = false
            animationX.fillMode = kCAFillModeForwards
            innerShape?.add(animationX, forKey: scaleX)
            
            animationY.toValue = scalingFactorY
            animationY.isRemovedOnCompletion = false
            animationY.fillMode = kCAFillModeForwards
            innerShape?.add(animationY, forKey: scaleY)
            
        } else {
            
            animationX.fromValue = scalingFactorX
            animationX.toValue = 1.0
            innerShape?.add(animationX, forKey: scaleX)
            
            animationY.fromValue = scalingFactorY
            animationY.toValue = 1.0
            innerShape?.add(animationY, forKey: scaleY)
            
            lockStatus = .normal
        }
    }
    
}

// MARK: - Gesture Recognizer
extension WJClipsButton: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // handle pan gesture
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        if sender.state == .changed {
            
            setTitle("", for: .normal)
            let transltationX: CGFloat = sender.translation(in: self).x
            
            if transltationX < 0 {
                
                // lockStatus from no status to invalidStatus or validStatus
                let oldStatus = lockStatus
                
                lockStatus = oldStatus == .selected ? oldStatus : .highlighted
                
                // change
                drawImageAlphaChanged(transltationX: transltationX)
                guideImageViewChanged(transltationX: transltationX)
                lockImageViewChanged(transltationX: transltationX)
                
            } else {
                lockStatus = .normal
            }
            
        } else if sender.state == .ended || sender.state == .cancelled {
            
            self.hightLightStatus = lockStatus == .selected
            if lockStatus != .selected {
                resetDisplay()
            } else {
                setTitle(titleOfSelectedStatus, for: .normal)
                setTitleColor(colorOfSelectedStatus, for: .normal)
                titleLabel?.font = titleFontOfSelectedStatus

                UIView.animate(withDuration: lockImageViewAnimationDucation, animations: {
                    self.lockImageView?.frame.origin.x = self.frame.size.width - self.cornerRadius / 2 - (self.lockImageView?.frame.size.width)!
                }, completion: nil)
            }
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.hightLightStatus = lockStatus != .selected
        if lockStatus != .selected {
            resetDisplay()
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hightLightStatus = lockStatus == .selected
        if lockStatus != .selected {
            resetDisplay()
        }
    }
}

// MARK: - Status Changed Events
extension WJClipsButton {
    
    // reset display to original state
    fileprivate func resetDisplay() {
        guideImageView?.frame.origin.x = bounds.width
        guideImageView?.isHidden = false
        
        lockImageView?.frame.origin.x = bounds.width + guideImageViewWidth
        lockImageView?.image = unlockImage
        if lockStatus == .normal && hightLightStatus == true {
            setTitle(titleOfHighLightStatus, for: .normal)
            setTitleColor(colorOfHighLightStatus, for: .normal)
            titleLabel?.font = titleFontOfHightLightStatus
        } else {
            setTitle(titleOfNormalStatus, for: .normal)
            setTitleColor(colorOfNormalStatus, for: .normal)
            titleLabel?.font = titleFontOfNormalStatus
        }
    }
    
    fileprivate func drawImageAlphaChanged(transltationX: CGFloat) {
        
        // guideImageView start change pointX
        let gImageStartX: CGFloat = guideImageViewWidth + scaling + innerInset + innerBorderInset
        
        // lockImageView start change pointX
        let lImageStartX: CGFloat = lockImageViewWidth + gImageStartX
        
        guard lImageStartX >= gImageStartX else {
            return
        }
        
        guard lockStatus == .highlighted else {
            return
        }
        
        guideImageView?.alpha = 0.5 + 0.5 * (-transltationX) / lImageStartX
        lockImageView?.alpha = (guideImageView?.alpha)!
    }
    
    fileprivate func guideImageViewChanged(transltationX: CGFloat) {
        
        let originX: CGFloat = bounds.width
        
        // the proportion of gestures velocity and guideImageView velocity
        let velocityScale: CGFloat = 1.0
        
        if  lockStatus == .highlighted {
            guideImageView?.frame.origin.x = originX + transltationX * velocityScale
        }
                
        // guideImageView hidden when running to center point
        if transltationX <= -0.5 * (originX - guideImageViewWidth) {
            guideImageView?.isHidden = true
        }
    }
    
    fileprivate func lockImageViewChanged(transltationX: CGFloat) {
        
        var originX: CGFloat = bounds.width + guideImageViewWidth
        
        // the pointX when lockImageView start slowing down velocity
        let startChangeX: CGFloat = -(guideImageViewWidth + lockImageViewWidth + scaling + innerInset + innerBorderInset + 10)
        
        // button center pointX, when guideImageView runs to this point, stop motion
        let centerX: CGFloat = -0.5 * (bounds.width - guideImageViewWidth)
        
        // the proportion of gestures velocity and lockImageView velocity
        let velocityScale: CGFloat = transltationX > startChangeX ? 1.0 : 0.2
        
        if transltationX > startChangeX && transltationX < 0 {
            
            // startChangeX ~ 0
            if lockStatus == .highlighted {
                lockImageView?.frame.origin.x = originX + transltationX * velocityScale
            }
            
        } else if transltationX <= startChangeX && transltationX > centerX {
            
            // centerX ~ startChangeX
            if lockStatus == .highlighted {
                originX = bounds.width + guideImageViewWidth + startChangeX
                lockImageView?.frame.origin.x = originX + (transltationX - startChangeX) * velocityScale
            }
            
        } else {
            
            // endPointX ~ centerX, lockStatus is valid
            UIView.animate(withDuration: lockImageViewAnimationDucation, animations: {
                self.lockImageView?.frame.origin.x = -centerX
                self.lockImageView?.image = self.lockImage
            }, completion: { (bool) in
                self.lockStatus = .selected
            })
        }
    }
}
