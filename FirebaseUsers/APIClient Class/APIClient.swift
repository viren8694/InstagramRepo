//
//  APIClient.swift
//  FirebaseUsers
//
//  Created by Viren Patel on 3/31/18.
//  Copyright © 2018 Viren Patel. All rights reserved.
//
typealias completionHandler = ([User]?) -> ()
typealias userprofilecompletionHandler = (User?) -> ()
typealias postscompletionHandler = ([Post]?) -> ()
typealias FetchCurrentUserResultHandler = (CurrentUser, String?) -> ()

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import AlamofireImage
import SVProgressHUD
import TWMessageBarManager

class GoogleDatahandler: NSObject
{
    private override init(){}
    static let SharedInstance = GoogleDatahandler()
    var currentuser = CurrentUser.sharedInstance
    var refstorage: StorageReference?
    var refDatabase = Database.database().reference()
    
    func getAllUsers(completion: @escaping completionHandler)
    {
        if let userid = Auth.auth().currentUser?.uid
        {
            refDatabase.child("User").observeSingleEvent(of: .value, with: { (snapshot) in
                guard let value = snapshot.value as? Dictionary<String,Any> else
                {
                    return
                }
                var arr: Array<User> = []
                for item in value
                {
                    if let userdata = item.value as? Dictionary<String,String>
                    {
                        if userdata["UserId"] == userid
                        {
                            
                        }
                        else
                        {
                            arr.append(User(UserId: userdata["UserId"], FullName: userdata["FullName"], UserImage: userdata["UserImage"], Email: userdata["Email"]))
                        }
                    }
                }
                completion(arr)
            })
        }
        else
        {
            completion(nil)
        }
    }
    
    func getUserProfile(completion: @escaping userprofilecompletionHandler )
    {
        if let userid = Auth.auth().currentUser?.uid
        {
            refDatabase.child("User/\(userid)").observeSingleEvent(of: .value, with: { (snapshot) in
                guard let value = snapshot.value as? Dictionary<String,String> else
                {
                    return
                }
                var obj_User_profile: User?
                print(value)
                obj_User_profile = User(UserId: value["UserId"], FullName: value["FullName"], UserImage: value["UserImage"], Email: value["Email"])
                completion(obj_User_profile)
            })
        }
        else
        {
            completion(nil)
        }
    }
    
    
    func fetchCurrentUserData(uid: String, completion: FetchCurrentUserResultHandler?) {
        var errorMessage: String?
        //refDatabase = Database.database().reference()
        //guard let id = Auth.auth().currentUser?.uid else { return }
        
        refDatabase.child("User/\(uid)").observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let strongSelf = self else { return }
            
            if let userObj = snapshot.value as? Dictionary<String,Any?>,
                let fullName = userObj["FullName"],
                let email = userObj["Email"],
                let password = userObj["Password"],
                let phoneNumber = userObj["Phonenumber"],
                let userimageStr = userObj["UserImage"]
            {
                strongSelf.currentuser.userId = uid
                strongSelf.currentuser.fullname = fullName as? String
                strongSelf.currentuser.email = email as! String
                strongSelf.currentuser.UserImage = userimageStr as? String
                strongSelf.currentuser.password = password as? String
                strongSelf.currentuser.phoneNumber = phoneNumber as? String
                
                self?.refDatabase.child("User/\(uid)").observe(.value, with: { (snapshot) in
                    if let publicUserDict = snapshot.value as? [String: Any] {
                        if let followingDict = publicUserDict["following"] as? [String: Bool] {
                            for val in followingDict{
                                strongSelf.currentuser.following.append(val.key)
                            }
                        }
                        else {
                            errorMessage = "No following users"
                        }
                        completion?((self?.currentuser)!, errorMessage)
                        
                    } else {
                        errorMessage = "Error pasing public user data"
                    }
                })
 
            } else {
                errorMessage = "Error pasing user data"
            }
        }
    }
    func CreatePost(img: UIImage, caption: String,userid: String, Location: String?)
    {
        refDatabase = Database.database().reference()
        refstorage = Storage.storage().reference()
        let reducedsizeimg = img.af_imageScaled(to: CGSize(width: 426, height: 240))
        let data = UIImagePNGRepresentation(reducedsizeimg)
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        let postkey = refDatabase.child("Post").childByAutoId().key
        print(postkey)
        let imagename = "PostImage/\(postkey).png"
        refstorage = refstorage?.child(imagename)
        let timestamp = Date().timeIntervalSince1970
        let PostDic = ["UserId": userid ,"PostDescription": caption, "PostImage" : "", "Location": Location ?? "", "Timestamp": timestamp] as [String : Any]
        self.refDatabase.child("Post").child(postkey).updateChildValues(PostDic)
            self.refstorage?.putData(data!, metadata: metadata, completion: { (meta, error) in
                SVProgressHUD.dismiss()
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Congratulations", description: "You have succesfully created a post", type: .success)
                if error == nil
                {
                    if let imageData = meta?.downloadURL()?.absoluteString
                    {
                        self.refDatabase.child("Post/\(postkey)/PostImage").setValue(imageData)
                        
                    }
                }
            })
    }
    
    func getAllPost(completion: @escaping postscompletionHandler)
    {
        //refDatabase = Database.database().reference()
        refDatabase.child("Post").observeSingleEvent(of: .value, with: { (snapshot) in
            let postid = self.refDatabase.child("Post").key
                guard let value = snapshot.value as? Dictionary<String,Any> else
                {
                    return
                }
                var arr: Array<Post> = []
                for item in value
                {
                    if let userdata = item.value as? Dictionary<String,Any>
                    {
                        arr.append(Post(UserId: userdata["UserId"]! as! String, PostDescription: userdata["PostDescription"]! as! String, PostImage: userdata["PostImage"]! as! String, Location: userdata["Location"] as? String, Timestamp: userdata["Timestamp"]! as! Double, PostId: postid))
                    }
                }
            arr.sort(by: {$0.Timestamp > $1.Timestamp})
                
                completion(arr)
        })
    }
    
    func followUser(uid: String, followinguid: String)
    {
        let userdic = [followinguid: true] as [String : Bool]
        refDatabase.child("User/\(uid)").child("following").updateChildValues(userdic)
    }
    
    func removeuserformfollowing(uid: String, followinguid: String)
    {
        refDatabase.child("User/\(uid)").child("following").child(followinguid).removeValue()
    }
    func getUserData(userid: String, completion: @escaping userprofilecompletionHandler)
    {
        refDatabase.child("User/\(userid)").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? Dictionary<String,String> else
            {
                return
            }
            var obj_User_profile: User?
            obj_User_profile = User(UserId: value["UserId"], FullName: value["FullName"], UserImage: value["UserImage"], Email: value["Email"])
            completion(obj_User_profile)
        })
    }
}
