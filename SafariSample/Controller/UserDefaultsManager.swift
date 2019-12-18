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
			UserDefaults.standard.set(temp, forKey: "HistoryData")
			UserDefaults.standard.synchronize() //////?????????
		} catch let error {
			print(error)
			return false
		}
		return true
	}
	
	func loadWebHistoryArray() -> [HistoryData]? {
		let decoder = JSONDecoder()
		
		if let jsonObject = UserDefaults.standard.object(forKey: "HistoryData") {
//			let historyD = try? JSONDecoder().decode([HistoryData].self, from: jsonObject as! Data)
			UserDefaults.standard.synchronize() ///?????????
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
