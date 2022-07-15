//
//  ViewController.swift
//  App
//
//  Created by SIU Suet Long on 1/10/2020.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var segmentedControl: KYSegmentedControl = {
        let segmentedControl = KYSegmentedControl(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width - 16, height: 44))
        segmentedControl.setSegmentItems(["Years", "Months", "Days", "All Photos"])

        return segmentedControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.addSubview(self.segmentedControl)
        self.segmentedControl.center = self.view.center
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.segmentedControl.center = self.view.center
    }

}
