//
//  AlertsAndMenus.swift
//  SafariSample
//
//  Created by Nomad on 2019/12/12.
//  Copyright © 2019 Nomad. All rights reserved.
//

import Foundation
import UIKit

//protocol AlertsAndMenuProtocol {
//	func alertMenuClick(menuType:AlertsAndMenus.MenuType, button:AlertsAndMenus.MenuButtonType)
//}

class AlertsAndMenus {
	static let shared = AlertsAndMenus()
	
	var delegate:AlertsAndMenus?
	
	public enum MenuButtonType {
		///Copy
		case copy
		///Copy Contents
		case copyContents
		///Open In New Tab
		case openInNewTab
		///Open In New Tabs
		case openInNewTabs
		/// Edit
		case edit
		/// Delete cancel
		case deleteCancel
		/// DeleteConfirmation
		case deleteConfirmation
		
		func createButtonAction(_ baseHandle: @escaping UIActionHandler) -> UIAction {
			switch self {
			case .copy:
				return UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc"), identifier: nil, discoverabilityTitle: nil, state: UIMenuElement.State.off, handler: baseHandle)
			case .copyContents:
				return UIAction(title: "Copy Contents", image: UIImage(systemName: "doc.on.doc"), identifier: nil, discoverabilityTitle: nil, state: UIMenuElement.State.off, handler: baseHandle)
			case .openInNewTab:
				return UIAction(title: "Open in New Tab", image: UIImage(systemName: "plus.rectangle.on.rectangle"), identifier: nil, discoverabilityTitle: nil, attributes: UIMenuElement.Attributes.init(), state: UIMenuElement.State.off, handler: baseHandle)
			case .openInNewTabs:
				return UIAction(title: "Open in New Tabs", image: UIImage(systemName: "plus.rectangle.on.rectangle"), identifier: nil, discoverabilityTitle: nil, attributes: UIMenuElement.Attributes.init(), state: UIMenuElement.State.off, handler: baseHandle)
			case .edit:
				return UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil"), identifier: nil, discoverabilityTitle: nil, attributes: UIMenuElement.Attributes.init(), state: UIMenuElement.State.off, handler: baseHandle)
			case .deleteCancel:
				return UIAction(title: "Cancel", image: UIImage(systemName: "xmark"), handler: baseHandle)
			case .deleteConfirmation:
				return UIAction(title: "Delete", image: UIImage(systemName: "checkmark"), identifier: nil, discoverabilityTitle: nil, attributes: UIMenuElement.Attributes.destructive, state: UIMenuElement.State.off, handler: baseHandle)
			}
		}
		
		func createDeleteConfirmationMenu(_baseHandle: @escaping UIActionHandler) -> UIMenu {
			return UIMenu(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil, options: UIMenu.Options.destructive, children: [self.createButtonAction(_baseHandle)
			
			])
		}
		
	}
	
	enum MenuType {
		case emptyFolder
		case folder
		case bookmark
//		case readinglist
//		case history

		func createMenu(_ baseHandle:@escaping UIActionHandler) -> UIMenu {
			return UIMenu(title: "Menu", image: nil, identifier: nil, options: UIMenu.Options.init(), children: self.getMenuButtons(baseHandle))
		}

		private func getMenuButtons(_ baseHandle:@escaping UIActionHandler) -> [UIAction] {
			switch self {
			case .emptyFolder:
				return [
					MenuButtonType.edit.createButtonAction(baseHandle),
					MenuButtonType.deleteConfirmation.createButtonAction(baseHandle)
					
				]
			case .folder:
				return [
					MenuButtonType.copyContents.createButtonAction(baseHandle),
					MenuButtonType.openInNewTabs.createButtonAction(baseHandle),
					MenuButtonType.edit.createButtonAction(baseHandle),
					MenuButtonType.deleteConfirmation.createButtonAction(baseHandle)
				]
			case .bookmark:
				return [
					MenuButtonType.copy.createButtonAction(baseHandle),
					MenuButtonType.openInNewTab.createButtonAction(baseHandle),
					MenuButtonType.edit.createButtonAction(baseHandle),
					MenuButtonType.deleteConfirmation.createButtonAction(baseHandle)
				]
			}
		}
	}

	//var aa : (_ aa:UIActionHandler)->()

