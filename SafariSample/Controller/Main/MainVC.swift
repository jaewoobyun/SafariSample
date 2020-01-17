//
//  ViewController.swift
//  SafariSample
//
//  Created by Nomad on 2019/11/18.
//  Copyright © 2019 Nomad. All rights reserved.
//

import UIKit
import QuartzCore
import WebKit



let hostNameForLocalFile = ""
/**
# MainVC
  웹 컨텐츠가 표시되는 메인 뷰를 관리 하는 뷰 컨트롤러
*/
class MainVC: UIViewController, UISearchControllerDelegate, UIViewControllerPreviewingDelegate {
	
	/// 검색 결과를 표시할 searchController
	let searchController = UISearchController(searchResultsController: nil)
	/// searchBar 검색
	lazy var searchBar = UISearchBar(frame: CGRect.zero)
	/// 웹 컨텐츠의 로딩을 표시할 파란색 진행 줄
	@IBOutlet weak var progressView: UIProgressView!
	/// CustomBarItem 을 상속한다. longPress 를 하기 위해
	@IBOutlet weak var backButton: CusBarItem!
	/// CustomBarItem 을 상속한다. longPress 를 하기 위해
	@IBOutlet weak var forwardButton: CusBarItem!
	/// ShareButton
	@IBOutlet weak var shareButton: UIBarButtonItem!
	/// CustomBarItem 을 상속한다. longPress 를 하기 위해
	@IBOutlet weak var bookmarksButton: CusBarItem!
	/// CustomBarItem 을 상속한다. longPress 를 하기 위해
	@IBOutlet weak var tabsButton: CusBarItem!
	/// Main webView. WKWebView
	@IBOutlet weak var webView: WKWebView!
	
	var currentContentMode: WKWebpagePreferences.ContentMode?
	var contentModeToRequestForHost: [String: WKWebpagePreferences.ContentMode] = [:]
	var estimatedProgressObservationToken: NSKeyValueObservation?
	var canGoBackObservationToken: NSKeyValueObservation?
	var canGoForwardObservationToken: NSKeyValueObservation?
	
	var visitedWebSiteHistoryRecords: [HistoryData] = []
	
	required init?(coder: NSCoder) {
		let configuration = WKWebViewConfiguration()
		configuration.applicationNameForUserAgent = "Version/1.0 SafariSample/1.0"
		webView = WKWebView(frame: .zero, configuration: configuration)
		
		super.init(coder: coder)
	}
	
	var isGalleryOpen = false
	
	var images = [
		ImageViewCard(imageNamed: "sampleImage1", title: "SampleImage1"),
		ImageViewCard(imageNamed: "favorites", title: "favorites"),
		ImageViewCard(imageNamed: "tabs", title: "tabs"),
		ImageViewCard(imageNamed: "bookmark", title: "bookmark")
	]
	
	var snapshots: [UIView] = []
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		
		if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
			
		} else  {
			// When force touch is not available, remove force touch gesture recognizer.
			// Also implement a fallback if necessary (e.g. a long press gesture recognizer)
			//			  bookmarksButton.removeGestureRecognizer()
		}
	}
	
	

	//MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
