//
//  ViewController.swift
//  translateMe
//
//  Created by Wan Kim Mok on 9/18/17.
//  Copyright © 2017 Wan Kim Mok. All rights reserved.
//

import UIKit
import Clarifai_Apple_SDK

class MainViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tagButtonOutlet: UIButton!
    
    @IBOutlet weak var tagsLabel: UILabel!
    
    var imagePicker = UIImagePickerController()
    
    var tags: [String] = []
    
    var model: Model!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //set model to general
        model = Clarifai.sharedInstance().generalModel
        
        imagePicker.delegate = self
        
        tagButtonOutlet.isEnabled = false
        
        tagsLabel.adjustsFontSizeToFitWidth = true
        tagsLabel.lineBreakMode = .byWordWrapping
        tagsLabel.numberOfLines = 0
        tagsLabel.textAlignment = .justified
        
        let settingButtonImage = UIImage(named: "settings25")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: settingButtonImage, style: .plain, target: self, action: #selector(goToSettings))

    }
    
    func goToSettings(){
        print("goToSettings")
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.title = "translateMe"
        var colors = [UIColor]()
        colors.append(UIColor(red: 182/255, green: 159/255, blue: 230/255, alpha: 1))
        colors.append(UIColor(red: 208/255, green: 201/255, blue: 224/255, alpha: 1))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
//        rgb(182, 159, 230)
//        rgb(208, 201, 224)
    }
    


    @IBAction func moveToTagTable(_ sender: Any) {
        print("move to table")
        self.performSegue(withIdentifier: "tag_table_seg", sender: nil)
    }
    
    @IBAction func selectPicture(_ sender: Any) {
        
        //create a new alert
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.view.tintColor = UIColor(red: 182/255, green: 159/255, blue: 230/255, alpha: 1)

        
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
    
    func getTags(){
        //clear out the previous tags
        print("getting tags")
        
        tags.removeAll()
        self.tagButtonOutlet.isEnabled = false
        
        let image = Image(image: imageView.image)
        let dataAsset = DataAsset.init(image: image)
        
        let input = Input(dataAsset: dataAsset)
        let inputs = [input]
        
        self.model.predict(inputs) { (outputs, error) in
            for output in outputs!{
                for concept in (output.dataAsset.concepts!){
                    if (!concept.name.isEmpty){
                        self.tags.append(concept.name)
                        print("tag: \(concept.name)  ------> \(concept.score) )")
                    }
                }
            }
            
            self.tagsLabel.text = self.tags.joined(separator: " , ")
            self.tagButtonOutlet.isEnabled = true
        }
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = selectedImage
            
            self.getTags()
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let nav = segue.destination as! UINavigationController
//        let dest = nav.viewControllers.first as! TableViewController
        let dest = segue.destination as! TableViewController
        dest.tags = self.tags
        
    }


}


extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 0, y: 1)
    }
    
    func creatGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}


extension UINavigationBar {
    
    func setGradientBackground(colors: [UIColor]) {
        
        var updatedFrame = bounds
        updatedFrame.size.height += 20
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        
        setBackgroundImage(gradientLayer.creatGradientImage(), for: UIBarMetrics.default)
    }
}
