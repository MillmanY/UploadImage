//
//  ViewController.swift
//  ImageExtensionTest
//
//  Created by MILLMAN on 2016/7/7.
//  Copyright © 2016年 MILLMAN. All rights reserved.
//

import UIKit
import MMUploadImage
class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
   
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var seg:UISegmentedControl!
    @IBOutlet weak var demoBtn:UIButton!
    
    var progress:Float =  0.0
    lazy var selectImage:UIImage = {
        let img = UIImage.init(named: "app_icon_60")!
        return img
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        seg.selectedSegmentIndex = 0

        self.imgView.completedBlock = {
            print("Upload image Finish")
        }
        
        self.imgView.failBlock = {
            print("Upload image Fail")
        }
        
        demoBtn.failedBlock { 
            print("Upload Button Failed")
        }
        
        demoBtn.completedBlock { 
            print("Upload Button Finish")
        }
    }
    
    func reset() {
        self.demoBtn.uploadImage(selectImage, progress: progress)
        self.imgView.uploadImage(selectImage, progress: progress)
        if(progress <= 1.0) {
            self.performSelector("reset", withObject: nil, afterDelay: 0.3)
        }
        progress += 0.1

    }
    
    @IBAction func autoAddAction () {
        
        if progress == 1.0 {
            progress = 0.0
        }
        
        progress = (progress + 0.14 <= 1.0) ? progress + 0.14 : 1.0
        self.reset()
        self.imgView.autoCompleted = true
        self.demoBtn.setAutoCompleted(true)
    }
    
    @IBAction func faileAction (){
        progress = 0.0
        self.imgView.uploadImageFail()
        self.demoBtn.uploadImageFail()
    }
    
    @IBAction func addAction() {
        progress = (progress + 0.14 <= 1.0) ? progress + 0.14 : 1.0
        self.imgView.uploadImage(selectImage, progress: progress)
        self.demoBtn.uploadImage(selectImage, progress: progress)
    }
    
    @IBAction func completedAction () {
        self.imgView.uploadCompleted()
        self.demoBtn.uploadCompleted()
    }

    @IBAction func selectImageAction () {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .PhotoLibrary
        picker.videoQuality = .TypeLow;
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func segmentAction(segment:UISegmentedControl) {
        progress = 0.0
        self.demoBtn.uploadImageFail()
        self.imgView.uploadImageFail()
        switch segment.selectedSegmentIndex {
        case 0:
            demoBtn.setStyle(.Sector)
            imgView.style = .Sector
        case 1:
            demoBtn.setStyle(.CenterExpand)
            imgView.style = .CenterExpand
        case 2:
            demoBtn.setStyle(.CenterShrink)
            imgView.style = .CenterShrink
        case 3:
            demoBtn.setStyle(.RoundWith(lineWdith: 5, lineColor: UIColor.yellowColor()))
            imgView.style = .RoundWith(lineWdith: 5, lineColor: UIColor.yellowColor())
        case 4:
            demoBtn.setStyle(.Wave)
            imgView.style = .Wave
        default:break
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if  let img = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.progress = 0.1
            self.selectImage = img
            self.imgView.uploadImage(selectImage, progress: progress)
            self.demoBtn.uploadImage(selectImage, progress: progress)

        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