//		is3dTouchAvailable(traitCollection: self.view!.traitCollection)
		
		setupCustomButtons()
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let resultsController = storyboard.instantiateViewController(identifier: "SearchResultsController") as! SearchResultsController
		//		let searchController = UISearchController(searchResultsController: resultsController)
		
		searchController.delegate = self
		searchController.searchResultsUpdater = self
		//		searchController.searchResultsUpdater = resultsController //!!!!!!!!!!!
		searchController.searchBar.delegate = self
		searchController.searchBar.placeholder = "Search or enter website name"
		searchController.obscuresBackgroundDuringPresentation = false
		
		webView?.navigationDelegate = self
		webView.scrollView.delegate = self
		registerForPreviewing(with: self, sourceView: self.view)
		
		if #available(iOS 11.0, *) {
			searchBar = searchController.searchBar
			navigationItem.searchController = searchController
			navigationItem.hidesSearchBarWhenScrolling = false
			navigationItem.prompt = nil
			navigationController?.toolbar.delegate = self
		}
		self.navigationController?.navigationBar.isHidden = true
		self.navigationController?.navigationBar.barTintColor = UIColor.white
		
		////  searchBar customization
		searchBar.showsBookmarkButton = true
		let refreshImage = UIImage(systemName: "arrow.clockwise")
		let aIcon = UIImage(systemName: "a")
		searchBar.setImage(aIcon, for: UISearchBar.Icon.search, state: UIControl.State.disabled)
		searchBar.setImage(refreshImage, for: UISearchBar.Icon.bookmark, state: UIControl.State.normal)
		searchBar.autocapitalizationType = .none
		
		let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "textformat.size"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(showPopover))
		navigationItem.leftBarButtonItem = leftBarButton
		
		var loadedExistingURL = false
		if let lastCommittedURLStringString = UserDefaults.standard.object(forKey: "LastCommittedURLString") as? String {
			if let url = URL(string: lastCommittedURLStringString) {
				searchBar.text = lastCommittedURLStringString
				webView.load(URLRequest(url: url))
				loadedExistingURL = true
			}
		}
		
		if !loadedExistingURL {
			loadStartPage()
		}
		setUpObservation()
		UserDefaultsManager.shared.initDatas()
		
		NotificationGroup.shared.registerObserver(type: .bookmarkURLName, vc: self, selector: #selector(onNotification(notification:)))
		NotificationGroup.shared.registerObserver(type: .historyURLName, vc: self, selector: #selector(onHitoryNotification(notification:)))
		NotificationGroup.shared.registerObserver(type: .readinglistURLName, vc: self, selector: #selector(onReadingListNotification(notification:)))
		
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		NotificationGroup.shared.removeAllObserver(vc: self)
	}
	
	@objc func cancelAddBookmark() {
		self.dismiss(animated: true, completion: nil)
	}
	
	/// Back , Forward , Share, Bookmarks, Tabs
	func setupCustomButtons() {
		//MARK: Bookmarks
		bookmarksButton.tapEvent = {
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let bookmarkNav = storyboard.instantiateViewController(identifier: "BookmarkNav") as UINavigationController
			self.navigationController?.present(bookmarkNav, animated: true, completion: nil)
			
			if let segmentVC = bookmarkNav.children[0] as? SegmentControlVC {
				segmentVC.selectedBookmarkHandler = { urlString in
					self.loadWebViewFromBookmarksURL(urlString: urlString)
				}
			}
		}

		bookmarksButton.longEvent = {
			print("bookmarksButton.longEvent")
			let alertcontroller = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
			let addBookmarkAction = UIAlertAction(title: "Add Bookmark", style: UIAlertAction.Style.default) { (action) in
				let urlString = self.webView.url?.absoluteString ?? ""
				var title = self.webView.backForwardList.currentItem?.title ?? ""
				if title.isEmpty {
					title = urlString
				}
				
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				let editBookmarkVC = storyboard.instantiateViewController(withIdentifier: "EditBookmarkVC") as! EditBookmarkVC
				let navController = UINavigationController(rootViewController: editBookmarkVC)
				
				editBookmarkVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAddBookmark))
				editBookmarkVC.caseType = .AddNewBookmark
				editBookmarkVC.bookmarkTitle = title
				editBookmarkVC.address = urlString
				
				self.present(navController, animated: true, completion: nil)
			}
			
			let addReadingListAction = UIAlertAction(title: "Add to Reading List", style: UIAlertAction.Style.default) { (action) in
				let backForwardList = self.webView.backForwardList.self
				guard let currentItemUrl = backForwardList.currentItem?.url else { return }
				guard let currentItemInitialUrl = backForwardList.currentItem?.initialURL else { return }
				guard let currentItemTitle = backForwardList.currentItem?.title else { return }
				guard let currentItemUrlString = backForwardList.currentItem?.url.absoluteString else { return }
				let now = Date()
				
//				backForwardList.currentItem?.initialURL
				
				let readingListDataInstance = ReadingListData(url: currentItemUrl, initialUrl: currentItemInitialUrl, title: currentItemTitle, urlString: currentItemUrlString, date: now)
				
				UserDefaultsManager.shared.insertCurrentItemToReadingList(readingListData: readingListDataInstance)
				
			}
			let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
				
			}
			
			alertcontroller.addAction(addBookmarkAction)
			alertcontroller.addAction(addReadingListAction)
			alertcontroller.addAction(cancelAction)
			
			self.present(alertcontroller, animated: true, completion: nil)
		}
		
		//MARK: Tabs
		tabsButton.tapEvent = {
			print("tabsButton.tapEvent!")
		}
		tabsButton.longEvent = {
			print("tabsButton.longEvent!")
			let tabAlerts = AlertsAndMenus.shared.makeTabAlerts()
			
			self.present(tabAlerts, animated: true, completion: nil)
			
		}
		//MARK: Backward
		backButton.tapEvent = {
			self.webView.goBack()
		}
		backButton.longEvent = {
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			//			let history = storyboard.instantiateViewController(identifier: "History") as! History
			let history = storyboard.instantiateViewController(identifier: "HistoryNavigationController") as UINavigationController
			self.navigationController?.present(history, animated: true, completion: nil)
		}
		//MARK: Forward
		forwardButton.tapEvent = {
			self.webView.goForward()
		}
		forwardButton.longEvent = {
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			//			let history = storyboard.instantiateViewController(identifier: "History") as! History
			let history = storyboard.instantiateViewController(identifier: "HistoryNavigationController") as UINavigationController
			self.navigationController?.present(history, animated: true, completion: nil)
		}
		
	}
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
//		previewingContext.sourceRect = bookmarksButton.accessibilityFrame
		guard let vc = storyboard?.instantiateViewController(identifier: "SegmentControlVC") as? SegmentControlVC else { preconditionFailure("Expected SegmentVC") }
		return vc
	}
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
		print("previewingContext")
	}
	
	
	func getPlist(withName name: String) -> [String]? {
		if let path = Bundle.main.path(forResource: name, ofType: "plist"), let xml = FileManager.default.contents(atPath: path) {
			return (try? PropertyListSerialization.propertyList(from: xml, options: PropertyListSerialization.ReadOptions.mutableContainersAndLeaves, format: nil)) as? [String]
		}
		return nil
	}
	//-----------------
	
	@objc func showPopover() {
		print("show PopOver !!!!!")
		presentPopoverWithActions(actions: [
			addToFavoritesAction(),
			shareAction(),
			toggleContentAction(),
			loadStartPageAction(),
			cancelAction()
		])
	}
	
	func setUpObservation() {
		estimatedProgressObservationToken = webView.observe(\.estimatedProgress) { (object, change) in
			let estimatedProgress = self.webView.estimatedProgress
			self.progressView.alpha = 1
			self.progressView.progress = Float(estimatedProgress)
			if estimatedProgress >= 1 { //로딩이 끝나면 progressview 를 안 보이게 해준다.
				self.progressView.alpha = 0
			}
		}
		
		canGoBackObservationToken = webView.observe(\.canGoBack) { (object, change) in
			self.backButton.isEnabled = self.webView.canGoBack
		}
		
		canGoForwardObservationToken = webView.observe(\.canGoForward) { (object, change) in
			self.forwardButton.isEnabled = self.webView.canGoForward
		}
	}
	
	//MARK: - ViewDidAppear
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		for image in images {
			image.layer.anchorPoint.y = 0.0
			//375 667
			image.frame = CGRect(x: 0, y:100, width: 375, height: 667)
			image.didSelect = selectImage
			//			self.view.addSubview(image)//
		}
		var perspective = CATransform3DIdentity
		perspective.m34 = -1.0/250.0
		view.layer.sublayerTransform = perspective
		
		//		for snapshot in snapshots {
		//			snapshot.layer.anchorPoint.y = 0.0
		//			snapshot.frame = CGRect(x: 0, y: 44, width: 375, height: 667)
		//			self.view.addSubview(snapshot)
		//		}
		//		var perspectvie = CATransform3DIdentity
		//		perspectvie.m34 = -1.0/250.0
		//		view.layer.sublayerTransform = perspectvie
		
	}
	
	//	override class func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
	//		if keyPath == "title" {
	//			if let title = webView.title {
	//				print(title)
	//			}
	//		}
	//	}
	
	@objc func onHitoryNotification(notification: Notification) {
		if let url = notification.userInfo?["selectedHistoryURL"] as? String {
			print(url)
			loadWebViewFromBookmarksURL(urlString: url)
		}
		
	}
	
	@objc func onNotification(notification: Notification) {
		//		print(notification.userInfo)
		if let url = notification.userInfo?["selectedBookmarkURL"] as? String {
			//			print(url)
			loadWebViewFromBookmarksURL(urlString: url)
		}
		
	}
	
	@objc func onReadingListNotification(notification: Notification) {
		if let url = notification.userInfo?["selectedReadinglistURL"] as? String {
			loadWebViewFromBookmarksURL(urlString: url)
		}
	}
	
	func loadWebViewFromBookmarksURL(urlString: String?) {
		//http://AAA.com
		self.searchBar.text = urlString
		
		guard var urlString = urlString?.lowercased() else { return }
		guard let url: URL = URL.init(string: urlString) else {
			return
		}
		if UIApplication.shared.canOpenURL(url) {
			//TODO: - Not sure
			self.webView.load(URLRequest(url: url))
		}
		
		if !urlString.contains("://") {
			if urlString.contains("localhost") || urlString.contains("127.0.0.1") {
				urlString = "http://" + urlString
			} else {
				urlString = "https://" + urlString
			}
		}
		if webView.url?.absoluteString == urlString {
			return
		}
		if let targetURL = URL(string: urlString) {
			webView.load(URLRequest(url: targetURL))
		}
		
	}
	
	func loadStartPage() {
		if let bookmarksURL = Bundle.main.url(forResource: "bookmarks_11_19_19", withExtension: "html") {
			searchBar.text = "bookmarks_11_19_19.html"
			webView.loadFileURL(bookmarksURL, allowingReadAccessTo: Bundle.main.bundleURL)
		}
	}

	//	func searchWebSite(urlString: String) {
	//		let url = URL(string: urlString)
	//		let request = URLRequest(url: url!)
	//		self.webView?.load(request)
	//	}
	
	//	func selectWebView(selectedWebView: CustomWebView) {
	//		for subview in view.subviews {
	//			guard let webV = subview as? CustomWebView else {
	//				continue
	//			}
	//			if webV === selectedWebView {
	//				UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
	//					webV.layer.transform = CATransform3DIdentity
	//				}) { (_) in
	//					self.view.bringSubviewToFront(webV)
	//				}
	//			} else {
	//				UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
	//					webV.alpha = 0.0
	//				}) { (_) in
	//					webV.alpha = 1.0
	//					webV.layer.transform = CATransform3DIdentity
	//				}
	//			}
	//		}
	//		isGalleryOpen = false
	//	}
	
	func selectImage(selectedImage: ImageViewCard) {
		for subview in view.subviews {
			guard let image = subview as? ImageViewCard else {
				continue
			}
			if image === selectedImage {
				UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
					image.layer.transform = CATransform3DIdentity
				}) { (_) in
					self.view.bringSubviewToFront(image)
				}
			} else {
				UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
					image.alpha = 0.0
				}) { (_) in
					image.alpha = 1.0
					image.layer.transform = CATransform3DIdentity
				}
			}
		}
		
		//		self.navigationItem.title = selectedImage.title
		isGalleryOpen = false
	}
	
	func presentPopoverWithActions(actions: [UIAlertAction]) {
		let alertController = UIAlertController(title: nil, message: nil
			, preferredStyle: UIAlertController.Style.actionSheet)
		for action in actions {
			alertController.addAction(action)
		}
		if let popoverController = alertController.popoverPresentationController {
			if let leftBarButtonItem = navigationItem.leftBarButtonItem {
				popoverController.sourceRect = leftBarButtonItem.accessibilityFrame
			}
			
			//			popoverController.sourceRect = navigationItem.leftBarButtonItem?.accessibilityFrame!
			popoverController.sourceView = self.view
			popoverController.permittedArrowDirections = .up
		}
		self.present(alertController, animated: true, completion: nil)
		
	}
	
	func addToFavoritesAction() -> UIAlertAction {
		return UIAlertAction(title: "Add To Favorites", style: .default, handler: { (alert: UIAlertAction!) -> Void in
			// Not implemented.
		})
	}
	func shareAction() -> UIAlertAction {
		return UIAlertAction(title: "Share…", style: .default, handler: { (alert: UIAlertAction!) -> Void in
			//			let message = "Message goes here"
			if let link = NSURL(string: self.searchBar.text!) {
				let objectsToShare = [link] as [Any]
				let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
				activityVC.excludedActivityTypes = []
				self.present(activityVC, animated: true, completion: nil)
			}
		})
	}
	func cancelAction() -> UIAlertAction {
		return UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (alert: UIAlertAction!) in
			//
		}
	}
	// Setup the popover item for toggling between the mobile and desktop version of a site.
	func toggleContentAction() -> UIAlertAction {
		let requestMobileSite = currentContentMode == .desktop
		let title = requestMobileSite ? "Request Mobile Site" : "Request Desktop Site"
		return UIAlertAction(title: title, style: .default, handler: { (alert: UIAlertAction!) -> Void in
			// Toggle the content mode of the current website and reload the content.
			if let url = self.webView.url {
				let requestedContentMode = requestMobileSite ? WKWebpagePreferences.ContentMode.mobile : WKWebpagePreferences.ContentMode.desktop
				if url.scheme != "file" {
					if let hostName = url.host {
						self.contentModeToRequestForHost[hostName] = requestedContentMode
					}
				} else {
					self.contentModeToRequestForHost[hostNameForLocalFile] = requestedContentMode
				}
				self.webView.reloadFromOrigin()
			}
		})
	}
	
	func loadStartPageAction() -> UIAlertAction {
		return UIAlertAction(title: "Load Start Page", style: .default, handler: { (alert: UIAlertAction!) -> Void in
			self.loadStartPage()
		})
	}
	
	func is3dTouchAvailable(traitCollection: UITraitCollection) -> Bool {
		return traitCollection.forceTouchCapability == UIForceTouchCapability.available
		
	}
	
	
	//	@IBAction func backButton(_ sender: UIBarButtonItem) {
	//		self.webView.goBack()
	//	}
	//	@IBAction func forwardButton(_ sender: UIBarButtonItem) {
	//		self.webView.goForward()
	//	}
	
	@IBAction func shareButton(_ sender: UIBarButtonItem) {
		//		let message = "Message goes here"
		if let link = NSURL(string: self.searchBar.text!) {
			let objectsToShare = [link] as [Any]
			let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
			activityVC.excludedActivityTypes = []
			self.present(activityVC, animated: true, completion: nil)
		}
	}
	
	
	
	
	//	@IBAction func openTabs(_ sender: Any) {
	//
	//		//TODO: - !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	////		var snapshot = webView.snapshotView(afterScreenUpdates: true)
	////		snapshot?.frame = webView.frame //???
	////
	////		self.snapshots.append(snapshot!)
	//////		self.view.addSubview(snapshot!)
	////		self.webView.stopLoading()
	////		self.webView.backgroundColor = UIColor.black
	////		self.webView.removeFromSuperview()
	////
	////		if isGalleryOpen {
	////			for subview in view.subviews {
	////				guard let snapshotView = subview as? SnapshotCard else {
	////					continue
	////				}
	////				webView.scrollView
	////			}
	////		}
	//
	//
	//		if isGalleryOpen {
	//			for subview in view.subviews {
	//				guard let image = subview as? ImageViewCard else {
	//					continue
	//				}
	//				let animation = CABasicAnimation(keyPath: "transform")
	//				animation.fromValue = NSValue(caTransform3D: image.layer.transform)
	//				animation.toValue = NSValue(caTransform3D: CATransform3DIdentity)
	//				animation.duration = 0.33
	//
	//				image.layer.add(animation, forKey: nil)
	//				image.layer.transform = CATransform3DIdentity
	//			}
	//			isGalleryOpen = false
	//			return
	//		}
	//
	//		var imageYOffset: CGFloat = 50.0
	//
	//		for subview in view.subviews {
	//			guard let image = subview as? ImageViewCard else {
	//				continue
	//			}
	//			//
	//			var imageTransform = CATransform3DIdentity
	//			//1
	//			imageTransform = CATransform3DTranslate(imageTransform, 0.0, imageYOffset, 0.0)
	//			//2
	//			imageTransform = CATransform3DScale(imageTransform, 0.95, 0.6, 1.0)
	//			//3
	//			imageTransform = CATransform3DRotate(imageTransform, .pi/8, -1.0, 0.0, 0.0)
	//
	//			let animation = CABasicAnimation(keyPath: "transform")
	//			animation.fromValue = NSValue(caTransform3D: image.layer.transform)
	//			animation.toValue = NSValue(caTransform3D: imageTransform)
	//			animation.duration = 0.33
	//			image.layer.add(animation, forKey: nil)
	//
	//			image.layer.transform = imageTransform
	//
	//			imageYOffset += view.frame.height / CGFloat(images.count)
	//
	//		}
	//		isGalleryOpen = true
	//
	//		// ------------------------------------------------------------------
	//
	////		var imageYOffset: CGFloat = 50.0
	////		self.webView.stopLoading()
	////		self.webView.removeFromSuperview()
	////		self.view.addSubview(snapshot!)
	////		for subview in view.subviews {
	////			var imageTransform = CATransform3DIdentity
	////			imageTransform = CATransform3DTranslate(imageTransform, 0.0, imageYOffset, 0.0)
	////			imageTransform = CATransform3DScale(imageTransform, 0.95, 0.6, 1.0)
	////			imageTransform = CATransform3DRotate(imageTransform, .pi/8, -1.0, 0.0, 0.0)
	////			let animation = CABasicAnimation(keyPath: "transform")
	////			animation.fromValue = NSValue(caTransform3D: subview.layer.transform)
	////			animation.toValue = NSValue(caTransform3D: imageTransform)
	////			animation.duration = 0.33
	////			subview.layer.add(animation, forKey: nil)
	////			subview.layer.transform = imageTransform
	////			imageYOffset += view.frame.height / CGFloat(snapshots.count)
	////		}
	////		isGalleryOpen = true
	////		if isGalleryOpen {
	////			print("gallery is open")
	////		}
	//
	//		//		if isGalleryOpen {
	//		//			for subview in view.subviews {
	//		//				guard let image = subview as? CustomWebView else {
	//		//					continue
	//		//				}
	//		//				let animation = CABasicAnimation(keyPath: "transform")
	//		//				animation.fromValue = NSValue(caTransform3D: image.layer.transform)
	//		//				animation.toValue = NSValue(caTransform3D: CATransform3DIdentity)
	//		//				animation.duration = 0.33
	//		//			}
	//		//			isGalleryOpen = false
	//		//			return
	//		//		}
	//		//
	//		//		var imageYOffset: CGFloat = 50.0
	//		//
	//		//		for subview in view.subviews {
	//		//			guard let webV = subview as? CustomWebView else {
	//		//				continue
	//		//			}
	//		//			var imageTransform = CATransform3DIdentity
	//		//			//1
	//		//			imageTransform = CATransform3DTranslate(imageTransform, 0.0, imageYOffset, 0.0)
	//		//			//2
	//		//			imageTransform = CATransform3DScale(imageTransform, 0.95, 0.6, 1.0)
	//		//			//3
	//		//			imageTransform = CATransform3DRotate(imageTransform, .pi/8, -1.0, 0.0, 0.0)
	//		//
	//		//			let animation = CABasicAnimation(keyPath: "transform")
	//		//			animation.fromValue = NSValue(caTransform3D: webV.layer.transform)
	//		//			animation.toValue = NSValue(caTransform3D: imageTransform)
	//		//			animation.duration = 0.33
	//		//			webV.layer.transform = imageTransform
	//		//
	//		//			imageYOffset += view.frame.height / CGFloat(customWebViews.count)
	//		//
	//		//		}
	//		//		isGalleryOpen = true
	//
	//	}
	
}

