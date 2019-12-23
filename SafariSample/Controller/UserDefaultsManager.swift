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
	let encoder = JSONEncoder()
	let decoder = JSONDecoder()
	
	var visitedWebSiteHistoryRecords: [HistoryData] = []
	var backList:[URL] = []
	var forwardList:[URL] = []
	
	init() {
		
	}
	
	//-------------------------------------------------------------------
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
			do {
				let historyD = try decoder.decode([HistoryData].self, from: jsonObject as! Data)
				
				return historyD
			} catch let error {
				print(error)
			}

		}
		return nil
		
	}
	//-----------------------------------------------------------------
	
//	enum BackForwardListData {
//
//	}
	
	
	
	func initDatas() {
		if let jsonData = userdefaultstandard.object(forKey: "HistoryData") {
			do {
				visitedWebSiteHistoryRecords = try decoder.decode([HistoryData].self, from: jsonData as! Data)
			} catch let error {
				print(error)
			}
		}
		
	}
	
	
	func updateDatasNoti() {
		//데이터가 변경됬을떄. 기존 데이터들을 쓰는 아가들에게 변경됬음을 공지한다.
		//옵저버로 post.
		
	}
	
	
	/// HistoryData 를 받아서 UD 있는 데이터에 첫번째에 삽입한다. 데이터가 업데이트를 공지하는 updateDatsNoti 를 호출한다.
	func insertCurrentPage(historyData: HistoryData) {
		
		var datas = self.loadWebHistoryArray() ?? []
		//2, 새로운 데이터를 추가한다,
		datas.insert(historyData, at: 0)
		//3. 기존의 userD에 어레이를 업데이트한다.
		let isSaveSuccess = self.saveWebHistoryArray(arr: datas)
		
		if !isSaveSuccess {
			print("뭐여. 왜 저장이 안됬지?")
		}
		
		visitedWebSiteHistoryRecords.removeAll()
		visitedWebSiteHistoryRecords.append(contentsOf: datas)
		
		//저장도 성공했네?
		self.updateDatasNoti()
	}
	
	func loadUserHistoryData() -> [HistoryData] {
		if let jsonData = userdefaultstandard.object(forKey: "HistoryData") {
		//			userdefaultstandard.synchronize()
					do {
						visitedWebSiteHistoryRecords = try decoder.decode([HistoryData].self, from: jsonData as! Data)
						return visitedWebSiteHistoryRecords
					} catch let error {
						print(error)
					}
				}
		return visitedWebSiteHistoryRecords // wrong
		
	}
	
	func removeHistoryItemAtIndexPath(historyData: HistoryData, indexPath: IndexPath) {
		//1. UserDefault 에 있는 데이터를 로드해온다. 데이터가 없으면 빈 배열 반환
		var datas = self.loadWebHistoryArray() ?? []
		//2. 지우려고 하는 indexPath.row 의 데이터를 지운다.
		datas.remove(at: indexPath.row)
		//3. 기존의 ud d 어레이를 업데이트한다.
		let isSaveSuccess = self.saveWebHistoryArray(arr: datas)
		if !isSaveSuccess {
			print("저장 실패함!!")
		}
		visitedWebSiteHistoryRecords.removeAll()
		visitedWebSiteHistoryRecords.append(contentsOf: datas)
		//4. 삭제 성공
		self.updateDatasNoti() //?????????
	}
	
	func removeAll() {
		var datas = self.loadWebHistoryArray() ?? []
		datas.removeAll()
		let isSaveSuccess = self.saveWebHistoryArray(arr: datas)
		if !isSaveSuccess {
			print("UserDefaults 의 데이터를 전부 다 날리고 저장하려고 하는데 실패!!??")
		}
		visitedWebSiteHistoryRecords.removeAll()
		//
		self.updateDatasNoti() //?????????
	}
	
	
	
//	deinit {
//		NotificationGroup.shared.
//	}

}


