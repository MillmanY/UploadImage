# MMUploadImage

[![CI Status](http://img.shields.io/travis/Millman/MMUploadImage.svg?style=flat)](https://travis-ci.org/Millman/MMUploadImage)
[![Version](https://img.shields.io/cocoapods/v/MMUploadImage.svg?style=flat)](http://cocoapods.org/pods/MMUploadImage)
[![License](https://img.shields.io/cocoapods/l/MMUploadImage.svg?style=flat)](http://cocoapods.org/pods/MMUploadImage)
[![Platform](https://img.shields.io/cocoapods/p/MMUploadImage.svg?style=flat)](http://cocoapods.org/pods/MMUploadImage)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

# UploadImage
It's a Extension helper for UIImageView to Upload a image when post to server

1.Set progress and image

    self.imgView.uploadImage(UIImage.init(named: "app_icon_60")!, progress: progress)
  
2.Set Upload completed With function

    self.imgView.uploadCompleted()
  
3.Set Upload failed with function

    self.imgView.uploadImageFail()
        
4.Upload Completed block

    self.imgView.completedBlock = {
        print("Upload Finish")
    }
  
5.Upload Failed block

    self.imgView.failBlock = {
      print("Upload Fail")
    }
  
![circledemo](https://github.com/MillmanY/UploadImage/blob/master/screen.gif)

## Installation

MMUploadImage is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MMUploadImage"
```

## Author

Millman, millmanyang@gmail.com

## License

MMUploadImage is available under the MIT license. See the LICENSE file for more info.
