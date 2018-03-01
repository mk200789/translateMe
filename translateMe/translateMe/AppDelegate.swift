//
//  AppDelegate.swift
//  translateMe
//
//  Created by Wan Kim Mok on 9/18/17.
//  Copyright © 2017 Wan Kim Mok. All rights reserved.
//

import UIKit
import Clarifai_Apple_SDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Clarifai.sharedInstance().start(apiKey: Misc.CLARIFAI_API_KEY)
        
        //check if app is launched for first time.
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if (hasLaunchedBefore){
            //has launched before
        }else{
            //first time.
            //set initial default setting for first time user.
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            UserDefaults.standard.set(Misc.languages[0], forKey: "default_language_data")
            UserDefaults.standard.set(0, forKey: "default_language_idx")
            UserDefaults.standard.set(0, forKey: "default_font_size")
        }
        return true
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcutItem(withShortcutItem: shortcutItem))
    }
    
    enum ShortcutType: String {
        case print = "Print"
        case new = "DynamicAction"
    }
    
    func handleShortcutItem(withShortcutItem item: UIApplicationShortcutItem) -> Bool {
        guard let shortcutType = item.type.components(separatedBy: ".").last else { return false}
        
        if let type = ShortcutType(rawValue: shortcutType){
            switch type{
                case .print :
                    print("quick actions handle")
                    return true
                case .new:
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let targetVC = storyboard.instantiateViewController(withIdentifier: "aboutViewController") as! AboutViewController
                    if let navC = window?.rootViewController as! UINavigationController? {
                        navC.pushViewController(targetVC, animated: false)
                    }
                    print("dynamic quick actions handle")
            }
        }
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

