//
//  SettingsViewController.swift
//  translateMe
//
//  Created by Wan Kim Mok on 10/21/16.
//  Copyright © 2016 Wan Kim Mok. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    
    @IBOutlet var selectLanguageButtonLabel: UIButton!
    
    @IBAction func selectLanguageButton(_ sender: AnyObject) {
        performSegue(withIdentifier: "default_trans_from", sender: nil)
    }

    @IBAction func eraseHistory(_ sender: AnyObject) {
        //erase search history
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Settings"
        self.tabBarController?.tabBar.barTintColor = UIColor(netHex:0xF8DED4)
        
        print("settings: current default language: ", getPropValue(key: "default_language"))
        
        //if there's a default language change button title to it
        if !(getPropValue(key: "translate_from").isEmpty){
            selectLanguageButtonLabel.setTitle(getPropValue(key: "translate_from"), for: UIControlState.normal)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
