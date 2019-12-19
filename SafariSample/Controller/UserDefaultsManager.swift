//
//  UserDefaultsManager.swift
//  SafariSample
//
//  Created by Nomad on 2019/12/18.
//  Copyright © 2019 Nomad. All rights reserved.
//

import Foundation
import UIKit


class UserDefaultsManager {
	
	static let shared = UserDefaultsManager()
	
	let userdefaultstandard = UserDefaults.standard
	
	init() {
		//
	}
	
	func saveWebHistoryArray(arr: [HistoryData]) -> Bool {
		let encoder = JSONEncoder()
		do {
			let temp = try encoder.encode(arr)
			userdefaultstandard.set(temp, forKey: "HistoryData")
			userdefaultstandard.synchronize() //////?????????
		} catch let error {
			print(error)
			return false
		}
		return true
	}
	
	func loadWebHistoryArray() -> [HistoryData]? {
		let decoder = JSONDecoder()
		
		if let jsonObject = userdefaultstandard.object(forKey: "HistoryData") {
//			let historyD = try? JSONDecoder().decode([HistoryData].self, from: jsonObject as! Data)
			userdefaultstandard.synchronize() ///?????????
			do {
				let historyD = try decoder.decode([HistoryData].self, from: jsonObject as! Data)
				
				return historyD
			} catch let error {
				print(error)
			}
			
			
//			if let content = historyD?.first {
//				let awef = content.date
//				print(awef!)
//				let jio = content.urlString
//			}
			
		}
		return nil
		
	}
	
}
