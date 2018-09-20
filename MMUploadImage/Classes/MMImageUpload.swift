//
//  ImageUpload.swift
//  ImageExtensionTest
//
//  Created by MILLMAN on 2016/7/14.
//  Copyright © 2016年 MILLMAN. All rights reserved.
//
import UIKit

public enum UploadStatus {
    case none
    case uploading
    case willFailed
    case failed
    case willCompleted
    case completed
}

public enum LoadingStyle {
    case sector
    case centerExpand
    case centerShrink
    case roundWith(lineWdith:CGFloat,lineColor:UIColor)
    case wave
}

private var WaveObjectKey = "WaveObjectKey"
private var WaveTimer = "WaveKey"
private var ProgressTimer = "TimerKey"
private var SECTORLAYER   = "SectorKey"
private var LastProgress = "ProgressKey"
private var BackgroundLayer = "BackgroundLayer"
private var UploadImage = "ImageKey"
private var AutoCompleted = "AutoCompletedKey"
private var CompletedBlock = "CompletedKey"
private var FailBlock = "FailKey"
private var UploadKey = "UploadKey"
private var StyleKey  = "StyleKey"
private var CurrentProgress = "CurrentProgressKey"
private let DefaultDuration = 0.3

public extension UIImageView {
    
    fileprivate var waveObject:WaveObject {
        set {
            objc_setAssociatedObject(self, &WaveObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        } get {
            if let wave = objc_getAssociatedObject(self, &WaveObjectKey) as? WaveObject {
                return wave
            } else {
                let wave = WaveObject.init(layerSize: self.sectorLayer.frame.size,speed: 3.0)
                self.waveObject = wave
                return wave
            }
        }
    }
    
    fileprivate var currentProgress:Float {
        set {
            // Prevent Reset Value When Fail or Completed
            if self.status != .completed &&
                self.status != .failed  &&
                newValue != currentProgress &&
                !(currentProgress == 1.0 || currentProgress == 0.0){
            }
            objc_setAssociatedObject(self, &CurrentProgress, newValue, .OBJC_ASSOCIATION_RETAIN)
            
        } get {
            if let progress = objc_getAssociatedObject(self, &CurrentProgress) as? Float {
                return progress
            } else {
                return 0.0
            }
        }
    }
    
    public var style:LoadingStyle {
        get {
            if let current = objc_getAssociatedObject(self,&StyleKey) as? LoadingStyle {
                return current
            } else {
                self.style = .sector
                return .sector
            }
        }
        set {
            objc_setAssociatedObject(self, &StyleKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public var status:UploadStatus {
        get {
            if let current = objc_getAssociatedObject(self,&UploadKey) as? UploadStatus {
                return current
            } else {
                return .none
            }
        }
        set {
            objc_setAssociatedObject(self,&UploadKey,newValue,.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public var completedBlock:(() -> Void)? {
        get {
            if let c = objc_getAssociatedObject(self, &CompletedBlock) as? (() -> Void) {
                return c
            }
            return nil
        }
        set {
            let new:Any = newValue

            objc_setAssociatedObject(self,&CompletedBlock,new,.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public var failBlock:(()-> Void)? {
        get {
            if let c = objc_getAssociatedObject(self, &FailBlock) as? (() -> Void) {
                return c
            }
            return nil
        }
        set {
            
            let new:Any = newValue
            objc_setAssociatedObject(self,&FailBlock,new as Any,.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    fileprivate var backgroundLayer:CAShapeLayer {
        set {
            objc_setAssociatedObject(self, &BackgroundLayer, newValue, .OBJC_ASSOCIATION_RETAIN)
            
        } get {
            if let layer = objc_getAssociatedObject(self, &BackgroundLayer) as? CAShapeLayer {
                return layer
            } else {
                let layer = CAShapeLayer()
                self.layer.insertSublayer(layer, below: sectorLayer)
                layer.frame = self.bounds
                layer.cornerRadius = self.bounds.width/2
                layer.masksToBounds = true
                layer.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor
                layer.isHidden = true
                self.backgroundLayer = layer
                return layer
            }
        }
    }
    
    fileprivate var waveTimer:Timer? {
        set {
            objc_setAssociatedObject(self, &WaveTimer, newValue, .OBJC_ASSOCIATION_RETAIN)
            
        } get {
            if let timer = objc_getAssociatedObject(self, &WaveTimer) as? Timer {
                return timer
            } else {
                return nil
            }
        }
    }
    
    fileprivate var progressTimer:Timer? {
        set {
            objc_setAssociatedObject(self, &ProgressTimer, newValue, .OBJC_ASSOCIATION_RETAIN)
            
        } get {
            if let timer = objc_getAssociatedObject(self, &ProgressTimer) as? Timer {
                return timer
            } else {
                return nil
            }
        }
    }
    
    fileprivate var sectorLayer:CAShapeLayer {
        set {
            objc_setAssociatedObject(self, &SECTORLAYER, newValue, .OBJC_ASSOCIATION_RETAIN)
        } get {
            if let layer = objc_getAssociatedObject(self, &SECTORLAYER) as? CAShapeLayer {
                return layer
            } else {
                self.layer.cornerRadius = self.frame.size.width/2
                self.clipsToBounds = true
                self.sectorLayer = CAShapeLayer()
                self.sectorLayer.masksToBounds = true
                self.layer.addSublayer(self.sectorLayer)
                return self.sectorLayer
            }
        }
    }
    
    fileprivate var lastProgress:Float {
        set {
            objc_setAssociatedObject(self, &LastProgress, newValue, .OBJC_ASSOCIATION_RETAIN)
        } get {
            if let progress = objc_getAssociatedObject(self, &LastProgress) as? Float {
                return progress
            }
            return Float(0.0)
        }
    }
    
    var uploadImage:UIImage? {
        set {
            objc_setAssociatedObject(self, &UploadImage, newValue, .OBJC_ASSOCIATION_RETAIN)
            
        } get {
            if let image = objc_getAssociatedObject(self, &UploadImage) as? UIImage {
                return image
            }
            return nil
        }
    }
    
    var autoCompleted:Bool {
        set {
            objc_setAssociatedObject(self, &AutoCompleted, newValue, .OBJC_ASSOCIATION_RETAIN)
            
        } get {
            if let auto = objc_getAssociatedObject(self, &AutoCompleted) as? Bool {
                return auto
            }
            return false
        }
    }
}

public extension UIImageView  {
    
    @objc func animationDoing(timer:Timer) {
        self.currentProgress = animationProgress()
    }
    
    public func uploadImage(image:UIImage,progress:Float) {
        self.uploadImage(image:image, progress: progress, duration: DefaultDuration)
    }
    
    fileprivate func uploadImage(image:UIImage,progress:Float,duration:CFTimeInterval) {
        let fixProgress = (progress > 1.0) ? 1.0 : progress
        
        self.uploadImage = image
        if self.status == .uploading && fixProgress < 1.0 || self.status == .completed  && fixProgress == 1.0{
            return
        }
        
        DispatchQueue.main.async {
            if self.status != .willFailed {
                self.backgroundLayer.isHidden = (progress > 0.0) ? false : true
            }
            self.backgroundLayer.frame = self.bounds
            self.sectorLayer.contents = image.cgImage
            self.sectorLayer.frame = self.layerFrame()
            let radius = self.sectorLayer.frame.width/2
            self.sectorLayer.cornerRadius = radius
            self.addAnimationWith(fixProgress,duration: duration)
        }
    }
    
    public func uploadImageFail() {
        self.uploadImageFail(duration:DefaultDuration)
    }
    
    public func uploadImageFail(duration:CFTimeInterval) {
        
        if self.status == .completed || self.status == .failed {
            return
        }
        
        self.status = .willFailed
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.lastProgress = (self.lastProgress <= 1.0) ? self.lastProgress : 1.0
            
            if let i = self.uploadImage {
                self.uploadImage(image: i, progress: 0.0, duration: duration)
            } else {
                self.status = .none
                print("Not set Upload Image")
            }
        }
        self.sectorLayer.frame = self.layerFrame()
        let radius = sectorLayer.frame.width/2
        
        self.sectorLayer.cornerRadius = radius
        self.sectorLayer.mask?.cornerRadius = radius
        CATransaction.commit()
    }
    
    public func uploadCompleted() {
        self.uploadCompleted(duration:DefaultDuration)
    }
    
    public func uploadCompleted(duration:CFTimeInterval) {
        if self.status == .completed {
            return
        }
        
        if let i = self.uploadImage {
            self.status = .willCompleted
            self.uploadImage(image:i, progress:1.0,duration: duration)
        } else {
            self.status = .none
            print("not set Upload Image")
        }
    }
    
    fileprivate func layerFrame() -> CGRect {
        switch self.style {
        case .sector:
            return self.bounds.insetBy(dx: 10, dy: 10)
        case .roundWith(let lineWdith, _):
            return self.bounds.insetBy(dx: lineWdith/2, dy: lineWdith/2)
        default:
            return self.bounds
        }
    }
}

extension UIImageView:CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        if flag == true {
            progressTimer?.invalidate()
            progressTimer = nil
        }
        
        if lastProgress >= 1.0 && autoCompleted || self.status == .willCompleted{
            
            if !flag {
                return
            }
            
            waveTimer?.invalidate()
            waveTimer = nil
            self.status = .completed
            self.image =  self.uploadImage
            let radius = self.bounds.width/2
            self.sectorLayer.frame = self.bounds
            self.sectorLayer.cornerRadius = radius
            self.sectorLayer.mask?.frame = self.bounds
            self.sectorLayer.mask?.cornerRadius = radius
            self.backgroundLayer.isHidden = true
            self.backgroundLayer.path = nil
            if let c = completedBlock {
                c()
            }
        } else if (lastProgress <= 0.0) {
            if !flag {
                return
            }
            waveTimer?.invalidate()
            waveTimer = nil
            self.status = .none
            if let f = failBlock{
                f()
            }
            self.backgroundLayer.isHidden = true
            self.backgroundLayer.path = nil
            
        } else {
            self.status = .none
        }
    }
    
    public func animationDidStart(_ anim: CAAnimation) {
        if progressTimer == nil {
            progressTimer = Timer.init(timeInterval: 0.01, target: self, selector: #selector(UIImageView.animationDoing(timer:)), userInfo: nil, repeats: true)
            if let pTimer = progressTimer {
                RunLoop.main.add(pTimer, forMode: RunLoop.Mode.common)
            }
        }
        
        if (self.status != .willFailed && self.status != .willCompleted) {
            self.status = .uploading
        }
    }
}

// Animation
extension UIImageView {
    
    fileprivate func addAnimationWith(_ progress:Float,duration:CFTimeInterval) {
        let animation = CABasicAnimation()
        animation.delegate = self
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.setValue("StrokeProgress", forKey: "animationID")
        animation.fromValue = self.animationFromValue()
        animation.toValue = self.animationToValue(progress: progress)
        animation.fillMode = CAMediaTimingFillMode.both
        
        switch self.style {
        case .sector:
            animation.keyPath = "strokeEnd"
            self.sectorLayer.mask = self.generateMask(progress:nil)
            self.sectorLayer.mask!.add(animation, forKey: "Sector")
        case .centerExpand:
            animation.keyPath = "transform.scale"
            self.sectorLayer.mask = self.generateMask(progress:nil)
            self.sectorLayer.mask!.add(animation, forKey: "CenterExpand")
        case .centerShrink:
            animation.keyPath = "lineWidth"
            self.sectorLayer.mask = self.generateMask(progress:nil)
            self.sectorLayer.mask!.add(animation, forKey: "CenterShrink")
        case .roundWith(let lineWidth, _):
            animation.keyPath = "strokeEnd"
            let resetPro:Float = (self.status == .willFailed) ? 0.0 : 1.0
            self.sectorLayer.mask = self.generateMask(progress:resetPro)
            let radius = backgroundLayer.frame.width/2
            let bezier = UIBezierPath(roundedRect: backgroundLayer.bounds, cornerRadius:radius)
            self.backgroundLayer.lineWidth = lineWidth
            self.backgroundLayer.path = bezier.cgPath
            self.backgroundLayer.strokeColor = self.maskStrokeColor()
            self.backgroundLayer.fillColor = self.maskFillColor()
            self.backgroundLayer.add(animation, forKey: "Round")
        case .wave:
            animation.keyPath = "transform.translation.y"
            if waveTimer == nil {
                self.sectorLayer.mask = self.generateMask(progress: nil)
                waveTimer = Timer.init(timeInterval: 0.05, target: self, selector: #selector(UIImageView.reDrawWave(timer:)), userInfo: nil, repeats: true)
                if let wTimer = waveTimer {
                    RunLoop.main.add(wTimer, forMode: RunLoop.Mode.common)
                }
            }
            
            self.sectorLayer.mask!.add(animation, forKey: "Wave")
        }
        self.lastProgress = progress
    }
    
    @objc func reDrawWave(timer:Timer) {
        if let m = self.sectorLayer.mask as? CAShapeLayer{
            m.path = waveObject.generateWavePath(CGFloat(10))
        }
    }
    
    fileprivate func animationFromValue() -> AnyObject? {
        switch self.style {
        case .sector,.centerExpand:
            return self.lastProgress as AnyObject?
        case .centerShrink:
            let radius = sectorLayer.frame.width/2
            return (self.lastProgress * Float(radius*2)) as AnyObject?
        case .roundWith(_, _):
            return self.lastProgress as AnyObject?
        case .wave:
            let height = Float(self.sectorLayer.frame.height)
            return NSNumber(value: (1-self.lastProgress) * height as Float)
        }
    }
    
    fileprivate func animationToValue(progress:Float) -> AnyObject? {
        let progressValue = (self.status == .willFailed) ? 0 : (progress <= 1.0) ? progress : 1.0
        switch self.style {
        case .sector,.centerExpand:
            return progressValue as AnyObject?
        case .centerShrink:
            let radius = sectorLayer.frame.width/2
            return (progressValue*Float(radius*2)) as AnyObject?
        case .roundWith(_, _):
            return progressValue as AnyObject?
        case .wave:
            let height = Float(self.sectorLayer.frame.height)
            return NSNumber(value: (1-progress) * height as Float)
        }
    }
    
    fileprivate func generateMask(progress:Float?) -> CAShapeLayer {
        let radius:CGFloat = sectorLayer.frame.width/2
        let bezier = UIBezierPath(roundedRect: sectorLayer.bounds, cornerRadius:radius)
        let maskLayer = CAShapeLayer()
        if let p = progress {
            maskLayer.strokeEnd = CGFloat(p)
        }
        maskLayer.frame = sectorLayer.bounds
        maskLayer.cornerRadius = radius
        maskLayer.path = bezier.cgPath
        maskLayer.strokeColor = self.maskStrokeColor()
        maskLayer.lineWidth = radius*2
        maskLayer.fillColor =  self.maskFillColor()
        maskLayer.masksToBounds = true
        return maskLayer
    }
    
    fileprivate func maskStrokeColor () -> CGColor {
        switch self.style {
        case .sector,.centerShrink:
            return UIColor.blue.cgColor
        case .centerExpand,.wave:
            return UIColor.clear.cgColor
        case .roundWith(_, let color):
            return color.cgColor
        }
    }
    
    fileprivate func maskFillColor () -> CGColor {
        switch self.style {
        case .centerExpand,.wave:
            return UIColor.blue.cgColor
        default:
            return UIColor.clear.cgColor
        }
    }
    
    fileprivate func animationProgress () -> Float {
        var value:CGFloat = 0.0
        
        if let layer = self.sectorLayer.mask?.presentation() as? CAShapeLayer ,
            let background = self.backgroundLayer.presentation(){
            switch self.style {
            case .sector:
                value = layer.strokeEnd
            case .centerExpand:
                value = layer.transform.m22
            case .centerShrink:
                value = layer.lineWidth/self.bounds.width
            case .roundWith(_, _):
                value = background.strokeEnd
            case .wave:
                value = (layer.frame.height - layer.frame.origin.y)/layer.frame.height
            }
            let floatStr = NSString.init(format: "%0.3f", value)
            return floatStr.floatValue
        } else {
            return 0.0
        }
    }
}
