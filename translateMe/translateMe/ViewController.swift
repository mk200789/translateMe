//
//  ViewController.swift
//  translateMe
//
//  Created by Wan Kim Mok on 10/6/16.
//  Copyright © 2016 Wan Kim Mok. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var selectedLanguageLabel: UIButton!
    
    var accessToken: String = ""
    
    var selectedLanguage : String = ""

    var parser = XMLParser()
    
    @IBOutlet var outputTextLabel: UILabel!
    
    @IBOutlet var inputTextLabel: UITextField!
    
    @IBOutlet var inputText: UITextField!
    
    let language : [String: String]  = ["Afrikaans": "af",
                                        "Arabic" : "ar",
                                        "Bosnian (Latin)": "bs-Latn",
                                        "Bulgarian" : "bg",
                                        "Catalan" : "ca",
                                        "Chinese Simplified" : "zh-CHS",
                                        "Chinese Traditional" : "zh-CHT",
                                        "Croatian" : "hr",
                                        "Czech" : "cs",
                                        "Danish" : "da",
                                        "Dutch" : "nl",
                                        "English" : "en",
                                        "Estonian" : "et",
                                        "Finnish" : "fi",
                                        "French" : "fr",
                                        "German" : "de",
                                        "Greek" : "el",
                                        "Hatian Creole" : "ht",
                                        "Hebrew" : "he",
                                        "Hindi" : "hi",
                                        "Hmong Daw" : "mww",
                                        "Hungarian" : "hu",
                                        "Indonesian" : "id",
                                        "Italian" : "it",
                                        "Japanese" : "ja",
                                        "Kiswahili" : "sw",
                                        "Klingon" : "tlh",
                                        "Klingon (pIqaD)" : "tlh-Qaak",
                                        "Korean" : "ko",
                                        "Latvian" : "lv",
                                        "Lithuanian" : "lt",
                                        "Malay" : "ms",
                                        "Maltese": "mt",
                                        "Norwegian": "no",
                                        "Persian" : "fa",
                                        "Polish" : "pl",
                                        "Portuguese" : "pt",
                                        "Querétaro Otomi" : "otq",
                                        "Romanian" : "ro",
                                        "Russian" : "ru",
                                        "Serbian (Cyrillic)" : "sr-Cyrl",
                                        "Serbian (Latin)" : "sr-Latn",
                                        "Slovak" : "sk",
                                        "Slovenian" : "sl",
                                        "Spanish" : "es",
                                        "Swedish" : "sv",
                                        "Thai": "th",
                                        "Turkish" : "tr",
                                        "Ukranian" : "uk",
                                        "Urdu" : "ur",
                                        "Vietnamese" : "vi",
                                        "Welsh" : "cy",
                                        "Yucatec Maya" : "yua"
    ]
    
    @IBAction func translateButton(_ sender: AnyObject) {
        print("translate button pressed")
        
        //Check if input text is empty
        if (!(inputTextLabel.text?.isEmpty)! && !((inputTextLabel.text?.replacingOccurrences(of: " ", with: ""))?.isEmpty)!){
            
            translate(text: inputTextLabel.text! , translateTo: self.selectedLanguage)
            
        }else{
            
            outputTextLabel.text = "Please enter a text to translate."
        }
        
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        var frameRect = inputText.frame
//        frameRect.size.height = 100;
//        inputText.frame = frameRect
        
        //get access token
        getAccessToken();
        
        //check if there's a language is selected, if there is change button name to that language
        if (!self.selectedLanguage.isEmpty){
            selectedLanguageLabel.setTitle(self.selectedLanguage, for: UIControlState.normal)
        }
        print("selected language is: ", self.selectedLanguage)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /*
     * Translates text using Bing Translator API
     *
     * - Parameters:
     *      - text   : The string that will be translated
     *      - langTo : The language `text` will be translated to
     *
     * - Outcome: Sets `outputTextLabel` to the `translated` text in the language `langTo`
     */
    func translate(text: String, translateTo: String) {
        
        print("Translating")
        
        let langFrom = "en";
        
        if (translateTo.isEmpty){
            self.outputTextLabel.text = "Please select a language to translate to."
            return
        }
        
        let langTo = getLanguageCode(name: translateTo)

        print("translation language code: ", langFrom)
        let uri = "https://api.microsofttranslator.com/v2/Http.svc/Translate?text="+text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + "&from=" + langFrom + "&to=" + langTo
        
        let authToken = "Bearer " + self.accessToken
        
        let url = URL(string: uri)
        var request = URLRequest(url: url!)
        
        var translated : NSString = ""
        
        request.httpMethod = "GET"
        request.setValue(authToken, forHTTPHeaderField: "Authorization ")
        

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if ((response as! HTTPURLResponse).statusCode == 200){
                
                print(String(data: data!, encoding: String.Encoding.utf8)!)
                
                //Reminder todo:  find the correct way to parse xml
                translated  = String(data: data!, encoding: String.Encoding.utf8)! as NSString
                translated = translated.replacingOccurrences(of: "<string xmlns=\"http://schemas.microsoft.com/2003/10/Serialization/\">", with: "") as NSString
                translated = translated.replacingOccurrences(of: "</string>", with: "") as NSString
                
                print("translated:" , translated)
                
                DispatchQueue.main.async {
                    self.outputTextLabel.text = translated as String
                }
                
            }

        }.resume()
    }
    

    /*
     * Url-encode strings
     *
     * - Parameters:
     *      - text: The string that will be encoded
     *
     * - Returns: The url-encoded string
     */
    func encodeURIComponent(text: String) -> String {
        let characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-_.!~*'()")
        
        return text.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)!
    }

    
    /*
     * Retrieves the access token
     */
    func getAccessToken(){
        
        let clientId = getKey(key: "bing_client_id")
        let clientSecret = getKey(key: "bing_client_secret")
        let scope = "http://api.microsofttranslator.com"
        let grantType = "client_credentials"
        let authUrl = "https://datamarket.accesscontrol.windows.net/v2/OAuth2-13/"
        
        //format the parameters for the access token
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
                    //self.accessToken = (json["access_token"] as! String).removingPercentEncoding!
                    
                    DispatchQueue.main.async {

                        self.accessToken = setVal(key: "bing_access_token", value: (json["access_token"] as! String))
                    }
                    
                
                }catch{
                    print("Error converting to json.")
                }
            }
        }
        
        task.resume()
        
        
    }
    
    /*
     * Gets the language code name
     *
     * - Parameters:
     *      - name : The name of the language
     *
     * Returns the code name of language `name`
     */
    func getLanguageCode(name: String) -> String{
        return language[name]!
        
    }
    
    
    /*
     * Get list of languages
     */
    func getLanguages() -> [String]{
        return Array(language.keys)
        
    }

}

