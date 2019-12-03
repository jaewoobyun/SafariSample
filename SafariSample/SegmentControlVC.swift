//
//  SegmentControlVC.swift
//  SafariSample
//
//  Created by Nomad on 2019/11/25.
//  Copyright © 2019 Nomad. All rights reserved.
//

import Foundation
import UIKit

class SegmentControlVC: UIViewController {
	
	@IBAction func done(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true, completion: nil)
	}
	@IBOutlet weak var contentView: UIView!
	
	@IBOutlet weak var topToolBar: UIToolbar!
	
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	
	lazy var bookmarksViewController: BookmarksVC = {
		//Load Storyboard
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		//Instantiate VC
		var viewController = storyboard.instantiateViewController(identifier: "BookmarksVC") as! BookmarksVC
		// Add VC as ChildVC
		self.add(asChildViewController: viewController)
		return viewController
	}()
	
	lazy var readingListViewController: ReadingList = {
		//Load Storyboard
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		//Instantiate VC
		var viewController = storyboard.instantiateViewController(identifier: "ReadingList") as! ReadingList
		// Add VC as ChildVC
		self.add(asChildViewController: viewController)
		return viewController
	}()
	
	lazy var historyViewController: History = {
		//Load Storyboard
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		//Instantiate VC
		var viewController = storyboard.instantiateViewController(identifier: "History") as! History
		// Add VC as ChildVC
		self.add(asChildViewController: viewController)
		return viewController
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Bookmarks"
		
		self.navigationController?.navigationBar.barTintColor = UIColor.blue
		self.topToolBar.delegate = self
		
		setupView()
		
	}
	
	func setupView() {
		setupSegmentedControl()
		updateView()
	}
	
	func updateView() {
		if segmentedControl.selectedSegmentIndex == 0 {
			remove(asChildViewController: readingListViewController)
			remove(asChildViewController: historyViewController)
			add(asChildViewController: bookmarksViewController)
			self.title = bookmarksViewController.title
			
		}
		else if segmentedControl.selectedSegmentIndex == 1 {
			remove(asChildViewController: bookmarksViewController)
			remove(asChildViewController: historyViewController)
			add(asChildViewController: readingListViewController)
			self.title = readingListViewController.title
		}
		else {
			remove(asChildViewController: bookmarksViewController)
			remove(asChildViewController: readingListViewController)
			add(asChildViewController: historyViewController)
			self.title = historyViewController.title
		}
	}
	
	func setupSegmentedControl() {
		// Configure Segmented Control
		segmentedControl.removeAllSegments()
		segmentedControl.insertSegment(with: UIImage(systemName: "book"), at: 0, animated: true)
		segmentedControl.insertSegment(with: UIImage(systemName: "eyeglasses"), at: 1, animated: true)
		segmentedControl.insertSegment(with: UIImage(systemName: "clock"), at: 2, animated: true)
		segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
		
		// Select First Segment
		segmentedControl.selectedSegmentIndex = 0
	}
	
	private func add(asChildViewController viewController: UIViewController) {
		// Add Child View Controller
		addChild(viewController)
		
		//add Child View as Subview
		self.contentView.addSubview(viewController.view)
		//		view.addSubview(viewController.view)
		
		//configure Child View
		viewController.view.bounds = view.bounds //
		viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.toolbarItems = viewController.toolbarItems
		
		//Notify Child ViewController
		viewController.didMove(toParent: self)
	}
	
	private func remove(asChildViewController viewController: UIViewController) {
		//Notify Child ViewController
		viewController.willMove(toParent: nil)
		
		//Remove Child View from Superview
		viewController.view.removeFromSuperview()
		
		//Notify Child View Controller
		viewController.removeFromParent()
	}
	
	@objc func selectionDidChange(_ sender: UISegmentedControl) {
		updateView()
	}
	
	
}

extension SegmentControlVC: UIToolbarDelegate {
	func position(for bar: UIBarPositioning) -> UIBarPosition {
		return UIBarPosition.topAttached
	}
}
