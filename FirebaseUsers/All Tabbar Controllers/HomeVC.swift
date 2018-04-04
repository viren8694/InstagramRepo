//
//  HomeVC.swift
//  FirebaseUsers
//
//  Created by Viren Patel on 3/31/18.
//  Copyright © 2018 Viren Patel. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import GooglePlaces
import GoogleSignIn

class HomeVC: UIViewController
{
    @IBOutlet weak var post_tableview: UITableView!
    var Posrarr: Array<Post>?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        GetCurrentUserProfile()
       // GetAllPosts()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func GetCurrentUserProfile()
    {
        if let uid = Auth.auth().currentUser?.uid
        {
            GoogleDatahandler.SharedInstance.fetchCurrentUserData(uid: uid, completion: { (obj_currentUser, error) in
                print(obj_currentUser.email)
                print(obj_currentUser.fullname ?? "No Full name")
                print(obj_currentUser.following.count)
            })
        }
        else if let uid = GIDSignIn.sharedInstance().currentUser.userID
        {
            GoogleDatahandler.SharedInstance.fetchCurrentUserData(uid: uid, completion: { (obj_currentUser, error) in
                print(obj_currentUser.email)
            })
        }
    }
    
    func GetAllPosts()
    {
        GoogleDatahandler.SharedInstance.getAllPost { (postarr) in
            self.Posrarr = postarr
            
            DispatchQueue.main.async {
                self.post_tableview.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        post_tableview.reloadData()
    }
    

    @IBAction func AddNewPost(_ sender: Any)
    {
        let obj_CreatePostVC = self.storyboard?.instantiateViewController(withIdentifier: "CreatePostVC") as! CreatePostVC
        self.navigationController?.pushViewController(obj_CreatePostVC, animated: true)
    }
    
}
extension HomeVC: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard let arr = Posrarr else
        {
            return 0
        }
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postcell") as! PostTableViewCell
        cell.post_description.text = Posrarr![indexPath.row].PostDescription
        let url = URL(string: Posrarr![indexPath.row].PostImage)
        cell.post_image.sd_setImage(with: url!, completed: nil)
        let userid = Posrarr![indexPath.row].UserId
        GoogleDatahandler.SharedInstance.getUserData(userid: userid) { (User) in
            let url = URL(string: (User?.UserImage)!)
            cell.user_name.text = (User?.FullName)!
            cell.user_image.sd_setImage(with: url!, completed: nil)
        }
        return cell
    }
}
