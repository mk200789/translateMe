//
//  ViewController.swift
//  translateMe
//
//  Created by Wan Kim Mok on 10/6/16.
//  Copyright © 2016 Wan Kim Mok. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var accessToken: String = ""

    @IBAction func translateButton(_ sender: AnyObject) {
        print("translate button pressed")
        translate(text: "hello girls")
    }
    @IBOutlet var inputText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        var frameRect = inputText.frame
//        frameRect.size.height = 100;
//        inputText.frame = frameRect
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func translate(text: String){
        print(text)
        getAccessToken();
    }
    

    
    func encodeURIComponent(text: String) -> String {
        let characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-_.!~*'()")
        
        return text.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)!
    }

    
    func getAccessToken(){
        
        let clientId = getKey(key: "bing_client_id")
        let clientSecret = getKey(key: "bing_client_secret")
        let scope = "http://api.microsofttranslator.com"
        let grantType = "client_credentials"
        let authUrl = "https://datamarket.accesscontrol.windows.net/v2/OAuth2-13/"
        
        let params = "client_id=\(encodeURIComponent(text: clientId))&client_secret=\(encodeURIComponent(text: clientSecret))&scope=\(encodeURIComponent(text: scope))&grant_type=\(grantType)"
        
        let url = URL(string: authUrl)
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = params.data(using: .utf8)
    
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if ((response as! HTTPURLResponse).statusCode == 200){
                do{
                    //convert data to json format
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    //set access token
                    self.accessToken = (json["access_token"] as! String).removingPercentEncoding!
                }catch{
                    
                }
                
            }
        }
        
        task.resume()

        
        
        
        
    }


}

