//
//  InfoPaneView.swift
//  SunSeekerApp
//
//  Created by Gudbrand Tandberg on 13/04/16.
//  Copyright (c) 2016 Duff Development. All rights reserved.
//

import UIKit

let FONTSIZE :CGFloat = 18.0
let BORDERWIDTH : CGFloat = 3.0
let PADDING : CGFloat = 3
let IPANE_WIDTH : CGFloat = 120.0
let IPANE_HEIGHT : CGFloat = 65.0

class InfoPaneView: UIView {

	var positionLabel: UILabel
	
	override init(frame: CGRect) {
		
		
		positionLabel = UILabel(frame: CGRectMake(frame.origin.x + BORDERWIDTH + PADDING, frame.origin.y + BORDERWIDTH, frame.size.width - 2*BORDERWIDTH - 2*PADDING, frame.size.height -  2 * BORDERWIDTH))
		positionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping // or NSLineBreakMode.ByWordWrapping
		positionLabel.numberOfLines = 0
		positionLabel.font = UIFont(name: "Helvetida", size: FONTSIZE)
		positionLabel.textColor = UIColor.whiteColor()
		positionLabel.textAlignment = NSTextAlignment.Center

		
		super.init(frame: frame)
		
		backgroundColor = UIColor(red: 0.0, green: 153.0/255, blue: 204.0/255, alpha: 1.0)
		
		layer.borderColor = UIColor.whiteColor().CGColor
		layer.borderWidth = BORDERWIDTH
		
		layer.zPosition = 0.6
		
		self.addSubview(positionLabel as UIView)		
		
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
