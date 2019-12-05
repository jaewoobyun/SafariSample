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
	
//	var Dates: [String] = ["Tuesday Afternoon", "Monday, November 18", "Saturday, November 16", "awefawef"]
	
	var dates: [String] = []
	
	let historyData = UserDefaults.standard.stringArray(forKey: "HistoryData") ?? [String]()
	
	//MARK: - ViewDidLoad
	override func viewDidLoad() {
		self.title = "History"
		self.navigationController?.navigationBar.isHidden = false
		
		let now = Date()
		let date = DateFormatter()
		date.locale = Locale(identifier: "ko_kr")
		date.dateFormat = "EEEE, MMMM d"
		let krDateTime = date.string(from: now)
		
		UserDefaults.standard.setValue(krDateTime, forKey: "Date")
		
		dates = [(UserDefaults.standard.object(forKey: "Date") as? String ?? "Today")]
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableHeaderView = searchController.searchBar
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "historycellsample")
		
		
	}
	
	
	
	@IBAction func clearButton(_ sender: UIBarButtonItem) {
		let alertController = UIAlertController(title: nil, message: "Clearing will remove history, cookies, and other browsing data. History will be cleared from devices signed into your iCloud Account. Clear from:", preferredStyle: UIAlertController.Style.actionSheet)
		let lastHour = UIAlertAction(title: "The last hour", style: UIAlertAction.Style.destructive) { (alertaction) in
			//
		}
		let today = UIAlertAction(title: "Today", style: UIAlertAction.Style.destructive) { (action) in
			//
		}
		let todayAndYesterday = UIAlertAction(title: "Today and Yesterday", style: UIAlertAction.Style.destructive) { (action) in
			//
		}
		let allTime = UIAlertAction(title: "All Time", style: UIAlertAction.Style.destructive) { (action) in
			//
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
		return dates.count
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return dates[section]
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return visitedWebsites.count
		return historyData.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "prototype", for: indexPath)
		cell.textLabel?.text = historyData[indexPath.row]
		cell.detailTextLabel?.text = historyData[indexPath.row]
		cell.detailTextLabel?.textColor = UIColor.gray
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
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
