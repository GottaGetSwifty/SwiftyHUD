//
//  ProgressHUD.swift
//  SVProgressHUD
//
//  Created by Paul Fechner on 12/26/15.
//  Copyright © 2015 EmbeddedSources. All rights reserved.
//

import UIKit

let ProgressHUDDidReceiveTouchEventNotification = "ProgressHUDDidReceiveTouchEventNotification";
let ProgressHUDDidTouchDownInsideNotification = "ProgressHUDDidTouchDownInsideNotification";
let ProgressHUDWillDisappearNotification = "ProgressHUDWillDisappearNotification";
let ProgressHUDDidDisappearNotification = "ProgressHUDDidDisappearNotification";
let ProgressHUDWillAppearNotification = "ProgressHUDWillAppearNotification";
let ProgressHUDDidAppearNotification = "ProgressHUDDidAppearNotification";

let ProgressHUDStatusUserInfoKey = "ProgressHUDStatusUserInfoKey";

let ProgressHUDParallaxDepthPoints: CGFloat = 10;
let ProgressHUDUndefinedProgress: CGFloat = -1;

let url = NSBundle(forClass: ProgressHUD.classForCoder()).URLForResource("SVProgressHUD", withExtension: "bundle")
let imageBundle = NSBundle(URL: url!)

class ProgressHUD: UIView {

	var backgroundLayer: CALayer?

	var progress: CGFloat?
	var activityCount = 0

	var defaultStyle: ProgressHUDStyle = .Light
	var defaultMaskType: ProgressHUDMaskType = .None
	var defaultAnimationType: ProgressHUDAnimationType = .Flat
	var minimumSize = CGSize.zero

