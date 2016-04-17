//
//  ViewController.swift
//  SunSeekerApp
//
//  Created by Gudbrand Tandberg on 09/04/16.
//  Copyright (c) 2016 Duff Development. All rights reserved.
//

import UIKit
import CoreLocation

enum DatePickState {
	
	case pressToPick, pressToSet
	
	mutating func next() {
		switch self {
		case .pressToPick:
			self = .pressToSet
			break;
		case .pressToSet:
			self = .pressToPick
		}
	}
}


let SUNSIZE : CGFloat = 70.0
let SIDEBUFFER : CGFloat = 30
let TOPBUFFER : CGFloat = 30
let DATEPICKERTAG = 0
let TIMEPICKERTAG = 1

/*
* Beautifuly displays the trajectory and position of the sun for a given day
* 
*
*/

class SolarDayViewController: UIViewController, UIGestureRecognizerDelegate, UIPickerViewDelegate {

	@IBOutlet weak var dateTitleLabel: UILabel!
	@IBOutlet weak var sunSpaceView: UIView!
	@IBOutlet weak var grassView: UIView!
	
	@IBOutlet weak var theDatePicker: SSDatePicker!
	
	@IBOutlet weak var mainButton: UIButton!
	
	let sunView = UIImageView(image: UIImage(named: "sun.png"))
	let yellow = UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0)
	let infoPane: InfoPaneView
	let spc : SunCalculator
	var sunTrajectory = SunTrajectory()
	var dpState = DatePickState.pressToPick
	
	let dateFormatter : NSDateFormatter = NSDateFormatter()
	
	var dateToDisplay : NSDate = NSDate() {
		willSet(newValue) {
		}
		didSet (newValue) {
			dateTitleLabel.text = dateFormatter.stringFromDate(newValue)
		}
	}

	var xPositionOfSun : CGFloat = 0.0 {
		willSet(newValue) {
//			moveSun(newValue)
		}
		didSet (newValue){
			moveSun(newValue)
		}
	}
	
	required init(coder aDecoder: NSCoder) {
		
		dateFormatter.dateStyle = .MediumStyle
		dateFormatter.timeStyle = .MediumStyle
		dateFormatter.locale = NSLocale.currentLocale()

		infoPane = InfoPaneView(frame: CGRectMake(0, 0, IPANE_WIDTH, IPANE_HEIGHT))
		
		let kampotLocation = CLLocation(latitude: 10.7412, longitude: 104.1931)
		
		spc = SunCalculator(location: kampotLocation, julianDate: JulianDate(date: dateToDisplay))
		
		super.init(coder: aDecoder)
		
		
		//trenger SolarComputer objekt:
		

		
		
		
		//fill pl and t array with points from sunrise to sunset with preset granularity
		
		//pl = spc.trajectories[0].positions //points = [(x1, y1), (x2, y2), ... (xn, yn)] [CGPoint]
		//t = spc.times //t = [t1, t2, ..., tn] [NSDate]
		
		//spc should also have properties nowPos : CGPoint and nowTime : NSDate
	
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		dateTitleLabel.text = dateFormatter.stringFromDate(dateToDisplay) //simpler
	
		//cofigure pickers
		
		
		
		view.addSubview(infoPane)
	}
	
	//	LÆREPENGE:
	//	You should not initialise UI geometry-related things in viewDidLoad,
	//	because the geometry of your view is not set at this point and the results will be unpredictable
	
	override func viewDidLayoutSubviews() {
		
		sunTrajectory =  mapTrajectory(spc.trajectories[0],
			fromRect: spc.coordinateRect,
			toRect: sunSpaceView.frame)
		
		fadeOutDatePicker()
		
		//only if path exists!
		drawPath()
//		sunView.center = pl[0] //pl[t_now]!
		sunView.frame.size = CGSizeMake(SUNSIZE, SUNSIZE)
		
		grassView.layer.zPosition = 2
		sunSpaceView.layer.zPosition = 0
		sunView.layer.zPosition = 1
		
		xPositionOfSun = sunTrajectory[0].p.x
		
		self.view.addSubview(sunView)

	}
	
	func drawPath() {
		
		let l = CAShapeLayer() //perhaps should be var
		l.path = sunTrajectory.bezierPath.CGPath
		l.fillColor = UIColor.clearColor().CGColor
		l.strokeColor = yellow.CGColor
		l.lineWidth = 7.0
		l.lineCap = kCALineCapRound
		l.zPosition = 0.5
		
		self.view.layer.addSublayer(l)

	}
	
	func flipY(point : CGPoint, axisHeight: CGFloat) -> CGPoint {
		//flips y-coordinate from (0, axisHeight) to (axisHeight, 0)
		return CGPointMake(point.x, axisHeight - point.y)
	}
	
	func mapTrajectory(trajectory : SunTrajectory, fromRect : CGRect, toRect : CGRect) -> SunTrajectory {
		
		var mappedTrajectory = SunTrajectory()
		
		var pl = [CGPoint]()
		var t = [CGFloat]()
		
		var i : Int
		
		for i in 1...trajectory.count {
			mappedTrajectory.addSpaceTimePoint(trajectory.times[i-1], p: gmap(flipY(trajectory.points[i-1], axisHeight: fromRect.size.height), fromRect: fromRect, toRect: toRect))
		}
		
		return mappedTrajectory
	}
	
	func mapFromabTocd(val : CGFloat, a : CGFloat, b: CGFloat, c : CGFloat, d : CGFloat) -> CGFloat {
		return (val-a)*(d-c)/(b-a) + c
		
	}
	
	func gmap(point : CGPoint, fromRect : CGRect, toRect : CGRect) -> CGPoint {
		
		var x : CGFloat = mapFromabTocd(point.x, a: fromRect.origin.x, b: fromRect.origin.x + fromRect.size.width, c: toRect.origin.x, d: toRect.origin.x + toRect.size.width)
		
		var y = mapFromabTocd(point.y, a: fromRect.origin.y, b: fromRect.origin.y + fromRect.size.height, c: toRect.origin.y, d: toRect.origin.y + toRect.size.height)
		
		return CGPointMake(x, y);
	}
	
	func moveSun(toXValue : CGFloat) {
		
		var (nearestPoint, ind) = sunTrajectory.getNearestPointByX(toXValue)
		
		sunView.center = nearestPoint.p
		
		infoPane.center = CGPointMake(nearestPoint.p.x, nearestPoint.p.y - IPANE_HEIGHT / 1.33)
		
		let x = String(format: "%.1f", Float(spc.trajectories[0][ind].p.x ))
		let y = String(format: "%.1f", Float(spc.trajectories[0][ind].p.y))
		
		infoPane.positionLabel.text = "Alt. " + y + "\u{B0}N \nAz. " + x + "\u{B0}E"
		
		dateTitleLabel.text = dateFormatter.stringFromDate(nearestPoint.t.date)
		//dateToDisplay = nearestPoint.t.date //does not work! property observers...
	
	}

	@IBAction func didPressMainButton(sender: UIButton) {
		
		switch dpState {
			case .pressToPick:
				fadeInDatePicker()
			case .pressToSet:
				dateToDisplay = theDatePicker.date
			fadeOutDatePicker()
		}
		dpState.next()
		
	}

	func fadeOutDatePicker() {
		theDatePicker.layer.opacity = 0.0
		dateTitleLabel.layer.opacity = 1.0
	}
	func fadeInDatePicker() {
		theDatePicker.layer.opacity = 1.0
		dateTitleLabel.layer.opacity = 0.0
	}
	
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		for touch in touches {
			
			//should check point
			
			//insta-move the sun to touch
			let point = touch.locationInView(self.view)
			xPositionOfSun = point.x
		}
	}
	
	@IBAction func pan(sender: UIPanGestureRecognizer!) {
		let touch = sender.locationInView(self.view)
		xPositionOfSun = touch.x
		
	}
	
	//#pragma mark PickerView functions
	

	
}

