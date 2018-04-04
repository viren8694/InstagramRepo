//
//  PostTableViewCell.swift
//  FirebaseUsers
//
//  Created by Viren Patel on 4/2/18.
//  Copyright © 2018 Viren Patel. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var user_image: UIImageView!
    
    @IBOutlet weak var post_image: UIImageView!
    
    @IBOutlet weak var post_description: UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        user_image.layer.cornerRadius = user_image.frame.size.height / 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
