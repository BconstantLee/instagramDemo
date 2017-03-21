//
//  ComposeViewController.swift
//  InstagramDemo
//
//  Created by Bconsatnt on 3/20/17.
//  Copyright © 2017 Bconsatnt. All rights reserved.
//

import UIKit
import MBProgressHUD


class ComposeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var captionLabel: UITextField!
    @IBOutlet weak var imageCell: UIImageView!
    var lastView: GalleryViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onSubmit(_ sender: AnyObject) {
        MBProgressHUD.showAdded(to: self.view, animated: true)

        Post.postUserImage(image: imageCell.image, withCaption: captionLabel.text) { (success:Bool, error:Error?) in
            if success {
                print("upload success")
                MBProgressHUD.hide(for: self.view, animated: true)
                self.lastView.refreshControl = UIRefreshControl()
                self.dismiss(animated: true, completion: nil)
                self.lastView.refreshControlAction(self.lastView.refreshControl)
            } else {
                print("upload fail")
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    @IBAction func takePhoto(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.camera
            self.present(vc, animated: true, completion: nil)
        } else {print("Camera unavailable")}
    }
    @IBAction func choosePhoto(_ sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
//        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        let imgData: NSData = NSData(data: UIImageJPEGRepresentation((editedImage), 1)!)
        let imageSize: Int = imgData.length
        if imageSize > 10485760
        {
            let newImage = resize(image: editedImage, newSize: CGSize(width: 4600, height: 2220))
            imageCell.image = newImage
        } else {imageCell.image = editedImage}
        
        // Do something with the images (based on your use case)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
}
