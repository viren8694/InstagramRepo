//
//  SignUpVC.swift
//  FirebaseUsers
//
//  Created by Viren Patel on 3/28/18.
//  Copyright © 2018 Viren Patel. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD
import TWMessageBarManager
import AlamofireImage
import FirebaseStorage

class SignUpVC: UIViewController
{
    @IBOutlet weak var user_image: UIImageView!
    var refDatabase: DatabaseReference!
    var refstorage: StorageReference!
    
    @IBOutlet weak var fullname_tf: kTextFiledPlaceHolder!
    @IBOutlet weak var phonenumber_tf: kTextFiledPlaceHolder!
    @IBOutlet weak var password_tf: kTextFiledPlaceHolder!
    @IBOutlet weak var email_tf: kTextFiledPlaceHolder!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        refDatabase = Database.database().reference()
        refstorage = Storage.storage().reference()
        
        title = "SIGN UP"
        user_image.layer.cornerRadius = user_image.frame.height / 2
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Signup_btn_Action(_ sender: Any)
    {
        if (email_tf.text?.isEmpty)! || (password_tf.text?.isEmpty)! || (fullname_tf.text?.isEmpty)!
        {
            TWMessageBarManager.sharedInstance().showMessage(withTitle: "Required Field", description: "Email, Password and Full name are required field", type: .error)
        }
        else
        {
            SVProgressHUD.show()
            Auth.auth().createUser(withEmail: email_tf.text!, password: password_tf.text!, completion: { (user, error) in
                
                if error == nil
                {
                    if let fuser = user
                    {
                        self.CreateUser(uid: fuser.uid)
                    }
                }
                else
                {
                    SVProgressHUD.dismiss()
                    TWMessageBarManager.sharedInstance().showMessage(withTitle: "Email & Password", description: error?.localizedDescription ?? "", type: .error)
                }
            })
        }
        
    }
    
    func CreateUser(uid: String)
    {
        if let img = user_image.image
        {
            let size = CGSize(width: 110, height: 110)
            let reducedsizeimg = img.af_imageScaled(to: size)
            let data = UIImagePNGRepresentation(reducedsizeimg)
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            let imagename = "UserImage/\(uid).png"
            refstorage = refstorage.child(imagename)
            
            refstorage.putData(data!, metadata: metadata, completion: { (meta, error) in
                if error == nil
                {
                    guard let userImage = meta?.downloadURL()?.absoluteString else{
                        return
                    }
                    let userDic = ["UserId": uid ,"FullName": self.fullname_tf.text!, "Email" : self.email_tf.text!, "Password": self.password_tf.text!, "Phonenumber": self.phonenumber_tf.text ?? "","UserImage": userImage] as [String : Any]
                   
                    self.refDatabase.child("User").child(uid).updateChildValues(userDic)
                    SVProgressHUD.dismiss()
                    
                    TWMessageBarManager.sharedInstance().showMessage(withTitle: "Congratulations", description: "You have Successfully Created your new Account", type: .success)
                    self.GoToTabbarController()
                }
                else
                {
                    print(error?.localizedDescription as! String)
                }
            })
        }
    }
    func GoToTabbarController()
    {
        let obj_TabViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
        self.navigationController?.pushViewController(obj_TabViewController, animated: true)
    }
    
    @IBAction func PickupProfilePicture(_ sender: Any)
    {
        imagePicker.allowsEditing = true
        if imagePicker.sourceType == .camera
        {
            imagePicker.sourceType = .camera
        }
        else
        {
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
}


extension SignUpVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            user_image.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
