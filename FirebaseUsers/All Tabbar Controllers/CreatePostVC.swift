//
//  CreatePostVC.swift
//  FirebaseUsers
//
//  Created by Viren Patel on 4/3/18.
//  Copyright © 2018 Viren Patel. All rights reserved.
//

import UIKit

class CreatePostVC: UIViewController
{
    @IBOutlet weak var location_txt: UITextField!
    @IBOutlet weak var caption_text: UITextView!
    @IBOutlet weak var post_img: UIImageView!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(sharePostAction))
        // Do any additional setup after loading the view.
    }
    
//    @objc func sharePostAction()
//    {
//        if post_img.image == nil
//        {
//            TWMessageBarManager.sharedInstance().showMessage(withTitle: "Post Image", description: "Please selcte the post image", type: .error)
//        }
//        else if caption_text.text == "write a caption...." || caption_text.text == ""
//        {
//            TWMessageBarManager.sharedInstance().showMessage(withTitle: "Caption", description: "Please decribe your post with few words", type: .error)
//        }
//        else
//        {
//            if let userid = Auth.auth().currentUser?.uid
//            {
//                SVProgressHUD.show()
//                GoogleDatahandler.SharedInstance.CreatePost(img: post_img.image!, caption: caption_text.text, userid: userid, Location: location_txt.text ?? "")
//                let tabBarController = TabViewController()
//                self.tabBarController?.selectedIndex = 0
//            }
//            else
//            {
//                print("Error")
//            }
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func CallImagePicker()
//    {
//        imagePicker.allowsEditing = true
//        if imagePicker.sourceType == .camera
//        {
//            imagePicker.sourceType = .camera
//        }
//        else
//        {
//            imagePicker.sourceType = .photoLibrary
//        }
//        present(imagePicker, animated: true, completion: nil)
//    }
}
