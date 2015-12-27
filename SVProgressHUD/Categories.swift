//
//  Categories.swift
//  SVProgressHUD
//
//  Created by Paul Fechner on 12/26/15.
//  Copyright © 2015 EmbeddedSources. All rights reserved.
//

extension CABasicAnimation {

	convenience init(keyPath: String, fromValue: AnyObject, toValue: AnyObject) {
		self.init(keyPath: keyPath)
		self.fromValue = fromValue
		self.toValue = toValue
	}

	convenience init(keyPath: String, fromValue: AnyObject, toValue: AnyObject, duration: Double, timingFunction: CAMediaTimingFunction, removedOnCompletion: Bool, repeatCount: Float, fillMode: String, autoreverses: Bool){

		self.init(keyPath: keyPath, fromValue: fromValue, toValue: toValue)
		self.duration = duration
		self.timingFunction = timingFunction
		self.removedOnCompletion = removedOnCompletion
		self.repeatCount = repeatCount
		self.fillMode = fillMode
		self.autoreverses = autoreverses;
	}
}

extension CAAnimationGroup {

	convenience init(duration: Double, repeatCount: Float, removedOnCompletion: Bool, timingFunction: CAMediaTimingFunction, animations: [CABasicAnimation]){

		self.init()

		self.duration = duration
		self.repeatCount = repeatCount
		self.removedOnCompletion = removedOnCompletion
		self.timingFunction = timingFunction
		self.animations = animations
	}
}

extension CAShapeLayer {

	convenience init(contentsScale: CGFloat, frame: CGRect, fillColor: CGColor, strokeColor: CGColor, lineWidth: CGFloat, lineCap: String, lineJoin: String, path: CGPath, mask: CALayer){
		self.init()

		self.contentsScale = contentsScale
		self.frame = frame
		self.fillColor = fillColor
		self.strokeColor = strokeColor
		self.lineWidth = lineWidth
		self.lineCap = lineCap
		self.lineJoin = lineJoin;
		self.path = path
		self.mask = mask
	}
}

extension CALayer {
	
	convenience init(contents: CGImage, frame: CGRect){

		self.init()
		self.contents = contents
		self.frame = frame
	}
}







