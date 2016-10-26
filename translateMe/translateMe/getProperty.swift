//
//  getProperty.swift
//  translateMe
//
//  Created by Wan Kim Mok on 10/14/16.
//  Copyright © 2016 Wan Kim Mok. All rights reserved.
//

import Foundation



func setPropValue(key: String, value: String) -> String{
    let sourcePath = Bundle.main.path(forResource: "property", ofType: "plist")
    
    let destPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("property.plist")
    
    let fileManager = FileManager.default
    
    //1. check if destination path does not exist, copy the source path to destination path
    if !fileManager.fileExists(atPath: destPath) {
        print("Destination file path DNE.")
        do{
            try fileManager.copyItem(atPath: sourcePath!, toPath: destPath)
            print("copied")
        }catch{
            print("cannot copy")
        }
    }
    
    //2. set the contents of destPath in an mutable dictionary and assign value
    let dict = NSMutableDictionary(contentsOfFile: destPath)
    dict?[key] = value
    print("Destination file path Exist.")
    
    let dictionary = dict! as NSDictionary
    
    //3. write changed dictionary to destination path
    if (dictionary.write(toFile: destPath, atomically: false)) {
        print("File written")
    }else{
        print("File not written successfully")
    }
    
    
    return value
}


func getPropValue(key: String) -> String{
    let destPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("property.plist")
    let fileManager = FileManager.default
    
    if fileManager.fileExists(atPath: destPath){
        let dict = NSDictionary(contentsOfFile: destPath)
        let value = dict?.object(forKey: key)
        print("File exists")
        return value as! String
    }
    else{
        print("File DNE")
    }
    return  ""
}

func getPropVal(key: String) -> String {
    let filePath = Bundle.main.path(forResource: "property", ofType: "plist")
    let plist = NSDictionary(contentsOfFile:filePath!)
    let value = plist?.object(forKey: key) as! String
    
    return value
}


func setPropVal(key: String, value: String) -> String{
    let filePath = Bundle.main.path(forResource: "property", ofType: "plist")
    let plist = NSMutableDictionary(contentsOfFile:filePath!)
    plist?.setValue(value, forKey: key)
    let success = plist?.write(toFile: filePath!, atomically: false)
    print("success?", success)
    
    
    return value
}
