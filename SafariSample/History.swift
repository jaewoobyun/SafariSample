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
	
	var visitedWebsites: [String] = ["www.google.com", "www.naver.com", "www.facebook.com", "www.daum.net"]
	var Dates: [String] = ["Tuesday Afternoon", "Monday, November 18", "Saturday, November 16", "awefawef"]
	
	//MARK: - ViewDidLoad
	override func viewDidLoad() {
		self.title = "History"
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
		return Dates.count
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return Dates[section]
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return visitedWebsites.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "historycellsample", for: indexPath)
		
		if indexPath.section == 0 {
			cell.textLabel?.text = visitedWebsites[indexPath.row]
			cell.detailTextLabel?.text = visitedWebsites[indexPath.row]
			
		}
		else if indexPath.section == 1 {
			cell.textLabel?.text = visitedWebsites[indexPath.row]
			cell.detailTextLabel?.text = visitedWebsites[indexPath.row]
		}
		
		return cell
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
