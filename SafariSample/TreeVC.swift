////
////  TreeVC.swift
////  SafariSample
////
////  Created by Nomad on 2019/11/29.
////  Copyright © 2019 Nomad. All rights reserved.
////
//
//import Foundation
//import UIKit
//import CITreeView
//
//class TreeVC: UIViewController, CITreeViewDelegate, CITreeViewDataSource {
//	
//	
//	
//	
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		
//		let ciTreeView = CITreeView.init(frame: self.view.bounds, style: UITableView.Style.plain)
//		ciTreeView.treeViewDelegate = self
//		ciTreeView.treeViewDataSource = self
//		self.view.addSubview(ciTreeView)
//		
//	}
//	
//	func treeView(_ treeView: CITreeView, heightForRowAt indexPath: IndexPath, withTreeViewNode treeViewNode: CITreeViewNode) -> CGFloat {
//		return 40
//	}
//	
//	func treeView(_ treeView: CITreeView, didSelectRowAt treeViewNode: CITreeViewNode, atIndexPath indexPath: IndexPath) {
//		<#code#>
//	}
//	
//	func treeView(_ treeView: CITreeView, didDeselectRowAt treeViewNode: CITreeViewNode, atIndexPath indexPath: IndexPath) {
//		<#code#>
//	}
//	
//	func willExpandTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath) {
//		<#code#>
//	}
//	
//	func didExpandTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath) {
//		<#code#>
//	}
//	
//	func willCollapseTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath) {
//		<#code#>
//	}
//	
//	func didCollapseTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath) {
//		<#code#>
//	}
//	
//	func treeView(_ treeView: CITreeView, atIndexPath indexPath: IndexPath, withTreeViewNode treeViewNode: CITreeViewNode) -> UITableViewCell {
//		let cell = treeView.dequeueReusableCell(withIdentifier: "treeviewcell", for: indexPath)
//		return cell
//	}
//	
//	func treeViewSelectedNodeChildren(for treeViewNodeItem: AnyObject) -> [AnyObject] {
//		//
//	}
//	
//	func treeViewDataArray() -> [AnyObject] {
//		""
//	}
//	
//	
//	
//}
