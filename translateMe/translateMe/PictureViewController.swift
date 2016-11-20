//
//  PictureViewController1.swift
//  translateMe
//
//  Created by Wan Kim Mok on 10/18/16.
//  Copyright © 2016 Wan Kim Mok. All rights reserved.
//

import UIKit
import Clarifai

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var resultLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet var showTableButton: UIButton!
    
    @IBOutlet var selectPhotoLabel: UIButton!
    
    var tag : Array<String> = []
    
    var app: ClarifaiApp = ClarifaiApp(appID: getPropValue(key: "clarifai_client_id"), appSecret: getPropValue(key: "clarifai_client_secret")) as ClarifaiApp
    

    @IBAction func showTable(_ sender: AnyObject) {
        setArrayValue(key: "clarifai_tags", value: self.tag as NSArray)
        performSegue(withIdentifier: "image_tags_seg", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view
        
        resultLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        //resultLabel.numberOfLines = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Translate by Photo"
        self.tabBarController?.tabBar.barTintColor = UIColor(netHex: 0xF7F4C8)
        resultLabel.backgroundColor = UIColor.clear
        selectPhotoLabel.layer.borderWidth = 0.1
        selectPhotoLabel.layer.cornerRadius = 2
        
        self.resultLabel.textAlignment = NSTextAlignment.center
    }
    
    
    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        
        //set an alertcontroller
        let alert = UIAlertController(title: "Select Photo", message: nil, preferredStyle: .actionSheet)
        
        //include photolib action in alert
        let photolib = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.photoLibTapped()
        }
        
        alert.addAction(photolib)
        
        //include camera action in alert
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.cameraTapped()
        }
        
        alert.addAction(camera)
        
        //include cancel
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
        
    }
    
    func photoLibTapped(){
        if (UIImagePickerController.availableMediaTypes(for: .photoLibrary) != nil){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            print("cant go to photolibrary")
        }
    }
    
    func cameraTapped(){
        if (UIImagePickerController.availableMediaTypes(for: .camera) != nil){
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            print("cant take pictures")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //save the selected image to imageView
        imageView.image = info[UIImagePickerControllerOriginalImage] as! UIImage?
        imageView.contentMode = .scaleAspectFit
        
        
        getTags()
        
        //dismiss the view
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func updateLabel(tags: NSArray){
        print(tags)
        showTableButton.isEnabled = true
        resultLabel.text = tags.componentsJoined(by: ", ")
    }
    
    
    
    func getTags(){
        
        let image : ClarifaiImage = ClarifaiImage(image: imageView.image)
        tag = []
        resultLabel.text = ""
        
        self.app.getModelByName("general-v1.3", completion: { (model, error) in
            model?.predict(on: [image], completion: { (output, error) in
                DispatchQueue.main.async {
                    let result = output?[0]
                
                    for i in (result?.concepts)!{
                        self.tag.append(i.conceptName)
                    }
                    self.updateLabel(tags: self.tag as NSArray)
                }
            
            })
        })
        

    }


    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//        let segDest = segue.destination as! WordTableViewController
//        segDest.words = self.tags as! [String]
    }
    
    
}
