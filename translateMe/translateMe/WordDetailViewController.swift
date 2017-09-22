//
//  WordDetailViewController.swift
//  translateMe
//
//  Created by Wan Kim Mok on 9/18/17.
//  Copyright © 2017 Wan Kim Mok. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class WordDetailViewController: UIViewController {
    
    var word : String!
    
    var translatedText: String!

    @IBOutlet weak var englishWordLabel: UILabel!
    
    @IBOutlet weak var translatedWordLabel: UILabel!
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Translation"//word
        self.englishWordLabel.text = word
        
        self.translateWord { (translation) in
            self.translatedWordLabel.text = translation
            self.translatedText = translation
            print("TRANSLATION :\(translation)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func listenToAudio(_ sender: Any) {
        let utterance = AVSpeechUtterance(string: word)
        utterance.rate = 0.4
        speechSynthesizer.speak(utterance)
    }

    @IBAction func listenToTranslatedAudio(_ sender: Any) {
        let utterance = AVSpeechUtterance(string: translatedText)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-HK")
        speechSynthesizer.speak(utterance)
    }
    
    
    func translateWord(completion: @escaping( _ translatedText: String)->Void ){
        let GOOGLE_API_KEY = "AIzaSyDH7pgBsIh8JlQEN9y_o2judRJANEGMfno"
        let BASE_URL = "https://translation.googleapis.com/language/translate/v2"
        let TRANSLATED_LANGUAGE = "zh-TW"
        
        let parameters: Parameters = ["q": word, "target": TRANSLATED_LANGUAGE]//, "key": GOOGLE_API_KEY]
        let httpHeaders: HTTPHeaders = ["Content-Type": "application/json"]
        print("alamofire \n")
        
        let newUrl = "\(BASE_URL)?key=\(GOOGLE_API_KEY)"
        print("NEWURL: \(newUrl)")
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
