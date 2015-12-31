//
//  ViewController.swift
//  SwiftyHUD
//
//  Created by Paul Fechner on 12/31/15.
//  Copyright © 2015 PeeJWeeJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


	@IBAction func showPressed(sender: AnyObject) {
		PWHUDView.addToScreen()
	}
}

