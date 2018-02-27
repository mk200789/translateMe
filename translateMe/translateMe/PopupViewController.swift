//
//  PopupViewController.swift
//  translateMe
//
//  Created by Wan Kim Mok on 9/22/17.
//  Copyright © 2017 Wan Kim Mok. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
//import Clarifai_Apple_SDK

class PopupViewController: UIViewController {

    @IBOutlet weak var originalTextLabel: UILabel!
    
    @IBOutlet weak var translatedTextLabel: UILabel!

    @IBOutlet weak var viewUI: UIView!
    
    @IBOutlet weak var closeButtonOutlet: UIButton!
    
    @IBOutlet weak var listenToTranslatedTextOutlet: UIButton!
    
    @IBOutlet weak var translatedImageView: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    var TRANSLATED_LANGUAGE = "zh-TW"
    
    var language_voice = "zh-HK"
    
    var word : String = ""
    
    var translatedWord: String = ""
    
    @IBOutlet weak var noImageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
        //hide audio button for translatedWord
        listenToTranslatedTextOutlet.isHidden = true
        listenToTranslatedTextOutlet.isEnabled = false
        
        //hide the no image message
        noImageLabel.isHidden = true
        noImageLabel.numberOfLines = 0
        noImageLabel.adjustsFontSizeToFitWidth = true
        noImageLabel.lineBreakMode = .byWordWrapping
        
        let fontsize = Misc.fontSize[(UserDefaults.standard.object(forKey: "default_font_size") ?? 0) as! Int]

        //setup originalTextLabel and translatedTextLabel attributes
        translatedTextLabel.numberOfLines = 0
        translatedTextLabel.lineBreakMode = .byWordWrapping
        translatedTextLabel.textAlignment = .left
        translatedTextLabel.adjustsFontSizeToFitWidth = true
        
        originalTextLabel.numberOfLines = 0
        originalTextLabel.lineBreakMode = .byWordWrapping
        originalTextLabel.textAlignment = .left
        originalTextLabel.adjustsFontSizeToFitWidth = true
        
        //set the font size for originalTextLabel and translatedTextLabel
        originalTextLabel.font = UIFont(name: originalTextLabel.font.fontName, size: CGFloat(fontsize))
        translatedTextLabel.font = UIFont(name: translatedTextLabel.font.fontName, size: CGFloat(fontsize))

        
        //retrieve and set default translated language and speech
        let default_language_data = (UserDefaults.standard.object(forKey: "default_language_data") ?? [:]) as! [String: String]
        if (!default_language_data.isEmpty){
            TRANSLATED_LANGUAGE = default_language_data["googleTarget"]!
            language_voice = default_language_data["speechCode"]!
        }
        
        //activate spinner
        spinner.startAnimating()
        
        
        originalTextLabel.text = word
        
        self.translateWord { (translation) in
            if (translation.isEmpty){
                self.listenToTranslatedTextOutlet.isHidden = true
                self.listenToTranslatedTextOutlet.isEnabled = false
            }else{
                self.translatedWord = translation
                self.translatedTextLabel.text = translation
                self.listenToTranslatedTextOutlet.isHidden = false
                self.listenToTranslatedTextOutlet.isEnabled = true
            }
            
            self.searchImageForWord(word: self.word, completion: { (imageURL) in
                self.setImageView(imageURL: imageURL, completion: {
                    
                    //deactivate and hide spinner
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                    
                    //check if there's no image set
                    if (self.translatedImageView.image == nil){
                        self.noImageLabel.isHidden = false
                    }
                })
            })
        }
        
        closeButtonOutlet.setTitle(NSLocalizedString("Close", comment: ""), for: .normal)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.viewUI.layer.cornerRadius = 10
        self.closeButtonOutlet.layer.cornerRadius = 10
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func listenToOriginalText(_ sender: Any) {
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        speechSynthesizer.speak(utterance)
    }
    
    @IBAction func listenToTranslatedText(_ sender: Any) {
        let utterance = AVSpeechUtterance(string: translatedWord)
        utterance.voice = AVSpeechSynthesisVoice(language: language_voice)
        utterance.rate = 0.4
        speechSynthesizer.speak(utterance)
    }
    
    @IBAction func closePopup(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }

    
    func translateWord(completion: @escaping( _ translatedText: String)->Void ){
        let BASE_URL = "https://translation.googleapis.com/language/translate/v2"
        let parameters: Parameters = ["q": word, "target": TRANSLATED_LANGUAGE]
        let httpHeaders: HTTPHeaders = ["Content-Type": "application/json"]
        
        let newUrl = "\(BASE_URL)?key=\(Misc.GOOGLE_API_KEY)"
        Alamofire.request(newUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: httpHeaders).responseJSON { (response) in
            
            if let json = response.result.value {
                let translations  = (((json as! NSDictionary)["data"] as! NSDictionary)["translations"] as! NSArray)[0]
                let translatedText = (translations as! NSDictionary)["translatedText"]!
                let translation = translatedText as! String
                completion(translation)
            }else{
                completion("")
            }
            
        }
    }
    
    func searchImageForWord(word: String, completion: @escaping(_ imageURL: String)->Void){
        let number = 10
        var query = word.trimmingCharacters(in: .whitespacesAndNewlines)
        query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
//        Alamofire.request("https://api.qwant.com/api/search/images?count=\(number)&q=\(query)").responseJSON { (response) in
        Alamofire.request("https://api.qwant.com/egp/search/images?count=\(number)&q=\(query)").responseJSON { (response) in
            if (response.response?.statusCode == 200){
                if let json = response.result.value {
                    let status = (json as! NSDictionary)["status"] as! String
                    if (status == "success"){
                        let data = (json as! NSDictionary)["data"]
                        let results = ((data as! NSDictionary)["result"] as! NSDictionary)["items"]
                        let result = (results as! NSArray)[0] as! NSDictionary
                        let media = result["media"] as! String
                        completion(media)
                    }else{
                        self.noImageLabel.text = "Sorry, there's no image found for this word"
                        completion("")
                    }
                    
                }
            }else{
                self.noImageLabel.text = "No internet connection detected!"
                completion("")
                
            }
        }
    }
    
    func setImageView(imageURL: String, completion: @escaping()->Void){
        Alamofire.request(imageURL).response { (response) in
            let image = UIImage(data: response.data!)
            self.translatedImageView.image = image
            completion()
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
