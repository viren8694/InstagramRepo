//
//  UsersVC.swift
//  FirebaseUsers
//
//  Created by Viren Patel on 3/31/18.
//  Copyright © 2018 Viren Patel. All rights reserved.
//

import UIKit
import SDWebImage

class UsersVC: UIViewController {

    @IBOutlet weak var Users_tableview: UITableView!
    var arrUsers: Array<User>?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Users"
        GetTableData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func GetTableData()
    {
        GoogleDatahandler.SharedInstance.getAllUsers { (UsersArr) in
            self.arrUsers = UsersArr
            DispatchQueue.main.async {
                self.Users_tableview.reloadData()
            }
        }
    }
}

extension UsersVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrUsers == nil
        {
            return 0
        }
        else
        {
            return (arrUsers?.count)!
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UsersTableViewCell
        let user = arrUsers![indexPath.row]
        cell.user_email.text = user.Email
        cell.user_name.text = user.FullName
        let url = URL(string: user.UserImage!)
        cell.user_img.sd_setImage(with: url!, completed: nil)
        cell.follow_btn.isSelected = GoogleDatahandler.SharedInstance.currentuser.following.contains(user.UserId!)
        cell.follow_btn.tag = indexPath.row
        
        cell.follow_btn.addTarget(self, action: #selector(followbtnAction), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "Suggestions For You"
    }
    
    @objc func followbtnAction(sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        let userProfile = arrUsers?[sender.tag]
        let uid = CurrentUser.sharedInstance.userId
        if !sender.isSelected
        {
            GoogleDatahandler.SharedInstance.removeuserformfollowing(uid: uid!, followinguid: (userProfile?.UserId!)!)
        }
        else
        {
            GoogleDatahandler.SharedInstance.followUser(uid: uid!, followinguid: (userProfile?.UserId!)! )
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.white
    }
}

