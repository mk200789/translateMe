//
//  ViewController.swift
//  translateMe
//
//  Created by Wan Kim Mok on 10/6/16.
//  Copyright © 2016 Wan Kim Mok. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var selectedLanguageLabel: UIButton!
    @IBOutlet var selectedLanguageFromButtonLabel: UIButton!
    
    var accessToken: String = ""
    
    var selectedLanguage : String = ""
    
    var selectedLanguageFrom : String = ""
    
    var parser = XMLParser()
    
    var direction : String = ""
    
    
    @IBOutlet var outputTextLabel: UILabel!
    
    @IBOutlet var inputTextLabel: UITextField!
    
    @IBOutlet var translateButtonLabel: UIButton!
    
    let language : [String: String]  = [
        "Chinese Simplified" : "zh-CHS",
        "Chinese Traditional" : "zh-CHT",
        "Afrikaans": "af",
        "Arabic" : "ar",
        "Bosnian (Latin)": "bs-Latn",
        "Bulgarian" : "bg",
        "Catalan" : "ca",
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
    
    //end editing when return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //end editing when touch outside input text
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.selectedLanguage = getPropValue(key: "translate_to")
        self.selectedLanguageFrom = getPropValue(key: "translate_from")
        
        //check if there's a language is selected, if there is change button name to that language
        if (!self.selectedLanguage.isEmpty){
            print("selected language to")
            selectedLanguageLabel.setTitle(self.selectedLanguage, for: UIControlState.normal)
        }
        
        if (!self.selectedLanguageFrom.isEmpty){
            print("selected language from")
            selectedLanguageFromButtonLabel.setTitle(self.selectedLanguageFrom, for: UIControlState.normal)
        }
        self.tabBarController?.title = "Translate by Text"
        self.tabBarController?.tabBar.barTintColor = UIColor(netHex: 0xE1F1F9)
        translateButtonLabel.layer.cornerRadius = 2
        translateButtonLabel.layer.borderWidth = 0.1
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //get access token
        //        getAccessToken();
        self.accessToken = getPropValue(key: "bing_access_token")
        print("viewDidLoad: ", self.selectedLanguage)
        if (!self.selectedLanguage.isEmpty){
            selectedLanguageLabel.setTitle(selectedLanguage, for: UIControlState.normal)
        }
        outputTextLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        outputTextLabel.numberOfLines = 0
        
        inputTextLabel.delegate = self
        inputTextLabel.returnKeyType = .done
        
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
        
        print("Translating " )
        
//        let langFrom = "en";
        let langFrom = getLanguageCode(name: getPropValue(key: "translate_from"))
        
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
                
            }else{
                //expired
                print("access token expired")
                self.getAccessToken()
                
                self.translate(text: text, translateTo: translateTo)
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
        
        let clientId = getPropValue(key: "bing_client_id")
        let clientSecret = getPropValue(key: "bing_client_secret")
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
                        
                        self.accessToken = setPropValue(key: "bing_access_token", value: (json["access_token"] as! String))
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
    
    @IBAction func to(_ sender: AnyObject) {
        direction = "translate_to"
        self.performSegue(withIdentifier: "select_language_id", sender: nil)
        
    }
    
    
    @IBAction func from(_ sender: AnyObject) {
        direction = "translate_from"
        self.performSegue(withIdentifier: "select_language_id", sender: nil)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segDest = segue.destination as! UINavigationController
        let vc = segDest.topViewController as! LanguageViewController
        print("prepare: \(direction)")
        vc.direction = direction
    }
    
    
}
