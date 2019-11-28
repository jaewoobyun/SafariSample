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
	@IBOutlet weak var editButton: UIBarButtonItem!
	
	//MARK: - Constants
	static let tableViewBookmarkCellIdentifier = "BookmarkCellID"
	static let tableViewHistoryCellIdentifier = "HistoryCellID"
	private static let nibName = "BookmarkNib"
	
	//MARK: - Properties
	
	var bookmarkStrings: [String] = []
	var topmostItem: [String] = []
	
	let searchController = UISearchController(searchResultsController: nil)
	lazy var searchBar = UISearchBar(frame: CGRect.zero)
	let barBackgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
	
//	let sampleBookmarkData0 = BookmarksData.Bookmark(name: "google", href: URL(string: "www.google.com")!, icon: nil)
//	let sampleBookmarkData1 = BookmarksData.Bookmark(name: "naver", href: URL(string: "www.m.naver.com")!, icon: nil)
//	let sampleBookmarkData2 = BookmarksData.Bookmark(name: "facebook", href: URL(string: "www.facebook.com")!, icon: nil)
//	let sampleBookmarkData3 = BookmarksData.Bookmark(name: "apple", href: URL(string: "www.apple.com")!, icon: nil)
	
	let sampleFolderData = BookmarksData.Folders.init(folderName: "Favorites", items: [
		BookmarksData.Bookmark(name: "google", href: URL(string: "www.google.com")!, icon: nil),
		BookmarksData.Bookmark(name: "naver", href: URL(string: "www.m.naver.com")!, icon: nil),
		BookmarksData.Bookmark(name: "facebook", href: URL(string: "www.facebook.com")!, icon: nil),
		BookmarksData.Bookmark(name: "apple", href: URL(string: "www.apple.com")!, icon: nil)
		
	])
	
	var toggle: Bool = false
	var newFolderButton:UIBarButtonItem?
	
	var btnTemp:UIButton?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Bookmarks"
		
		readStringFromHTMLFile(with: "bookmarks_11_19_19")
		print(topmostItem)
//		self.topToolBar.delegate = self
		
//		self.navigationItem.searchController = searchController
		
//		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "sample")
		self.navigationController?.navigationBar.barTintColor = barBackgroundColor
		
		
		self.editButton = self.editButtonItem
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableHeaderView = searchController.searchBar
		tableView.isEditing = false
		toggle = tableView.isEditing
		
		
		btnTemp = UIButton.init(type: .custom)
		btnTemp = UIButton.init(type: UIButton.ButtonType.contactAdd)
//		btnTemp?.setTitle("New Folder", for: .normal) //title
		btnTemp?.addTarget(self, action: #selector(addNewFolder), for: UIControl.Event.touchUpInside)
		btnTemp?.isHidden = true
		
		newFolderButton = UIBarButtonItem.init(customView: btnTemp!)
		
		//newFolderButton = UIBarButtonItem(title: "New Folder", style: UIBarButtonItem.Style.plain, target: self, action: #selector(addNewFolder))
		self.toolbarItems?.insert(newFolderButton!, at: 0)
		

		
		tableView.reloadData()
		
		
	}
	
	
	@IBAction func editButton(_ sender: UIBarButtonItem) {
		toggle = !toggle
		if toggle == true {
			tableView.isEditing = true
			btnTemp?.isHidden = false
			sender.title = "Done"
		} else {
			tableView.isEditing = false
			btnTemp?.isHidden = true
			sender.title = "Edit"
		}
		
	}
	
	@objc func addNewFolder() {
		print("AddNewFolder!!")
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let editFolderVC = storyboard.instantiateViewController(identifier: "EditFolderVC")
		self.navigationController?.pushViewController(editFolderVC, animated: true)
	}
	
	
	private func readStringFromHTMLFile(with name: String) -> String {
		guard let path = Bundle.main.url(forResource: name, withExtension: "html") else { return "" }
		do {
			let content = try String(contentsOf: path, encoding: String.Encoding.utf8)
			print("-----------content-------------")
//			print(content)
			let doc: Document = try SwiftSoup.parse(content)
			
/// Swift Soup parsing Example
//			print(doc)
//			let link: Element = try doc.select("A").first()!
//			print("------link---------")
//			print(link)
//			let text: String = try doc.body()!.text();
//			print("------text---------")
//			print(text)
//			let linkHref: String = try link.attr("href");
//			print("-----linkHref----------")
//			print(linkHref)
//			let linkText: String = try link.text();
//			print("------linkText---------")
//			print(linkText)
//			let linkOuterH: String = try link.outerHtml();
//			print("------linkOuterH---------")
//			print(linkOuterH)
//			let linkInnerH: String = try link.html();
//			print("------linkText---------")
//			print(linkInnerH)
			
//			let h3s: Elements = try doc.select("H3")
//			for h3 in h3s {
//				let text = try h3s.text()
//				bookmarkStrings.append(text)//
//				print(text)
//			}
			
//			let dls: Elements = try doc.select("DL")
//			for dl in dls {
//				let dts: Elements = try dls.select("DT")
//				for dt in dts {
//					let h3s: Elements = try dts.select("H3")
//					for h3 in h3s {
//						let folders = try h3.text()
//						print(folders)
//					}
//
//				}
//			}
			
			
//			let p: Elements = try doc.select("p")
//			for dt in p {
//				let a: Elements = try p.select("A")
//				let aText = try a.text()
//				print(aText)
//				topmostItem.append(aText)
//
//
//			}
			
			//-------------------------------------

//				let dts: Elements = try doc.select("DT")
//				for dt in dts {
//					let h3s: Elements = try dt.select("H3")
//					for h3 in h3s {
//						if h3.hasText() {
//							let foldername: String = try h3.text()
//							topmostItem.append(foldername)
//						}
//					}
//				}
			
//			let dls: Elements = try doc.select("DL > p")
//			for dl in dls {
//				print(dl)
//			}
			
			let wants: Elements = try doc.select("DT > H3")
			for want in wants {
				let text = try want.text()
				topmostItem.append(text)
			}
			
//			let dls: Elements = try doc.select("DL > p")
//			for dl in dls {
//				let dts: Elements = try dls.select("DT > H3")
//				for dt in dts {
//					let h3 = try dt.text()
//					topmostItem.append(h3)
//				}
//			}
			
//-------------------------------------------
			
			
//			if let topmostElement: Element = try doc.lastElementSibling() {
//				print(topmostElement.ownText())
//			}
//			let topmostElement: Elements = try doc.select("DL")
			
			
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
		
//		if toggle == true {
//			self.toolbarItems?.insert(newFolderButton, at: 0)
//		}
//		else if toggle == false {
//
//		}
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
//		return topmostItem.count
		return sampleFolderData.items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "sample", for: indexPath)
//		cell.textLabel?.text = topmostItem[indexPath.row]
		cell.textLabel?.text = sampleFolderData.folderName
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			//TODO: - delete the row from the data source
			tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
		}
	}
	
	func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//		var rowToMove = data[indexPath.row]
//		data.removeAtIndex()
		
	}
	
	
}
