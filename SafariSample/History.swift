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
		}
		else if indexPath.section == 1 {
			cell.textLabel?.text = visitedWebsites[indexPath.row]
		}
		
		return cell
	}
	
	
}

extension History: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		print("update SearchResults")
	}
	
	
}
