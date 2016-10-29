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
    
    var selectedLanguageFrom : String = ""
    
    var direction : String = ""
    
    @IBOutlet var picker: UIPickerView!
    
    @IBOutlet var submitLanguage: UIButton!
    
    @IBOutlet var pickerCollection: [UIPickerView]!
    
    var pickerData: [String] = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.barTintColor = UIColor(netHex: 0xE1F1F9)
        
        print("kim: \(direction)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Connect data:
        self.picker.delegate = self
        self.picker.dataSource = self
        
        let viewController = ViewController()
        pickerData = viewController.getLanguages()

        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(LanguageViewController.nearbyTapped))
    }
    
    func nearbyTapped(){
        //        self.performSegue(withIdentifier: "back_main", sender: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submitLanguageButton(_ sender: AnyObject) {
        print("selected language: ", self.selectedLanguage)
        //let put = setPropVal(key: "translate_to", value: self.selectedLanguage)
        
//        let put = setPropValue(key: "translate_to", value: self.selectedLanguage)
        var put : String = ""
        if direction == "translate_from"{
            put = setPropValue(key: direction, value: self.selectedLanguageFrom)
        }else{
            put = setPropValue(key: direction, value: self.selectedLanguage)
        }
        print(direction)
        print("saved: ", put)
        var h = getPropVal(key: direction)
        print("retrieve: ", h)
        self.dismiss(animated: true, completion: nil)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueDestination = segue.destination as! ViewController
        
        if (direction == "translate_to"){
            segueDestination.selectedLanguage = self.selectedLanguage
        }else{
            segueDestination.selectedLanguageFrom = self.selectedLanguageFrom
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
        print("picker\(direction)")
        if (direction == "translate_to"){
            self.selectedLanguage = pickerData[row]
        }else{
            self.selectedLanguageFrom = pickerData[row]
        }
        
        return pickerData[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

}
