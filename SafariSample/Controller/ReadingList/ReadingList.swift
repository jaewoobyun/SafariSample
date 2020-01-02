//
//  ReadingList.swift
//  SafariSample
//
//  Created by Nomad on 2019/11/25.
//  Copyright © 2019 Nomad. All rights reserved.
//

import UIKit

class ReadingList: UIViewController {
	
	//MARK: - Outlets
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var editButton: UIBarButtonItem!
	@IBOutlet weak var secretButton: UIBarButtonItem!
	
	var toggle: Bool = false
	
	let searchController = UISearchController(searchResultsController: nil)
	lazy var searchBar = UISearchBar(frame: CGRect.zero)
	
//	var dataSample = ["One","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten"]
	var readingListDatas : [ReadingListData] = []
	
	var deleteButton: UIButton?
	var deleteBarButton: UIBarButtonItem?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Reading List"
		self.navigationController?.navigationBar.isHidden = false
		
		self.editButton = self.editButtonItem
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableHeaderView = searchController.searchBar
		tableView.isEditing = false
		toggle = tableView.isEditing
		
		tableView.register(UINib(nibName: "ReadingListCell", bundle: nil), forCellReuseIdentifier: "ReadingListCell")
		tableView.allowsMultipleSelectionDuringEditing = true
		
		deleteButton = UIButton.init(type: UIButton.ButtonType.close)
//		deleteButton?.setTitle("delete", for: UIControl.State.normal)
		deleteBarButton = UIBarButtonItem.init(customView: deleteButton!)
		deleteButton?.addTarget(self, action: #selector(deleteSelection), for: UIControl.Event.touchUpInside)
		deleteButton?.isHidden = true
		
		self.toolbarItems?.insert(deleteBarButton!, at: 2)
		
		tableView.reloadData()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		UserDefaultsManager.shared.registerReadingListDataObserver(vc: self, selector: #selector(updateReadingListDatas))
		UserDefaultsManager.shared.loadUserReadingListData()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		UserDefaultsManager.shared.removeReadingListDataObserver()
	}
	
	@objc func updateReadingListDatas() {
		print("readinglistVC updateReadinglistDatas")
		self.readingListDatas.removeAll()
		readingListDatas = UserDefaultsManager.shared.readingListDataSave
		
		tableView.reloadData()
	}
	
	
	@IBAction func editButtonAction(_ sender: UIBarButtonItem) {
		print("Edit!")
		toggle = !toggle
		if toggle == true {
			sender.title = "Done"
			tableView.isEditing = true
//			tableView.allowsMultipleSelectionDuringEditing = true
//			UserDefaultsManager.shared.removeReadingListDataObserver()
			
			deleteButton?.isHidden = false
			
		} else {
			tableView.isEditing = false
			deleteButton?.isHidden = true
			sender.title = "Edit"
		}
	}
	
	
	@objc func deleteSelection() {
		print("deletebutton pressed!!")
		if let selectedRows = tableView.indexPathsForSelectedRows {
			//1
//			var items = [String]()
			var uuids: [String] = []
			
			//지우고싶은, 선택된 아이템을 걸러낸다.
			for indexPath in selectedRows {
				uuids.append(readingListDatas[indexPath.row].uuid)
			}
			
			//3
			/// 이 vc 에서 쓰는 데이터도 지워야 하기 때문에 readingListData 도 필터해 지운다.
			self.readingListDatas = self.readingListDatas.filter({ (data) -> Bool in
				for removeItem in uuids {
					if removeItem == data.uuid {
						return false
					}
				}
				
				return true
			})
			
			tableView.beginUpdates()
			tableView.deleteRows(at: selectedRows, with: UITableView.RowAnimation.automatic)
			tableView.endUpdates()
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
				UserDefaultsManager.shared.removeReadingListItemWithUUID(uuids: uuids)
			}
			
		}

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

extension ReadingList: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		print("updateSearchResults")
	}
	
}

extension ReadingList : UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return readingListDatas.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		let cell = tableView.dequeueReusableCell(withIdentifier: "readinglistprototype", for: indexPath)
		let cell = tableView.dequeueReusableCell(withIdentifier: "ReadingListCell", for: indexPath) as! ReadingListCell
		let data = readingListDatas[indexPath.row]
		cell.setCellData(data)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("didSelectRowAt \(indexPath)")
		let urlString = self.readingListDatas[indexPath.row].urlString
		
		if tableView.isEditing == true {
			print("tableview is editing")
			
		}
		else {
			NotificationGroup.shared.post(type: .readinglistURLName, userInfo: ["selectedReadinglistURL": urlString])
			self.dismiss(animated: true, completion: nil)
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
			UserDefaultsManager.shared.removeReadingListItemAtIndexPath(indexPath: indexPath)
			tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
		}
		
	}
	
	func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (actions) -> UIMenu? in
			return AlertsAndMenus.shared.makeContextMenu()
		}
	}
	
	func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
		//
	}
	
	
//	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//		let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.destructive, title: "delete") { (action, indexPath) in
//			// delete
//		}
//
//		let saveOfflineAction = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: "Save Offline") { (action, indexPath) in
//			// save offline
//		}
//
//
//		return [deleteAction, saveOfflineAction]
//	}
	
	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		// leading swipe
		let markUnreadAction = UIContextualAction(style: UIContextualAction.Style.normal, title: "Mark Unread") { (ac: UIContextualAction, view: UIView, success: @escaping (Bool) -> Void) in
			// Call mark unread Action
			
			//Reset state
			success(true)
		}
		markUnreadAction.backgroundColor = UIColor.systemBlue
		
		return UISwipeActionsConfiguration(actions: [markUnreadAction])
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let deleteAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: "Delete") { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
			// Call edit action
			UserDefaultsManager.shared.removeReadingListItemAtIndexPath(indexPath: indexPath)
			//Reset state
			
			success(true)
		}
		
		let saveOfflineAction = UIContextualAction(style: UIContextualAction.Style.normal, title: "Save Offline") { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
			// Call edit aciton
			
			// Reset state
			
			success(true)
		}
		
		return UISwipeActionsConfiguration(actions: [deleteAction, saveOfflineAction])
		
	}
	
	
}
