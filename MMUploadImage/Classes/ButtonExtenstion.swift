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
    
    private var originalSize:CGSize {
        get {
            if let size = objc_getAssociatedObject(self,&OriginalSize) as? Associated<CGSize> {
                return size.value
            } else {
                let size = CGSizeZero
                self.originalSize = size
                return size
            }
        }
        set {
            objc_setAssociatedObject(self,
                                     &OriginalSize,
                                     Associated<CGSize>(newValue),
                                     .OBJC_ASSOCIATION_RETAIN)
        }
    }
  
    public func uploadImage(image: UIImage, progress: Float) {
        self.setImageSize()
        self.imageView?.uploadImage(image, progress: progress)
    }
    
    public func uploadImageFail() {
        self.imageView?.uploadImageFail()
    }
    
    public func uploadImageFail(duration: CFTimeInterval) {
        self.imageView?.uploadImageFail(duration)
    }
    
    public func uploadCompleted() {
        self.imageView?.uploadCompleted()
    }
    
    public func uploadCompleted(duration: CFTimeInterval) {
        self.imageView?.uploadCompleted(duration)
    }
    
    public func completedBlock(completed:(()-> Void)?) {
        
        self.imageView?.completedBlock = {
            if let c = completed {
                self.setImage(self.reDrawImage(), forState: .Normal)
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
    
    private func reDrawImage() -> UIImage {
        var frame = CGRectZero
        frame.size = self.originalSize
        UIGraphicsBeginImageContext(self.originalSize)
        self.imageView?.uploadImage!.drawInRect(frame)
        let resize = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resize
    }
    
    private func setImageSize() {
        if let size = self.imageView?.frame.size
            where self.originalSize == CGSizeZero {
            self.originalSize = size
        }
    }
}