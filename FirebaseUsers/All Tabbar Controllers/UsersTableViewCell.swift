//
//  UsersTableViewCell.swift
//  FirebaseUsers
//
//  Created by Viren Patel on 3/31/18.
//  Copyright © 2018 Viren Patel. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var user_email: UILabel!
    @IBOutlet weak var user_img: UIImageView!
    
    @IBOutlet weak var user_name: UILabel!
    
    @IBOutlet weak var follow_btn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        user_img.layer.cornerRadius = user_img.frame.size.width / 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
