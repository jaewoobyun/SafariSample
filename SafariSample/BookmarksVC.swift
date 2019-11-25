//
//  BookmarksVC.swift
//  SafariSample
//
//  Created by Nomad on 2019/11/19.
//  Copyright © 2019 Nomad. All rights reserved.
//

import Foundation
import UIKit
import SwiftSoup

class BookmarksVC: UIViewController {
	
	
	//MARK: - Outlets
	@IBOutlet weak var tableView: UITableView!
	
	//MARK: - Constants
	static let tableViewBookmarkCellIdentifier = "BookmarkCellID"
	static let tableViewHistoryCellIdentifier = "HistoryCellID"
	private static let nibName = "BookmarkNib"
	
	//MARK: - Properties
	
	var bookmarkStrings: [String] = []
	var allHrefs: [URL] = []
	
	let searchController = UISearchController(searchResultsController: nil)
	lazy var searchBar = UISearchBar(frame: CGRect.zero)
	let barBackgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Bookmarks"
		
		readStringFromHTMLFile(with: "bookmarks_11_19_19")
		
//		self.topToolBar.delegate = self
		
//		self.navigationItem.searchController = searchController
		
//		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "sample")
		self.navigationController?.navigationBar.barTintColor = barBackgroundColor
		
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.tableHeaderView = searchController.searchBar

		tableView.reloadData()
		
	}
	
	private func readStringFromHTMLFile(with name: String) -> String {
		guard let path = Bundle.main.url(forResource: name, withExtension: "html") else { return "" }
		do {
			let content = try String(contentsOf: path, encoding: String.Encoding.utf8)
			print("-----------content-------------")
//			print(content)
			let doc: Document = try SwiftSoup.parse(content)
			let link: Element = try doc.select("A").first()!
//			let h3s: [Element] = try doc.getElementsContainingOwnText("H3").array()
			
//			let firstDepth = try doc.childNode(<#T##index: Int##Int#>)

//			let text: String = try doc.body()!.text();
//			let linkHref: String = try link.attr("href");
//			let linkText: String = try link.text();
//
//			let linkOuterH: String = try link.outerHtml();
//			let linkInnerH: String = try link.html();
		
//			bookmarkStrings.append(contentsOf: )

//			print(doc)
//			print("------link---------")
//			print(link)
//			print("------text---------")
//			print(text)
//			print("-----linkHref----------")
//			print(linkHref)
//			print("------linkText---------")
//			print(linkText)
//
//			print("------linkOuterH---------")
//			print(linkOuterH)
//			print("------linkText---------")
//			print(linkInnerH)
			
			
			
//			bookmarkStrings.append(text)
//			print("------bookmarkStrings-----")
//			print(bookmarkStrings)
			
//			bookmarkStrings.append(try doc.getElementsByTag("H3"))
//			print("-------bookmarkstrings------")
//			print(bookmarkStrings)
			
			
//			guard let elements = try? doc.getAllElements() else { return content}
//
//			for element in elements {
//				for textNode in element.textNodes() {
//					bookmarkStrings.append(textNode.text())
//				}
//			}
//			print(bookmarkStrings)
			
			
			return content
		}
		catch {
			return ""
		}
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
