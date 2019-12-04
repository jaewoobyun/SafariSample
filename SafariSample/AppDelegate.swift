//
//  AppDelegate.swift
//  SafariSample
//
//  Created by Nomad on 2019/11/18.
//  Copyright © 2019 Nomad. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
//	var window: UIWindow?
	
//	var plistPathInDocument: String = String()
//	
//	func preparePlistForUse(){
//		 // 1
//		let rootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
//		 // 2
//		plistPathInDocument = rootPath.appending("/history.plist")
//		if !FileManager.default.fileExists(atPath: plistPathInDocument){
//			let plistPathInBundle = Bundle.main.path(forResource: "notes", ofType: "plist") as String?
//			  // 3
//			  do {
//				try FileManager.defaultManager.copyItemAtPath(plistPathInBundle, toPath: plistPathInDocument)
//			  }catch{
//					print("Error occurred while copying file to document \(error)")
//			  }
//		 }
//	}
	

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
//		window = UIWindow(frame: UIScreen.main.bounds)
//		window?.makeKeyAndVisible()
//		window?.rootViewController = UINavigationController(rootViewController: MainVC(coder: NSCoder))
		
		
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}


}

