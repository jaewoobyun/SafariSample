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
	var readingListDataSave: [ReadingListData] = []
	var bookmarkListDataSave: [BookmarksData] = []
	
	init() {
		
	}
	
	
	//MARK: - History Data CRUD
	//-------------------------------------------------------------------
	func saveWebHistoryArray(arr: [HistoryData]) -> Bool {
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
	
	///데이터를 불러오고, 직접 반환한다.
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
	
	///데이터를 불러오고, update noti를 날린다.
	func loadUserHistoryData() {
		if let jsonData = userdefaultstandard.object(forKey: "HistoryData") {
			do {
				
				visitedWebSiteHistoryRecords = try decoder.decode([HistoryData].self, from: jsonData as! Data)
			} catch let error {
				print(error)
			}
		}
		
		self.updateHistoryDatasNoti()
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
	func updateHistoryDatasNoti() {
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
		self.updateHistoryDatasNoti()
	}
	
	///안쓰임!!! technically 지워도 됨??
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
		self.updateHistoryDatasNoti()
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
		
		self.updateHistoryDatasNoti()
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
		
		self.updateHistoryDatasNoti()
	}
	
	func removeAllHistoryData() {
		userdefaultstandard.removeObject(forKey: "HistoryData")
		visitedWebSiteHistoryRecords.removeAll()
		
		self.updateHistoryDatasNoti()
	}
	
	
	//MARK: - ReadingListData CRUD methods
	func registerReadingListDataObserver(vc: UIViewController, selector: Selector) {
		NotificationGroup.shared.registerObserver(type: .ReadingListDataUpdate, vc: vc, selector: selector)
	}
	
	func removeReadingListDataObserver() {
		print("Removing ReadingListData Observer")
		NotificationCenter.default.removeObserver(self, name: NotificationGroup.NotiType.ReadingListDataUpdate.getNotificationName(), object: nil)
	}
	
	func updateReadingListDataNoti() {
		NotificationGroup.shared.post(type: .ReadingListDataUpdate)
	}
	
	func saveReadingListData(rld: [ReadingListData]) -> Bool {
		do {
			let encodedReadingListData = try encoder.encode(rld)
			userdefaultstandard.set(encodedReadingListData, forKey: "ReadingListData")
			userdefaultstandard.synchronize()
		} catch let error {
			print(error)
			return false
		}
		return true
	}
	
	///데이터를 불러오고, update noti를 날린다.
	func loadUserReadingListData() {
		if let jsonData = userdefaultstandard.object(forKey: "ReadingListData") {
			do {
				self.readingListDataSave = try decoder.decode([ReadingListData].self, from: jsonData as! Data)
			} catch let error {
				print(error)
			}
		}
		
		self.updateReadingListDataNoti()
	}
	
	func loadReadingListArray() -> [ReadingListData]? {
		if let jsonObject = userdefaultstandard.object(forKey: "ReadingListData") {
			do {
				let readinglistD = try decoder.decode([ReadingListData].self, from: jsonObject as! Data)
				
				return readinglistD
			} catch let error {
				print(error)
			}
		}
		return nil
	}
	
	func insertCurrentItemToReadingList(readingListData: ReadingListData) {
		var data = self.loadReadingListArray() ?? []
		data.insert(readingListData, at: 0)
		let isSaveSuccess = self.saveReadingListData(rld: data)
		
		if !isSaveSuccess {
			print("ReadingList 저장에 실패함!!")
		}
		self.readingListDataSave.removeAll()
		self.readingListDataSave.append(contentsOf: data)
		
		self.updateReadingListDataNoti()
	}
	
	
	func removeReadingListItemAtIndexPath(indexPath: IndexPath) {
		var data = self.loadReadingListArray() ?? []
		data.remove(at: indexPath.row)
		let isSaveSuccess = self.saveReadingListData(rld: data)
		if !isSaveSuccess {
			print("ReadingList 저장 실패.")
		}
		self.readingListDataSave.removeAll()
		self.readingListDataSave.append(contentsOf: data)
		
		self.updateReadingListDataNoti()
	}
	
	
	func removeReadingListItemWithUUID(uuids: [String]) {
		
		let arrNew = (self.loadReadingListArray() ?? []).filter { (item) -> Bool in
			for uuid in uuids {
				if item.uuid == uuid {
					return false
				}
			}
			return true
		}
		
		let isSaveSuccess = self.saveReadingListData(rld: arrNew)
		if !isSaveSuccess {
			print("ReadingList 저장 실패.")
		}
		
		self.readingListDataSave.removeAll()
		self.readingListDataSave.append(contentsOf: arrNew)
		
		self.updateReadingListDataNoti()
	}
	
	
	//	deinit {
	//		NotificationGroup.shared.
	//	}
	
	
	
	//MARK: - BookmarkData CRUD methods
	/// Save
	func saveBookMarkListData(bookmarkD: [BookmarksData]) -> Bool {
		do {
			let encodedReadingListData = try encoder.encode(bookmarkD)
			userdefaultstandard.set(encodedReadingListData, forKey: "BookMarkListData")
			userdefaultstandard.synchronize()
		} catch let error {
			print(error)
			return false
		}
		self.updateBookmarkListDataNoti() //
		return true
	}
	
	///데이터를 불러오고, update noti를 날린다.
	func loadUserBookMarkListData() -> [BookmarksData] {
		if let jsonData = userdefaultstandard.object(forKey: "BookMarkListData") {
			do {
				let datas = try decoder.decode([BookmarksData].self, from: jsonData as! Data)
				return datas
			} catch let error {
				print(error)
			}
		}
		self.updateBookmarkListDataNoti()
		return []
	}
	
	/// Insert
	//TODO: - not yet final
	func insertFolder(folder: BookmarksData, indexPath: IndexPath) {
		var bookmarkDatas = self.loadUserBookMarkListData()
		
		
	}
	
	/// 데이터를 해당 indexPath 에서 지운다.
	func removeBookmarkFolderItemAtIndexPath(indexPath: IndexPath) {
		var data = loadUserBookMarkListData()
		data.remove(at: indexPath.row)
		let isSaveSuccess = self.saveBookMarkListData(bookmarkD: data)
		if !isSaveSuccess {
			print("BookmarkData 를 indexPath.row 에서 지우고 저장하는데에 실패")
		}
		self.bookmarkListDataSave.removeAll()
		self.bookmarkListDataSave.append(contentsOf: data)
		
		self.updateBookmarkListDataNoti()
		
	}
	
	func registerBookmarkDataObserver(vc: UIViewController, selector: Selector) {
		NotificationGroup.shared.registerObserver(type: .BookmarkListDataUpdate, vc: vc, selector: selector)
	}
	
	func removeBookmarksDataObserver() {
		print("Removing Bookmark / Folder Data Observer")
		NotificationCenter.default.removeObserver(self, name: NotificationGroup.NotiType.BookmarkListDataUpdate.getNotificationName(), object: nil)
	}
	
	func updateBookmarkListDataNoti() {
		NotificationGroup.shared.post(type: .BookmarkListDataUpdate)
	}
	
	
}


