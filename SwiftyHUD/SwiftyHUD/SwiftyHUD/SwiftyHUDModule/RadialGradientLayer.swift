//
//  RadialGradientLayet.swift
//  SVProgressHUD
//
//  Created by Paul Fechner on 12/26/15.
//  Copyright © 2015 EmbeddedSources. All rights reserved.
//

import UIKit

let locations: [CGFloat] = [0.0, 1.0]
let colors: [CGFloat] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.75];
let gradient = CGGradientCreateWithColorComponents(CGColorSpaceCreateDeviceRGB(), colors, locations, locations.count);

class RadialGradientLayer: CALayer {

	var gradientCenter: CGPoint

	init(gradientCenter: CGPoint){
		self.gradientCenter = gradientCenter
		super.init()
	}

	convenience init(gradientCenter: CGPoint, frame: CGRect, needsDisplay: Bool){
		self.init(gradientCenter: gradientCenter)

		self.frame = frame

		if needsDisplay {
			setNeedsDisplay()
		}
	}

	required init?(coder aDecoder: NSCoder) {
		gradientCenter = CGPoint();
		super.init(coder: aDecoder)
	}

	override func drawInContext(context: CGContextRef) {

		let radius =  min(self.bounds.size.width , self.bounds.size.height)
		CGContextDrawRadialGradient (context, gradient, self.gradientCenter, 0, self.gradientCenter, radius, .DrawsAfterEndLocation)
	}

}
