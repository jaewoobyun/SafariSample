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
	
	var data: [BookmarksData] = []
	var selectedFolderTitle: String?
	
	
	override func viewDidLoad() {
		self.title = "Edit Folder"
		super.viewDidLoad()
//		BookmarksDataModel.createSampleData()
//		data = BookmarksDataModel.bookMarkDatas
		data = UserDefaultsManager.shared.loadUserBookMarkListData()
		
		titleTextField.text = folderTitle
		
		titleTextField.delegate = self
		
		treeView.allowsMultipleSelection = false
		treeView.treeViewDelegate = self
		treeView.treeViewDataSource = self
		
		treeView.collapseNoneSelectedRows = false //
		treeView.register(UINib(nibName: "FolderCell", bundle: nil), forCellReuseIdentifier: "folderCell")
		
	}
	
}
//MARK: - TextField Delegate
extension EditFolder: UITextFieldDelegate {
	func textFieldDidEndEditing(_ textField: UITextField) {
		print("textfieldDidEndEditing!!")
		guard let titleString = self.titleTextField.text else { return }
		let newFolder = BookmarksData.init(titleString: titleString, child: [], indexPath: [0])
		
		data.append(newFolder)
		UserDefaultsManager.shared.saveBookMarkListData(bookmarkD: data)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//		self.view.endEditing(true) //
		
//		return false
		
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
			let selectedNodeItemTitle = selectedNode.titleString
			selectedFolderTitle = selectedNodeItemTitle
//			if let selectedCell = treeView.cellForRow(at: indexPath) {
//				if selectedNode.isFolder {
//					selectedCell.accessoryType = .checkmark
//				}
//			}
			
		}
		
		
	}
	
	func treeView(_ treeView: CITreeView, didDeselectRowAt treeViewNode: CITreeViewNode, atIndexPath indexPath: IndexPath) {
		if let selectedNode = treeViewNode.self.item as? BookmarksData {
			let selectedNodeItemTitle = selectedNode.titleString
			selectedFolderTitle = selectedNodeItemTitle
//			if let selectedCell = treeView.cellForRow(at: indexPath) {
//				if selectedNode.isFolder {
//					selectedCell.accessoryType = .none
//				}
//			}
			
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
		
		let filteredData = data.filter { (item) -> Bool in
			let temp = item.isFolder
			if !temp {
				print("asdsadas")
			}
			return temp
		}
		
//		let filteredData = data.filter { (item) -> Bool in
//			let temp = item.isFolder
//			if !temp {
//				print("asdsadas")
//			}
//			return temp
//		}

		return filteredData as [AnyObject]
//		return data as [AnyObject]
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
		
		
		return cell
	}
	
	
}


//TODO: - ?? what does it mean to use a extension here?
//extension EditFolder: UITableViewDelegate {
//
//}
