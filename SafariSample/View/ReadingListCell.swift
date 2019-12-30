//
//  ReadingListCell.swift
//  SafariSample
//
//  Created by Nomad on 2019/12/30.
//  Copyright © 2019 Nomad. All rights reserved.
//

import UIKit

class ReadingListCell: UITableViewCell {
	
	@IBOutlet weak var iconImage: UIImageView!
	@IBOutlet weak var iconInitialLetter: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var detailLabel: UILabel!
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
		iconImage.layer.cornerRadius = 5
		iconImage.clipsToBounds = true
		
	}
	
	
	
	func setCellData(_ data: ReadingListData? = nil) {
		if let data = data {
			titleLabel.text = data.title
			detailLabel.text = data.urlString
			iconInitialLetter.text = data.getFirstIconLetter()
		} else {
			titleLabel.text = ""
			detailLabel.text = ""
			iconInitialLetter.text = ""
		}
	}
	
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}
