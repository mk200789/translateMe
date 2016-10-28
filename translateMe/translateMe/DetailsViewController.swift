//
//  DetailsViewController.swift
//  translateMe
//
//  Created by Wan Kim Mok on 10/26/16.
//  Copyright © 2016 Wan Kim Mok. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var word : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Word List", style: .plain, target: self, action: #selector(DetailsViewController.nearbyTapped))
    }

    override func viewWillAppear(_ animated: Bool) {
        self.word = getPropValue(key: "selected_word")
        self.navigationItem.title = self.word
    }
    func nearbyTapped(){
//        self.performSegue(withIdentifier: "back_main", sender: nil)
        self.dismiss(animated: true, completion: nil)
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
