//
//  SwiftyHUD.swift
//  SwiftyHUD
//
//  Created by Paul Fechner on 1/3/16.
//  Copyright © 2016 PeeJWeeJ. All rights reserved.
//

class SwiftyHUD {

	private static var existingHUDs: [SwiftyHUD] = []

	private static var hudView: SwiftyHUDView?

	private var hudOptions: HudOptions

	init(hudOptions: HudOptions){
		self.hudOptions = hudOptions
	}

	class func builder() -> SwiftyHUD{
		return SwiftyHUD(hudOptions: HudOptions())
	}

	class func builder(hudOptions: HudOptions) -> SwiftyHUD {
		return SwiftyHUD(hudOptions: hudOptions)
	}

	func build(){
		hudView = 
	}

	func show(){

	}


	+ (void)setDefaultStyle:(SVProgressHUDStyle)style;                  // default is SVProgressHUDStyleLight
	+ (void)setDefaultMaskType:(SVProgressHUDMaskType)maskType;         // default is SVProgressHUDMaskTypeNone
	+ (void)setDefaultAnimationType:(SVProgressHUDAnimationType)type;   // default is SVProgressHUDAnimationTypeFlat
	+ (void)setMinimumSize:(CGSize)minimumSize;                         // default is CGSizeZero, can be used to avoid resizing for a larger message
	+ (void)setRingThickness:(CGFloat)ringThickness;                    // default is 2 pt
	+ (void)setRingRadius:(CGFloat)radius;                              // default is 18 pt
	+ (void)setRingNoTextRadius:(CGFloat)radius;                        // default is 24 pt
	+ (void)setCornerRadius:(CGFloat)cornerRadius;                      // default is 14 pt
	+ (void)setFont:(UIFont*)font;                                      // default is [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]
	+ (void)setForegroundColor:(UIColor*)color;                         // default is [UIColor blackColor], only used for SVProgressHUDStyleCustom
	+ (void)setBackgroundColor:(UIColor*)color;                         // default is [UIColor whiteColor], only used for SVProgressHUDStyleCustom
	+ (void)setInfoImage:(UIImage*)image;                               // default is the bundled info image provided by Freepik
	+ (void)setSuccessImage:(UIImage*)image;                            // default is the bundled success image provided by Freepik
	+ (void)setErrorImage:(UIImage*)image;                              // default is the bundled error image provided by Freepik
	+ (void)setViewForExtension:(UIView*)view;                          // default is nil, only used if #define SV_APP_EXTENSIONS is set
	+ (void)setMinimumDismissTimeInterval:(NSTimeInterval)interval;     // default is 5.0 seconds

	#pragma mark - Show Methods

	+ (void)show;
	+ (void)showWithMaskType:(SVProgressHUDMaskType)maskType __attribute__((deprecated("Use show and setDefaultMaskType: instead.")));
	+ (void)showWithStatus:(NSString*)status;
	+ (void)showWithStatus:(NSString*)status maskType:(SVProgressHUDMaskType)maskType __attribute__((deprecated("Use showWithStatus: and setDefaultMaskType: instead.")));

	+ (void)showProgress:(float)progress;
	+ (void)showProgress:(float)progress maskType:(SVProgressHUDMaskType)maskType __attribute__((deprecated("Use showProgress: and setDefaultMaskType: instead.")));
	+ (void)showProgress:(float)progress status:(NSString*)status;
	+ (void)showProgress:(float)progress status:(NSString*)status maskType:(SVProgressHUDMaskType)maskType __attribute__((deprecated("Use showProgress: and setDefaultMaskType: instead.")));

	+ (void)setStatus:(NSString*)status; // change the HUD loading status while it's showing

	// stops the activity indicator, shows a glyph + status, and dismisses the HUD a little bit later
	+ (void)showInfoWithStatus:(NSString*)status;
	+ (void)showInfoWithStatus:(NSString*)status maskType:(SVProgressHUDMaskType)maskType __attribute__((deprecated("Use showInfoWithStatus: and setDefaultMaskType: instead.")));
	+ (void)showSuccessWithStatus:(NSString*)status;
	+ (void)showSuccessWithStatus:(NSString*)status maskType:(SVProgressHUDMaskType)maskType __attribute__((deprecated("Use showSuccessWithStatus: and setDefaultMaskType: instead.")));
	+ (void)showErrorWithStatus:(NSString*)status;
	+ (void)showErrorWithStatus:(NSString*)status maskType:(SVProgressHUDMaskType)maskType __attribute__((deprecated("Use showErrorWithStatus: and setDefaultMaskType: instead.")));

	// shows a image + status, use 28x28 white PNGs
	+ (void)showImage:(UIImage*)image status:(NSString*)status;
	+ (void)showImage:(UIImage*)image status:(NSString*)status maskType:(SVProgressHUDMaskType)maskType __attribute__((deprecated("Use showImage: and setDefaultMaskType: instead.")));

	+ (void)setOffsetFromCenter:(UIOffset)offset;
	+ (void)resetOffsetFromCenter;

	+ (void)popActivity; // decrease activity count, if activity count == 0 the HUD is dismissed
	+ (void)dismiss;
	+ (void)dismissWithDelay:(NSTimeInterval)delay; // delayes the dismissal

	+ (BOOL)isVisible;

	+ (NSTimeInterval)displayDurationForString:(NSString*)string;
}