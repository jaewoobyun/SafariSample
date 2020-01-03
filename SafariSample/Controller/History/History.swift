//
//  History.swift
//  SafariSample
//
//  Created by Nomad on 2019/11/20.
//  Copyright © 2019 Nomad. All rights reserved.
//

import Foundation
import UIKit

class History: UITableViewController {
	
	let searchController = UISearchController(searchResultsController: nil)
	lazy var searchBar = UISearchBar(frame: CGRect.zero)
	
	let dateFormatter = DateFormatter()
	let calendar = Calendar(identifier: .gregorian)
	
	var historyData: [HistoryData] = []
	
	struct Section {
		var date: Date
		var cells: [HistoryData]
	}
	var sections: [Section] = []
	
	//MARK: - ViewDidLoad
	override func viewDidLoad() {
		self.title = "History"
		self.navigationController?.navigationBar.isHidden = false
		
		let library_path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
		print("library path is \(library_path)")
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableHeaderView = searchController.searchBar
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "historycellsample")
		
	}
	
	/// 원본 데이터의 순서가 다를 수 있기 때문에 순번대로 바꿔준다. 아래 코드가 실행되는 기준이 원본데이터가 정렬되있다고 가정하고 짜여진 코드이기 때문에.
	func sortHistoryDataDatesByTopNewBottomOld() {
		historyData.sort { (h1, h2) -> Bool in
			guard let h1Date = h1.date else {
				return false
			}
			guard let h2Date = h2.date else {
				return false
			}
			
			return (h1Date > h2Date)
		}
	}
	
	///원본 데이터를 화면에 뿌리기 좋게 가공한다.
	func sectionize() {
		
		sections.removeAll()
		
		sortHistoryDataDatesByTopNewBottomOld()
		var beforeItem: HistoryData? = nil
		
		//원본 데이터를 전부 돌린다.
		for item in historyData {
			//현재 순서의 날짜ㄹ를 빼둔다. 날짜가 없다면 현재 날짜가 된다.
			let nowDate = item.date ?? Date()
			
			//바로 직전 루프의 아이템 날짜값과 현재 아이템의 날짜값이 같은지 비교한다.
			if let beforeDate = beforeItem?.date,
				calendar.isDate(beforeDate, inSameDayAs: nowDate){
				
				sections[sections.count-1].cells.append(item)
			}
			else {
				//이전 아이템과 현재 아이템의 날짜가 다르다.
				
				//섹션에 추가될 cells를 먼저 생성하고, 현재 루프의 아이템을 추가한다.
				var arrItems:[HistoryData] = []
				arrItems.append(item)
				
				//새로운 섹션을 만들어서 sections 에 추가한다.
				let section = Section.init(date: nowDate, cells: arrItems)
				
				//sections 에 배정한다.
				sections.append(section)
			}
			// beforeItem 은 한번의 루프가 돌때 다음 아이템이 된다. historyData[0] ----> historyData[1]
			beforeItem = item
		}
		
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		UserDefaultsManager.shared.registerHistoryDataObserver(vc: self, selector: #selector(updateHistoryDatas))

		UserDefaultsManager.shared.loadUserHistoryData()
		
		
	}
	
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		UserDefaultsManager.shared.removeHistoryDataObserver()
	}
	
	@objc func updateHistoryDatas() {
		//데이터가 업데이트되었다.
		print("historyVC updateHistoryDatas")
		historyData.removeAll()
		historyData = UserDefaultsManager.shared.visitedWebSiteHistoryRecords
		
		sectionize()
		
		tableView.isUserInteractionEnabled = true
		tableView.reloadData()
		
	}
	

	@IBAction func clearButton(_ sender: UIBarButtonItem) {
		let alertController = UIAlertController(title: nil, message: "Clearing will remove history, cookies, and other browsing data. History will be cleared from devices signed into your iCloud Account. Clear from:", preferredStyle: UIAlertController.Style.actionSheet)
		let lastHour = UIAlertAction(title: "The last hour", style: UIAlertAction.Style.destructive) { (alertaction) in
			
			UserDefaultsManager.shared.removeHistoryDataAtLastHour(1)
		}
		let today = UIAlertAction(title: "Today", style: UIAlertAction.Style.destructive) { (action) in
			
			UserDefaultsManager.shared.removeHistoryDataAtLastHour(24)
		}
		let todayAndYesterday = UIAlertAction(title: "Today and Yesterday", style: UIAlertAction.Style.destructive) { (action) in
			
			UserDefaultsManager.shared.removeHistoryDataAtLastHour(48)
		}
		let allTime = UIAlertAction(title: "All Time", style: UIAlertAction.Style.destructive) { (action) in
			//HistoryVC 에 있는 데이터도 날리고 UserDefaults에 persist 하고 있는 데이터도 모두 날린다.
//			self.historyData.removeAll()
//			self.sections.removeAll()
//			self.tableView.reloadData()
			
			UserDefaultsManager.shared.removeAllHistoryData()
			
		}
		let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
			//
		}
		alertController.addAction(lastHour)
		alertController.addAction(today)
		alertController.addAction(todayAndYesterday)
		alertController.addAction(allTime)
		alertController.addAction(cancel)
		
		self.present(alertController, animated: true
			, completion: nil
		)
		
		
	}
	
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		dateFormatter.locale = Locale(identifier: "ko_kr")
		dateFormatter.dateFormat = "EEEE, MMMM d" //"화요일, 12월 17"

		let dateString = dateFormatter.string(from: sections[section].date)
		return dateString
		
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections[section].cells.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "prototype", for: indexPath)
		cell.detailTextLabel?.textColor = UIColor.gray
		
		if let titleString = sections[indexPath.section].cells[indexPath.row].title {
			cell.textLabel?.text = titleString
		}
		if let visitedDate = sections[indexPath.section].cells[indexPath.row].date {
			dateFormatter.locale = Locale(identifier: "ko_kr")
			dateFormatter.dateFormat = "EEEE, MMMM d HH:mm" //"화요일, 12월 17"
			let visitedDateString = dateFormatter.string(from: visitedDate)
			if let urlString = sections[indexPath.section].cells[indexPath.row].urlString {
				cell.detailTextLabel?.text = visitedDateString + "  " + urlString
			}
			
		}
		
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("didSelctRowAt \(indexPath)")
		let urlString = sections[indexPath.section].cells[indexPath.row].urlString
		
		NotificationGroup.shared.post(type: .historyURLName, userInfo: ["selectedHistoryURL": urlString])
		self.dismiss(animated: true, completion: nil)
		
	}
	
	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			
			///아이디는 먼저 뺴돌리고
			let selectedItemUUID = sections[indexPath.section].cells[indexPath.row].uuid
			
			//디스플레이 데이터를 기반으로 애니메이션 실행.
			self.sections[indexPath.section].cells.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
			
			tableView.isUserInteractionEnabled = false
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
				//		실물데이터에서 삭제요청.
				UserDefaultsManager.shared.removeHistoryItemAtUUID(selectedItemUUID)
				
				//??
			}
			
			
		}
	}

	
	override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (actions) -> UIMenu? in
			return AlertsAndMenus.shared.makeContextMenu()
		}
	}
	
	override func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
		//
	}
	
	
}

extension History: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		print("update SearchResults")
	}
	
	
}

class HistoryCell: UITableViewCell {
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
}
