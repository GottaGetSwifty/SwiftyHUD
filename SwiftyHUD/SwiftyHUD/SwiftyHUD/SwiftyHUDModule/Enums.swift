//
//  Enums.swift
//  SVProgressHUD
//
//  Created by Paul Fechner on 12/29/15.
//  Copyright © 2015 EmbeddedSources. All rights reserved.
//

import UIKit
enum ProgressHUDStyle {

	case Light, Dark, Custom

	func getBlurStyle() -> UIBlurEffectStyle? {

		switch self {
			case .Light:
				return .Light
			case .Dark:
				return .Dark
			default:
				return nil
		}
	}
}

enum StatusImageOption {

	case None, Succeeded, Failed, Custom

	func getImage() -> UIImage? {

		switch self {
			case .Succeeded:
				return UIImage(contentsOfFile: "success")!
			case .Failed:
				return UIImage(contentsOfFile: "error")!
			default:
				return nil
		}
	}
}

enum ProgressHUDMaskType {
	case None, Clear, Black, White, Gradient

	func maskLayer(layer: CALayer) {

		switch self {
		case .Black:
			layer.backgroundColor = CGColorCreateCopyWithAlpha(UIColor.blackColor().CGColor, 0.6)
		case .White:
			layer.backgroundColor = CGColorCreateCopyWithAlpha(UIColor.whiteColor().CGColor, 0.6)
		default:
			layer.backgroundColor = CGColorCreateCopyWithAlpha(UIColor.blackColor().CGColor, 0)
		}
	}

}

enum ProgressHUDAnimationType {
	case Flat, Native
}