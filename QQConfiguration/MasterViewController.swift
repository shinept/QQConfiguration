//
//  MasterViewController.swift
//  QQConfiguration
//
//  Created by 张亚东 on 15/4/3.
//  Copyright (c) 2015年 blurryssky. All rights reserved.
//

import UIKit

protocol MasterViewControllerDelegate {
    func MasterViewControllerShowButtonDidClicked()
}

class MasterViewController: UIViewController {
    var delegate : MasterViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func respondsToShowButton(sender: UIBarButtonItem) {
        //2
        delegate?.MasterViewControllerShowButtonDidClicked()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
