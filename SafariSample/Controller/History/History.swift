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
	
	let ud = UserDefaults.standard
	
	var dates: [String] = []
	
	var sectionDates: [Date] = []
	var historyData: [HistoryData] = []
	
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
	
	struct Section {
		var date: Date
		var cells: [HistoryData]
	}
	var sections: [Section] = []
	
	func sortDatesBySection() {
		
		var comparableDate: Date
		let calendar = Calendar(identifier: .gregorian)
		
		for item in historyData {
			guard let itemdate = item.date else { return }
			/// comparableDate 에 현재 아이템이 추가된 시간을 할당.
			comparableDate = itemdate
			/// 만약 comparableDate 가 다음에 올 itemDate 와 같은 날에 있다면 sectionDate 를 갱신한다.
			
			if calendar.isDate(comparableDate, inSameDayAs: itemdate) {
				sectionDates = [comparableDate]
				/// 같은 날짜에 들어간 history 들을 section하나로 묶고,  그 안에 해당 데이터들을 넣는다.
//				sections.append(History.Section(date: comparableDate, cells: [item]))
			}
			else { //만약 다른 날짜라고 하면 sectionDates에 다른 날짜를 추가해준다.
				sectionDates.append(itemdate)
				/// 다른 날짜면, section 이 바뀌어야 하니까 section 에 다른 Section 타입의 데이터를 추가해준다.
//				sections.append(History.Section(date: itemdate, cells: [item]))
			}
		}
		
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		guard let historyD = UserDefaultsManager.shared.loadWebHistoryArray() else { return }
		
		historyData = historyD
		sortDatesBySection()
		tableView.reloadData()
//		dates = [(UserDefaults.standard.object(forKey: "Date") as? String ?? "Today")]
		dates = UserDefaults.standard.stringArray(forKey: "Date") ?? ["Today"]
	}
	
	
	
	@IBAction func clearButton(_ sender: UIBarButtonItem) {
		let alertController = UIAlertController(title: nil, message: "Clearing will remove history, cookies, and other browsing data. History will be cleared from devices signed into your iCloud Account. Clear from:", preferredStyle: UIAlertController.Style.actionSheet)
		let lastHour = UIAlertAction(title: "The last hour", style: UIAlertAction.Style.destructive) { (alertaction) in
			//??
		}
		let today = UIAlertAction(title: "Today", style: UIAlertAction.Style.destructive) { (action) in
			//??
		}
		let todayAndYesterday = UIAlertAction(title: "Today and Yesterday", style: UIAlertAction.Style.destructive) { (action) in
			//??
			
		}
		let allTime = UIAlertAction(title: "All Time", style: UIAlertAction.Style.destructive) { (action) in
			//??
			self.historyData.removeAll()
			UserDefaults.standard.removeObject(forKey: "HistoryData")
			self.dates.removeAll()
			UserDefaults.standard.removeObject(forKey: "Date")
//			UserDefaults.standard.removeObject(forKey: "jsonKey")
			self.tableView.reloadData()
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
//		return dates.count
		return sectionDates.count
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//		return dates[section]
		
		dateFormatter.locale = Locale(identifier: "ko_kr")
		dateFormatter.dateFormat = "EEEE, MMMM d HH:mm" //"화요일, 12월 17"
		let dateString = dateFormatter.string(from: sectionDates[section])
		return dateString
//		let dateString = dateFormatter.string(from: sections[section].date)
//		return dateString
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return historyData.count
//		return sections[section].cells.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "prototype", for: indexPath)
		cell.textLabel?.text = historyData[indexPath.row].urlString

		if let visitedDate = historyData[indexPath.row].date {
			dateFormatter.locale = Locale(identifier: "ko_kr")
			dateFormatter.dateFormat = "EEEE, MMMM d HH:mm" //"화요일, 12월 17"
			let dt = dateFormatter.string(from: visitedDate)
			cell.detailTextLabel?.text = dt
		}

		cell.detailTextLabel?.textColor = UIColor.gray
		
//		cell.textLabel?.text = sections[indexPath.section].cells[indexPath.row].urlString
//		if let visitedDate = sections[indexPath.section].cells[indexPath.row].date {
//			dateFormatter.locale = Locale(identifier: "ko_kr")
//			dateFormatter.dateFormat = "EEEE, MMMM d HH:mm" //"화요일, 12월 17"
//			cell.detailTextLabel?.text = dateFormatter.string(from: visitedDate)
//		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			historyData.remove(at: indexPath.row) /// <- 이거 아님??!!!!!!!!!!!
//			UserDefaults.standard.setValue(historyData, forKey: "HistoryData")
			
//			sections[indexPath.section].cells.remove(at: indexPath.row)
			
			UserDefaultsManager.shared.saveWebHistoryArray(arr: self.historyData) /// <- 여기 로직 틀린듯!!!!!!!!!!!!!!!!
			tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("didSelctRowAt \(indexPath)")
		let urlString = historyData[indexPath.row].urlString
		
		NotificationGroup.shared.post(type: .historyURLName, userInfo: ["selectedHistoryURL": urlString])
		self.dismiss(animated: true, completion: nil)
		
		
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
