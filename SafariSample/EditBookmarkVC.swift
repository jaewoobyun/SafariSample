//
//  EditBookmarkVC.swift
//  SafariSample
//
//  Created by Nomad on 2019/11/29.
//  Copyright © 2019 Nomad. All rights reserved.
//

import UIKit
import CITreeView

class EditBookmarkVC: UIViewController {
	//MARK: - Outlets
	@IBOutlet weak var treeView: CITreeView!
	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var titleInput: UITextField!
	@IBOutlet weak var addressInput: UITextField!
	
	
	var data: [TreeData] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		data = TreeData.getDefaultData() //get the default data
		
		treeView.treeViewDelegate = self
		treeView.treeViewDataSource = self
		
		treeView.collapseNoneSelectedRows = false
		treeView.register(UINib(nibName: "FolderCell", bundle: nil), forCellReuseIdentifier: "folderCell")
		treeView.expandAllRows()
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
		//
	}
	
	func willCollapseTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath) {
		//
	}
	
	func didCollapseTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath) {
		//
	}
	
	func treeView(_ treeView: CITreeView, heightForRowAt indexPath: IndexPath, withTreeViewNode treeViewNode: CITreeViewNode) -> CGFloat {
		return 40
	}
	
	func treeView(_ treeView: CITreeView, didSelectRowAt treeViewNode: CITreeViewNode, atIndexPath indexPath: IndexPath) {
		print("didSelectRowAt", treeViewNode)
	}
	
	func treeView(_ treeView: CITreeView, didDeselectRowAt treeViewNode: CITreeViewNode, atIndexPath indexPath: IndexPath) {
		if let parentNode = treeViewNode.parentNode{
			print(parentNode.item)
		}
	}
	
	
}
//MARK: - CITreeViewDataSource
extension EditBookmarkVC: CITreeViewDataSource {
	func treeViewSelectedNodeChildren(for treeViewNodeItem: AnyObject) -> [AnyObject] {
		if let dataObj = treeViewNodeItem as? TreeData {
			return dataObj.children
		}
		return []
	}
	
	func treeViewDataArray() -> [AnyObject] {
		return data
	}
	
	func treeView(_ treeView: CITreeView, atIndexPath indexPath: IndexPath, withTreeViewNode treeViewNode: CITreeViewNode) -> UITableViewCell {
		let cell = treeView.dequeueReusableCell(withIdentifier: "folderCell") as! FolderCell
		
//		let cell = treeView.dequeueReusableCell(withIdentifier: "exampleCell", for: indexPath)
		let dataObj = treeViewNode.item as! TreeData
		cell.folderName.text = dataObj.title
		cell.setupCell(level: treeViewNode.level)
		
//		cell.textLabel?.text = dataObj.title
		
		return cell
	}
	
	
}
