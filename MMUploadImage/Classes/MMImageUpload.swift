//
//  ImageUpload.swift
//  ImageExtensionTest
//
//  Created by MILLMAN on 2016/7/14.
//  Copyright © 2016年 MILLMAN. All rights reserved.
//
import UIKit
public final class Associated<T>: NSObject {
    public typealias Type = T
    public let value: Type
    public init(_ value: Type) {
        self.value = value
    }
}

public enum UploadStatus {
    case None
    case Uploading
    case WillFailed
    case Failed
    case WillCompleted
    case Completed
}

public enum LoadingStyle {
    case Sector
    case CenterExpand
    case CenterShrink
    case RoundWith(lineWdith:CGFloat,lineColor:UIColor)
    case Wave
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
    
    private var waveObject:WaveObject {
        set {
    
            objc_setAssociatedObject(self, &WaveObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            
        } get {
            if let wave = objc_getAssociatedObject(self, &WaveObjectKey) as? WaveObject {
                return wave
            } else {
                let width = CGRectGetWidth(self.sectorLayer.frame)
                let wave = WaveObject.init(layerWidth: Double(width))
                self.waveObject = wave
                self.waveObject.speed = 5.0
                return wave
            }
        }
    }
    
    private var currentProgress:Float {
        set {
            // Prevent Reset Value When Fail or Completed
            if self.status != .Completed &&
               self.status != .Failed  &&
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
    
    var style:LoadingStyle {
        get {
            if let current = objc_getAssociatedObject(self,
                                                      &StyleKey) as? Associated<LoadingStyle> {
                return current.value
            } else {
                self.style = .Sector
                return .Sector
            }
        }
        set {
            objc_setAssociatedObject(self,
                                     &StyleKey,
                                     Associated<LoadingStyle>(newValue),
                                     .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var status:UploadStatus {
        get {
            
            if let current = objc_getAssociatedObject(self,
                                                      &UploadKey) as? Associated<UploadStatus> {
                return current.value
            } else {
                return .None
            }
            
        }
        set {
            objc_setAssociatedObject(self,
                                     &UploadKey,
                                     Associated<UploadStatus>(newValue),
                                     .OBJC_ASSOCIATION_RETAIN)
        }
    }
        
    public var completedBlock:(() -> Void)? {
        get {
            
            if((objc_getAssociatedObject(self,
                &CompletedBlock) as? Associated<(() -> Void)>)
                .map {$0.value} == nil) {
                return nil
            }
            return (objc_getAssociatedObject(self, &CompletedBlock)
                as? Associated<() -> Void>)
                .map {$0.value}
        }
        set {
            objc_setAssociatedObject(self,
                                     &CompletedBlock,
                                     newValue.map
                                        { Associated<(() -> Void)>($0) },
                                     .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public var failBlock:(()-> Void)? {
        get {
            
            if((objc_getAssociatedObject(self,
                &FailBlock) as? Associated<(() -> Void)>)
                .map {$0.value} == nil) {
                return nil
            }
            return (objc_getAssociatedObject(self, &FailBlock)
                as? Associated<() -> Void>)
                .map {$0.value}
        }
        set {
            objc_setAssociatedObject(self,
                                     &FailBlock,
                                     newValue.map
                                        { Associated<(() -> Void)>($0) },
                                     .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    private var backgroundLayer:CAShapeLayer {
        set {
            objc_setAssociatedObject(self, &BackgroundLayer, newValue, .OBJC_ASSOCIATION_RETAIN)
            
        } get {
            if let layer = objc_getAssociatedObject(self, &BackgroundLayer) as? CAShapeLayer {
                return layer
            } else {
                let layer = CAShapeLayer()
                self.layer.insertSublayer(layer, below: sectorLayer)
                layer.frame = self.bounds
                layer.cornerRadius = CGRectGetWidth(self.bounds)/2
                layer.masksToBounds = true
                layer.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
                layer.hidden = true
                self.backgroundLayer = layer
                return layer
            }
        }
    }
    
    private var waveTimer:NSTimer? {
        set {
            objc_setAssociatedObject(self, &WaveTimer, newValue, .OBJC_ASSOCIATION_RETAIN)
            
        } get {
            if let timer = objc_getAssociatedObject(self, &WaveTimer) as? NSTimer {
                return timer
            } else {
                return nil
            }
        }
    }
    
    private var progressTimer:NSTimer? {
        set {
            objc_setAssociatedObject(self, &ProgressTimer, newValue, .OBJC_ASSOCIATION_RETAIN)
            
        } get {
            if let timer = objc_getAssociatedObject(self, &ProgressTimer) as? NSTimer {
                return timer
            } else {
                return nil
            }
        }
    }
    
    private var sectorLayer:CAShapeLayer {
        set {
            objc_setAssociatedObject(self, &SECTORLAYER, newValue, .OBJC_ASSOCIATION_RETAIN)
        } get {
            if let layer = objc_getAssociatedObject(self, &SECTORLAYER) as? CAShapeLayer {
                return layer
            } else {
                self.layer.cornerRadius = self.frame.size.width/2
                self.clipsToBounds = true
                self.sectorLayer = CAShapeLayer()
                self.layer.addSublayer(self.sectorLayer)
                return self.sectorLayer
            }
        }
    }
    
    private var lastProgress:Float {
        set {
            objc_setAssociatedObject(self, &LastProgress, newValue, .OBJC_ASSOCIATION_RETAIN)
        } get {
            if let progress = objc_getAssociatedObject(self, &LastProgress) as? Float {
                return progress
            }
            return Float(0.0)
        }
    }
    
    private var uploadImage:UIImage? {
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
    
    func animationDoing(timer:NSTimer) {
        self.currentProgress = animationProgress()
    }
    
    public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
        if flag == true {
            progressTimer?.invalidate()
            progressTimer = nil
        }
        
        if lastProgress >= 1.0 && autoCompleted || self.status == .WillCompleted{
            
            if !flag {
                return
            }
            
            waveTimer?.invalidate()
            waveTimer = nil
            self.status = .Completed
            self.image =  self.uploadImage
            let radius = CGRectGetWidth(self.bounds)/2
            self.sectorLayer.frame = self.bounds
            self.sectorLayer.cornerRadius = radius
            self.sectorLayer.mask?.frame = self.bounds
            self.sectorLayer.mask?.cornerRadius = radius
            self.backgroundLayer.hidden = true
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
            self.status = .None
            if let f = failBlock{
                f()
            }
            self.backgroundLayer.hidden = true
            self.backgroundLayer.path = nil

        } else {
            self.status = .None
        }
    }
    
    public override func animationDidStart(anim: CAAnimation) {
        if progressTimer == nil {
            progressTimer =  NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(UIImageView.animationDoing(_:)), userInfo: nil, repeats: true)
        }
        
        if (self.status != .WillFailed && self.status != .WillCompleted) {
            self.status = .Uploading
        }
    }
    
    public func uploadImage(image:UIImage,progress:Float) {
        self.uploadImage(image, progress: progress, duration: DefaultDuration)
    }
    
    private func uploadImage(image:UIImage,progress:Float,duration:CFTimeInterval) {
        self.uploadImage = image
        
        if self.status == .Uploading && progress < 1.0 || self.status == .Completed  && progress == 1.0{
            return
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            if self.status != .WillFailed {
                self.backgroundLayer.hidden = (progress > 0.0) ? false : true
            }
            
            self.backgroundLayer.frame = self.bounds
            self.sectorLayer.contents = image.CGImage
            self.sectorLayer.frame = self.layerFrame()
            let radius = CGRectGetWidth(self.sectorLayer.frame)/2
            self.sectorLayer.cornerRadius = radius
            self.sectorLayer.masksToBounds = true
            self.addAnimationWith(progress,duration: duration)
        }
    }
    
    public func uploadImageFail() {
        self.uploadImageFail(DefaultDuration)
    }
    
    public func uploadImageFail(duration:CFTimeInterval) {
        
        if self.status == .Completed || self.status == .Failed {
            return
        }
        
        self.status = .WillFailed
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.lastProgress = (self.lastProgress <= 1.0) ? self.lastProgress : 1.0
            
            if let i = self.uploadImage {
                self.uploadImage(i, progress:0.0,duration: duration)
            } else {
                self.status = .None
                print("Not set Upload Image")
            }
        }
        self.sectorLayer.frame = self.layerFrame()
        let radius = CGRectGetWidth(sectorLayer.frame)/2
        
        self.sectorLayer.cornerRadius = radius
        self.sectorLayer.mask?.cornerRadius = radius
        CATransaction.commit()
    }
    
    public func uploadCompleted() {
        self.uploadCompleted(DefaultDuration)
    }
    
    public func uploadCompleted(duration:CFTimeInterval) {
        if self.status == .Completed {
            return
        }
        
        if let i = self.uploadImage {
            self.status = .WillCompleted
            self.uploadImage(i, progress:1.0,duration: duration)
        } else {
            self.status = .None
            print("not set Upload Image")
        }
    }
    
    private func layerFrame() -> CGRect {
        switch self.style {
        case .Sector:
            return CGRectInset(self.bounds, 10, 10)
        case .RoundWith(let lineWdith, _):
            return CGRectInset(self.bounds, lineWdith/2, lineWdith/2)
        default:
            return self.bounds
        }
    }
}

// Animation
extension UIImageView {
    private func addAnimationWith(progress:Float,duration:CFTimeInterval) {
        
        let animation = CABasicAnimation()
        animation.delegate = self
        animation.duration = duration
        animation.removedOnCompletion = false
        animation.setValue("StrokeProgress", forKey: "animationID")
        animation.fromValue = self.animationFromValue()
        animation.toValue = self.animationToValue(progress)
        animation.fillMode = kCAFillModeBoth

        switch self.style {
            case .Sector:
                animation.keyPath = "strokeEnd"
                self.sectorLayer.mask = self.generateMask(nil)
                self.sectorLayer.mask!.addAnimation(animation, forKey: "Sector")
            case .CenterExpand:
                animation.keyPath = "transform.scale"
                self.sectorLayer.mask = self.generateMask(nil)
                self.sectorLayer.mask!.addAnimation(animation, forKey: "CenterExpand")
            case .CenterShrink:
                animation.keyPath = "lineWidth"
                self.sectorLayer.mask = self.generateMask(nil)
                self.sectorLayer.mask!.addAnimation(animation, forKey: "CenterShrink")
            case .RoundWith(let lineWidth, _):
                animation.keyPath = "strokeEnd"
                let resetPro:Float = (self.status == .WillFailed) ? 0.0 : 1.0
                self.sectorLayer.mask = self.generateMask(resetPro)
                let radius = CGRectGetWidth(backgroundLayer.frame)/2
                let bezier = UIBezierPath(roundedRect: backgroundLayer.bounds, cornerRadius:radius)
                self.backgroundLayer.lineWidth = lineWidth
                self.backgroundLayer.path = bezier.CGPath
                self.backgroundLayer.strokeColor = self.maskStrokeColor()
                self.backgroundLayer.fillColor = self.maskFillColor()
                self.backgroundLayer.addAnimation(animation, forKey: "Round")
            case .Wave:
                animation.keyPath = "transform.translation.y"
                
                if waveTimer == nil {
                    self.sectorLayer.mask = self.generateMask(nil)

                    waveTimer =  NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(UIImageView.reDrawWave(_:)), userInfo: nil, repeats: true)
                }
       
                self.sectorLayer.mask!.addAnimation(animation, forKey: "Wave")

        }
        self.lastProgress = progress
    }
    
    func reDrawWave(timer:NSTimer) {
        if let m = self.sectorLayer.mask as? CAShapeLayer{
            m.path = waveObject.generateWavePath(CGFloat(10))
        }
    }
    
    private func animationFromValue() -> AnyObject? {
        switch self.style {
            case .Sector,.CenterExpand:
                return self.lastProgress
            case .CenterShrink:
                let radius = CGRectGetWidth(sectorLayer.frame)/2
                return self.lastProgress * Float(radius*2)
            case .RoundWith(_, _):
                return self.lastProgress
            case .Wave:
                let height = Float(CGRectGetHeight(self.sectorLayer.frame))
                return NSNumber(float:(1-self.lastProgress) * height)
        }
    }
    
    private func animationToValue(progress:Float) -> AnyObject? {
        let progressValue = (self.status == .WillFailed) ? 0 : (progress <= 1.0) ? progress : 1.0
        switch self.style {
            case .Sector,.CenterExpand:
                return progressValue
            case .CenterShrink:
                let radius = CGRectGetWidth(sectorLayer.frame)/2
                return progressValue * Float(radius*2)
            case .RoundWith(_, _):
                return progressValue
            case .Wave:
                let height = Float(CGRectGetHeight(self.sectorLayer.frame))
                return NSNumber(float:(1-progress) * height)
        }
    }
    
    private func generateMask(progress:Float?) -> CAShapeLayer {
        var radius:CGFloat = 0.0
        switch self.style {
            case .Wave:
                radius = 0.0
            default:
                radius = CGRectGetWidth(sectorLayer.frame)/2
        }
        
        let bezier = UIBezierPath(roundedRect: sectorLayer.bounds, cornerRadius:radius)

        let maskLayer = CAShapeLayer()
        if let p = progress {
            maskLayer.strokeEnd = CGFloat(p)
        }
        maskLayer.frame = sectorLayer.bounds
        maskLayer.cornerRadius = radius
        maskLayer.path = bezier.CGPath
        maskLayer.strokeColor = self.maskStrokeColor()
        maskLayer.lineWidth = radius*2
        maskLayer.fillColor =  self.maskFillColor()
        maskLayer.masksToBounds = true
        return maskLayer
    }
    
    private func maskStrokeColor () -> CGColor {
        switch self.style {
            case .Sector,.CenterShrink:
                return UIColor.blueColor().CGColor
            case .CenterExpand:
                return UIColor.clearColor().CGColor
            case .RoundWith(_, let color):
                return color.CGColor
            case .Wave:
                return UIColor.clearColor().CGColor
        }
    }
    
    private func maskFillColor () -> CGColor {
        switch self.style {
            case .CenterExpand:
                return UIColor.blueColor().CGColor
            case .Wave:
                return UIColor.blueColor().CGColor
            default:
                return UIColor.clearColor().CGColor
        }
    }
    
    private func animationProgress () -> Float {
        var value:CGFloat = 0.0
        if let layer = self.sectorLayer.mask?.presentationLayer() as? CAShapeLayer ,
           let background = self.backgroundLayer.presentationLayer() as? CAShapeLayer{
            switch self.style {
                case .Sector:
                    value = layer.strokeEnd
                case .CenterExpand:
                    value = layer.transform.m22
                case .CenterShrink:
                    value = layer.lineWidth/100.0
                case .RoundWith(_, _):
                    value = background.strokeEnd
                case .Wave:
                    value = layer.frame.origin.y
            }
            
            let floatStr = NSString.init(format: "%0.3f", value)
            return floatStr.floatValue
        } else {
            return 0.0
        }
    }
}
