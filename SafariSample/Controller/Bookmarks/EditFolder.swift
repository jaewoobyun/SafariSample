//
//  EditFolder.swift
//  SafariSample
//
//  Created by Nomad on 2019/12/09.
//  Copyright © 2019 Nomad. All rights reserved.
//

import Foundation
import UIKit
import CITreeView

class EditFolder: UIViewController {
	
	var folderTitle: String?
	
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var treeView: CITreeView!
	
	var bookmarksData: [BookmarksData] = []
	var selectedFolderTitle: String?
	var selectedNode: CITreeViewNode? //
	var selectedIndexPath: IndexPath? //
	
	//MARK: - Life Cycle
	override func viewDidLoad() {
		self.title = "Edit Folder"
		super.viewDidLoad()

		titleTextField.text = folderTitle
		
		titleTextField.delegate = self
		
		treeView.allowsMultipleSelection = false
		treeView.treeViewDelegate = self
		treeView.treeViewDataSource = self
		
		treeView.collapseNoneSelectedRows = false //
		treeView.register(UINib(nibName: "FolderCell", bundle: nil), forCellReuseIdentifier: "folderCell")
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveFolder))
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
//		BookmarksDataModel.createSampleData()
//		bookmarksData = BookmarksDataModel.bookMarkDatas
		
//		let favChildFolder = BookmarksData(titleString: "FavChild", child: [], indexPath: [])
//		let favFolder = BookmarksData(titleString: "Favorites", child: [favChildFolder], indexPath: [])
//
//		self.bookmarksData = [favFolder]
		
		self.bookmarksData = UserDefaultsManager.shared.loadUserBookMarkListData()
		
		if let selectedIndexpath = self.treeView.indexPathForSelectedRow {
			treeView.deselectRow(at: selectedIndexpath, animated: animated)
		}
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	@objc func saveFolder() {
		
	}
	
	func insertFolderAtSelectedLocation(indexPath: IndexPath, selectedNode: CITreeViewNode, title: String) {
		let newFolder = BookmarksData.init(titleString: title, child: [], indexPath: [])

		var array = UserDefaultsManager.shared.loadUserBookMarkListData()

		if let selectedNodeItem = selectedNode.item as? BookmarksData {
			print(selectedNodeItem.dataIndexPath)
			array[indexPath.row].addChild(newFolder)
		}

//		array.append(newFolder)

		let isSaveSuccess = UserDefaultsManager.shared.saveBookMarkListData(bookmarkD: array)

		print(isSaveSuccess)
		
		
	}
	

	
}
//MARK: - TextField Delegate
extension EditFolder: UITextFieldDelegate {
	func textFieldDidEndEditing(_ textField: UITextField) {
		print("textfieldDidEndEditing!!")
		
		
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		print("textFieldShouldReturn")
//		guard let selectedIndexPath = self.selectedIndexPath else { return ((treeView?.indexPathForSelectedRow) != nil)}
//		guard let selectedNode = self.selectedNode else {
//			return false
//		}
//		guard let selectedTitle = self.titleTextField.text else { return false}
//
//		if titleTextField.text?.isEmpty == false {
//			treeView.beginUpdates()
//			insertFolderAtSelectedLocation(indexPath: selectedIndexPath, selectedNode: selectedNode, title: selectedTitle)
//			treeView.endUpdates()
//			treeView.reloadData()
//		}
		
		self.selectedFolderTitle = self.titleTextField.text
		
		textField.resignFirstResponder()
		return true
	}
	
	
}

