//
//  EditBookmarkVC.swift
//  SafariSample
//
//  Created by Nomad on 2019/11/29.
//  Copyright © 2019 Nomad. All rights reserved.
//

import UIKit
import CITreeView
import FavIcon

class EditBookmarkVC: UIViewController {
	
	//MARK: - Properties
	var bookmarkTitle: String?
	var address: String?
	
	//MARK: - Outlets
	@IBOutlet weak var treeView: CITreeView!
	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var titleInput: UITextField!
	@IBOutlet weak var addressInput: UITextField!
	
	
	
	
//	var data: [TreeData] = []
	var data: [BookmarksData] = []
	var selectedFolderTitle: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		titleInput.textColor = .gray
		addressInput.textColor = .gray
		
		titleInput.text = bookmarkTitle
		addressInput.text = address
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAddBookmark))

//		data = TreeData.getDefaultData() //get the default data
//		BookmarksDataModel.createSampleData()
//		data = BookmarksDataModel.bookMarkDatas
		
		if address != nil {
			do {
				try FavIcon.downloadPreferred(address!, completion: { (result) in
					if case let .success(image) = result {
						self.iconImageView.image = image
					}
					else if case let .failure(error) = result {
						print("failed to download preferred favicon for \(String(describing: self.address)): \(error)")
					}
				})
			}
			catch let error {
				print("failed to download preferred favicon for \(String(describing: self.address)): \(error)")
			}
		}
		
		data = UserDefaultsManager.shared.loadUserBookMarkListData()
		
		treeView.treeViewDelegate = self
		treeView.treeViewDataSource = self
		
		treeView.collapseNoneSelectedRows = false
		treeView.register(UINib(nibName: "FolderCell", bundle: nil), forCellReuseIdentifier: "folderCell")
//		treeView.expandAllRows()
	}
	
	@objc func saveAddBookmark() {
		print("Save Clicked!!")
		//TODO: - put the following code into EditBookmarkVC

//		let saveData = BookmarksData.init(urlString: urlString, titleString: title, iconUrlString: "", indexPath: [0])
//		var array = UserDefaultsManager.shared.loadUserBookMarkListData()
//		array.append(saveData)
//
//		UserDefaultsManager.shared.saveBookMarkListData(bookmarkD: array)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
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
//MARK: - CITreeView Delegate
extension EditBookmarkVC: CITreeViewDelegate {
	func willExpandTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath) {
		//
	}
	
	func didExpandTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath) {
		if atIndexPath.row == 0 {
			treeView.expandAllRows()
		}
	}
	
	func willCollapseTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath) {
		//
	}
	
	func didCollapseTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath) {
		if atIndexPath.row == 0 {
			treeView.collapseAllRows()
		}
	}
	
	func treeView(_ treeView: CITreeView, heightForRowAt indexPath: IndexPath, withTreeViewNode treeViewNode: CITreeViewNode) -> CGFloat {
		return 40
	}
	
	func treeView(_ treeView: CITreeView, didSelectRowAt treeViewNode: CITreeViewNode, atIndexPath indexPath: IndexPath) {
//		print("didSelectRowAt", treeViewNode)
//		if let parentNode = treeViewNode.parentNode {
//			print("parentNode.item", parentNode.item)
//		}
//		print("TreeViewNode: ", treeViewNode, "indexPath:", indexPath.section, indexPath.row)

//		if let selectedNodeAtIndexPath = treeViewNode.self.item as? TreeData {
//
//			let selectedNodeItemTitle = selectedNodeAtIndexPath.title
//			selectedFolderTitle = selectedNodeItemTitle
//		}
		
		if let selectedNodeAtIndexPath = treeViewNode.self.item as? BookmarksData {
			let selectedNodeItemTitle = selectedNodeAtIndexPath.titleString
			selectedFolderTitle = selectedNodeItemTitle
		}
		
	}
	

	
	func treeView(_ treeView: CITreeView, didDeselectRowAt treeViewNode: CITreeViewNode, atIndexPath indexPath: IndexPath) {
//		if let parentNode = treeViewNode.parentNode{
//			print(parentNode.item)
//		}
		
//		if let selectedNodeAtIndexPath = treeViewNode.self.item as? TreeData {
//			let string = selectedNodeAtIndexPath.title
//			print(string)
//		}
		if let selectedNodeAtIndexPath = treeViewNode.self.item as? BookmarksData {
			let string = selectedNodeAtIndexPath.titleString
			print(string as Any)
		}
		
		
	}
	
	
}
//MARK: - CITreeViewDataSource
extension EditBookmarkVC: CITreeViewDataSource {
	func treeViewSelectedNodeChildren(for treeViewNodeItem: AnyObject) -> [AnyObject] {
//		if let dataObj = treeViewNodeItem as? TreeData {
//
////			print(dataObj.title)
//
//
//			return dataObj.children
//		}
		if let dataObj = treeViewNodeItem as? BookmarksData {
			return dataObj.child as [AnyObject]
		}
		
		return []
	}
	
	func treeViewDataArray() -> [AnyObject] {
		return data as [AnyObject]
	}
	
	func treeView(_ treeView: CITreeView, atIndexPath indexPath: IndexPath, withTreeViewNode treeViewNode: CITreeViewNode) -> UITableViewCell {
		let cell = treeView.dequeueReusableCell(withIdentifier: "folderCell") as! FolderCell
//		let cell = treeView.dequeueReusableCell(withIdentifier: "exampleCell", for: indexPath)
		
//		let dataObj = treeViewNode.item as! TreeData
		let dataObj = treeViewNode.item as! BookmarksData
//		cell.folderName.text = dataObj.title
//		cell.setupCell(level: treeViewNode.level)
		cell.folderName.text = dataObj.titleString
		cell.setupCell(level: treeViewNode.level)
		
//		if indexPath.row == 0 && selectedFolderTitle != nil {
//			cell.folderName.text = selectedFolderTitle
//
//		}
		
		return cell
	}
	
	
}
