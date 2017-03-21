//
//  Post.swift
//  InstagramDemo
//
//  Created by Bconsatnt on 3/20/17.
//  Copyright © 2017 Bconsatnt. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject {
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let post = PFObject(className: "Post")
        
        // Add relevant fields to the object
        post["media"] = getPFFileFromImage(image: image) // PFFile column type
        post["author"] = PFUser.current() // Pointer column type that points to PFUser\
        post["poster"] = PFUser.current()!.username!
        print(PFUser.current()!.username!)
        post["caption"] = caption
        post["likesCount"] = 0
        post["commentsCount"] = 0
        post["createdTime"] = Date()
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackground(block: completion)
    }
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
}
