//
//  LanguageViewController.swift
//  translateMe
//
//  Created by Wan Kim Mok on 10/16/16.
//  Copyright © 2016 Wan Kim Mok. All rights reserved.
//

import UIKit

class LanguageViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var selectedLanguage : String = ""
    
    @IBOutlet var picker: UIPickerView!
    
    @IBOutlet var submitLanguage: UIButton!
    
    @IBOutlet var pickerCollection: [UIPickerView]!
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Connect data:
        self.picker.delegate = self
        self.picker.dataSource = self
        
        let viewController = ViewController()
        pickerData = viewController.getLanguages()

    }
    
    @IBAction func submitLanguageButton(_ sender: AnyObject) {
        print("selected language: ", self.selectedLanguage)
        performSegue(withIdentifier: "submit_language", sender: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var segueDestination = segue.destination as! ViewController
        segueDestination.selectedLanguage = self.selectedLanguage
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // The number of columns of data
    func numberOfComponentsInPickerView(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        print("Focused on: ", pickerData[row])
        self.selectedLanguage = pickerData[row]
        return pickerData[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

}
