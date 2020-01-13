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

class BookmarksVC: UIViewController{
	
	//MARK: - Outlets
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var editButton: UIBarButtonItem!
	
	//MARK: - Constants
	static let tableViewBookmarkCellIdentifier = "BookmarkCellID"
	static let tableViewHistoryCellIdentifier = "HistoryCellID"
	private static let nibName = "BookmarkNib"
	
	//MARK: - Properties
	
	var isDepthViewController:Bool = false
	var bookmarksData: [BookmarksData] = []
	var bookmarkStrings: [String] = []
	var topmostItem: [String] = []
	
	let searchController = UISearchController(searchResultsController: nil)
	lazy var searchBar = UISearchBar(frame: CGRect.zero)
	let barBackgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
	
	var toggle: Bool = false
	var newFolderButton:UIBarButtonItem?
	
	var btnTemp:UIButton?
	
	var completionHandler: ((_ urlString: String?) ->())?
	
	//MARK: - LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		self.title = "Bookmarks"
		self.navigationController?.navigationBar.isHidden = false
		
		readStringFromHTMLFile(with: "bookmarks_11_19_19")
		//		print(topmostItem)
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
		tableView.allowsSelectionDuringEditing = true
		
		
		btnTemp = UIButton.init(type: .custom)
		//		btnTemp = UIButton.init(type: UIButton.ButtonType.contactAdd)
		btnTemp?.setTitle("New Folder", for: .normal) //title
		btnTemp?.setTitleColor(.systemBlue, for: .normal)
		btnTemp?.addTarget(self, action: #selector(addNewFolder), for: UIControl.Event.touchUpInside)
		btnTemp?.isHidden = true
		
		newFolderButton = UIBarButtonItem.init(customView: btnTemp!)
		
		self.toolbarItems?.insert(newFolderButton!, at: 0)
		//		registerForPreviewing(with: self, sourceView: tableView)
		let interaction = UIContextMenuInteraction(delegate: self)
		tableView.addInteraction(interaction)
		
		tableView.reloadData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.title = title
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationController?.navigationBar.barTintColor = barBackgroundColor
		UserDefaultsManager.shared.registerBookmarkDataObserver(vc: self, selector: #selector(updateBookmarkListDatas))
		
		
		if bookmarksData.count == 0, !isDepthViewController {
			self.title = "Bookmarks"
			//			BookmarksDataModel.createSampleData()
			//			let bookmarksArray = BookmarksDataModel.bookMarkDatas
			//			bookmarksData = bookmarksArray
			///제일 처음 데이터가 로드 된다.
			bookmarksData = UserDefaultsManager.shared.loadUserBookMarkListData()
		}
		
		if let selectedIndexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: selectedIndexPath, animated: animated)
		}
		
		//		if toggle == true {
		//			self.toolbarItems?.insert(newFolderButton, at: 0)
		//		}
		//		else if toggle == false {
		//
		//		}
		
