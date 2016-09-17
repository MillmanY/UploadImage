//
//  ButtonExtenstion.swift
//  Pods
//
//  Created by MILLMAN on 2016/9/12.
//
//
import UIKit
private var OriginalSize = "OriginalSizeKey"
public extension UIButton {
    
    fileprivate var originalSize:CGSize {
        get {
            if let size = objc_getAssociatedObject(self,&OriginalSize) as? CGSize {
                return size
            } else {
                let size = CGSize.zero
                self.originalSize = size
                return size
            }
        }
        set {
            objc_setAssociatedObject(self,&OriginalSize,newValue,.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func uploadImage(image: UIImage, progress: Float) {
        self.setImageSize()
        self.imageView?.uploadImage(image:image, progress: progress)
    }
    
    public func uploadImageFail() {
        self.imageView?.uploadImageFail()
    }
    
    public func uploadImageFail(duration: CFTimeInterval) {
        self.imageView?.uploadImageFail(duration: duration)
    }
    
    public func uploadCompleted() {
        self.imageView?.uploadCompleted()
    }
    
    public func uploadCompleted(duration: CFTimeInterval) {
        self.imageView?.uploadCompleted(duration: duration)
    }
    
    public func completedBlock(completed:(()-> Void)?) {
        
        self.imageView?.completedBlock = {
            if let c = completed {
                self.setImage(self.reDrawImage(), for: .normal)
                c()
            }
        }
    }
    
    public func failedBlock(completed:(()-> Void)?) {
        self.imageView?.failBlock = completed
    }
    
    public func setStyle(style:LoadingStyle) {
        self.imageView?.style = style
    }
    
    public func setAutoCompleted(isAuto:Bool) {
        self.imageView?.autoCompleted = isAuto
    }
    
    fileprivate func reDrawImage() -> UIImage {
        var frame = CGRect.zero
        frame.size = self.originalSize
        UIGraphicsBeginImageContext(self.originalSize)
        self.imageView?.uploadImage!.draw(in: frame)
        let resize = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resize!
    }
    
    fileprivate func setImageSize() {
        if let size = self.imageView?.frame.size
            , self.originalSize == CGSize.zero {
            self.originalSize = size
        }
    }
}
