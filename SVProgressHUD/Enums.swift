//
//  Enums.swift
//  SVProgressHUD
//
//  Created by Paul Fechner on 12/29/15.
//  Copyright © 2015 EmbeddedSources. All rights reserved.
//

enum ProgressHUDStyle {
	case Light, Dark, Custom

	func getBlurStyle() -> UIBlurEffectStyle? {

		switch this {
			case .Light:
				return .Light
			case .Dark:
				return .Dark
			default:
				return nil
		}
	}
}

enum ProgressHUDMaskType {
	case None, Clear, Black, Gradient
}

enum ProgressHUDAnimationType {
	case Flat, Native
}