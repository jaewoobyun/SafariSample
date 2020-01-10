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
	
	enum CaseType {
		case AddNewBookmark
		case EditBookmark
		
		func getTitle() -> String {
			switch self {
			case .AddNewBookmark: return "Add Bookmark"
			case .EditBookmark: return "Edit Bookmark"
			}
		}
		
		func getButtonTitle() -> UIBarButtonItem.SystemItem {
			switch self {
			case .AddNewBookmark: return .add
			case .EditBookmark: return .save
			}
		}
	}

//	var data: [BookmarksData] = [] //
	var caseType: CaseType = .EditBookmark
	var bookmarksData: NSMutableArray = []
//	var selectedFolderTitle: String?
	var editedBookmarkTitle: String?
	
	var selectedNode: CITreeViewNode? //?
	var selectedIndexPath: IndexPath? //?
	///선택된 노드의(select) 부모를 조회하여, 선택 줄이 몇 레벨에 있는지 화인한다.
	/// [0,0,1] -> let now = bookmarksData[0].child[0].child[0],  === > now.child.append(folder)
	var selectedNodeIndexs: [Int] = []
	var editTargetData: BookmarksData? = nil
	
	
	//MARK: - LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = caseType.getTitle()
		titleInput.textColor = .gray
		addressInput.textColor = .gray
		
		titleInput.text = bookmarkTitle
		addressInput.text = address
		
		/// 주소의 favIcon 이미지
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
		
//		data = UserDefaultsManager.shared.loadUserBookMarkListData()
		self.bookmarksData.addObjects(from: UserDefaultsManager.shared.loadUserBookMarkListData())
		
		titleInput.delegate = self
		addressInput.delegate = self
		treeView.treeViewDelegate = self
		treeView.treeViewDataSource = self
		
		treeView.collapseNoneSelectedRows = false
		treeView.register(UINib(nibName: "FolderCell", bundle: nil), forCellReuseIdentifier: "folderCell")
		treeView.reloadData()
		treeView.expandAllRows()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: caseType.getButtonTitle(), target: self, action: #selector(saveAddBookmark))
		
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.title = super.title
		
		if caseType == .EditBookmark {
			guard let bookmarkTitle = self.bookmarkTitle else { return }
			let editTargetData = locateSelectedBookmark(targetArray: (self.bookmarksData as! [BookmarksData]), searchKeyword: bookmarkTitle)
			self.editTargetData = editTargetData
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	func locateSelectedBookmark(targetArray: [BookmarksData], searchKeyword: String) -> BookmarksData? {
		for data in targetArray {
			let child = data.child
			if child.count != 0 {
				if let searchData = locateSelectedBookmark(targetArray: child, searchKeyword: searchKeyword) {
					return searchData
				}
			}
			
			print("data.titleString : \(data.titleString ?? "??")")
			if data.titleString == searchKeyword {
				print("These are the droids you are looking for \(data)")
				return data
			}
		}
		print("These are NOT the droids you are looking for: \(searchKeyword)")
		return nil
		
	}
	
	func insertBookmarkAtSelectedLocation(bookMarkTitle: String, urlAddress: String, selectNodeIndexs:[Int]) {
		
		let newBookmarkItem = BookmarksData.init(urlString: urlAddress, titleString: bookMarkTitle, indexPath: selectNodeIndexs)
		
		if selectNodeIndexs.count == 0 {
			self.bookmarksData.add(newBookmarkItem)
		}
		else {
			var data: BookmarksData?
			for index in selectNodeIndexs {
				if data == nil {
					data = self.bookmarksData.object(at: index) as! BookmarksData
				} else {
					data = data?.child[index]
				}
			}
			data?.child.append(newBookmarkItem)
		}
		
		UserDefaultsManager.shared.saveBookMarkListData(bookmarkD: bookmarksData as! [BookmarksData])
		
		treeView.reloadData()
		treeView.expandAllRows()
		
	}
	
		@objc func saveAddBookmark() {
			print("Save Clicked!!")
	//		let saveData = BookmarksData.init(urlString: urlString, titleString: title, iconUrlString: "", indexPath: [0])
	//		var array = UserDefaultsManager.shared.loadUserBookMarkListData()
	//		array.append(saveData)
	//
	//		UserDefaultsManager.shared.saveBookMarkListData(bookmarkD: array)
			
			guard let bookmarkTitle = self.titleInput.text else {
				return
			}
			
			guard let address = self.addressInput.text else {
				return
			}
			
			if caseType == .AddNewBookmark {
				insertBookmarkAtSelectedLocation(bookMarkTitle: bookmarkTitle, urlAddress: address, selectNodeIndexs: selectedNodeIndexs)
			}
			
			if caseType == .EditBookmark {
				guard let edittedBookmarkTitle = self.editedBookmarkTitle else { return }
				editBookmarkNameAtSelectedLocation(edittedBookmarkTitle: edittedBookmarkTitle)
			}
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
				self.dismiss(animated: true, completion: nil)
			}
		}
	
	func editBookmarkNameAtSelectedLocation(edittedBookmarkTitle: String) { //, edittedBookmarkAddress: String
		if let passedBookmarkTitle = bookmarkTitle {
			let editTargetBookmarkData = locateSelectedBookmark(targetArray: (self.bookmarksData as! [BookmarksData]), searchKeyword: passedBookmarkTitle)
			editTargetBookmarkData?.titleString = edittedBookmarkTitle
			self.editTargetData = editTargetBookmarkData
		}
		let isSaveSuccess = UserDefaultsManager.shared.saveBookMarkListData(bookmarkD: bookmarksData as! [BookmarksData])
		print("Editing Bookmark Name at Selected Location success: ", isSaveSuccess)
		treeView.reloadData()
		treeView.expandAllRows()
	}
	
}
//MARK: - UITextField Delegate
extension EditBookmarkVC: UITextFieldDelegate {
	func textFieldDidEndEditing(_ textField: UITextField) {
		
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.editedBookmarkTitle = self.titleInput.text
		textField.resignFirstResponder()
		return true
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)

