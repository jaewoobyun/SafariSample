//
//  BookmarksVC.swift
//  SafariSample
//
//  Created by Nomad on 2019/11/19.
//  Copyright © 2019 Nomad. All rights reserved.
//

import Foundation
import UIKit

class BookmarksVC: UIViewController {
	
	
	//MARK: - Outlets
	@IBAction func done(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true, completion: nil)
	}
	@IBOutlet weak var topToolBar: UIToolbar!
	
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	
	@IBOutlet weak var tableView: UITableView!
	
	//MARK: - Constants
	static let tableViewBookmarkCellIdentifier = "BookmarkCellID"
	private static let nibName = "BookmarkNib"
	
	
	@IBAction func indexChanged(_ sender: UISegmentedControl) {
		switch segmentedControl.selectedSegmentIndex {
		case 0:
			print("Bookmarks")
			self.title = "Bookmarks"
		case 1:
			print("Reading List")
			self.title = "Reading List"
		case 2:
			print("History")
			self.title = "History"
		default:
			break
		}
		
	}
	
	//MARK: - Properties
	
	let searchController = UISearchController(searchResultsController: nil)
	lazy var searchBar = UISearchBar(frame: CGRect.zero)
	let barBackgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
	
	override func viewDidLoad() {
		super.viewDidLoad()
//		self.title = "Bookmarks"
		self.title = title
		
		self.topToolBar.delegate = self
		
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationController?.navigationBar.barTintColor = barBackgroundColor
		
		
//		self.navigationItem.searchController = searchController
		
//		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "sample")
		
		
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.tableHeaderView = searchController.searchBar
		
		tableView.reloadData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.title = title
		tableView.reloadData()
	}
	
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
		navigationController?.navigationBar.shadowImage = nil
	}
	
}

//MARK: - ToolbarDelgate
extension BookmarksVC: UIToolbarDelegate {
	func position(for bar: UIBarPositioning) -> UIBarPosition {
		return UIBarPosition.topAttached
	}
}


//MARK: - UISearchResultsUpdating
extension BookmarksVC: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
//		searchBar = searchController.searchBar //
	}
	
	
}


//MARK: - UITableView Delegate, Datasource
extension BookmarksVC: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5 //
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "sample", for: indexPath)
		cell.textLabel?.text = "\(indexPath.row)awfe"
		cell.detailTextLabel?.text = "detail"
		
		return cell
	}
	
	
	
}
