//
//  PWHudView.swift
//  SVProgressHUD
//
//  Created by Paul Fechner on 12/28/15.
//  Copyright © 2015 EmbeddedSources. All rights reserved.
//

import UIKit

class PWHUDView: UIView {

	@IBOutlet weak var blurVisualEffectView: UIVisualEffectView!

	@IBOutlet weak var mainHudView: UIView!

	@IBOutlet weak var stackView: UIStackView!

	@IBOutlet weak var progressIndicator: UIActivityIndicatorView!

	@IBOutlet weak var indicationImage: UIImageView!

	@IBOutlet weak var messageLabel: UILabel!

	@IBOutlet weak var cancelButton: UIButton!

	var hudOptions: HudOptions;

	override init(frame: CGRect) {
		self.hudOptions = HudOptions()
		super.init(frame: frame)
	}

	required init?(coder aDecoder: NSCoder) {
		self.hudOptions = HudOptions()
	    super.init(coder: aDecoder)
	}

	func setupForState(state: HudOptions){
		update()
	}

	func update(){
		setupForBlurEffect()
		setupProgressIndicator()
		setupIndicationImage()
		setupMessageLabel()
		setupCancelButton()
		setupBackground()
		mainHudView.layer.cornerRadius = 25
	}

	func setupForBlurEffect(){

		if let blurStyle = hudOptions.hudStyle.getBlurStyle() {

			let effectsView = getBlurEffect(true, blurStyle: blurStyle)
			effectsView.addConstraints(blurVisualEffectView.constraints)

			blurVisualEffectView.removeFromSuperview()

			effectsView.frame = mainHudView.bounds
			self.blurVisualEffectView = effectsView
			mainHudView.insertSubview(self.blurVisualEffectView, atIndex: 0)
		}
	}

	func setupProgressIndicator(){

		if( hudOptions.hudAnimationType == .Native) {
			progressIndicator.startAnimating()
			progressIndicator.hidden = false

			if hudOptions.hudStyle == .Light {
				progressIndicator.color = UIColor.blackColor()
			}
			else{
				progressIndicator.color = UIColor.whiteColor()
			}
		}
		else{
			progressIndicator.hidden = true
		}
	}

	func setupIndicationImage() {

		if let image = hudOptions.statusImageOption.getImage() {
			indicationImage.image = image
			indicationImage.hidden = false
		}
		else if let image = hudOptions.statusImage {
			indicationImage.image = image
			indicationImage.hidden = false
		}
		else{
			indicationImage.hidden = true
		}
	}

	func setupMessageLabel(){
		if let labelText = hudOptions.message {
			messageLabel.text = labelText
			messageLabel.hidden = true
		}
		else{
			messageLabel.hidden = false
		}

		if hudOptions.hudStyle == .Light {
			messageLabel.textColor = UIColor.blackColor()
		}
		else{
			messageLabel.textColor = UIColor.whiteColor()
		}
	}

	func setupCancelButton(){

		if let buttonText = hudOptions.buttonMessage {
			cancelButton.titleLabel?.text = buttonText
			cancelButton.hidden = false
		}
		else {
			cancelButton.hidden = true
		}
	}

	func setupBackground(){
		hudOptions.hudMaskType.maskLayer(self.layer)
	}

	@IBAction func cancelButtonPressed(sender: AnyObject) {

	}

	class func addToScreen(){

		let view: PWHUDView = UIView.fromNib()
		view.frame =  UIScreen.mainScreen().bounds

		for window in UIApplication.sharedApplication().windows.reverse() {
			let windowOnMainScreen = window.screen == UIScreen.mainScreen()
			let windowIsVisible = !window.hidden && window.alpha > 0
			let windowLevelNormal = window.windowLevel == UIWindowLevelNormal

			if(windowOnMainScreen && windowIsVisible && windowLevelNormal){
				window.addSubview(view)
				break;
			}
		}
		if let superView = view.superview {
			superView.bringSubviewToFront(view)
		}
		view.update()
	}
}


