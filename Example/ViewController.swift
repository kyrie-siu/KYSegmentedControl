//
//  ViewController.swift
//  Example
//
//  Created by SIU Suet Long on 1/10/2020.
//

import UIKit
import KYSegmentedControl

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let segmentedControl = KYSegmentedControl(frame: CGRect(x: 0, y: 0, width: 260, height: 500))
        segmentedControl.setSegmentItems(["Testing1", "Testing2", "Testing3", "Testing4"])
        
        self.view.addSubview(segmentedControl)
        segmentedControl.center = self.view.center        
    }


}

