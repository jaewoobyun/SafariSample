//
//  WebViewClass.swift
//  SafariSample
//
//  Created by Nomad on 2019/11/18.
//  Copyright © 2019 Nomad. All rights reserved.
//

import UIKit
import WebKit

class CustomWebView: WKWebView {

//	var title: String!
	var didSelect: ((CustomWebView) -> ())?
	
	convenience init(url: URL, title name: String) {
		self.init()
		
		let request = URLRequest(url: url)
		
		autoresizingMask = [.flexibleHeight, .flexibleWidth]
		layer.shouldRasterize = true
		layer.rasterizationScale = UIScreen.main.scale
		
	}
	
	override func didMoveToSuperview() {
		isUserInteractionEnabled = true
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ImageViewCard.didTapHandler(_:))))

	}
	
	@objc func didTapHandler(_ tap: UITapGestureRecognizer) {
		didSelect?(self)
	}

}
