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
	
//	let now = Date()
//	let dateFormatter = DateFormatter()
//	let calendar = Calendar(identifier: .gregorian)
//	var dates: [String] = []
//	
//	let ud = UserDefaults.standard
//
//	let tomorrow = Date(timeIntervalSinceNow: 86400)

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
//		window = UIWindow(frame: UIScreen.main.bounds)
//		window?.makeKeyAndVisible()
//		window?.rootViewController = UINavigationController(rootViewController: MainVC(coder: NSCoder))
		
//		/// 앱이 실행되었을 때의 날짜 시간을 userdefaults 에 저장한다.
//		dateFormatter.locale = Locale(identifier: "ko_kr")
//		dateFormatter.dateFormat = "EEEE, MMMM d" //"화요일, 12월 17"
//		let krTodayDateTime = dateFormatter.string(from: now)

//		if let arr = UserDefaults.standard.stringArray(forKey: "Date") {
//			var arrValues = arr as! [String]
//			arrValues.append(krTodayDateTime)
//			self.ud.setValue(arrValues, forKey: "Date")
//			self.ud.synchronize()
//			print(arr)
//		}
//		else {
//			self.ud.setValue([krTodayDateTime], forKey: "Date")
//		}
//		dates.append(krTodayDateTime)
//		ud.setValue(dates, forKey: "Date")
		
//		if let arr = ud.stringArray(forKey: "Date") {
//			dates = arr
//			dates.insert(krTodayDateTime, at: 0)
//
//			ud.setValue(dates, forKey: "Date")
//			ud.synchronize()
//		}
		
		
		
		
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

