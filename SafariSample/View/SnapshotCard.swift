//
//  SnapshotCard.swift
//  SafariSample
//
//  Created by Nomad on 2019/11/22.
//  Copyright © 2019 Nomad. All rights reserved.
//

import Foundation
import UIKit

class SnapshotCard: UIView {
	
//	var urlString: String!
	var didSelect: ((SnapshotCard) -> ())?
	
	let closeButton: UIButton!
	let urlLabel: UILabel!
	
	convenience init() {
		self.init()
//		urlLabel.text = urlString
		urlLabel.font = UIFont.systemFont(ofSize: 5)
		
		closeButton.titleLabel?.text = nil
		closeButton.imageView?.image = UIImage(systemName: "xmark")
		let closewidth = closeButton.widthAnchor.constraint(equalToConstant: 10)
		let closeheight = closeButton.heightAnchor.constraint(equalToConstant: 10)
		let closetop = closeButton.topAnchor.constraint(equalTo: topAnchor)
		let closeleft = closeButton.leftAnchor.constraint(equalTo: leftAnchor)
		NSLayoutConstraint.activate([closewidth, closeheight, closetop, closeleft])
		
		urlLabel.leftAnchor.constraint(equalTo: closeButton.rightAnchor).isActive = true
		urlLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
		urlLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		urlLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
		
		autoresizingMask = [.flexibleHeight, .flexibleWidth]
		layer.shouldRasterize = true
		layer.rasterizationScale = UIScreen.main.scale
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
		
	}
	
	override func didMoveToSuperview() {
		isUserInteractionEnabled = true
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHandler(_:))))
	}
	
	@objc func didTapHandler(_ tap: UITapGestureRecognizer) {
		didSelect?(self)
	}
	
}
