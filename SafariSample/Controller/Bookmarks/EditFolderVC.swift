//
//  EditFolderVC.swift
//  SafariSample
//
//  Created by Nomad on 2019/11/28.
//  Copyright © 2019 Nomad. All rights reserved.
//

import UIKit

class EditFolderVC: UIViewController {
	
	
	@IBOutlet weak var tableView: UITableView!
	
	var folderData = [FolderData]()
	var sampleData = [SampleData]()
	var initialFolderTitles = ["Bookmarks", "Favorites", "ReadingList"]
	
	var cellisExpanded: Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Edit Folder"
		
		folderData = [
			FolderData(sectionTitle: "Bookmarks", isExpanded: false, containsUserSelectedValue: false, sectionOptions: ["Row Item 1", "Row Item 2", "Row Item 3"]),
			FolderData(sectionTitle: "Favorites", isExpanded: false, containsUserSelectedValue: false, sectionOptions: ["folder1", "folder2", "folder3"])
		]
		
		sampleData = [
			SampleData(folderTitle: "Favorites", isExpanded: false, indexDepth: 0, contents: ["A", "B", "C"])
		]
		
		tableView.dataSource = self
		tableView.delegate = self
		
		
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


//MARK: - TableView DataSource, Delegate
extension EditFolderVC: UITableViewDataSource, UITableViewDelegate {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return nil
		}
		return "Location"
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		}
		else {
			if sampleData[0].isExpanded == false {
				return sampleData.count
			}
			else {
				return sampleData.count + sampleData[0].contents.count
			}
		}
	}
	
//	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//		if section == 0 {
//			return nil
//		}
//		if section == 1 {
//			let label = UILabel()
//			label.text = "LOCATION"
//			label.textColor = UIColor.gray
//			label.font = UIFont.systemFont(ofSize: 14)
//			label.backgroundColor = UIColor.clear
//			return label
//		}
//		return UIView() //???
//	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 0 {
			return 40
		}
		return 50
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 43
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath)
			return cell
		}
		else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath)
			if sampleData[0].isExpanded == false {
				cell.textLabel?.text = sampleData[0].folderTitle
			}
			else if sampleData[0].isExpanded == true {
				if indexPath.row == 0 { //sampleData[0].indexDepth { // depth 가 0 일때
					sampleData[0].indexDepth += 1
					cell.textLabel?.text = sampleData[0].folderTitle
					
				}
				else {
					cell.indentationLevel = 2
					cell.indentationWidth = 5
					cell.shouldIndentWhileEditing = true
					let string = sampleData[0].contents[indexPath.row - 1]
					
					let imageAttachment = NSTextAttachment()
					imageAttachment.image = UIImage(systemName: "folder")
					let imageOffsety: CGFloat = -5.0
					imageAttachment.bounds = CGRect(x: 0, y: imageOffsety, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
					let attachmentString = NSAttributedString(attachment: imageAttachment)
					let completeText = NSMutableAttributedString(string: "")
					completeText.append(attachmentString)
					let textAfterIcon = NSMutableAttributedString(string: " " + string!)
					completeText.append(textAfterIcon)
					cell.textLabel?.attributedText = completeText
					cell.imageView?.image = nil
					
				}
				
			}
			
			return cell
		}

	}
	
	func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
		if sampleData[0].isExpanded == true {
			if indexPath.row == 0 {
				return 0
			}
			else {
				return 5
			}
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 1 {
			if indexPath.row == 0 {
				sampleData[0].isExpanded = !sampleData[0].isExpanded
				tableView.reloadData()
//				tableView.beginUpdates()
				
			}
			if indexPath.row == 1 {
				
				//FIXME: - 임시
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				let editBookmarkVC = storyboard.instantiateViewController(identifier: "EditBookmarkVC")
				self.navigationController?.pushViewController(editBookmarkVC, animated: true)
			}
		}
	}
	

	
}
