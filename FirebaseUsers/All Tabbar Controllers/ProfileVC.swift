//
//  ProfileVC.swift
//  FirebaseUsers
//
//  Created by Viren Patel on 3/31/18.
//  Copyright © 2018 Viren Patel. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController
{
    
    @IBOutlet weak var user_image: UIImageView!
    var user_profile: User?
    @IBOutlet weak var posts_lbl: UILabel!
    @IBOutlet weak var user_name_lbl: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        user_image.layer.cornerRadius = user_image.frame.size.height / 2
        GetUserProfileData()
        
        print(CurrentUser.sharedInstance)
        print(CurrentUser.sharedInstance.email)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Edit_profile_btn(_ sender: Any)
    {
        
    }
    func GetUserProfileData()
    {
        GoogleDatahandler.SharedInstance.getUserProfile { (userprofile) in
            if let url = URL(string: (userprofile?.UserImage)!)
            {
                DispatchQueue.global().async
                {
                    if let data = try? Data(contentsOf: url)
                    {
                        DispatchQueue.main.async {
                            self.user_image.image = UIImage(data: data)
                        }
                    }
                }
                self.user_name_lbl.text = userprofile?.FullName
            }
        }
    }
}

