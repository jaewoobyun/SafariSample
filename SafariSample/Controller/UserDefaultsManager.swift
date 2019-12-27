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
			userdefaultstandard.synchronize()
		} catch let error {
			print(error)
			return false
		}
		return true
	}
	
	//데이터를 불러오고, 직접 반환한다.
	func loadWebHistoryArray() -> [HistoryData]? {
		
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
	
	//데이터를 불러오고, update noti를 날린다.
	func loadUserHistoryData() {
		if let jsonData = userdefaultstandard.object(forKey: "HistoryData") {
					do {
						
						visitedWebSiteHistoryRecords = try decoder.decode([HistoryData].self, from: jsonData as! Data)
					} catch let error {
						print(error)
					}
				}
		
		self.updateDatasNoti()
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
	
	
	///히스토리 데이터의 업데이트를 수신하는 vc들은 이 함수로 구독신청.
	func registerHistoryDataObserver(vc:UIViewController, selector: Selector) {
		
		NotificationGroup.shared.registerObserver(type: .HistoryDataUpdate, vc: vc, selector: selector)
	}
	
	func removeHistoryDataObserver() {
		//단일. history data Observer 만 지워주세요.
		print("RemoveHistoryDataObserver")
		//TODO: ???? not sure
		NotificationCenter.default.removeObserver(self, name: NotificationGroup.NotiType.HistoryDataUpdate.getNotificationName(), object: nil)
		
	}
	
	///데이터가 변경됬을떄. 기존 데이터들을 쓰는 아가들에게 변경됬음을 공지한다.
	func updateDatasNoti() {
		//옵저버로 post.
		NotificationGroup.shared.post(type: .HistoryDataUpdate)
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
		self.updateDatasNoti()
	}
	
	
	func removeHistoryItemAtUUID(_ uuid:String) {
		
		visitedWebSiteHistoryRecords = visitedWebSiteHistoryRecords.filter { (item) -> Bool in
			if item.uuid == uuid {
				return false
			}
			
			return true
		}
		
		let isSuccess = self.saveWebHistoryArray(arr: visitedWebSiteHistoryRecords)
		print("isSuccess : \(isSuccess)")
		
		self.updateDatasNoti()
	}
	
	func removeHistoryDataAtLastHour(_ withHour:Int) {
		
		guard let deleteHour = Calendar.current.date(byAdding: .hour, value: -withHour, to: Date()) else {
			return
		}
		
		visitedWebSiteHistoryRecords = visitedWebSiteHistoryRecords.filter { (item) -> Bool in
			if deleteHour < (item.date ?? Date()) {
				return false
			}
			
			return true
		}

		let isSuccess = self.saveWebHistoryArray(arr: visitedWebSiteHistoryRecords)
		print("isSuccess : \(isSuccess)")
		
		self.updateDatasNoti()
	}
	
	func removeAllHistoryData() {
		userdefaultstandard.removeObject(forKey: "HistoryData")
		visitedWebSiteHistoryRecords.removeAll()
		
		self.updateDatasNoti()
	}
	
	
	
//	deinit {
//		NotificationGroup.shared.
//	}

}


