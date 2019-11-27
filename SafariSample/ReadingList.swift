//
//  ReadingList.swift
//  SafariSample
//
//  Created by Nomad on 2019/11/25.
//  Copyright © 2019 Nomad. All rights reserved.
//

import UIKit

class ReadingList: UIViewController {
	
	//MARK: - Outlets
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var editButton: UIBarButtonItem!
	@IBOutlet weak var secretButton: UIBarButtonItem!
	
	let searchController = UISearchController(searchResultsController: nil)
	lazy var searchBar = UISearchBar(frame: CGRect.zero)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Reading List"
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableHeaderView = searchController.searchBar
		tableView.isEditing = false
		
		
		tableView.reloadData()
		
	}
	
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/
	
}

extension ReadingList: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		print("updateSearchResults")
	}
	
}

extension ReadingList : UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "readinglistprototype", for: indexPath)
		cell.textLabel?.text = "1aowefjawof;weaofj"
		cell.detailTextLabel?.text = "2awioefjwaiofoi"
//		cell.imageView?.image =
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
	
	
}
