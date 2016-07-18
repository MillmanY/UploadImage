//
//  ViewController.swift
//  ImageExtensionTest
//
//  Created by MILLMAN on 2016/7/7.
//  Copyright © 2016年 MILLMAN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imgView:UIImageView!
    var progress:Float =  0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.imgView.uploadImage(UIImage.init(named: "app_icon_60")!, progress: 0.4)
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.imgView.completedBlock = {
            print("Upload Finish")
        }
        
        self.imgView.failBlock = {
            print("Upload Fail")
        }
    }
    
    func reset() {
        self.imgView.uploadImage(UIImage.init(named: "app_icon_60")!, progress: progress)
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
        self.imgView.uploadImage(UIImage.init(named: "app_icon_60")!, progress: progress)
    }
    
    @IBAction func completedAction () {
        self.imgView.uploadCompleted()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
