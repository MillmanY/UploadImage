//
//  ImageUpload.swift
//  ImageExtensionTest
//
//  Created by MILLMAN on 2016/7/14.
//  Copyright © 2016年 MILLMAN. All rights reserved.
//

import UIKit


public final class Associated<T>: NSObject {
    public typealias `Type` = T
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
}

private var SECTORLAYER   = "SectorKey"
private var MaskLayer = "MaskKey"
private var ProgressAnimate = "AnimateKey"
private var LastProgress = "ProgressKey"
private var IsStartAnimate = "StartKey"
private var BackgroundLayer = "BackgroundLayer"
private var UploadImage = "ImageKey"
private var AutoCompleted = "AutoCompletedKey"
private var CompletedBlock = "CompletedKey"
private var FailBlock = "FailKey"
private var UploadKey = "UploadKey"
private var StyleKey  = "StyleKey"

// Var
public extension UIImageView {
    var style:LoadingStyle {
        get {
            if let current = objc_getAssociatedObject(self,
                                                      &StyleKey) as? Associated<LoadingStyle> {
                return current.value
            } else {
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
                layer.cornerRadius = self.bounds.width/2
                layer.masksToBounds = true
                layer.backgroundColor = UIColor.black().withAlphaComponent(0.5).cgColor
                layer.isHidden = true
                self.backgroundLayer = layer
                return layer
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
                self.style = .Sector
                return self.sectorLayer
            }
        }
    }
    
    var lastProgress:Float {
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

public extension UIImageView {
    
    public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
        if lastProgress >= 1.0 && autoCompleted || self.status == .WillCompleted {
            
            if !flag {
                return
            }
            self.status = .Completed
            self.image =  self.uploadImage
            let radius = self.bounds.width/2
            self.sectorLayer.frame = self.bounds
            self.sectorLayer.cornerRadius = radius
            self.sectorLayer.mask?.frame = self.bounds
            self.sectorLayer.mask?.cornerRadius = radius
            self.backgroundLayer.isHidden = true
            if let c = completedBlock {
                c()
            }
        } else if (lastProgress <= 0.0) {
            if !flag {
                return
            }
            self.status = .Failed
            if let f = failBlock{
                f()
            }
            
            self.backgroundLayer.isHidden = true
        } else {
            self.status = .None
        }
    }
    
    public override func animationDidStart(anim: CAAnimation) {
        if (self.status != .WillFailed && self.status != .WillCompleted) {
            self.status = .Uploading
        }
    }
    
    public func uploadImage(image:UIImage,progress:Float) {
        self.uploadImage = image
        
        if self.status == .Uploading && progress < 1.0 || self.status == .Completed  && progress == 1.0{
            return
        }
        
        DispatchQueue.main.async {
            self.backgroundLayer.isHidden = (progress > 0.0) ? false : true
            self.backgroundLayer.frame = self.bounds
            self.sectorLayer.contents = image.cgImage
            self.sectorLayer.frame = self.layerFrame()
            let radius = self.sectorLayer.frame.width/2
            self.sectorLayer.cornerRadius = radius
            self.sectorLayer.masksToBounds = true
            self.addAnimationWith(progress: progress)
        }
    }
    
    public func uploadImageFail() {
        
        if self.status == .Completed {
            return
        }
        
        self.status = .WillFailed
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.lastProgress = (self.lastProgress <= 1.0) ? self.lastProgress : 1.0
            
            if let i = self.uploadImage {
                //                self.uploadImage(i, progress:0.0)
                self.uploadImage(image: i, progress: 0.0)
            } else {
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
        if self.status == .Completed {
            return
        }
        
        if let i = self.uploadImage {
            self.status = .WillCompleted
            self.uploadImage(image: i, progress:1.0)
        } else {
            print("not set Upload Image")
        }
    }
    
    private func layerFrame() -> CGRect {
        switch self.style {
        case .Sector:
            return self.bounds.insetBy(dx: 10, dy: 10)
        default:
            return self.bounds
        }
    }
}

// Animation
extension UIImageView {
    private func addAnimationWith(progress:Float) {
        
        let animation = CABasicAnimation()
        animation.delegate = self
        animation.duration = 0.3
        animation.isRemovedOnCompletion = false
        animation.setValue("StrokeProgress", forKey: "animationID")
        animation.fromValue = self.animationFromValue()
        animation.toValue = self.animationToValue(progress: progress)
        switch self.style {
        case .Sector:
            animation.keyPath = "strokeEnd"
            self.sectorLayer.mask = self.generateMask(progress: progress)
        case .CenterExpand:
            animation.keyPath = "transform.scale"
            self.sectorLayer.mask = self.generateMask(progress: progress)
        case .CenterShrink:
            animation.keyPath = "lineWidth"
        }
        animation.fillMode = kCAFillModeBoth
        self.sectorLayer.mask = self.generateMask(progress: progress)
        self.sectorLayer.mask!.add(animation, forKey: "Stroke")
        self.lastProgress = progress
    }
    
    private func animationFromValue() -> AnyObject? {
        switch self.style {
        case .Sector,.CenterExpand:
            return self.lastProgress
        case .CenterShrink:
            let radius = sectorLayer.frame.width/2
            return self.lastProgress * Float(radius*2)
        }
    }
    
    private func animationToValue(progress:Float) -> AnyObject? {
        let progressValue = (self.status == .Failed) ? 0 : (progress <= 1.0) ? progress : 1.0
        switch self.style {
        case .Sector,.CenterExpand:
            return progressValue
        case .CenterShrink:
            let radius = sectorLayer.frame.width/2
            return progressValue * Float(radius*2)
        }
    }
    
    private func generateMask(progress:Float) -> CAShapeLayer {
        let radius = sectorLayer.frame.width/2
        let bezier = UIBezierPath(roundedRect: sectorLayer.bounds, cornerRadius:radius)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = sectorLayer.bounds
        maskLayer.cornerRadius = radius
        maskLayer.path = bezier.cgPath
        maskLayer.strokeColor = self.maskStrokeColor()
        maskLayer.lineWidth = radius*2
        if self.style != .CenterShrink {
            maskLayer.strokeEnd = CGFloat(progress)
        }
        maskLayer.fillColor =  self.maskFillColor()
        maskLayer.masksToBounds = true
        return maskLayer
    }
    
    private func maskStrokeColor () -> CGColor {
        switch self.style {
        case .Sector:
            return UIColor.blue().cgColor
        case .CenterExpand:
            return UIColor.clear().cgColor
        case .CenterShrink:
            return UIColor.blue().cgColor
        }
    }
    
    private func maskFillColor () -> CGColor {
        switch self.style {
        case .Sector:
            return UIColor.clear().cgColor
        case .CenterExpand:
            return UIColor.blue().cgColor
        case .CenterShrink:
            return UIColor.clear().cgColor
        }
    }
}

