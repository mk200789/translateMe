//
//  ViewController.swift
//  translateMe
//
//  Created by Wan Kim Mok on 9/18/17.
//  Copyright © 2017 Wan Kim Mok. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tagButtonOutlet: UIButton!
    @IBOutlet weak var tagsLabel: UILabel!
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
    }

    @IBAction func moveToTagTable(_ sender: Any) {
    }
    
    @IBAction func selectPicture(_ sender: Any) {
        
        //create a new alert
        let alert = UIAlertController(title: "Select Photo", message: nil, preferredStyle: .actionSheet)
        
        //include photo library action in alert
        let photoLib = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.photoLibTapped()
        }
        
        alert.addAction(photoLib)
        
        //include camera action in alert
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.cameraTapped()
        }
        
        alert.addAction(camera)
        
        //include cancel action in alert
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }

        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func photoLibTapped(){
        if (UIImagePickerController.availableMediaTypes(for: .photoLibrary) != nil){
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            print("cant go to photolibrary")
        }
    }
    
    func cameraTapped(){
        if(UIImagePickerController.availableMediaTypes(for: .camera) != nil){
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            print("cant take pictures")
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

