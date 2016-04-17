//
//  SSDatePicker.swift
//  SunSeekerApp
//
//  Created by Gudbrand Tandberg on 16/04/16.
//  Copyright (c) 2016 Duff Development. All rights reserved.
//

import UIKit

class SSDatePicker: UIDatePicker {
	var changed = false
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.layer.zPosition = 1000
	}
	
	override func addSubview(view: UIView) {
		if !changed {
			changed = true
			self.setValue(UIColor.yellowColor(), forKey: "textColor")
		}
		super.addSubview(view)
	}
}
