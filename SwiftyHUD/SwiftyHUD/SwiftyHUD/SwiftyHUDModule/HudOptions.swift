//
//  HudOptions.swift
//  SVProgressHUD
//
//  Created by Paul Fechner on 12/27/15.
//  Copyright © 2015 EmbeddedSources. All rights reserved.
//

import UIKit

struct HudOptions {

	var hudStyle: ProgressHUDStyle = .Dark
	var hudMaskType: ProgressHUDMaskType = .None
	var hudAnimationType: ProgressHUDAnimationType = .Native
	var statusImageOption: StatusImageOption = .None
	var message: String?
	var buttonMessage: String?
	var statusImage: UIImage?

	init() { }
}
