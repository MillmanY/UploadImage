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
            print("Upload image Finish")
        }
        
        self.imgView.failBlock = {
            print("Upload image Fail")
        }
    }
    
    @objc
    func reset() {
        self.imgView.uploadImage(image:selectImage, progress: progress)
        if(progress <= 1.0) {
            self.perform(#selector(ViewController.reset), with: nil, afterDelay: 0.3)
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
        self.imgView.uploadImage(image:selectImage, progress: progress)
    }
    
    @IBAction func completedAction () {
        self.imgView.uploadCompleted()
    }

    @IBAction func selectImageAction () {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.videoQuality = .typeLow;
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func segmentAction(_ segment:UISegmentedControl) {
        progress = 0.0
        self.imgView.uploadImageFail()
        switch segment.selectedSegmentIndex {
        case 0:
            imgView.style = .sector
        case 1:
            imgView.style = .centerExpand
        case 2:
            imgView.style = .centerShrink
        case 3:
            imgView.style = .roundWith(lineWdith: 5, lineColor: UIColor.yellow)
        case 4:
            imgView.style = .wave
        default:break
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if  let img = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.progress = 0.1
            self.selectImage = img
            self.imgView.uploadImage(image:selectImage, progress: progress)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
