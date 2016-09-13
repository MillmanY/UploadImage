# MMUploadImage

[![CI Status](http://img.shields.io/travis/Millman/MMUploadImage.svg?style=flat)](https://travis-ci.org/Millman/MMUploadImage)
[![Version](https://img.shields.io/cocoapods/v/MMUploadImage.svg?style=flat)](http://cocoapods.org/pods/MMUploadImage)
[![License](https://img.shields.io/cocoapods/l/MMUploadImage.svg?style=flat)](http://cocoapods.org/pods/MMUploadImage)
[![Platform](https://img.shields.io/cocoapods/p/MMUploadImage.svg?style=flat)](http://cocoapods.org/pods/MMUploadImage)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
It's an Extension helper for UIImageView to Upload an image when post to server

1.Set progress and image

    imgView.uploadImage(UIImage.init(named: "app_icon_60")!, progress: progress)
  
2.Set Upload completed With function

    1.imgView.uploadCompleted(2.0) // Duration
    2.imgView.uploadCompleted() // Default Duration 0.3
  
3.Set Upload failed with function

    1.imgView.uploadImageFail(2.0) // Duration
    2.imgView.uploadImageFail() // Default Duration 0.3
        
4.Upload Completed block

    imgView.completedBlock = {
        print("Upload Finish")
    }
  
5.Upload Failed block

    imgView.failBlock = {
      print("Upload Fail")
    }
6.Set Progress Style

    public enum LoadingStyle {
      case Sector
      case CenterExpand
      case CenterShrink
      case RoundWith(lineWdith:CGFloat,lineColor:UIColor)
      case Wave
    }
    

    imgView.style = .Sector

![circledemo](https://github.com/MillmanY/UploadImage/blob/master/midscreen.gif)

    imgView.style = .RoundWith(lineWdith: 5, lineColor: UIColor.yellowColor())

![circledemo](https://github.com/MillmanY/UploadImage/blob/master/RoundMid.gif)

    imgView.style = .Wave
![circledemo](https://github.com/MillmanY/UploadImage/blob/master/wave.gif)


Convenience for Button Image Extension

    public func uploadImage(image: UIImage, progress: Float)
    public func uploadImageFail()
    public func uploadImageFail(duration: CFTimeInterval)
    public func uploadCompleted()
    public func uploadCompleted(duration: CFTimeInterval)
    public func completedBlock(completed: (() -> Void)?)
    public func failedBlock(completed: (() -> Void)?)
    public func setStyle(style: MMUploadImage.LoadingStyle)
    public func setAutoCompleted(isAuto: Bool)

## Installation

MMUploadImage is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MMUploadImage'
```

## Author

Millman, millmanyang@gmail.com

## License

MMUploadImage is available under the MIT license. See the LICENSE file for more info.