	var ringThickeness: CGFloat = 2
	var ringRadius: CGFloat = 18
	var ringNoTextRadius: CGFloat = 24
	var cornerRadius: CGFloat = 14
	var font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)

	var infoImage = UIImage(contentsOfFile: (imageBundle?.pathForResource("info", ofType: "png"))!)!.imageWithRenderingMode(.AlwaysTemplate)
	var successImage = UIImage(contentsOfFile: (imageBundle?.pathForResource("success", ofType: "png"))!)!.imageWithRenderingMode(.AlwaysTemplate)
	var errorImage = UIImage(contentsOfFile: (imageBundle?.pathForResource("error", ofType: "png"))!)!.imageWithRenderingMode(.AlwaysTemplate)
	var viewForExtension: UIView?
	var minimumDismissTimeInterval = NSTimeInterval(5.0)
	var offsetFromCenter = UIOffset(horizontal: 0, vertical: 0)

	var fadeOutTimer: NSTimer? {
		willSet {
			if let fadeOutTimer = fadeOutTimer {
				fadeOutTimer.invalidate()
				self.fadeOutTimer = nil
			}
		}
	}
	var clear: Bool {
		get {
			return (self.defaultMaskType == .Clear || self.defaultMaskType == .None);
		}
	}

	private var realVisibleKeyboardHeight: CGFloat?
	var visibleKeyboardHeight: CGFloat? {
		get {
			if let keyboardWindow = (UIApplication.sharedApplication().windows.filter(){ $0.isKindOfClass(UIWindow.classForCoder()) }.first) {
				return getHeightFromViews(keyboardWindow.subviews)
			}
			else{
				return 0
			}
		}
		set { realVisibleKeyboardHeight = newValue }
	}


	var realHudView: UIView?
	var hudView: UIView? {
		get {
			if (realHudView == nil) {
				realHudView = UIView(frame: CGRectZero, layerCornerRadius: self.cornerRadius, layerMasksToBounds: true,
					autoresizingMask: [.FlexibleBottomMargin, .FlexibleTopMargin, .FlexibleRightMargin, .FlexibleLeftMargin])
			}

			if let realHudView = realHudView {
				realHudView.backgroundColor = self.backgroundColor

				if let _ = realHudView.superview {
					addSubview(realHudView)
				}
			}
			return realHudView
		}
		set { realHudView = newValue }
	}


	private var realStringLabel: UILabel?
	var stringLabel: UILabel? {
		get {
			if (realStringLabel == nil){
				realStringLabel = UILabel(frame: CGRectZero, backgroundColor: UIColor.clearColor(), adjustsFontSizeToFitWidth: true, textAlignment: .Center, baselineAdjustment: .AlignCenters, numberOfLines: 0)
			}

			if let realStringLabel = realStringLabel {
				realStringLabel.textColor = self.foregroundColor
				realStringLabel.font = self.font
				if let _ = realStringLabel.superview {
					hudView?.addSubview(realStringLabel)
				}
			}
			return realStringLabel
		}
		set { realStringLabel = newValue }
	}


	private var realImageView: UIImageView?
	var imageView: UIImageView? {
		get {
			if (realImageView == nil) {
				realImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 28.0, height: 28.0))
			}
			if let realImageView = realImageView {
				if let _ = realImageView.superview{
					self.hudView?.addSubview(realImageView)
				}
			}
			return realImageView
		}
		set { realImageView = newValue }
	}


	private var realOverlayView: UIControl?
	var overlayView: UIControl? {
		get {

			if(realOverlayView == nil){

				let windowBounds = UIApplication.sharedApplication().delegate?.window!?.bounds
				realOverlayView = UIControl(frame: windowBounds!, autoResizingMask: [.FlexibleWidth, .FlexibleHeight], backgroundColor: UIColor.clearColor())
				realOverlayView?.addTarget(self, action: Selector("overlayViewDidReceiveTouchEvent"), forControlEvents: .TouchDown)
			}
			return realOverlayView;
		}
		set { realOverlayView = newValue }
	}


	private var realHudBackgroundColor: UIColor?
	var hudBackgroundColor: UIColor? {
		get {
			switch defaultStyle {
			case .Light:
				return UIColor.whiteColor()
			case .Dark:
				return UIColor.blackColor()
			default:
				return self.realHudBackgroundColor
			}
		}
		set{ realHudBackgroundColor = newValue }
	}


	private var realForegroundColor: UIColor = UIColor.blackColor()
	var foregroundColor: UIColor {
		get {
			switch defaultStyle {
				case .Light:
					return UIColor.blackColor()
				case .Dark:
					return UIColor.whiteColor()
				default:
					return self.realForegroundColor
			}

		}
		set { realForegroundColor = newValue}
	}


	private var realIndefinateAnimatedView : UIView?
	var indefiniteAnimatedView: UIView? {
		get{
			if (realIndefinateAnimatedView == nil) {
				realIndefinateAnimatedView = (defaultAnimationType == .Flat) ? createIndefiniteAnimatedView() : createActivityIndicatorView()
			}
			return realIndefinateAnimatedView
		}
		set { realIndefinateAnimatedView = newValue }
	}


	private var realRingLayer: CAShapeLayer?
	var ringLayer: CAShapeLayer? {
		get {
			if realRingLayer == nil {
				realBackgroundRingLayer = createHudLayer(hudView, radius: ringRadius, strokeEnd: 1)
			}
			if let realRingLayer = realRingLayer {
				updateLayer(realRingLayer, strokeColor: foregroundColor.CGColor, lineWidth: ringThickeness)
			}
			return realRingLayer
		}
		set{ realRingLayer = newValue }
	}


	private var realBackgroundRingLayer: CAShapeLayer?
	var backgroundRingLayer: CAShapeLayer? {
		get{
			if (realBackgroundRingLayer == nil){
				realBackgroundRingLayer = createHudLayer(hudView, radius: ringRadius, strokeEnd: 1)
			}

			if let realBackgroundRingLayer = realBackgroundRingLayer {
				updateLayer(realBackgroundRingLayer, strokeColor: foregroundColor.colorWithAlphaComponent(0.1).CGColor, lineWidth: ringThickeness)
			}
			return realBackgroundRingLayer
		}
		set{ realBackgroundRingLayer = newValue }
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = UIColor.whiteColor()


		userInteractionEnabled = false
		alpha = 0.0
		activityCount = 0
		accessibilityIdentifier = "SVProgressHUD"
		accessibilityLabel = "SVProgressHUD"
		isAccessibilityElement = true
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	func createHudLayer(addingView: UIView?, radius: CGFloat, strokeEnd: CGFloat) -> CAShapeLayer? {

		var layer: CAShapeLayer?
		if let addingView = addingView {
			layer = createRingLayer(addingView.center, radius: radius, strokeEnd: strokeEnd)
			addingView.layer.addSublayer(layer!)
		}
		return layer
	}

	func updateLayer(layer: CAShapeLayer, strokeColor: CGColor, lineWidth: CGFloat) {

		layer.strokeColor = strokeColor
		layer.lineWidth = lineWidth
	}
	
	func updateHUDFrame() {

		var hudWidth = 100.0
		var hudHeight = 100.0
		let stringHeightBuffer = 20.0
		let stringAndContentHeightBuffer = 80.0
//		let labelRect = CGRectZero

		let progressUsed = (self.progress != ProgressHUDUndefinedProgress) && (self.progress >= 0.0)

		let stringWidth: Double = Double((self.stringLabel?.frame.width)!)
		let stringHeight = Double((self.stringLabel?.frame.height)!)

		if ((self.imageView != nil && self.imageView?.image != nil) || progressUsed){
			hudHeight = stringAndContentHeightBuffer + stringHeight
		}
		else{
			hudHeight = stringHeightBuffer + stringHeight
		}

		if(stringWidth > hudWidth){
			hudWidth = ceil(stringWidth / 2) * 2.0
		}

		// Update values on subviews
		self.hudView!.bounds = CGRectMake(0.0, 0.0, [self.minimumSize.width, CGFloat(hudWidth)].maxElement()!, [self.minimumSize.height, CGFloat(hudHeight)].maxElement()!);
//		labelRect.size.width += max(CGFloat(0), CGFloat(self.minimumSize.width - hudWidth));
//		updateBlurBounds()

		if let imageView = imageView, hudView = hudView {
			if let _ = self.stringLabel?.text{
				imageView.center = CGPointMake(CGRectGetWidth(hudView.bounds)/2, 36.0)
			}
			else{
				imageView.center = CGPointMake(CGRectGetWidth(hudView.bounds)/2, CGRectGetHeight(hudView.bounds)/2)
			}
		}

		if let stringLabel = stringLabel {
			stringLabel.hidden = false
		}

		CATransaction.begin()
		CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)

		if let _ = stringLabel?.text {
			if(self.defaultAnimationType == .Flat){

				if let view = indefiniteAnimatedView as? IndefiniteAnimatedView {
					view.radius = self.ringNoTextRadius
				}
				indefiniteAnimatedView?.sizeToFit()
			}

			let viewCenter = CGPointMake((CGRectGetWidth(self.hudView!.bounds) / 2 ), 36.0)
			indefiniteAnimatedView?.center = viewCenter

			if(self.progress != ProgressHUDUndefinedProgress){
				self.ringLayer!.position = CGPointMake((CGRectGetWidth(self.hudView!.bounds) / 2), 36.0);
				self.backgroundRingLayer!.position = (self.ringLayer?.position)!
			}
		}
		else {
			if(self.defaultAnimationType == .Flat){

				if let view = indefiniteAnimatedView as? IndefiniteAnimatedView {
					view.radius = self.ringNoTextRadius
				}
				indefiniteAnimatedView?.sizeToFit()
			}

			let viewCenter = CGPointMake((CGRectGetWidth(self.hudView!.bounds) / 2), CGRectGetHeight(self.hudView!.bounds) / 2)
			indefiniteAnimatedView?.center = viewCenter

			if(self.progress != ProgressHUDUndefinedProgress){
				self.ringLayer!.position = CGPointMake((CGRectGetWidth(self.hudView!.bounds) / 2), CGRectGetHeight(self.hudView!.bounds) / 2)
				self.backgroundRingLayer!.position = (self.ringLayer?.position)!
			}
		}

		CATransaction.commit()
	}

	func updateMask(){

		if let _ = backgroundLayer {
			backgroundLayer?.removeFromSuperlayer()
			backgroundLayer = nil
		}
		switch defaultMaskType {

			case .Black:
				self.backgroundLayer = CALayer(frame: self.bounds, backgroundColor: UIColor(white: 0, alpha: 0.5).CGColor, needsDisplay: true)
				self.layer.insertSublayer(backgroundLayer!, atIndex: 0)
				break;

			case .Gradient:
				var gradientCenter = self.center;
				gradientCenter.y = (self.bounds.size.height - self.visibleKeyboardHeight!) / 2;
				backgroundLayer = RadialGradientLayer(gradientCenter: gradientCenter, frame: self.bounds, needsDisplay: true)
				layer.insertSublayer(self.backgroundLayer!, atIndex: 0)
				break

			default:
				break

		}
	}

	func updateBlurBounds(){

		if(defaultStyle != .Custom){
			hudView?.backgroundColor = UIColor.clearColor()

			hudView?.subviews.forEach({ (view: UIView) -> () in
				if let _ = view as? UIVisualEffectView {
					view.removeFromSuperview()
				}
			})

			if(self.backgroundColor != UIColor.clearColor()){
				self.hudView?.addBlurEffect(true, blurStyle: getBlurStyle())
			}
		}
	}

	func getBlurStyle() -> UIBlurEffectStyle{

		return (self.defaultStyle == .Dark) ? .Dark : .Light
	}

	func updateMotionEffectsForOrientation(orientation: UIInterfaceOrientation){

		let isPortrait = UIInterfaceOrientationIsPortrait(orientation)

		let xMotionEffectType: UIInterpolatingMotionEffectType = (isPortrait) ? .TiltAlongHorizontalAxis : .TiltAlongVerticalAxis
		let yMotionEffectType: UIInterpolatingMotionEffectType = (isPortrait) ? .TiltAlongVerticalAxis : .TiltAlongHorizontalAxis

		updateMotionEffect(xMotionEffectType, yMotionEffectType: yMotionEffectType)
	}

	func updateMotionEffect(xMotionEffectType: UIInterpolatingMotionEffectType, yMotionEffectType: UIInterpolatingMotionEffectType) {

		let effectX = UIInterpolatingMotionEffect(keyPath: "center.x", type: xMotionEffectType)
		effectX.minimumRelativeValue =  -ProgressHUDParallaxDepthPoints
		effectX.maximumRelativeValue = ProgressHUDParallaxDepthPoints

		let effectY = UIInterpolatingMotionEffect(keyPath: "center.y", type: yMotionEffectType)
		effectY.minimumRelativeValue =  -ProgressHUDParallaxDepthPoints
		effectY.maximumRelativeValue = ProgressHUDParallaxDepthPoints

		hudView?.motionEffects = [effectX, effectY]
	}

	func setStatus(text: String) {
		self.stringLabel?.text = text
		updateHUDFrame()
	}

	func registerNotifications() {

		[UIKeyboardDidShowNotification, UIApplicationDidChangeStatusBarOrientationNotification,
			UIApplicationDidBecomeActiveNotification, UIKeyboardWillHideNotification,
			UIKeyboardDidHideNotification, UIKeyboardWillShowNotification, UIKeyboardDidShowNotification]
			.forEach(addNotificationForPositionHud)
	}

	func addNotificationForPositionHud(notificationName: String){
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("positionHud"), name: notificationName, object: nil)
	}

	func getNotificationUserInfo() -> [String : String]? {

		if let text = self.stringLabel?.text {
			return [SVProgressHUDStatusUserInfoKey : text]
		}
		else {
			return nil
		}
	}

	func positionHud(notification: NSNotification?){

		var keyboardHeight = CGFloat(0.0)
		let animationDuration = 0.0

		self.frame = (UIApplication.sharedApplication().delegate?.window!!.bounds)!
		let orientation = UIApplication.sharedApplication().statusBarOrientation

//		let ignoreOrientation = true

		if let notification = notification {
			let keyboardInfo = notification.userInfo
			let keyboardFrame = keyboardInfo![UIKeyboardFrameBeginUserInfoKey]?.CGRectValue
//			let animationDuration = keyboardInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue

			if notification.name == UIKeyboardAnimationDurationUserInfoKey || notification.name == UIKeyboardDidShowNotification {
				keyboardHeight = (keyboardFrame?.height)!
			}
		}
		else{
			keyboardHeight = self.visibleKeyboardHeight!;
		}

		let orientationFrame = self.bounds
		let statusBarFrame = UIApplication.sharedApplication().statusBarFrame
		updateMotionEffectsForOrientation(orientation)
		updateMotionEffect(.TiltAlongHorizontalAxis, yMotionEffectType: .TiltAlongHorizontalAxis)

		var activeHeight = orientationFrame.height
		if(keyboardHeight > 0){
			activeHeight += statusBarFrame.height
		}
		activeHeight -= keyboardHeight
		let posX = orientationFrame.width / 2.0
		let posY = floor(activeHeight * 0.45)

		let rotateAngle = CGFloat(0.0)
		let newCenter = CGPoint(x: posX, y: posY)

		if let _ = notification {
			UIView.animateWithDuration(animationDuration, delay: 0, options: .AllowUserInteraction, animations: { () -> Void in
				self.moveToPoint(newCenter, rotateAngle: rotateAngle)
				self.hudView!.setNeedsDisplay()
				}, completion: nil)
		}
		else{
			moveToPoint(newCenter, rotateAngle: rotateAngle)
			self.hudView?.setNeedsDisplay()
		}

		updateMask()
	}

	func moveToPoint(newCenter: CGPoint, rotateAngle: CGFloat) {

		hudView?.transform = CGAffineTransformMakeRotation(rotateAngle)
		hudView?.center = CGPoint(x: newCenter.x + offsetFromCenter.horizontal, y: newCenter.y + offsetFromCenter.vertical)
	}

	func overlayViewDidReceiveTouchEvent(sender: AnyObject, event: UIEvent) {

		NSNotificationCenter.defaultCenter().postNotificationName(SVProgressHUDDidReceiveTouchEventNotification, object: event)
		let touch = event.allTouches()?.first
		let touchLocation = touch?.locationInView(self)
		if((hudView?.frame.contains(touchLocation!)) != nil){
			NSNotificationCenter.defaultCenter().postNotificationName(SVProgressHUDDidTouchDownInsideNotification, object: event)
		}
	}

	func showProgress(progress: Float, status: String?) {

		if let view = overlayView?.superview {
			view.bringSubviewToFront(overlayView!)

		}
		else{

			for window in UIApplication.sharedApplication().windows.reverse() {
				let windowOnMainScreen = window.screen == UIScreen.mainScreen()
				let windowIsVisible = !window.hidden && window.alpha > 0
				let windowLevelNormal = window.windowLevel == UIWindowLevelNormal

				if(windowOnMainScreen && windowIsVisible && windowLevelNormal){
					window.addSubview(overlayView!)
					break;
				}
			}
		}

		if let _ = self.superview {
			overlayView?.addSubview(self)
		}

		if let _ = self.fadeOutTimer {
			activityCount = 0
		}

		fadeOutTimer = nil
		self.imageView?.hidden = true
		self.progress = CGFloat(progress)

		stringLabel?.text = status
		updateHUDFrame()

		if (progress >= 0) {
			imageView?.image = nil
			imageView?.hidden = false
			indefiniteAnimatedView?.removeFromSuperview()
			if let view = indefiniteAnimatedView as? UIActivityIndicatorView {
				view.stopAnimating()
			}

		}

		ringLayer?.strokeEnd = CGFloat(progress)
		activityCount += 1
		if (progress != 0){
			activityCount += 1
			cancelRingLayerAnimation()
			hudView?.addSubview(indefiniteAnimatedView!)
			if let view = indefiniteAnimatedView as? UIActivityIndicatorView {
				view.stopAnimating()
			}
		}

		if(self.defaultMaskType != .None){
			overlayView?.userInteractionEnabled = true
			accessibilityLabel = status
			isAccessibilityElement = true
		}
		else{
			overlayView?.userInteractionEnabled = false
			hudView?.accessibilityLabel = status
			hudView?.isAccessibilityElement = true
		}

		overlayView?.hidden = false
		overlayView?.backgroundColor = UIColor.clearColor()
		positionHud(nil)

		if(self.alpha != 1 || self.hudView?.alpha != 1){
			let userInfo = getNotificationUserInfo()
			NSNotificationCenter.defaultCenter().postNotificationName(SVProgressHUDWillAppearNotification, object: nil, userInfo: userInfo)
			registerNotifications()
			hudView?.transform = CGAffineTransformScale((hudView?.transform)!, 1.3, 1.3)

			if(clear){
				self.alpha = 1
				self.hudView?.alpha = 0
			}

			let weakSelf: ProgressHUD? = self
			UIView.animateWithDuration(0.15, delay: 0, options: [.AllowUserInteraction, .CurveEaseOut, .BeginFromCurrentState], animations: { () -> Void in
				if let strongSelf = weakSelf {
					strongSelf.hudView!.transform = CGAffineTransformScale(strongSelf.hudView!.transform, 1 / 1.3, 1 / 1.3)

					if (strongSelf.clear) {
						strongSelf.hudView!.alpha = 1
					}
					else{
						strongSelf.alpha = 1
					}
				}

				}, completion: { (Bool) -> Void in
					NSNotificationCenter.defaultCenter().postNotificationName(SVProgressHUDDidAppearNotification, object: nil, userInfo: userInfo)
					UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil)
					UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, status)
					self.setNeedsDisplay()
			})
		}
	}

	func showImage(var image: UIImage, status: String, duration: NSTimeInterval) {

		self.progress = ProgressHUDUndefinedProgress
		cancelRingLayerAnimation()

		if(!self.classForCoder.isVisible()){
			self.classForCoder.show()
		}

		let tintColor = self.foregroundColor
		if(image.renderingMode != .AlwaysTemplate) {
			image = image.imageWithRenderingMode(.AlwaysTemplate)
		}
		self.imageView?.tintColor = tintColor

		imageView?.image = image
		imageView?.hidden = false

		stringLabel?.text = status
		updateHUDFrame()
		indefiniteAnimatedView?.removeFromSuperview()
		if let view = indefiniteAnimatedView as? UIActivityIndicatorView {
			view.stopAnimating()
		}

		if(self.defaultMaskType != .None){
			overlayView?.userInteractionEnabled = false
			self.accessibilityLabel = status
			self.isAccessibilityElement = true
		}
		else{
			self.overlayView?.userInteractionEnabled = false
			self.hudView?.accessibilityLabel = status
			self.hudView?.isAccessibilityElement = true
		}

		UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil)
		UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, status)

		self.fadeOutTimer = NSTimer(timeInterval: duration, target: self, selector: Selector("dismiss"), userInfo: nil, repeats: false)
		NSRunLoop.mainRunLoop().addTimer(fadeOutTimer!, forMode: NSRunLoopCommonModes)

	}

	func dismiss(){
		dismissWithDelay(0)
	}

	func dismissWithDelay(delay: NSTimeInterval) {

		let userInfo = self.getNotificationUserInfo()

		NSNotificationCenter.defaultCenter().postNotificationName(SVProgressHUDWillDisappearNotification, object: nil, userInfo: userInfo)

		activityCount = 0
		let weakSelf: ProgressHUD? = self
		UIView.animateWithDuration(0.15, delay: delay, options: [.CurveEaseIn, .AllowUserInteraction], animations: { () -> Void in

			if let strongSelf = weakSelf {
				strongSelf.hudView!.transform = CGAffineTransformScale((self.hudView?.transform)!, 0.8, 0.8)
				if(strongSelf.clear){
					strongSelf.hudView!.alpha = 0.0
				}
				else{
					strongSelf.alpha = 0.0
				}
			}
			}) { (Bool) -> Void in
				if let strongSelf = weakSelf {
					if(strongSelf.alpha == 0.0 || strongSelf.hudView?.alpha == 0.0){
						strongSelf.alpha = 0.0
						strongSelf.hudView?.alpha = 0.0

						NSNotificationCenter.defaultCenter().removeObserver(strongSelf)
						strongSelf.cancelRingLayerAnimation()

						self.resetViews()

						UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil)
						NSNotificationCenter.defaultCenter().postNotificationName(SVProgressHUDDidDisappearNotification, object: nil, userInfo: userInfo)

						let rootController = UIApplication.sharedApplication().keyWindow?.rootViewController
						rootController?.setNeedsStatusBarAppearanceUpdate()

					}
				}
		}
	}

	func resetViews(){
		self.hudView?.removeFromSuperview()
		self.hudView = nil

		self.overlayView?.removeFromSuperview()
		self.overlayView = nil

		self.indefiniteAnimatedView?.removeFromSuperview()
		self.indefiniteAnimatedView = nil
	}



	func createActivityIndicatorView() -> UIActivityIndicatorView{

		let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
		indicatorView.color = self.foregroundColor
		indicatorView.sizeToFit()
		return indicatorView
	}

	func createIndefiniteAnimatedView() -> IndefiniteAnimatedView {

		let animatedView = IndefiniteAnimatedView(frame: CGRectZero)
		animatedView.strokeColor = foregroundColor
		let radius: CGFloat
		if let _ = self.stringLabel?.text {
			radius = self.ringRadius
		}
		else{
			radius = self.ringNoTextRadius
		}
		animatedView.refresh(radius, strokeThickness: ringThickeness)
		return animatedView
	}

	func cancelRingLayerAnimation(){
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		hudView?.layer.removeAllAnimations()
		ringLayer?.strokeEnd = 0.0

		if let _ = ringLayer?.superlayer {
				ringLayer?.removeFromSuperlayer()
		}
		ringLayer = nil

		if let _ = backgroundRingLayer?.superlayer{
			backgroundRingLayer?.removeFromSuperlayer()
		}
		backgroundRingLayer = nil

		CATransaction.commit()
	}

	func createRingLayer(center: CGPoint, radius: CGFloat, strokeEnd: CGFloat) -> CAShapeLayer {

		let smoothedPath = UIBezierPath(arcCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI + M_PI_2), clockwise: true)

		let frame = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
		let slice = CAShapeLayer(contentsScale: UIScreen.mainScreen().scale, frame: frame, fillColor: UIColor.clearColor().CGColor, lineCap: kCALineCapRound, lineJoin: kCALineJoinBevel, path: smoothedPath.CGPath, strokeEnd: strokeEnd)

		return slice
	}

	func getHeightFromViews(views: [UIView]) -> CGFloat {

		var height: CGFloat = 0
		views.forEach { (view) -> () in
			if (view.isKindOfClass(NSClassFromString("UIPeripheralHostView")!) || view.isKindOfClass(NSClassFromString("UIKeyboard")!)){
				height = view.bounds.height
				return
			}
			else if( view.isKindOfClass(NSClassFromString("UIInputSetContainerView")!)){
				height = getHeightFromViews(view.subviews)
				return
			}
		}
		return height
	}
	
}
