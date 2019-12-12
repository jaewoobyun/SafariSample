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
	
	var dataSample = ["One","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten"]
	
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
		tableView.allowsMultipleSelectionDuringEditing = true
		
		deleteButton = UIButton.init(type: UIButton.ButtonType.close)
//		deleteButton?.setTitle("delete", for: UIControl.State.normal)
		deleteBarButton = UIBarButtonItem.init(customView: deleteButton!)
		deleteButton?.addTarget(self, action: #selector(deleteSelection), for: UIControl.Event.touchUpInside)
		deleteButton?.isHidden = true
		
		self.toolbarItems?.insert(deleteBarButton!, at: 2)
		
		tableView.reloadData()
		
	}
	
	
	@IBAction func editButtonAction(_ sender: UIBarButtonItem) {
		print("Edit!")
		toggle = !toggle
		if toggle == true {
			sender.title = "Done"
			tableView.isEditing = true
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
			var items = [String]()
			for indexPath in selectedRows {
				items.append(dataSample[indexPath.row])
			}
			//2
			for item in items {
				if let index = dataSample.firstIndex(of: item) {
					dataSample.remove(at: index)
					print("selected index: \(index)")
				}
			}
			//3
			tableView.beginUpdates()
			tableView.deleteRows(at: selectedRows, with: UITableView.RowAnimation.automatic)
			tableView.endUpdates()
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
		return 5
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "readinglistprototype", for: indexPath)
		cell.textLabel?.text = dataSample[indexPath.row]
		cell.detailTextLabel?.text = dataSample[indexPath.row]
//		cell.imageView?.image =
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		NotificationGroup.shared.post(type: .readinglistURLName, userInfo: ["selectedReadinglistURL": "awefawefawefawef"])
	}
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
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
