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
