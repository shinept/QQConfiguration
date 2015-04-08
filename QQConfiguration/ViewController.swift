

import UIKit

class ViewController: UIViewController {
    var vc=LeftEdgeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var v=UIView(frame: self.view.frame)
        v.backgroundColor=UIColor.yellowColor()
        vc.setBackgroundAndMasterVC(v,vc: self)
        self.view.backgroundColor=UIColor.redColor()
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

