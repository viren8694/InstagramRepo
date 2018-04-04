//
//  User.swift
//  FirebaseUsers
//
//  Created by Viren Patel on 3/31/18.
//  Copyright © 2018 Viren Patel. All rights reserved.
//

import Foundation

struct User
{
    var UserId: String?
    var FullName: String?
    var UserImage: String?
    var Email: String?
}

struct Post
{
    var UserId: String
    var PostDescription: String
    var PostImage: String
    var Location: String?
    var Timestamp: Double
    var PostId: String
}

class CurrentUser: NSObject {
    struct Static {
        static var instance: CurrentUser?
    }
    
    class var sharedInstance: CurrentUser {
        if Static.instance == nil
        {
            Static.instance = CurrentUser()
        }
        
        return Static.instance!
    }
    
    func dispose() {
        CurrentUser.Static.instance = nil
        print("Disposed Singleton instance")
    }
    
    private override init() {}
    
    var userId: String!
    var email: String!
    var fullname: String?
    var password: String?
    var UserImage: String?
  //  var username: String?
   // var website: String?
   // var bio: String?
    var phoneNumber: String?
//    var gender: String?
//    var posts: [String] = []
    var following: [String] = []
//    var follwers: [String] = []
}

