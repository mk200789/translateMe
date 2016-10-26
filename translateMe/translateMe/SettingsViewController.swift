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

    @IBOutlet var saveSettingsLabel: UIButton!
    
    @IBAction func selectLanguageButton(_ sender: AnyObject) {
        performSegue(withIdentifier: "default_trans_from", sender: nil)
    }
    @IBAction func saveSettingsButton(_ sender: AnyObject) {
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.tabBarController?.title = "Settings"
//        self.tabBarController?.tabBar.barTintColor = UIColor(netHex:0xF8DED4)
//        storeLanguage(language: "french")
        getLanguage()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Settings"
        self.tabBarController?.tabBar.barTintColor = UIColor(netHex:0xF8DED4)
        saveSettingsLabel.layer.cornerRadius = 2
        saveSettingsLabel.layer.borderWidth = 0.1
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
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func storeLanguage (language: String) {
        let context = getContext()
        
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "Users", in: context)
        
        let user = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        user.setValue(language, forKey: "default_language")
        
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    func getLanguage () {
        //create a fetch request, telling it about the entity
        
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Users")
        
        request.returnsObjectsAsFaults = false
        
        do{
            let results = try getContext().fetch(request)
            print(results.count)
            if (results.count > 0){
                
            }
            
        }
        catch{
            print("error")
        }
        
    }

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
