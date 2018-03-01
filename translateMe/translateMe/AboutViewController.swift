//
//  AboutViewController.swift
//  translateMe
//
//  Created by Wan Kim Mok on 10/4/17.
//  Copyright © 2017 Wan Kim Mok. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var translationCreditLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var reserveLabel: UILabel!
    @IBOutlet weak var creditScrollView: UIScrollView!
    
    @IBAction func dynamicactionbutton(_ sender: Any) {
        if let bundleID = Bundle.main.bundleIdentifier {
            
            
            let type = bundleID + ".DynamicAction"
            let icon = UIApplicationShortcutIcon(templateImageName: "ic_add_circle_outline")
            
            let newQuickAction = UIApplicationShortcutItem(type: type, localizedTitle: "New Dynamic Action", localizedSubtitle: nil, icon: icon, userInfo: nil)
            var existingShortcutItems = UIApplication.shared.shortcutItems ?? []
            print(existingShortcutItems)
            
            if !existingShortcutItems.contains(newQuickAction) {
                
                existingShortcutItems.append(newQuickAction)
                UIApplication.shared.shortcutItems = existingShortcutItems
            }
            
        } else {
            print("bundle Id is missing")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        aboutLabel.adjustsFontSizeToFitWidth = true
        aboutLabel.numberOfLines = 0
        aboutLabel.lineBreakMode = .byWordWrapping
        
        translationCreditLabel.adjustsFontSizeToFitWidth = true
        translationCreditLabel.numberOfLines = 0
        translationCreditLabel.lineBreakMode = .byWordWrapping
        
        reserveLabel.adjustsFontSizeToFitWidth = true
        reserveLabel.numberOfLines = 0
        reserveLabel.lineBreakMode = .byWordWrapping
        
        creditScrollView.isDirectionalLockEnabled = true
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
