//
//  AlertsAndMenus.swift
//  SafariSample
//
//  Created by Nomad on 2019/12/12.
//  Copyright © 2019 Nomad. All rights reserved.
//

import Foundation
import UIKit

class AlertsAndMenus {
	static let shared = AlertsAndMenus()
	
	func makeContextMenu() -> UIMenu {
	//		let copycontentsAction = UIAction(title: "Copy Contents", image: UIImage(systemName: "doc.on.doc"), identifier: nil, discoverabilityTitle: nil, attributes: UIMenuElement.Attributes.init(), state: UIMenuElement.State.mixed) { (action) in
	//		}
			let copycontentsAction = UIAction(title: "Copy Contents", image: UIImage(systemName: "doc.on.doc")) { action in }
	//		let openInNewTabsAction = UIAction(title: "Open in New Tabs", image: UIImage(systemName: "plus.rectangle.on.rectangle"), identifier: nil, discoverabilityTitle: nil, attributes: UIMenuElement.Attributes.init(), state: UIMenuElement.State.mixed) { (action) in
	//		}
			let openInNewTabsAction = UIAction(title: "Open in New Tabs", image: UIImage(systemName: "plus.rectangle.on.rectangle")) { action in }
			let editAction = UIAction(title: "Edit...", image: UIImage(systemName: "square.and.pencil")) { action in }
			
	//		let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: "delete", attributes: UIMenuElement.Attributes.destructive, state: UIMenuElement.State.mixed) { (action) in
	//		}
			let deleteCancel = UIAction(title: "Cancel", image: UIImage(systemName: "xmark")) { action in }
			let deleteConfirmation = UIAction(title: "Delete", image: UIImage(systemName: "checkmark"), attributes: .destructive) { action in }
			// The delete sub-menu is created like the top-level menu, but we also specify an image and options
			let deleteAction = UIMenu(title: "Delete", image: UIImage(systemName: "trash"), options: .destructive, children: [deleteCancel, deleteConfirmation])
			
			return UIMenu(title: "Menu", image: nil, identifier: nil, options: UIMenu.Options.init(), children: [copycontentsAction, openInNewTabsAction, editAction, deleteAction])
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