//MARK: - ScrollView Delegate
extension MainVC: UIScrollViewDelegate {
	/// 웹뷰를 스크롤 할 때 상위의 navigation bar (search bar) 와 하단의 toolbar 가 위 아래로 사라지기 위해 사용
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		
		if(velocity.y>0) {
			//Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
			UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
				self.navigationController?.setNavigationBarHidden(true, animated: true)
				self.navigationController?.setToolbarHidden(true, animated: true)
				//				self.navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
				//				self.navigationController?.toolbar.isHidden = true
				
				print("Hide")
			}, completion: nil)
			
		} else {
			UIView.animate(withDuration: 0.1, delay: 0, options: UIView.AnimationOptions(), animations: {
				self.navigationController?.setNavigationBarHidden(false, animated: true)
				self.navigationController?.setToolbarHidden(false, animated: true)
				print("Unhide")
			}, completion: nil)
		}
	}
	
}

//MARK: - UIToolBar Delegate
extension MainVC: UIToolbarDelegate {
	func position(for bar: UIBarPositioning) -> UIBarPosition {
		return UIBarPosition.bottom
	}
}

//MARK: - UISearchResultsUpdating
extension MainVC: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		print("updateSearchResults")
		searchBar = searchController.searchBar
		//		searchWebSite(urlString: searchBar.text!)
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		//		self.searchBar.showsCancelButton = true
		
		//// Search protocol????
		//		var urlstring = "search keyword"
		//
		//		if urlstring.hasPrefix("http://") {
		//			if let url = URL(string: urlstring) {
		//				if UIApplication.shared.canOpenURL(url) {
		//
		//				}
		//			}
		//		} else if urlstring.hasPrefix("https://") {
		//			if let url = URL(string: urlstring) {
		//				if UIApplication.shared.canOpenURL(url) {
		//
		//				}
		//			}
		//		} else {
		//			urlstring.insert("http://", at: 0)
		//
		//			if let url = URL(string: urlstring) {
		//				if UIApplication.shared.canOpenURL(url) {
		//
		//				} else {
		//					//정상적인 url이 아니다.
		//				}
		//			} else {
		//				//정상적인 url이 아니다.
		//			}
		//
		//		}
		
		guard var urlString = searchBar.text?.lowercased() else {
			return
		}
		if !urlString.contains("://") {
			if urlString.contains("localhost") || urlString.contains("127.0.0.1") {
				urlString = "http://" + urlString
			} else {
				urlString = "https://" + urlString
			}
		}
		//		if !urlString.contains(".com") {
		//			urlString.append(contentsOf: ".com")
		//		}
		
		if webView.url?.absoluteString == urlString {
			return
		}
		
		if let targetUrl = URL(string: urlString) {
			webView.load(URLRequest(url: targetUrl))
		}
		
		
	}
	
	func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
		searchBar.endEditing(true)
		searchBar.resignFirstResponder()
		return true
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBarTextDidEndEditing(searchBar)
		self.searchBar.resignFirstResponder()
	}
	
}

