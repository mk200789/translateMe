//
//  LanguageTableViewController.swift
//  translateMe
//
//  Created by Wan Kim Mok on 9/23/17.
//  Copyright © 2017 Wan Kim Mok. All rights reserved.
//

import UIKit

class LanguageTableViewController: UITableViewController {
    
    var languages = [ 0: ["name": "中文" , "speechCode": "zh-HK", "googleTarget": "zh-TW"], 1: ["name": "日本語" , "speechCode" :"ja-JP", "googleTarget": "ja"], 2: ["name": "Nederlands", "speechCode": "nl-NL", "googleTarget": "nl"], 3: ["name" : "한국어" ,"speechCode" : "ko-KR", "googleTarget": "ko"], 4: ["name" : "Español" , "speechCode" : "es-ES", "googleTarget": "es"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let defaults = UserDefaults.standard
        let default_language_idx = (defaults.object(forKey: "default_language_idx") ?? 0) as! Int
        let indexPath = IndexPath(row: default_language_idx, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let defaults = UserDefaults.standard
//        let languageData = defaults.object(forKey: "default_language_data") as! [String : String] ?? [:]

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //a hack way to pass data to previous view controller
//        let vcsCount = self.navigationController?.viewControllers.count
//        (self.navigationController?.viewControllers[vcsCount!-1] as! SettingsViewController).language = "Hello"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return languages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageName", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = languages[indexPath.row]!["name"]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        languages[indexPath.row]
        let vcsCount = self.navigationController?.viewControllers.count
        (self.navigationController?.viewControllers[vcsCount!-2] as! SettingsViewController).languageData = languages[indexPath.row]!
        (self.navigationController?.viewControllers[vcsCount!-2] as! SettingsViewController).languageIdx = indexPath.row
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
