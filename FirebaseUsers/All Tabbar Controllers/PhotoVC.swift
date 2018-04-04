//
//  PhotoVC.swift
//  FirebaseUsers
//
//  Created by Viren Patel on 3/31/18.
//  Copyright © 2018 Viren Patel. All rights reserved.
//

import UIKit
import TWMessageBarManager
import GooglePlaces
import FirebaseAuth
import SVProgressHUD

class PhotoVC: UIViewController
{
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var location_txt: UITextField!
    @IBOutlet weak var caption_text: UITextView!
    @IBOutlet weak var post_img: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imagePicker.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(PhotoVC.Imagetapped))
        post_img.addGestureRecognizer(tap)
        post_img.isUserInteractionEnabled = true
        CallImagePicker()

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    @objc func Imagetapped()
    {
        CallImagePicker()
    }
    
    func CallImagePicker()
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
    @IBAction func Sharepost(_ sender: Any)
    {
        if post_img.image == nil
        {
            TWMessageBarManager.sharedInstance().showMessage(withTitle: "Post Image", description: "Please selcte the post image", type: .error)
        }
        else if caption_text.text == "write a caption...." || caption_text.text == ""
        {
            TWMessageBarManager.sharedInstance().showMessage(withTitle: "Caption", description: "Please decribe your post with few words", type: .error)
        }
        else
        {
            if let userid = Auth.auth().currentUser?.uid
            {
                SVProgressHUD.show()
               GoogleDatahandler.SharedInstance.CreatePost(img: post_img.image!, caption: caption_text.text, userid: userid, Location: location_txt.text ?? "")
                let tabBarController = TabViewController()
                self.tabBarController?.selectedIndex = 0
            }
            else
            {
                print("Error")
            }
        }
    }
    
    @IBAction func Cancel_btn_for_txt(_ sender: Any)
    {
        location_txt.text = ""
    }
}



extension PhotoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            post_img.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension PhotoVC: GMSAutocompleteViewControllerDelegate, UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
        location_txt.text = place.name
        guard let addresscomponents = place.formattedAddress?.components(separatedBy: ",") else
        {
            location_txt.text = place.name
            return
        }
        if addresscomponents.count > 2
        {
            let count = addresscomponents.count
            location_txt.text = "\(place.name),\(addresscomponents[count-2]),\(addresscomponents[count-1])" as String
        }
        else if addresscomponents.count > 1
        {
            let count = addresscomponents.count
            location_txt.text = "\(place.name),\(addresscomponents[count-2]),\(addresscomponents[count - 1])" as String
        }
        else if addresscomponents.count == 0
        {
            location_txt.text = "\(place.name),\(addresscomponents[0])"
        }
        else
        {
            location_txt.text = place.name
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
