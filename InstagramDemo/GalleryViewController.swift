//
//  GalleryViewController.swift
//  InstagramDemo
//
//  Created by Bconsatnt on 3/20/17.
//  Copyright © 2017 Bconsatnt. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import MBProgressHUD

class GalleryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var posts: [PFObject] = []
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource=self
        tableView.delegate=self
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.red
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        refreshControlAction(refreshControl)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let post = posts[indexPath.row]
        cell.captionLabel.text=post["caption"] as? String
        cell.captionLabel.sizeToFit()
        let poster = post["poster"] as! String
        cell.posterLabel.text=poster
        cell.posterLabel.sizeToFit()
//        cell.timeLabel.text=post["createdAt"] as! String?
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm y"
        let dateString = formatter.string(from:post["createdTime"] as! Date)
        cell.timeLabel.text = dateString
        cell.timeLabel.sizeToFit()
        cell.imageCell.file = post["media"] as? PFFile
        cell.imageCell.loadInBackground()
//        print("\(post["createdTime"])")
        return cell
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        // Configure session so that completion handler is executed on main UI thread

            
            // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) -> Void in
            if let posts = posts {
                // do something with the data fetched
                self.posts = posts
                MBProgressHUD.hide(for: self.view, animated: true)
                self.tableView.reloadData()
                refreshControl.endRefreshing()
            } else {
                // handle error
                print(error?.localizedDescription)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(_ sender: AnyObject) {
        PFUser.logOutInBackground { (error:Error?) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                print("Logout success")
                NotificationCenter.default.post(name: User.userDidLogoutNotification, object: nil)
            }
        }

    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "composeSegue" {
            let navController = segue.destination as! UINavigationController
            let destination = navController.topViewController as! ComposeViewController
            destination.lastView = self
        }
        
    }
    

}