		tableView.reloadData()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
		navigationController?.navigationBar.shadowImage = nil
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		UserDefaultsManager.shared.removeBookmarksDataObserver()
	}
	
	@objc func updateBookmarkListDatas() {
		print("BookmarkVC updateBookmarkListDatas")
		self.bookmarksData.removeAll()
		self.bookmarksData = UserDefaultsManager.shared.loadUserBookMarkListData()
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
		//		let editFolderVC = storyboard.instantiateViewController(identifier: "EditFolderVC")
		//		self.navigationController?.pushViewController(editFolderVC, animated: true)
		let editFolderVC = storyboard.instantiateViewController(identifier: "EditFolder")
		if let editFolder = editFolderVC as? EditFolder {
			editFolder.caseType = .AddNewFolder
			self.navigationController?.pushViewController(editFolder, animated: true)
		}
		
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
		return bookmarksData.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "sample", for: indexPath)
		//		cell.textLabel?.text = topmostItem[indexPath.row]
		//		cell.textLabel?.text = sampleFolderData.folderName
		
		if !bookmarksData[indexPath.row].isFolder {
			cell.imageView?.image = UIImage(systemName: "book")
			cell.textLabel?.text = bookmarksData[indexPath.row].titleString
			cell.editingAccessoryType = .disclosureIndicator
			return cell
		}
		else if bookmarksData[0].titleString == "Favorites" && bookmarksData[indexPath.row].isFolder {
			cell.imageView?.image = UIImage(systemName: "star")
		}
		else {
			//cell 재활용할때 반드시 반대 케이스 명시!!!!!!!!!
			cell.imageView?.image = UIImage(systemName: "folder")
		}
		
		cell.textLabel?.text = bookmarksData[indexPath.row].titleString
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("didSelctRowAt \(indexPath)")
		
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		if let reuseableVC = storyboard.instantiateViewController(identifier: "BookmarksVC") as? BookmarksVC {
			if bookmarksData[indexPath.row].isFolder {
				if tableView.isEditing {
					if let reusableEditFolder = storyboard.instantiateViewController(identifier: "EditFolder") as? EditFolder {
						reusableEditFolder.folderTitle = bookmarksData[indexPath.item].titleString
						//TODO: - need to pass the location of the editing folder to EditFolder
						reusableEditFolder.selectedIndexPath = indexPath
						navigationController?.pushViewController(reusableEditFolder, animated: true)
					}
				}
				else {
					print("is Folder")
					reuseableVC.navigationController?.title = bookmarksData[indexPath.row].titleString
					reuseableVC.title = bookmarksData[indexPath.row].titleString
					reuseableVC.bookmarksData = bookmarksData[indexPath.row].child
					reuseableVC.isDepthViewController = true
					
					if let cc = self.completionHandler {
						reuseableVC.completionHandler = cc
					}
					navigationController?.pushViewController(reuseableVC, animated: true)
				}
			}
			else {
				guard let urlString = bookmarksData[indexPath.row].urlString else { return }
				guard let titleString = bookmarksData[indexPath.row].titleString else { return }
				if tableView.isEditing {
					if let reusableEditBookmarkVC = storyboard.instantiateViewController(withIdentifier: "EditBookmarkVC") as? EditBookmarkVC {
						reusableEditBookmarkVC.bookmarkTitle = titleString
						reusableEditBookmarkVC.address = urlString
						navigationController?.pushViewController(reusableEditBookmarkVC, animated: true)
					}
					
				}
				else {
					NotificationGroup.shared.post(type: .bookmarkURLName, userInfo: ["selectedBookmarkURL": urlString])
					//				if let completionHandler = self.completionHandler {
					//					completionHandler(urlString)
					//				}
					self.dismiss(animated: true, completion: nil)
				}
				
				
			}
		} else {
			print("vc load fail")
		}
		
		
		
	}
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			//TODO: - child로 들어가서 지울때 에러난다.
			
			bookmarksData.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
				UserDefaultsManager.shared.removeBookmarkFolderItemAtIndexPath(indexPath: indexPath)
			}
		}
	}
	
	func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		//		var rowToMove = data[indexPath.row]
		//		data.removeAtIndex()
		
	}
	
	func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		//		return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (suggestedActions) -> UIMenu? in
		//			return self.makeContextMenu()
		//		}
		//		guard let indexPath = tableView.indexPathForRow(at: location), let cell = tableView.cellForRow(at: indexPath) else { return nil }
		//		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		guard let bookmarksVC = storyboard?.instantiateViewController(identifier: "BookmarksVC") as? BookmarksVC else { preconditionFailure("Failed to preview bookmarksVC")}
		///폴더 일때
		if bookmarksData[indexPath.row].isFolder {
			//ContextMenu * Copy Contents, * Open in new tabs, * Edit, * Delete
			print("is Folder")
			bookmarksVC.navigationController?.title = bookmarksData[indexPath.row].titleString
			bookmarksVC.title = bookmarksData[indexPath.row].titleString
			bookmarksVC.bookmarksData = bookmarksData[indexPath.row].child
			bookmarksVC.isDepthViewController = true
			/// leaf node 일때 (= 마지막 끝 노드일때)
			if bookmarksData[indexPath.row].child.isEmpty {
				print("leaf node!!")
				return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (actions) -> UIMenu? in
					return AlertsAndMenus.shared.makeEmptyFolderContextMenu()
				}
				
			}
		}
		else { // Bookmark 일때 Context Menu * preview, * copy, * open in new tab, * Edit, * Delete
			print("is Bookmark")
			//TODO: - show a preview of the link (webview).
			return UIContextMenuConfiguration(identifier: nil, previewProvider: {return bookmarksVC}) { (actions) -> UIMenu? in
				return AlertsAndMenus.shared.makeBookmarkContextMenu()
			}
		}
		return UIContextMenuConfiguration(identifier: nil, previewProvider: {return bookmarksVC}) { (actions) -> UIMenu? in
			return AlertsAndMenus.shared.makeFolderContextMenu()
		}
		
	}
	
	func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
		animator.addCompletion {
			
		}
	}
	
	
}

