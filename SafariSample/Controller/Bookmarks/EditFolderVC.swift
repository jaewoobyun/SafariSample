//
//  EditFolderVC.swift
//  SafariSample
//
//  Created by Nomad on 2019/11/28.
//  Copyright © 2019 Nomad. All rights reserved.
//

import UIKit

class EditFolderVC: UIViewController {
	
	
	@IBOutlet weak var tfTitle: UITextField!
	@IBOutlet weak var tableView: UITableView!
	
//	var folderData = [FolderData]()
//	var sampleData = [SampleData]()
//	var initialFolderTitles = ["Bookmarks", "Favorites", "ReadingList"]
	
	var data: [BookmarksData] = []
	
	var selectedIndex: IndexPath?
	
	var cellisExpanded: Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Edit FolderVC"
		
//		folderData = [
//			FolderData(sectionTitle: "Bookmarks", isExpanded: false, containsUserSelectedValue: false, sectionOptions: ["Row Item 1", "Row Item 2", "Row Item 3"]),
//			FolderData(sectionTitle: "Favorites", isExpanded: false, containsUserSelectedValue: false, sectionOptions: ["folder1", "folder2", "folder3"])
//		]
//
//		sampleData = [
//			SampleData(folderTitle: "Favorites", isExpanded: false, indexDepth: 0, contents: ["A", "B", "C"])
//		]
		
//		tableView.register(UINib(nibName: "Main", bundle: nil), forCellReuseIdentifier: "folderCell")
		
		tableView.register(UINib(nibName: "FolderCell", bundle: nil), forCellReuseIdentifier: "folderCell")
		
		tfTitle.delegate = self
		
		tableView.dataSource = self
		tableView.delegate = self
		
		tableView.reloadData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		data = UserDefaultsManager.shared.loadUserBookMarkListData()
		tableView.reloadData()
		
	}
	
	func insertFolderAtSelectedRow(indexPath: IndexPath, title: String) {
		let insertingFolder = BookmarksData.init(titleString: title, child: [], indexPath: [indexPath.row])
		data[indexPath.row].addChild(insertingFolder)
	}
	
}

//MARK: - TextField Delegate
extension EditFolderVC: UITextFieldDelegate {
	func textFieldDidEndEditing(_ textField: UITextField) {
		print("textfieldDidEndEditing")
		insertFolderAtSelectedRow(indexPath: selectedIndex!, title: self.tfTitle.text!) //!!!!!!!!!!!!!!!!!!!!!!!
	}
}


//MARK: - TableView DataSource, Delegate
extension EditFolderVC: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.count
	}
	
	
//	func numberOfSections(in tableView: UITableView) -> Int {
//		return 1
//	}
//
//	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//		return nil
//	}
	
//	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		if section == 0 {
//			return 1
//		}
//		else {
//			if sampleData[0].isExpanded == false {
//				return sampleData.count
//			}
//			else {
//				return sampleData.count + sampleData[0].contents.count
//			}
//		}
//
//
//	}
	
//	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//		if section == 0 {
//			return 40
//		}
//		return 50
//
//	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 40
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		if indexPath.section == 0 {
//			let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath)
//			return cell
//		}
//		else {
//			let cell = tableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath)
//			if sampleData[0].isExpanded == false {
//				cell.textLabel?.text = sampleData[0].folderTitle
//			}
//			else if sampleData[0].isExpanded == true {
//				if indexPath.row == 0 { //sampleData[0].indexDepth { // depth 가 0 일때
//					sampleData[0].indexDepth += 1
//					cell.textLabel?.text = sampleData[0].folderTitle
//
//				}
//				else {
//					cell.indentationLevel = 2
//					cell.indentationWidth = 5
//					cell.shouldIndentWhileEditing = true
//					let string = sampleData[0].contents[indexPath.row - 1]
//
//					let imageAttachment = NSTextAttachment()
//					imageAttachment.image = UIImage(systemName: "folder")
//					let imageOffsety: CGFloat = -5.0
//					imageAttachment.bounds = CGRect(x: 0, y: imageOffsety, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
//					let attachmentString = NSAttributedString(attachment: imageAttachment)
//					let completeText = NSMutableAttributedString(string: "")
//					completeText.append(attachmentString)
//					let textAfterIcon = NSMutableAttributedString(string: " " + string!)
//					completeText.append(textAfterIcon)
//					cell.textLabel?.attributedText = completeText
//					cell.imageView?.image = nil
//
//				}
//
//			}
//
//			return cell
//		}
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath)
		cell.textLabel?.text = data[indexPath.item].titleString
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
//		if sampleData[0].isExpanded == true {
//			if indexPath.row == 0 {
//				return 0
//			}
//			else {
//				return 5
//			}
//		} else {
//			return 0
//		}
	
		var indentationLevel = 0
		while data[indexPath.row].child != nil {
			indentationLevel += 5
		}
		return indentationLevel
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		if indexPath.section == 1 {
//			if indexPath.row == 0 {
//				sampleData[0].isExpanded = !sampleData[0].isExpanded
//				tableView.reloadData()
////				tableView.beginUpdates()
//
//			}
//			if indexPath.row == 1 {
//
//				//FIXME: - 임시
//				let storyboard = UIStoryboard(name: "Main", bundle: nil)
//				let editBookmarkVC = storyboard.instantiateViewController(identifier: "EditBookmarkVC")
//				self.navigationController?.pushViewController(editBookmarkVC, animated: true)
//			}
//		}
		selectedIndex = indexPath
		
	}
	

	
}
