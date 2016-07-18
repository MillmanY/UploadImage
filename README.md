# UploadImage
It's a Extension helper for UIImageView to Upload a image when post to server

1.Set progress and image

  self.imgView.uploadImage(UIImage.init(named: "app_icon_60")!, progress: progress)
  
2.set Upload completed With function

  self.imgView.uploadCompleted()
  
3.set Upload failed with function

  self.imgView.uploadImageFail()
        
4.Upload Completed block

  self.imgView.completedBlock = {
        print("Upload Finish")
  }
5.Upload Failed block
  self.imgView.failBlock = {
      print("Upload Fail")
  }