		if !text.isEmpty {
			self.navigationItem.rightBarButtonItem?.isEnabled = true
		}
		else {
			self.navigationItem.rightBarButtonItem?.isEnabled = false
		}
		return true
	}
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
		
		if let selectedNode = treeViewNode.self.item as? BookmarksData {
			self.selectedNode = treeViewNode
			self.selectedIndexPath = indexPath
			
			var selectNodeTitle: String = selectedNode.titleString ?? ""
			
			selectedNodeIndexs.removeAll()
			var parentNode: CITreeViewNode? = treeViewNode
			
			repeat {
				if let currentNode = parentNode {
					parentNode = currentNode.parentNode
					
					if let parentBookMark = parentNode?.item as? BookmarksData {
						
						for index in 0..<parentBookMark.child.count {
							let item = parentBookMark.child[index]
							if item.titleString == selectNodeTitle {
								//찾음
								selectedNodeIndexs.insert(index, at: 0)
								selectNodeTitle = parentBookMark.titleString ?? ""
								break
							}
						}
					}
				}
				else {
					parentNode = nil
				}
			} while parentNode != nil
			
			//root
			for index in 0..<self.bookmarksData.count {
				let rootItem = self.bookmarksData[index] as! BookmarksData
				if rootItem.titleString == selectNodeTitle {
					selectedNodeIndexs.insert(index, at: 0)
					break
				}
			}
			
			
		}
		
	}
	

	
	func treeView(_ treeView: CITreeView, didDeselectRowAt treeViewNode: CITreeViewNode, atIndexPath indexPath: IndexPath) {

		if let selectedNode = treeViewNode.self.item as? BookmarksData {
			let string = selectedNode.titleString
			print(string as Any)
		}
		
		
	}
	
	
}
//MARK: - CITreeViewDataSource
extension EditBookmarkVC: CITreeViewDataSource {
	func treeViewSelectedNodeChildren(for treeViewNodeItem: AnyObject) -> [AnyObject] {
		if let dataObj = treeViewNodeItem as? BookmarksData {
			return dataObj.child as [AnyObject]
		}
		
		return []
	}
	
	func treeViewDataArray() -> [AnyObject] {
		return bookmarksData as [AnyObject]
	}
	
	func treeView(_ treeView: CITreeView, atIndexPath indexPath: IndexPath, withTreeViewNode treeViewNode: CITreeViewNode) -> UITableViewCell {
		let cell = treeView.dequeueReusableCell(withIdentifier: "folderCell") as! FolderCell
		let dataObj = treeViewNode.item as! BookmarksData
		cell.folderName.text = dataObj.titleString
		cell.setupCell(level: treeViewNode.level)
		cell.setupIconFolderOrBook(dataObj)
		
		if !dataObj.isFolder {
			cell.isUserInteractionEnabled = false
		}
		
		if caseType == .EditBookmark {
			cell.isUserInteractionEnabled = false
			if let target = treeViewNode.item as? BookmarksData {
				if let editTarget = self.editTargetData {
					if target.titleString == editTarget.titleString {
						self.treeView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
					}
				}
			}
		}
		
		
		return cell
	}
	
	
}
