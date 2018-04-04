//
//  ViewController.swift
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
import GoogleSignIn

class SignInViewController: BaseViewController, GIDSignInDelegate, GIDSignInUIDelegate
{
    @IBOutlet weak var password_txtfield: kTextFiledPlaceHolder!
    @IBOutlet weak var eamil_txtfield: kTextFiledPlaceHolder!
    var refDatabase: DatabaseReference!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        refDatabase = Database.database().reference()
    }
    
    
    @IBAction func GoogleLogin(_ sender: Any)
    {
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if error != nil {
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Sign-In Failure", description: error?.localizedDescription, type: .error)
                return
            }
            else
            {
                if let userdata = user
                {
                    let userDic = ["UserId": userdata.uid ,"FullName": userdata.displayName ?? "", "Email" : userdata.email!, "Password": "", "Phonenumber": userdata.phoneNumber ?? "","UserImage": userdata.photoURL?.absoluteString ?? ""] as [String : Any]
                    self.refDatabase.child("User").child(userdata.uid).updateChildValues(userDic, withCompletionBlock: { (error, ref) in
                        if error != nil
                        {
                            print(error?.localizedDescription)
                        }
                        else
                        {
                            TWMessageBarManager.sharedInstance().showMessage(withTitle: "Success", description: "You have succesfully created account", type: .success)
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func SignIn_btn(_ sender: Any)
    {
        if (eamil_txtfield.text?.isEmpty)! || (password_txtfield.text?.isEmpty)!
        {
            TWMessageBarManager.sharedInstance().showMessage(withTitle: "Required Feild", description: "Please Enter Email and Password", type: .error)
            
        }
        else
        {
            SVProgressHUD.show()
            Auth.auth().signIn(withEmail: eamil_txtfield.text!, password: password_txtfield.text!, completion: { (user, error) in
                SVProgressHUD.dismiss()
                if error == nil
                {
                    self.AfterLoginController()
                }
                else
                {
                    TWMessageBarManager.sharedInstance().showMessage(withTitle: "Email & Password", description: error?.localizedDescription ?? "Please Enter Correct Email & Password.", type: .error)
                }
            })
        }
    }
    
    func AfterLoginController()
    {
        let obj_TabViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
        self.navigationController?.pushViewController(obj_TabViewController, animated: true)
    }
    
    @IBAction func SignUp_btn_action(_ sender: Any)
    {
        let obj_SignUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(obj_SignUpVC, animated: true)
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