//MARK: - CITreeView Delegate
extension EditFolder: CITreeViewDelegate {
	func willExpandTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath) {
		print("willExpand")
		//
	}
	
	func didExpandTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath) {
		print("didExpand")
		if atIndexPath.row == 0 {
			treeView.expandAllRows()
		}
		
	}
	
	func willCollapseTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath) {
		print("willCollapse")
	}
	
	func didCollapseTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath) {
		print("didCollapse")
		if atIndexPath.row == 0 {
			treeView.collapseAllRows()
		}
	}
	
	
	func treeView(_ treeView: CITreeView, heightForRowAt indexPath: IndexPath, withTreeViewNode treeViewNode: CITreeViewNode) -> CGFloat {
		return 40
	}
	
	func treeView(_ treeView: CITreeView, didSelectRowAt treeViewNode: CITreeViewNode, atIndexPath indexPath: IndexPath) {
		
		if let selectedNode = treeViewNode.self.item as? BookmarksData {
			self.selectedNode = treeViewNode
			self.selectedIndexPath = indexPath
//			if let selectedCell = treeView.cellForRow(at: indexPath) {
//				if selectedNode.isFolder {
//					selectedCell.accessoryType = .checkmark
//				}
//			}
			
			let cell = treeView.cellForRow(at: indexPath)
			if let val = selectedIndexPath {
				if indexPath == val{
					cell?.accessoryType = .checkmark
				}
				else {
					cell?.accessoryType = .none
				}
			}
			
			
			
//			let alertController = UIAlertController(title: selectedFolderTitle, message: "indexPath:" + String(describing: indexPath) + "\n" + "dataIndexPath:" + String(describing: selectedNode.dataIndexPath) + "\n"
//				, preferredStyle: UIAlertController.Style.alert)
//			let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
//			alertController.addAction(cancelAction)
//			self.present(alertController, animated: true, completion: nil)
			
			if selectedNode.isFolder{
//				insertFolderAtSelectedLocation(indexPath: indexPath, selectedNode: treeViewNode, title: selectedFolderTitle!)
			}
			
						
			
		}
		
		
	}
	
	func treeView(_ treeView: CITreeView, didDeselectRowAt treeViewNode: CITreeViewNode, atIndexPath indexPath: IndexPath) {
		if let selectedNode = treeViewNode.self.item as? BookmarksData {
			let cell = treeView.cellForRow(at: indexPath)
			cell?.accessoryType = .none
			
		}
		
		
	}
	
	
}

//MARK: - CITreeView DataSource
extension EditFolder: CITreeViewDataSource {
	func treeViewSelectedNodeChildren(for treeViewNodeItem: AnyObject) -> [AnyObject] {
		if let dataObj = treeViewNodeItem as? BookmarksData {
			return dataObj.child as [AnyObject]
		}
		return []
	}
	
	func treeViewDataArray() -> [AnyObject] {
//		data.filter { (bookmarkdata) -> Bool in
//			bookmarkdata.isFolder
//		}
//		let filteredData = data.filter { $0.isFolder }
		
//		let filteredData = bookmarksData.filter { (item) -> Bool in
//			let temp = item.isFolder
//			if !temp {
//				print("isn't folder")
//			}
//			return temp
//		}
//
//		return filteredData as [AnyObject]
		return bookmarksData as [AnyObject]
	}
	
	func treeView(_ treeView: CITreeView, atIndexPath indexPath: IndexPath, withTreeViewNode treeViewNode: CITreeViewNode) -> UITableViewCell {
		treeView.allowsSelection = true
		
		let cell = treeView.dequeueReusableCell(withIdentifier: "folderCell") as! FolderCell
		
		let dataObj = treeViewNode.item as! BookmarksData
		
		//FIXME: - 안됨 ㅠㅠ
//		if dataObj.isFolder && dataObj.titleString == "Favorites" || indexPath.row == 0 {
//			cell.icon.image = UIImage(systemName: "star")
//			cell.textLabel?.text = selectedFolderTitle
//		}
		
		//------------------
		
		if dataObj.isFolder {
			cell.icon.image = UIImage(systemName: "folder")
		}
		if !dataObj.isFolder {
			cell.icon.image = UIImage(systemName: "book")
		}
		
		cell.icon.tintColor = UIColor.gray
		cell.folderName.text = dataObj.titleString
		cell.setupCell(level: treeViewNode.level)
		
		if selectedNode != nil, selectedFolderTitle != nil {
			print("selectedNode: \(selectedNode), selectedFolderTitle: \(selectedFolderTitle)")
		}
		
		
		
		return cell
	}
	
	
}


//TODO: - ?? what does it mean to use a extension here?
//extension EditFolder: UITableViewDelegate {
//	tableviewcellf
//}

//
//extension EditFolder: CITreeViewControllerDelegate {
//	func getChildren(forTreeViewNodeItem item: AnyObject, with indexPath: IndexPath) -> [AnyObject] {
//		<#code#>
//	}
//
//
//}
