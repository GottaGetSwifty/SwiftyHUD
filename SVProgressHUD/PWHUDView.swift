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





	@IBAction func cancelButtonPressed(sender: AnyObject) {}




	func setupForState(state: HudOptions){

	}

	func setupForBlurEffect(){
		blurVisualEffectView
	}
}


