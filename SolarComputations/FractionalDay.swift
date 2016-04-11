//
//  FractionalDay.swift
//  
//
//  Created by Gudbrand Tandberg on 26/09/15.
//
//

import Foundation

let degreesPerHour = 360.0 / 24.0
let degreesPerMinute = 360.0 / (24.0 * 60)
let degreesPerSecond = 360.0 / (24.0 * 60 * 60)

public struct FractionalDay {
	
	var fractionalValue  : Double = 0.0
	
	var hours : Int = 0
	var minutes : Int = 0
	var seconds: Int = 0
	
	init() {}
	
	init(fractionalValue : Double) {
		self.fractionalValue = fractionalValue
		self.hours = Int(floor(self.fractionalValue))
		self.minutes = Int(floor((fractionalValue % 1) * 60.0))
		self.seconds = Int(floor(((fractionalValue % 1) * 60.0) % 1))
	}
	
	init(hours: Int, minutes: Int, seconds: Int) {
		self.hours = hours
		self.minutes = minutes
		self.seconds = seconds
		self.fractionalValue = Double(hours) * degreesPerHour + Double(minutes) * degreesPerMinute + Double(seconds) * degreesPerSecond
		
	}
}