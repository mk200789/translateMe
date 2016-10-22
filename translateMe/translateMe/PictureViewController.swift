//
//  PictureViewController1.swift
//  translateMe
//
//  Created by Wan Kim Mok on 10/18/16.
//  Copyright © 2016 Wan Kim Mok. All rights reserved.
//

import UIKit

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var resultLabel: UILabel!
    
    var result : NSDictionary = NSDictionary()
    
    let imagePicker = UIImagePickerController()
    
    var accessToken : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        //getAccessToken()
        self.accessToken = getKey(key: "clarifai_access_token")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        //dismiss the view
        dismiss(animated: true, completion: nil)
        
    }

    func getTags(){
        resultLabel.text = ""
        
        let tagURL = "https://api.clarifai.com/v1/tag/"
        let header = "Bearer " + self.accessToken
        
        let url = URL(string: tagURL)
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.setValue(header, forHTTPHeaderField: "Authorization")
        
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.3)
        let base64String = imageData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        
        
        request.httpBody = ("encoded_data=\(ViewController().encodeURIComponent(text: base64String!))").data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if ((response as! HTTPURLResponse).statusCode == 200){
                print("success!")
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    DispatchQueue.main.async {
                        self.result = json
                        print(json)
                        
                    }
                }catch{
                    
                }
            }
        }
        task.resume()
        
    }

    func getAccessToken(){
        let clientID = getKey(key: "clarifai_client_id")
        let clientSecret = getKey(key: "clarifai_client_secret")
        let authURL = "https://api.clarifai.com/v1/token"
        
        
        let params = "client_id=\(clientID)&client_secret=\(clientSecret)&grant_type=client_credentials"
        let url = URL(string: authURL)
        
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        
        request.httpBody = params.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if ((response as! HTTPURLResponse).statusCode == 200){
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    DispatchQueue.main.async {
                        self.accessToken = setVal(key: "clarifai_access_token", value: json["access_token"] as! String)
                        setVal(key: "clarifai_expires_in", value: String(describing: json["expires_in"]))
                        
                    }
                }catch{
                    
                }
            }
        }
        task.resume()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
