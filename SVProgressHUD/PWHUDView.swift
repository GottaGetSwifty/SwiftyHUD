//
//  PWHudView.swift
//  SVProgressHUD
//
//  Created by Paul Fechner on 12/28/15.
//  Copyright © 2015 EmbeddedSources. All rights reserved.
//

import UIKit

class PWHUDView: UIView {

	var blurVisualEffectView: UIVisualEffectView?

	@IBOutlet weak var mainHudView: UIView!

	@IBOutlet weak var stackView: UIStackView!

	@IBOutlet weak var progressIndicator: UIActivityIndicatorView!

	@IBOutlet weak var indicationImage: UIImageView!

	@IBOutlet weak var messageLabel: UILabel!

	@IBOutlet weak var cancelButton: UIButton!

	var hudOptions: HudOptions;

	func setupForState(state: HudOptions){

	}

	func setupForBlurEffect(){

		var effectsView = getBlurEffect(true, blurStyle: hudOptions.hudStyle.getBlurEffect)

		if let blurVisualEffectView = blurVisualEffectView {
			blurVisualEffectView.removeFromSuperView()
		}

		blurVisualEffectView = effectsView
		self.addSubView(effectsView)
	}

	func setupProgressIndicator(){

	}

	func setupIndicationImage() {

	}
	
	func setupMessageLabel(){

	}

	func setupCancelButton(){

	}

	func setupVisibilities(){

	}


	@IBAction func cancelButtonPressed(sender: AnyObject) {

	}
}


