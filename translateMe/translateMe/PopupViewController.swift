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

    @IBOutlet weak var originalTextLabel: UILabel!
    
    @IBOutlet weak var translatedTextLabel: UILabel!

    @IBOutlet weak var viewUI: UIView!
    
    @IBOutlet weak var closeButtonOutlet: UIButton!
    
    @IBOutlet weak var listenToTranslatedTextOutlet: UIButton!
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    var TRANSLATED_LANGUAGE = "zh-TW"
    
    var language_voice = "zh-HK"
    
    var word : String = ""
    
    var translatedWord: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
        //hide audio button for translatedWord
        listenToTranslatedTextOutlet.isHidden = true
        listenToTranslatedTextOutlet.isEnabled = false
        
        let fontsize = Misc.fontSize[(UserDefaults.standard.object(forKey: "default_font_size") ?? 0) as! Int]
        
        //set the font size for originalTextLabel and translatedTextLabel
        originalTextLabel.font = UIFont(name: originalTextLabel.font.fontName, size: CGFloat(fontsize))
        translatedTextLabel.font = UIFont(name: translatedTextLabel.font.fontName, size: CGFloat(fontsize))
        
        //setup originalTextLabel and translatedTextLabel attributes
        translatedTextLabel.numberOfLines = 0
        translatedTextLabel.lineBreakMode = .byWordWrapping
        translatedTextLabel.textAlignment = .left
        originalTextLabel.numberOfLines = 0
        originalTextLabel.lineBreakMode = .byWordWrapping
        originalTextLabel.textAlignment = .left
        
        
        //retrieve and set default translated language and speech
        let default_language_data = (UserDefaults.standard.object(forKey: "default_language_data") ?? [:]) as! [String: String]
        if (!default_language_data.isEmpty){
            TRANSLATED_LANGUAGE = default_language_data["googleTarget"]!
            language_voice = default_language_data["speechCode"]!
        }
        
        
        originalTextLabel.text = word
        
        self.translateWord { (translation) in
            self.translatedWord = translation
            self.translatedTextLabel.text = translation
            self.listenToTranslatedTextOutlet.isHidden = false
            self.listenToTranslatedTextOutlet.isEnabled = true
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
        //7058
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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("PREPARE")
    }


}