//extension BookmarksVC: UIViewControllerPreviewingDelegate {
//	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
//		guard let indexPath = tableView.indexPathForRow(at: location), let cell = tableView.cellForRow(at: indexPath) else { return nil }
//
//		previewingContext.sourceRect = cell.frame
////		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//		guard let reusableVC = storyboard?.instantiateViewController(identifier: "BookmarksVC") as? BookmarksVC else { preconditionFailure("Failed to preview reusableVC")}
//		if bookmarksData[indexPath.row].isFolder {
//			print("is Folder")
//			reusableVC.navigationController?.title = bookmarksData[indexPath.row].titleString
//			reusableVC.title = bookmarksData[indexPath.row].titleString
//			reusableVC.bookmarksData = bookmarksData[indexPath.row].child
//			reusableVC.isDepthViewController = true
//			return reusableVC
//		}
//		else {
//			print("isn't Folder")
//			let alert = UIAlertController.init(title: "is folder empty~", message: "", preferredStyle: .alert)
//			let action = UIAlertAction.init(title: "done", style: .destructive, handler: nil)
//			alert.addAction(action)
//			self.present(alert, animated: true, completion: nil)
//		}
//
//		return reusableVC
//	}
//
//	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
//		navigationController?.pushViewController(viewControllerToCommit, animated: true)
//	}
//
//
//}

//MARK: - UI ContextMenuInteractionDelegate
extension BookmarksVC: UIContextMenuInteractionDelegate {
	func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
		guard let indexPath = tableView.indexPathForRow(at: location), let cell = tableView.cellForRow(at: indexPath) else { return nil }
//		//		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//		guard let bookmarksVC = storyboard?.instantiateViewController(identifier: "BookmarksVC") as? BookmarksVC else { preconditionFailure("Failed to preview bookmarksVC")}
//		if bookmarksData[indexPath.row].isFolder {
//			print("is Folder")
//			bookmarksVC.navigationController?.title = bookmarksData[indexPath.row].titleString
//			bookmarksVC.title = bookmarksData[indexPath.row].titleString
//			bookmarksVC.bookmarksData = bookmarksData[indexPath.row].child
//			bookmarksVC.isDepthViewController = true
//		}
//		else {
//			print("isn't Folder")
//			//TODO: - folder 가 아니라 bookmark 이기 때문에 preview 로 해당 url 이 보여야 한다 ??
//
//		}
//
//		return UIContextMenuConfiguration(identifier: nil, previewProvider: {return bookmarksVC}) { (element) -> UIMenu? in
//			return self.makeContextMenu()
//		}
		
		guard let bookmarksVC = storyboard?.instantiateViewController(identifier: "BookmarksVC") as? BookmarksVC else { preconditionFailure("Failed to preview bookmarksVC")}
		///폴더 일때
		if bookmarksData[indexPath.row].isFolder {
			//ContextMenu * Copy Contents, * Open in new tabs, * Edit, * Delete
			print("is Folder")
			bookmarksVC.navigationController?.title = bookmarksData[indexPath.row].titleString
			bookmarksVC.title = bookmarksData[indexPath.row].titleString
			bookmarksVC.bookmarksData = bookmarksData[indexPath.row].child
			bookmarksVC.isDepthViewController = true
			/// leaf node 일때 (= 마지막 끝 노드일때)
			if bookmarksData[indexPath.row].child.isEmpty {
				print("leaf node!!")
				return UIContextMenuConfiguration(identifier: nil, previewProvider: {return bookmarksVC}) { (actions) -> UIMenu? in
					return AlertsAndMenus.shared.makeEmptyFolderContextMenu()
				}
				
			}
		}
		else { // Bookmark 일때 Context Menu * preview, * copy, * open in new tab, * Edit, * Delete
			print("is Bookmark")
			//TODO: - show a preview of the link (webview).
			return UIContextMenuConfiguration(identifier: nil, previewProvider: {return bookmarksVC}) { (actions) -> UIMenu? in
				return AlertsAndMenus.shared.makeBookmarkContextMenu()
			}
		}
		return UIContextMenuConfiguration(identifier: nil, previewProvider: {return bookmarksVC}) { (actions) -> UIMenu? in
			return AlertsAndMenus.shared.makeFolderContextMenu()
		}
		
		
		
	}
	
	func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
		animator.addCompletion {
			if let vc = animator.previewViewController {
				self.show(vc, sender: self)
			}
		}
	}
	
	
}
