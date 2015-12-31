////
////  IndefiniteAnimatedView.swift
////  SVProgressHUD
////
////  Created by Paul Fechner on 12/26/15.
////  Copyright © 2015 EmbeddedSources. All rights reserved.
////
//
//let animationDuration = 1.0
//
//let linearCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
//
//let animations = [CABasicAnimation(keyPath: "strokeStart", fromValue: 0.015, toValue: 0.515),
//	CABasicAnimation(keyPath: "strokeStart", fromValue: 0.485, toValue: 0.985)]
//
//let animationGroup = CAAnimationGroup(duration: animationDuration, repeatCount: Float.infinity, removedOnCompletion: false, timingFunction: linearCurve,
//	animations: animations)
//
//
//class IndefiniteAnimatedView: UIView {
//
//	private var indefiniteAnimatedLayer: CAShapeLayer?
//
//	override var frame: CGRect {
//		didSet {
//			if(!CGRectEqualToRect(frame, oldValue)){
//				layoutIfSuperviewExists()
//	}
//		}
//	}
//
//	var strokeThickness: CGFloat? {
//		didSet {
//			if let _ = indefiniteAnimatedLayer, thickness = strokeThickness{
//				indefiniteAnimatedLayer!.lineWidth = thickness;
//			}
//		}
//	}
//
//	var radius: CGFloat?{
//		didSet{
//			if(radius != oldValue){
//				resetIndefiniteAnimatedLayerIfExists()
//			}
//		}
//	}
//
//	var strokeColor: UIColor? {
//		didSet{
//			if let _ = indefiniteAnimatedLayer, color = strokeColor {
//				indefiniteAnimatedLayer!.strokeColor = color.CGColor;
//			}
//		}
//	}
//
//	var animatedLayer: CAShapeLayer? {
//		get{
//			if let layer = indefiniteAnimatedLayer {
//				return layer
//			}
//			else{
//				return getLayer()
//			}
//		}
//	}
//
//	required init?(coder aDecoder: NSCoder) {
//		super.init(coder: aDecoder)
//	}
//
//	override init(frame: CGRect) {
//		super.init(frame: frame)
//	}
//
//	override func willMoveToSuperview(newSuperview: UIView?) {
//
//		if let _ = newSuperview {
//			layoutAnimatedLayer()
//		}
//		else if let animatedLayer = indefiniteAnimatedLayer{
//			animatedLayer.removeFromSuperlayer()
//			indefiniteAnimatedLayer = nil
//		}
//	}
//
//	override func sizeThatFits(size: CGSize) -> CGSize {
//		if let thickness = self.strokeThickness, rad = self.radius {
//			return CGSizeMake((rad + thickness / 2 + 5) * 2, (rad + thickness / 2 + 5) * 2);
//		}
//
//		return CGSize()
//	}
//
//	func resetIndefiniteAnimatedLayerIfExists(){
//
//		if let layer = indefiniteAnimatedLayer {
//			layer.removeFromSuperlayer()
//			indefiniteAnimatedLayer = nil
//
//			layoutIfSuperviewExists()
//		}
//	}
//
//	func layoutIfSuperviewExists(){
//		if let _ = superview {
//			self.layoutAnimatedLayer()
//		}
//	}
//
//	func layoutAnimatedLayer() {
//
//		if let animationLayer = indefiniteAnimatedLayer {
//			self.layer.addSublayer(animationLayer)
//
//			let widthDiff  = CGRectGetWidth(self.bounds) - CGRectGetWidth(layer.bounds)
//			let heightDiff = CGRectGetHeight(self.bounds) - CGRectGetHeight(layer.bounds)
//			animationLayer.position = CGPointMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(layer.bounds) / 2 - widthDiff / 2, CGRectGetHeight(self.bounds) - CGRectGetHeight(layer.bounds) / 2 - heightDiff / 2)
//		}
//	}
//
//	func getLayer() -> CAShapeLayer? {
//
//		if let (center, rad) = getArcCenter(), thickness = self.strokeThickness, color = strokeColor{
//
//			let smoothedPath = getSmoothedPath(center, rad: rad)
//			let rect = CGRectMake(0.0, 0.0, center.x * 2, center.y * 2)
//
//			let maskLayer = CALayer(contents: (UIImage(contentsOfFile: getImagePath()!)?.CGImage)!, frame: (indefiniteAnimatedLayer?.bounds)!)
//
//			indefiniteAnimatedLayer = CAShapeLayer(contentsScale: UIScreen.mainScreen().scale, frame: rect, fillColor: UIColor.clearColor().CGColor, strokeColor: color.CGColor, lineWidth: thickness, lineCap: kCALineCapRound, lineJoin: kCALineJoinBevel, path: smoothedPath.CGPath, mask: maskLayer)
//
//			let animation = CABasicAnimation(keyPath: "transform.rotation", fromValue: 0, toValue: M_PI * 2, duration: animationDuration, timingFunction: linearCurve, removedOnCompletion: false, repeatCount: Float.infinity, fillMode: kCAFillModeForwards, autoreverses: false)
//
//			indefiniteAnimatedLayer?.mask?.addAnimation(animation, forKey: "rotate")
//
//			indefiniteAnimatedLayer?.addAnimation(animationGroup, forKey: "progress")
//		}
//
//		return indefiniteAnimatedLayer
//	}
//
//	func getImagePath() -> String? {
//
//		let bundle = NSBundle(forClass: self.classForCoder)
//		let url = bundle.URLForResource("SVProgressHUD", withExtension: "bundle")
//		let imageBundle = NSBundle(URL: url!)
//		return imageBundle?.pathForResource("angle-mask", ofType: "png")
//	}
//
//	func getSmoothedPath(arcCenter: CGPoint, rad: CGFloat) -> UIBezierPath {
//
//		return UIBezierPath( arcCenter: arcCenter, radius: rad, startAngle: CGFloat(M_PI * 3 / 2), endAngle: CGFloat(M_PI / 2 + M_PI * 5), clockwise: true)
//
//	}
//
//	func getArcCenter() -> (CGPoint, CGFloat)? {
//
//		if let rad = self.radius, thickness = self.strokeThickness{
//			return (CGPointMake(rad + thickness / 2 + 5, rad + thickness / 2 + 5), rad)
//		}
//		else{
//			return nil
//		}
//	}
//
//	func refresh(radius: CGFloat, strokeThickness: CGFloat){
//		self.radius = radius
//		self.strokeThickness = strokeThickness
//		self.sizeToFit()
//	}
//}
//
//
//
//
//
