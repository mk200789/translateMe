//
//  SettingsViewController.swift
//  translateMe
//
//  Created by Wan Kim Mok on 9/23/17.
//  Copyright © 2017 Wan Kim Mok. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var fontSize = [14, 18, 25]
    
    @IBOutlet weak var fontSizeSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var saveSettingButtonOutlet: UIButton!
    
    @IBOutlet weak var changeDefaultLanguageOutlet: UIButton!
    
    @IBOutlet weak var defaultLanguageLabel: UILabel!
    
    @IBOutlet weak var defaultFontSizeLabel: UILabel!
    
    var language = ""
    
    var languageData:  [String: String] = [:]
    
    var languageIdx: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        saveSettingButtonOutlet.layer.cornerRadius = 10
        navigationController?.navigationBar.tintColor = UIColor.black
        
        retrieveDefaultSettings()
    }
 
    
    override func viewWillAppear(_ animated: Bool) {

        changeDefaultLanguageOutlet.setTitle(languageData["name"], for: .normal)
        let defaults = UserDefaults.standard
        let default_language_data = (defaults.object(forKey: "default_language_data") ?? [:]) as! [String: String]
        let default_language_idx  = (defaults.object(forKey: "default_language_idx") ?? 0) as! Int
        let default_font_size     = (defaults.object(forKey: "default_font_size") ?? 0) as! Int
        
        print("default_language_data \(default_language_data)")
        print("default_language_idx  \(default_language_idx)")
        print("default_font_size     \(default_font_size)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func changeDefaultLanguage(_ sender: Any) {
        self.performSegue(withIdentifier: "languageSegue", sender: nil)
    }
    
    @IBAction func saveSetting(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(fontSizeSegmentControl.selectedSegmentIndex, forKey: "default_font_size")
        defaults.set(languageData, forKey: "default_language_data")
        defaults.set(languageIdx, forKey: "default_language_idx")
        defaults.synchronize()
        
        retrieveDefaultSettings()
    }
    
    func retrieveDefaultSettings(){
        let defaults = UserDefaults.standard

        //retrieve default font size setting
        
        let default_font_size = fontSize[(defaults.object(forKey: "default_font_size") ?? 0) as! Int]
        
        changeDefaultLanguageOutlet.titleLabel?.font = UIFont(name: changeDefaultLanguageOutlet.titleLabel!.font.fontName, size: CGFloat(default_font_size))
        
        defaultLanguageLabel.font = UIFont(name: defaultLanguageLabel.font.fontName, size: CGFloat(default_font_size)+2.0)
        
        defaultFontSizeLabel.font = UIFont(name: defaultFontSizeLabel.font.fontName, size: CGFloat(default_font_size)+2.0)
        
        //retrieve default language setting
        languageData = (defaults.object(forKey: "default_language_data") ?? [:]) as! [String: String]
        if (!languageData.isEmpty){
            changeDefaultLanguageOutlet.setTitle(languageData["name"], for: .normal)
            languageIdx = (defaults.object(forKey: "default_language_idx") ?? 0 ) as! Int
        }
        
        //retrieve default font size segment
        fontSizeSegmentControl.selectedSegmentIndex = (defaults.object(forKey: "default_font_size") ?? 0) as! Int

    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
 

}