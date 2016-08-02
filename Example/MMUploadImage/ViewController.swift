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
    var progress:Float =  0.0
    lazy var selectImage:UIImage = {
        let img = UIImage.init(named: "app_icon_60")!
        return img
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        seg.selectedSegmentIndex = 0

        self.imgView.completedBlock = {
            print("Upload Finish")
        }
        
        self.imgView.failBlock = {
            print("Upload Fail")
        }
    }
    
    func reset() {
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
    }
    
    @IBAction func faileAction (){
        progress = 0.0
        self.imgView.uploadImageFail()
    }
    
    @IBAction func addAction() {
        progress = (progress + 0.14 <= 1.0) ? progress + 0.14 : 1.0
        self.imgView.uploadImage(selectImage, progress: progress)
    }
    
    @IBAction func completedAction () {
        self.imgView.uploadCompleted()
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
        self.imgView.uploadImageFail()
        switch segment.selectedSegmentIndex {
        case 0:
            imgView.style = .Sector
        case 1:
            imgView.style = .CenterExpand
        case 2:
            imgView.style = .CenterShrink
        default:break
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if  let img = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.progress = 0.1
            self.selectImage = img
            self.imgView.uploadImage(selectImage, progress: progress)

        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
