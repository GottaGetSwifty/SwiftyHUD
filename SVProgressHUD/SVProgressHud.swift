//
//  SVProgressHud.swift
//  SVProgressHUD
//
//  Created by Paul Fechner on 12/27/15.
//  Copyright © 2015 EmbeddedSources. All rights reserved.
//

import Foundation



class SVProgressHUD {

	private static var realSharedView: ProgressHUD?
	private static var sharedView: ProgressHUD {
		get{
			if (realSharedView == nil){
				realSharedView = ProgressHUD(frame: UIScreen.mainScreen().bounds)
			}
			return realSharedView!
		}
	}

	class func setStatus(status: String){
		sharedView.setStatus(status)
	}

	class func setDefaultStyle(style: ProgressHUDStyle){
		sharedView.defaultStyle = style
	}

	class func setDefaultMaskType(maskType: ProgressHUDMaskType) {
		sharedView.defaultMaskType = maskType
	}

	class func setDefaultAnimationType(type: ProgressHUDAnimationType) {
		sharedView.defaultAnimationType = type
	}

	class func setMinimumSize(minimumSize: CGSize) {
		sharedView.minimumSize = minimumSize
	}

	class func setRingThickness(ringThickness: CGFloat) {
		sharedView.ringThickeness = ringThickness
	}

	class func setRingRadius(radius: CGFloat) {
		sharedView.ringRadius = radius
	}

	class func setRingNoTextRadius(radius: CGFloat) {
		sharedView.ringNoTextRadius = radius
	}

	class func setCornerRadius(cornerRadius: CGFloat) {
		sharedView.cornerRadius = cornerRadius
	}

	class func setDefaultMaskType(type: SVProgressHUDAnimationType) {
		sharedView
	}

	class func setFont(font: UIFont) {
		sharedView.font = font
	}

	class func setForegroundColor(color: UIColor) {
		sharedView.foregroundColor = color
	}

	class func setBackgroundColor(color: UIColor) {
		sharedView.backgroundColor = color
	}

	class func setInfoImage(image: UIImage) {
		sharedView.infoImage = image
	}

	class func setSuccessImage(image: UIImage) {
		sharedView.successImage = image
	}
	class func setErrorImage(image: UIImage) {
		sharedView.errorImage = image
	}
	class func setViewForExtension(view: UIView) {
		sharedView.viewForExtension = view
	}
	class func setMinimumDismissTimeInterval(interval: NSTimeInterval) {
		sharedView.minimumDismissTimeInterval = interval
	}

	class func setOffsetFromCenter(offset: UIOffset){
		sharedView.offsetFromCenter = offset
	}

	class func resetOffsetFromCenter(){
		setOffsetFromCenter(UIOffsetZero)
	}


	class func show(){
		show(nil)
	}

	class func show(status: String?){
		show(status, maskType: nil)
	}

	class func show(maskType: ProgressHUDMaskType){
		show(nil, maskType: maskType)
	}

	class func show(status: String?, maskType: ProgressHUDMaskType?){

		var existingMaskType: ProgressHUDMaskType? = nil
		if let maskType = maskType {
			existingMaskType = sharedView.defaultMaskType
			setDefaultMaskType(maskType)
		}

		showProgress(Float(ProgressHUDUndefinedProgress), status: status)

		if let existingMaskType = existingMaskType {
			setDefaultMaskType(existingMaskType)
		}
	}

	class func showProgress(progress: Float){
		showProgress(progress, status: nil)
	}

	class func showProgress(progress: Float, maskType: ProgressHUDMaskType){
		showProgress(progress, status: nil, maskType: maskType)
	}

	class func showProgress(progress: Float, status: String?){
		showProgress(progress, status: status, maskType: nil)
	}

	class func showProgress(progress: Float, status: String?, maskType: ProgressHUDMaskType?){

		var existingMaskType: ProgressHUDMaskType? = nil
		if let maskType = maskType {
			existingMaskType = sharedView.defaultMaskType
			setDefaultMaskType(maskType)
		}

		sharedView.showProgress(progress, status: status)

		if let existingMaskType = existingMaskType {
			setDefaultMaskType(existingMaskType)
		}
	}

	class func showInfo(status: String){
		showImage(sharedView.infoImage, status: status)
	}

	class func showInfo(status: String, maskType: ProgressHUDMaskType){
		let defaultMaskType = sharedView.defaultMaskType
		setDefaultMaskType(maskType)
		showInfo(status)
		setDefaultMaskType(defaultMaskType)
	}

	class func showSuccess(status: String){
		showImage(sharedView.successImage, status: status)
	}

	class func showSuccess(status: String, maskType: ProgressHUDMaskType){
		let existingMaskType = sharedView.defaultMaskType
		setDefaultMaskType(maskType)
		showSuccess(status)
		setDefaultMaskType(existingMaskType)
	}

	class func showError(status: String){
		showImage(sharedView.errorImage, status: status)
	}

	class func showError(status: String, maskType: ProgressHUDMaskType){
		let existingMaskType = sharedView.defaultMaskType
		setDefaultMaskType(maskType)
		showError(status)
		setDefaultMaskType(existingMaskType)
}

	class func showImage(image: UIImage, status: String){
		showImage(image, status: status, maskType: nil)
	}

	class func showImage(image: UIImage, status: String, maskType: ProgressHUDMaskType?){
		var existingMaskType: ProgressHUDMaskType? = nil
		if let maskType = maskType {
			existingMaskType = sharedView.defaultMaskType
			setDefaultMaskType(maskType)
		}

		let displayInterval = displayDuration(status)
		sharedView.showImage(image, status: status, duration: displayInterval)

		if let existingMaskType = existingMaskType{
			setDefaultMaskType(existingMaskType)
		}
	}

	class func popActivity(){
		if(sharedView.activityCount > 0){
			sharedView.activityCount -= 1
		}
		if(sharedView.activityCount == 0){
			sharedView.dismiss()
		}
	}

	class func dismiss(delay: NSTimeInterval){
		if(isVisible()){
			sharedView.dismissWithDelay(delay)
		}
	}

	class func dismiss(){
		dismiss(0)
	}

	class func isVisible() -> Bool{
		return Float(sharedView.alpha) > Float(0.99)
	}

	class func displayDuration(text: String) -> NSTimeInterval{
		let durations: [Double] = [Double(text.characters.count) * 0.06 + 0.5, sharedView.minimumDismissTimeInterval]
		if let duration = durations.minElement() {
			return duration
		}
		else{
			return 0
		}
	}
}