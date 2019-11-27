//
//  AppDelegate.swift
//  Todoey
//
//  Created by Marina Svistkova on 08/10/2019.
//  Copyright © 2019 Marina Svistkova. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
        do {
         _ = try Realm()
        } catch {
            print("Error installing new realm \(error)")
        }
        
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        return true
    }


}

