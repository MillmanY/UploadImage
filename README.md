# MMUploadImage

[![CI Status](http://img.shields.io/travis/Millman/MMUploadImage.svg?style=flat)](https://travis-ci.org/Millman/MMUploadImage)
[![Version](https://img.shields.io/cocoapods/v/MMUploadImage.svg?style=flat)](http://cocoapods.org/pods/MMUploadImage)
[![License](https://img.shields.io/cocoapods/l/MMUploadImage.svg?style=flat)](http://cocoapods.org/pods/MMUploadImage)
[![Platform](https://img.shields.io/cocoapods/p/MMUploadImage.svg?style=flat)](http://cocoapods.org/pods/MMUploadImage)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
It's an Extension helper for UIImageView to Upload a image when post to server

1.Set progress and image

    imgView.uploadImage(UIImage.init(named: "app_icon_60")!, progress: progress)
  
2.Set Upload completed With function

    imgView.uploadCompleted()
  
3.Set Upload failed with function

    self.imgView.uploadImageFail()
        
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
    }
    
    imgView.style = .Sector

![circledemo](https://github.com/MillmanY/UploadImage/blob/master/midscreen.gif)

## Installation

MMUploadImage is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MMUploadImage'
```

### Setting up with Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate UploadImage into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "Dershowitz011/UploadImage" "Swift3"
```


## Author

Millman, millmanyang@gmail.com

## License

MMUploadImage is available under the MIT license. See the LICENSE file for more info.
