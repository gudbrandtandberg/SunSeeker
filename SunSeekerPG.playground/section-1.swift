import UIKit
import Foundation
import SolarComputations
import CoreLocation

///////////////////////// TESTS /////////////////////////////////

//let bangkokLocation : CLLocation = CLLocation(latitude: 13.7391169, longitude: 100.55409510000004)
//let yangonLocation : CLLocation = CLLocation(latitude: 16.8, longitude: 96.15)
//let netherlandsLocation = CLLocation(latitude: 52.0, longitude: 5.0)
//let osloLocation = CLLocation(latitude: 59.95, longitude: 10.75)
//let tromsoLocation = CLLocation(latitude: 69.6828, longitude: 18.9428)
//
//let dateFormatter = NSDateFormatter()
//dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss"
//
//let now = JulianDate(date: NSDate())
//let christmas = JulianDate(date: NSDate().dateByAddingTimeInterval(60*60*24*30*3))
//let apr2004 = JulianDate(date: dateFormatter.dateFromString("1 Apr 2004 19:00:00")!)
//
//
//let posCalculator = SunLocationCalculator(location: yangonLocation, julianDate: now)
//
//
//let (A, h) = posCalculator.getSunPosition()
//let (R, S) = posCalculator.getRiseSetTimes()

//let sunriseString = dateFormatter.stringFromDate(R)
//let sunsetString = dateFormatter.stringFromDate(S)

//println("The position of the sun is \(A.degrees + 180) degrees E, \(-h.degrees) degrees N")
//println("The sun rises at \(sunriseString), and sets at \(sunsetString)")


// (0 180) -> (y, y + h)
//
// (-180, 180) -> (x, x + w)   //x

// formula
//	(a, b) to (d, c)
//	f(x) = (x-a)/(b-a) * c + (x-b)/(a-b) * d

// (value - a)*(d-c)/(b-c) + c


func mapFromabTocd(val : CGFloat, a : CGFloat, b: CGFloat, c : CGFloat, d : CGFloat) -> CGFloat {
	
//	(val - A)*(b-a)/(B-A) + a
//  val - a) * (d-c)/(b-a) + c
	return (val-a)*(d-c)/(b-a) + c
	
}



func gmap(point : CGPoint, #fromRect : CGRect, #toRect : CGRect) -> CGPoint {
	
	var x : CGFloat = mapFromabTocd(point.x, fromRect.origin.x, fromRect.origin.x + fromRect.size.width, toRect.origin.x, toRect.origin.x + toRect.size.width)
	
	var y = mapFromabTocd(point.y, fromRect.origin.y, fromRect.origin.y + fromRect.size.height, toRect.origin.y, toRect.origin.y + toRect.size.height)
	
	return CGPointMake(x, y);
}

let rect = CGRectMake(-180, -45, 360, 90)
let otherRect = CGRectMake(16, 97, 568, 379)

mapFromabTocd(45, 45, 135, 16, 16 + 379)

gmap(CGPointMake(0, 0), fromRect: rect, toRect: otherRect)






