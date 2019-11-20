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
	
	@IBOutlet weak var bottomLeftBarButton: UIBarButtonItem!
	
	@IBOutlet weak var bottomRightBarButton: UIBarButtonItem!
	
	
	//MARK: - Constants
	static let tableViewBookmarkCellIdentifier = "BookmarkCellID"
	static let tableViewHistoryCellIdentifier = "HistoryCellID"
	private static let nibName = "BookmarkNib"
	
	
	@IBAction func indexChanged(_ sender: UISegmentedControl) {
		switch segmentedControl.selectedSegmentIndex {
		case 0:
			self.title = "Bookmarks"
			searchController.searchBar.placeholder = "Search Bookmarks"
			//TODO: - bookmarks cell
			bottomRightBarButton.title = "Edit"
		case 1:
			self.title = "Reading List"
			searchController.searchBar.placeholder = "Search Reading List"
			//TODO: - reading list cell
			tableView.reloadData()
		case 2:
			self.title = "History"
			searchController.searchBar.placeholder = "Search History"
			//TODO: - historycell
			bottomRightBarButton.title = "Clear"
			
//			reloadTableView()
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
		self.title = "Bookmarks"
		self.title = title
		
		self.topToolBar.delegate = self
		
//		self.navigationItem.searchController = searchController
		
//		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "sample")
		self.navigationController?.navigationBar.barTintColor = barBackgroundColor
		
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.tableHeaderView = searchController.searchBar
		
		tableView.reloadData()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.title = title
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationController?.navigationBar.barTintColor = barBackgroundColor
		tableView.reloadData()
	}
	
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
		navigationController?.navigationBar.shadowImage = nil
	}
	
	func reloadTableView() {
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "example")
		tableView.reloadData()
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
