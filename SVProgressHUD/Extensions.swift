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

extension UIView {

	convenience init(frame: CGRect, layerCornerRadius: CGFloat, layerMasksToBounds: Bool, autoresizingMask: UIViewAutoresizing) {

		self.init(frame: frame)
		self.layer.cornerRadius = layerCornerRadius
		self.layer.masksToBounds = layerMasksToBounds
		self.autoresizingMask = autoresizingMask

		class func fromNib<T : UIView>(nibNameOrNil: String? = nil) -> T {
			let v: T? = fromNib(nibNameOrNil)
			return v!
		}

		class func fromNib<T : UIView>(nibNameOrNil: String? = nil) -> T? {
			var view: T?
			let name: String
			if let nibName = nibNameOrNil {
				name = nibName
			} else {
				// Most nibs are demangled by practice, if not, just declare string explicitly
				name = "\(T.self)".componentsSeparatedByString(".").last!
			}
			let nibViews = NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil)
			for v in nibViews {
				if let tog = v as? T {
					view = tog
				}
			}
			return view
		}
	}

	func addBlurEffect(addVibrancy: Bool, blurStyle: UIBlurEffectStyle){

			let blurEffect = UIBlurEffect(style: blurStyle)

			let blurEffectView = UIVisualEffectView(effect: blurEffect)
			blurEffectView.autoresizingMask = self.autoresizingMask
			blurEffectView.frame = self.bounds
			if(addVibrancy){
				addVibrancyEffect(blurEffectView, blurEffect: blurEffect)
			}
			self.addSubview(blurEffectView)
	}

	func addVibrancyEffect(view: UIVisualEffectView?, blurEffect: UIBlurEffect) {

		if let view = view {

			let vibrancyEffectView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: blurEffect))
			vibrancyEffectView.autoresizingMask = view.autoresizingMask
			vibrancyEffectView.bounds = view.bounds
			view.contentView.addSubview(vibrancyEffectView)
		}
	}
}

extension UILabel {

	convenience init(frame: CGRect, backgroundColor: UIColor, adjustsFontSizeToFitWidth: Bool, textAlignment: NSTextAlignment, baselineAdjustment: UIBaselineAdjustment, numberOfLines: Int){

		self.init(frame: frame)
		self.backgroundColor = backgroundColor
		self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
		self.textAlignment = textAlignment
		self.baselineAdjustment = baselineAdjustment
		self.numberOfLines = numberOfLines
	}
}

extension CALayer {

	convenience init(frame: CGRect, backgroundColor: CGColor, needsDisplay: Bool) {

		self.init()
		self.frame = frame
		self.backgroundColor = backgroundColor

		if needsDisplay {
			setNeedsDisplay()
		}
	}
}

extension UIControl {

	convenience init(frame: CGRect, autoResizingMask: UIViewAutoresizing, backgroundColor: UIColor){

		self.init(frame: frame)
		self.autoresizingMask = autoresizingMask
		self.backgroundColor = backgroundColor
	}
}

extension CAShapeLayer {

	convenience init(contentsScale: CGFloat, frame: CGRect, fillColor: CGColor, lineCap: String, lineJoin: String, path: CGPath, strokeEnd: CGFloat){

		self.init()
		self.contentsScale = contentsScale
		self.frame = frame
		self.fillColor = fillColor
		self.lineCap = lineCap
		self.lineJoin = lineJoin
		self.path = path
		self.strokeEnd = strokeEnd
	}
}