	func makeMenu(menuType: MenuType, prevVC:UIViewController) {

		let menu = menuType.createMenu { (action) in
			print("action.title : \(action.title)")
		}

		UIContextMenuConfiguration(identifier: nil, previewProvider: {return prevVC}) { (actions) -> UIMenu? in
			return menu
		}

	}
	
	let copycontentsAction = UIAction(title: "Copy Contents", image: UIImage(systemName: "doc.on.doc")) { action in
		
	}
	
	let copyAction = UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc")) { action in
		
	}
	
	let openInNewTabsAction = UIAction(title: "Open in New Tabs", image: UIImage(systemName: "plus.rectangle.on.rectangle")) { action in
		
	}
	
	let openInNewTabAction = UIAction(title: "Open in New Tab", image: UIImage(systemName: "plus.rectangle.on.rectangle")) { action in
		
	}
	
	let editAction = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil")) { action in
		
	}
	
	let deleteCancel = UIAction(title: "Cancel", image: UIImage(systemName: "xmark")) { action in
		
	}
	let deleteConfirmation = UIAction(title: "Delete", image: UIImage(systemName: "checkmark"), attributes: .destructive) { action in
		
	}
	// The delete sub-menu is created like the top-level menu, but we also specify an image and options
	
	
	func makeEmptyFolderContextMenu() -> UIMenu {
		let deleteAction = UIMenu(title: "Delete", image: UIImage(systemName: "trash"), options: .destructive, children: [deleteCancel, deleteConfirmation])
		
		return UIMenu(title: "Menu", image: nil, identifier: nil, options: UIMenu.Options.init(), children: [editAction, deleteAction])
	}
	
	func makeFolderContextMenu() -> UIMenu {
			let deleteAction = UIMenu(title: "Delete", image: UIImage(systemName: "trash"), options: .destructive, children: [deleteCancel, deleteConfirmation])
			
			return UIMenu(title: "Menu", image: nil, identifier: nil, options: UIMenu.Options.init(), children: [copycontentsAction, openInNewTabsAction, editAction, deleteAction])
		}
	
	func makeBookmarkContextMenu() -> UIMenu {
		let deleteAction = UIMenu(title: "Delete", image: UIImage(systemName: "trash"), options: .destructive, children: [deleteCancel, deleteConfirmation])
		return UIMenu(title: "Menu", image: nil, identifier: nil, options: UIMenu.Options.init(), children: [copyAction, openInNewTabAction, editAction, deleteAction])
	}
	
	func makeReadingListContextMenu() -> UIMenu {
		let deleteAction = UIMenu(title: "Delete", image: UIImage(systemName: "trash"), options: .destructive, children: [deleteCancel, deleteConfirmation])
		return UIMenu(title: "Menu", image: nil, identifier: nil, options: UIMenu.Options.init(), children: [copyAction, openInNewTabAction, deleteAction])
	}
	
	func makeHistoryContextMenu() -> UIMenu {
		let deleteAction = UIMenu(title: "Delete", image: UIImage(systemName: "trash"), options: .destructive, children: [deleteCancel, deleteConfirmation])
		return UIMenu(title: "Menu", image: nil, identifier: nil, options: UIMenu.Options.init(), children: [copyAction, openInNewTabAction, deleteAction])
	}
	
	func makeTabAlerts() -> UIAlertController {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
		
		let closeThisTabAction = UIAlertAction(title: "Close This Tab", style: UIAlertAction.Style.destructive) { (action) in
			//TODO: implement later Close This Tab
		}
		let closeAllTabsAction = UIAlertAction(title: "Close All Tabs", style: UIAlertAction.Style.destructive) { (action) in
			//TODO: implement later Close All Tabs
		}
		let newTabAction = UIAlertAction(title: "New Tab", style: UIAlertAction.Style.default) { (action) in
			//TODO: implement later ADD TO READINGLIST
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
			//TODO: implement later Cancel
		}
		
		alertController.addAction(closeAllTabsAction)
		alertController.addAction(closeThisTabAction)
		alertController.addAction(newTabAction)
		alertController.addAction(cancelAction)
		
		return alertController
	}
	
	
	func alertNotify(title: String?, message: String?, style: UIAlertController.Style) -> UIAlertController {
		let alert = UIAlertController.init(title: "Not A Valid URL", message: nil, preferredStyle: UIAlertController.Style.alert)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
		
		let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
		
		alert.addAction(okAction)
		
		return alert
	}

}


