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
	
	var bookmarksData: NSMutableArray = []
	var folderTitleInputText: String?
	var selectedNode: CITreeViewNode? //
	var selectedIndexPath: IndexPath? //
	
	///선택된 노드의(select) 부모를 조회하여, 선택 줄이 몇 레벨에 있는지 화인한다.
	/// [0,0,1] -> let now = bookmarksData[0].child[0].child[0],  === > now.child.append(folder)
	var selectNodeIndexs:[Int] = []
	
	//MARK: - Life Cycle
	override func viewDidLoad() {
		self.title = "Edit Folder"
		super.viewDidLoad()
		self.bookmarksData.addObjects(from: UserDefaultsManager.shared.loadUserBookMarkListData())
		
		//self.bookmarksData = UserDefaultsManager.shared.loadUserBookMarkListData()
		
		titleTextField.text = folderTitle
		
		titleTextField.delegate = self
		
		treeView.allowsMultipleSelection = false
		treeView.treeViewDelegate = self
		treeView.treeViewDataSource = self
		
		treeView.collapseNoneSelectedRows = false //
		treeView.register(UINib(nibName: "FolderCell", bundle: nil), forCellReuseIdentifier: "folderCell")
		treeView.reloadData()
		treeView.expandAllRows()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveFolder))
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	@objc func saveFolder() {
		//guard let selectedIndexPath = self.selectedIndexPath else {return}
		//guard let selectedNode = self.selectedNode else { return}
		
		guard let title = self.titleTextField.text else { return}
		
		//insertFolderAtSelectedLocation(indexPath: selectedIndexPath, selectedNode: selectedNode, title: title)
		insertFolderAtSelectedLocation(folderTitle: title, selectNodeIndexs: selectNodeIndexs)
	}
	
	
	func insertFolderAtSelectedLocation(indexPath: IndexPath, selectedNode: CITreeViewNode, title: String) {
		let newFolder = BookmarksData.init(titleString: title, child: [], indexPath: [])

		var array = UserDefaultsManager.shared.loadUserBookMarkListData()

		if let selectedNodeItem = selectedNode.item as? BookmarksData {
			print(selectedNodeItem.dataIndexPath)
			array[indexPath.row].child.append(newFolder)
		}

//		array.append(newFolder)

		let isSaveSuccess = UserDefaultsManager.shared.saveBookMarkListData(bookmarkD: array)

		print(isSaveSuccess)
		
	}
	
	func insertFolderAtSelectedLocation(folderTitle:String, selectNodeIndexs:[Int]) {
		
		let appendFolder = BookmarksData.init(titleString: folderTitle, child: [], indexPath: selectNodeIndexs)
		
		if selectNodeIndexs.count == 0 {
			//self.bookmarksData.append(appendFolder)
			self.bookmarksData.add(appendFolder)
		} else {
			
			var data:BookmarksData?
			for index in selectNodeIndexs {
				if data == nil {
					//data = self.bookmarksData[index]
					data = self.bookmarksData.object(at: index) as! BookmarksData
				} else {
					data = data?.child[index]
				}
			}
			
			data?.child.append(appendFolder)
		}
		
		UserDefaultsManager.shared.saveBookMarkListData(bookmarkD: bookmarksData as! [BookmarksData])
		
		treeView.reloadData()
		treeView.expandAllRows()
	}
	

	
}
//MARK: - TextField Delegate
extension EditFolder: UITextFieldDelegate {
	func textFieldDidEndEditing(_ textField: UITextField) {
		print("textfieldDidEndEditing!!")
		
		
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		print("textFieldShouldReturn")		
		self.folderTitleInputText = self.titleTextField.text
		
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
			
			var selectNodeTitle:String = selectedNode.titleString ?? ""
			
			selectNodeIndexs.removeAll()
			var parentNode:CITreeViewNode? = treeViewNode
			
			repeat {
				if let nowNode = parentNode {
					parentNode = nowNode.parentNode
					
					if let parentBookMark = parentNode?.item as? BookmarksData {
						
						for index in 0..<parentBookMark.child.count {
							let item = parentBookMark.child[index]
							if item.titleString == selectNodeTitle {
								///찾았다?
								selectNodeIndexs.insert(index, at: 0)
								selectNodeTitle = parentBookMark.titleString ?? ""
								break
							}
						}
					}
					
				} else {
					parentNode = nil
				}
			} while parentNode != nil
			
			//root
			for index in 0..<self.bookmarksData.count {
				let rootItem = self.bookmarksData[index] as! BookmarksData
				if rootItem.titleString == selectNodeTitle {
					selectNodeIndexs.insert(index, at: 0)
					break
				}
			}
			
			print("selectNodeIndexs \(selectNodeIndexs)")
			
//			if let selectedCell = treeView.cellForRow(at: indexPath) {
//				if selectedNode.isFolder {
//					selectedCell.accessoryType = .checkmark
//				}
//			}
			
//			let cell = treeView.cellForRow(at: indexPath)
//			if let val = selectedIndexPath {
//				if indexPath == val{
//					cell?.accessoryType = .checkmark
//				}
//				else {
//					cell?.accessoryType = .none
//				}
//			}
			
			if let cell = treeView.cellForRow(at: indexPath) {
				cell.accessoryType = .checkmark
			}
			
			
			
//			let alertController = UIAlertController(title: folderTitleInputText, message: "indexPath:" + String(describing: indexPath) + "\n" + "dataIndexPath:" + String(describing: selectedNode.dataIndexPath) + "\n"
//				, preferredStyle: UIAlertController.Style.alert)
//			let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
//			alertController.addAction(cancelAction)
//			self.present(alertController, animated: true, completion: nil)
			
			/// 선택한 노드가 폴더일때만 새로 만든 폴더가 그 안에 있어야 한다. indexpath 로 위치를 잡을 것이 아니라 자식 안에도 만들 수 있어야 한다. 그렇다면 폴더를 닫으면 index가 바뀌기 때문에 절대 경로(데이터)를 기준으로 생성해야 한다.?
			if selectedNode.isFolder{
//				insertFolderAtSelectedLocation(indexPath: indexPath, selectedNode: treeViewNode, title: folderTitleInputText!)
			}
			
						
			
		}
		
		
	}
	
	func treeView(_ treeView: CITreeView, didDeselectRowAt treeViewNode: CITreeViewNode, atIndexPath indexPath: IndexPath) {
		if let selectedNode = treeViewNode.self.item as? BookmarksData {
			if let cell = treeView.cellForRow(at: indexPath) {
				cell.accessoryType = .none
			}
			
			
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
//			cell.textLabel?.text = folderTitleInputText
//		}
		
		//------------------
		
		if dataObj.isFolder {
			cell.icon.image = UIImage(systemName: "folder")
		}
		if !dataObj.isFolder {
			cell.icon.image = UIImage(systemName: "book")
		}
		
		cell.folderName.text = dataObj.titleString
		cell.setupCell(level: treeViewNode.level)
		
		if selectedNode != nil, folderTitleInputText != nil {
			print("selectedNode: \(selectedNode), folderTitleInputText: \(folderTitleInputText)")
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
