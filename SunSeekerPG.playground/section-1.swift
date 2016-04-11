import UIKit
import Foundation
import SolarComputations
import CoreLocation

///////////////////////// TESTS /////////////////////////////////

let bangkokLocation : CLLocation = CLLocation(latitude: 13.7391169, longitude: 100.55409510000004)
let yangonLocation : CLLocation = CLLocation(latitude: 16.8, longitude: 96.15)
let netherlandsLocation = CLLocation(latitude: 52.0, longitude: 5.0)
let osloLocation = CLLocation(latitude: 59.95, longitude: 10.75)
let tromsoLocation = CLLocation(latitude: 69.6828, longitude: 18.9428)

let dateFormatter = NSDateFormatter()
dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss"

let now = JulianDate(date: NSDate())
let christmas = JulianDate(date: NSDate().dateByAddingTimeInterval(60*60*24*30*3))
let apr2004 = JulianDate(date: dateFormatter.dateFromString("1 Apr 2004 19:00:00")!)


let posCalculator = SunLocationCalculator(location: yangonLocation, julianDate: now)


let (A, h) = posCalculator.getSunPosition()
//let (R, S) = posCalculator.getRiseSetTimes()

//let sunriseString = dateFormatter.stringFromDate(R)
//let sunsetString = dateFormatter.stringFromDate(S)

println("The position of the sun is \(A.degrees + 180) degrees E, \(-h.degrees) degrees N")
//println("The sun rises at \(sunriseString), and sets at \(sunsetString)")