//MARK: - UISearchBarDelegate
extension MainVC: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		print("textDidChange")
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.endEditing(true)
		searchBar.resignFirstResponder()
		resignFirstResponder()
		hideKeyboardWhenTappedAround()
	}
	
	func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
		print("bookmark button clicked")
		self.webView.reload()
		
	}

}

//MARK: - WKNavigationDelegate
extension MainVC: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		print("didStartProvisionalNavigation")
	}
	
	func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
		print("didCommit")
		if let url = webView.url {
			if url.scheme != "file" {
				if let urlString = webView.url?.absoluteString {
					UserDefaults.standard.set(urlString, forKey: "LastCommittedURLString")
					searchBar.text = urlString
				}
			} else {
				UserDefaults.standard.removeObject(forKey: "LastCommittedURLString")
				searchBar.text = url.lastPathComponent
			}
		}
		currentContentMode = navigation.effectiveContentMode
	}
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		print("didFinish")
		
		let backForwardList = self.webView.backForwardList.self
		guard let currentItemUrl = backForwardList.currentItem?.url else { return }
		guard let currentItemInitialUrl = backForwardList.currentItem?.initialURL else { return }
		guard let currentItemTitle = backForwardList.currentItem?.title else { return }
		guard let currentItemUrlString = backForwardList.currentItem?.url.absoluteString else { return }
		let now = Date()
		
		let historyDataInstance = HistoryData(url: currentItemUrl, initialUrl: currentItemInitialUrl, title: currentItemTitle, urlString: currentItemUrlString, date: now)
		
		UserDefaultsManager.shared.insertCurrentPage(historyData: historyDataInstance)
		
		//NotificationGroup.shared.post(type: .historyDataInstance, userInfo: ["historyDataInstance": historyDataInstance])
	}
	
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
		if let hostName = navigationAction.request.url?.host {
			if let preferredContentMode = contentModeToRequestForHost[hostName] {
				preferences.preferredContentMode = preferredContentMode
			}
		} else if navigationAction.request.url?.scheme == "file" {
			if let preferredContentMode = contentModeToRequestForHost[hostNameForLocalFile] {
				preferences.preferredContentMode = preferredContentMode
			}
		}
		decisionHandler(.allow, preferences)
	}
	
	
}

//// To hide the keyboard when clicking around??
extension UIViewController {
	
	func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard(_:)))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	@objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
		view.endEditing(true)
		
		if let nav = self.navigationController {
			nav.view.endEditing(true)
		}
	}
}

