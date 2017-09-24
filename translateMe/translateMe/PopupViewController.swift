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

class PopupViewController: UIViewController {

    var word : String = ""
    
    var translatedWord: String = ""
    
    @IBOutlet weak var originalTextLabel: UILabel!
    
    @IBOutlet weak var translatedTextLabel: UILabel!
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    @IBOutlet weak var viewUI: UIView!
    
    @IBOutlet weak var closeButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        originalTextLabel.text = word
        
        self.translateWord { (translation) in
            self.translatedWord = translation
            self.translatedTextLabel.text = translation
        }
        
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
        utterance.rate = 0.4
        speechSynthesizer.speak(utterance)
    }
    
    @IBAction func listenToTranslatedText(_ sender: Any) {
        let utterance = AVSpeechUtterance(string: translatedWord)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-HK")
        utterance.rate = 0.4
        speechSynthesizer.speak(utterance)
    }
    
    @IBAction func closePopup(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }

    
    func translateWord(completion: @escaping( _ translatedText: String)->Void ){
        let GOOGLE_API_KEY = "AIzaSyDH7pgBsIh8JlQEN9y_o2judRJANEGMfno"
        let BASE_URL = "https://translation.googleapis.com/language/translate/v2"
        let TRANSLATED_LANGUAGE = "zh-TW"
        
        let parameters: Parameters = ["q": word, "target": TRANSLATED_LANGUAGE]//, "key": GOOGLE_API_KEY]
        let httpHeaders: HTTPHeaders = ["Content-Type": "application/json"]
        
        let newUrl = "\(BASE_URL)?key=\(GOOGLE_API_KEY)"
        Alamofire.request(newUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: httpHeaders).responseJSON { (response) in
            
            if let json = response.result.value {
                //                print("JSON: \(json)") // serialized json response
                let translations  = (((json as! NSDictionary)["data"] as! NSDictionary)["translations"] as! NSArray)[0]
                let translatedText = (translations as! NSDictionary)["translatedText"]!
                let translation = translatedText as! String
                completion(translation)
            }else{
                completion("")
            }
            
        }
        
        
        
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("PREPARE")
    }


}
