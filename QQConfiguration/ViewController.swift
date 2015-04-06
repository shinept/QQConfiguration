//
//  ViewController.swift
//  QQConfiguration
//
//  Created by 张亚东 on 15/4/3.
//  Copyright (c) 2015年 blurryssky. All rights reserved.
//

import UIKit

let ZDScreenWidth = UIScreen.mainScreen().bounds.width
let ZDScreenHeight = UIScreen.mainScreen().bounds.height
//base on iPhone 6,屏幕系数
let ZDScreenFactorWidth = ZDScreenWidth / 375.0
let ZDScreenFactorHeight = ZDScreenHeight / 667.0

class ViewController: UIViewController , MasterViewControllerDelegate{

    @IBOutlet weak var masterContainerView: UIView!
    @IBOutlet weak var leftsideContainerView: UIView!
    
    var leftContainerViewShowed = false
    
    @IBOutlet weak var leftContainerViewLayoutConstraintTralingToEdge: NSLayoutConstraint!
    
    let leftsideContainerViewOffsetX = -220 * ZDScreenFactorWidth
    let masterContainerViewOffsetX = 305 * ZDScreenFactorWidth
    
    //左视图出现需要超过的拖动的距离
    let paddingSpaceToLeftEdge = 80 * ZDScreenFactorWidth
    
    //显示出来的左视图的右边缘距离屏幕的宽度
    let marginToRightEdge = 80 * ZDScreenFactorWidth
    
    lazy var leftMaskView : UIView!  = {
        let view = UIView()
        view.backgroundColor = UIColor.blackColor()
        view.alpha = 1
        return view
        }()
    
    lazy var masterMaskView : UIView!  = {
        let view = UIView()
        view.backgroundColor = UIColor.blackColor()
        view.alpha = 0
        return view
        }()
    
    //Gesture
    lazy var tap:UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: "respondsToTap:")
        return tap
        }()
    
    lazy var leftScreenEdgePan :UIScreenEdgePanGestureRecognizer = {
        let pan = UIScreenEdgePanGestureRecognizer(target: self, action: "respondsToPan:")
        pan.edges = UIRectEdge.Left
        return pan
        }()
    
    lazy var pan:UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: "respondsToPan:")
        return pan
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initialyConfiguration()
    }
    
    func initialyConfiguration() {
        
        leftContainerViewLayoutConstraintTralingToEdge.constant = 80 * ZDScreenFactorWidth
        //5
        view.layoutIfNeeded()
        
        //leftsideContainerView
        leftMaskView.frame = CGRectMake(0, 0,
            leftsideContainerView.bounds.width ,
            leftsideContainerView.bounds.height)
        
        leftsideContainerView.addSubview(leftMaskView)
        
        //masterView
        masterMaskView.frame = CGRectMake(0, 0, ZDScreenWidth, ZDScreenHeight)
        masterContainerView.addSubview(masterMaskView)
        
        //add tap gesture
        masterMaskView.addGestureRecognizer(tap)
        
        //注意是加在view上
        view.addGestureRecognizer(leftScreenEdgePan)
        //1
        leftsideContainerView.transform = CGAffineTransformMakeScale(0.5, 0.5)
        leftsideContainerView.transform = CGAffineTransformTranslate(leftsideContainerView.transform, leftsideContainerViewOffsetX, 0)
        
        
    }
    
    //3
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as UIViewController
        
        if vc.isKindOfClass(UINavigationController) {
            let naviVC = vc as UINavigationController
            let topVC = naviVC.topViewController
            
            if topVC.isKindOfClass(MasterViewController) {
                let masterVC = topVC as MasterViewController
                masterVC.delegate = self
            }
        }
    }
    
    //#MARK:MasterViewControllerDelegate
    //4
    func MasterViewControllerShowButtonDidClicked() {
        showLeftContainerViewAnimated(true, completion: { () -> Void in
            
        })
    }
    
    //#MARK:Gesture
    func respondsToTap(sender :UITapGestureRecognizer){
        dismissLeftContainerViewAnimated(true, completion: { () -> Void in
            
        })
    }
    
    func respondsToPan(sender: UIPanGestureRecognizer) {
        
        let translationPoint = sender.translationInView(masterContainerView)
        
        var translationX : CGFloat?
        
        //建立静态变量
        struct Static {
            static var panStartPoint : CGPoint!
        }
        
        switch sender.state {
        case UIGestureRecognizerState.Began:
            Static.panStartPoint = translationPoint
            
        case .Changed:
            translationX = translationPoint.x - Static.panStartPoint!.x
            
            //从左往右拖的时候拖出了左视图显示时的宽度
            if abs(translationX!) > ZDScreenWidth - marginToRightEdge {
                return
            }
            //caculator the factor
            var factor = translationX! / (ZDScreenWidth - marginToRightEdge)

            //从左往右滑的情况,系数需要作调整
            if leftContainerViewShowed {
                factor = 1 + factor
            }
            
            //从右往左拖了一点后立刻往右拖的情况
            if leftContainerViewShowed {
                if translationX! > 0 {
                    showLeftContainerViewAnimated(false, completion: { () -> Void in
                        
                    })
                    
                    return
                }
            }
                //从左往右拖了一点后立刻往左拖的情况
            else {
                if translationX! < 0 {
                    
                    dismissLeftContainerViewAnimated(false, completion: { () -> Void in
                        
                    })
                    return
                }
            }
            
            //由于scale一开始就是0.5倍，所以相应的乘以0.5
            self.leftsideContainerView.transform = CGAffineTransformMakeTranslation(self.leftsideContainerViewOffsetX * (1 - factor) * 0.5, 0)
            //由0.5 -> 1
            self.leftsideContainerView.transform = CGAffineTransformScale(self.leftsideContainerView.transform, 0.5 + 0.5 * factor, 0.5 + 0.5 * factor)
            //1 -> 0
            self.leftMaskView.alpha = 1 - factor
            //1 -> 0.9
            self.masterContainerView.transform = CGAffineTransformMakeScale(1 - 0.1 * factor, 1 - 0.1 * factor)
            //做一些偏移
            self.masterContainerView.transform = CGAffineTransformTranslate(self.masterContainerView.transform, self.masterContainerViewOffsetX * factor , 0)
            //0 -> 0.5
            self.masterMaskView.alpha = 0.5 * factor
            
        
        case .Ended:
            
            translationX = abs(translationPoint.x - Static.panStartPoint!.x)
            
            let velocity = pan.velocityInView(view)
            
            //如果滑动结束时，水平速度的方向向右
            if velocity.x > 0 {
                showLeftContainerViewAnimated(true, completion: { () -> Void in
                    
                })
            }
            else if velocity.x < 0{
                dismissLeftContainerViewAnimated(true, completion: { () -> Void in
                    
                })
            }
                //不知为什么，触发ScreenEdgePan的时候velocity为0，所以我做了以下判断，有发现原因的开发者可以告知我一下
            else {
                if translationX > paddingSpaceToLeftEdge {
                    showLeftContainerViewAnimated(true, completion: { () -> Void in
                        
                    })
                }
                else {
                    dismissLeftContainerViewAnimated(true, completion: { () -> Void in
                        
                    })
                }
            }
            Static.panStartPoint = nil
        default:break
        }
    }

    func showLeftContainerViewAnimated(animated:Bool, completion:() -> Void) {
        
        var duration = animated ? 0.3 : 0
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.leftsideContainerView.transform = CGAffineTransformIdentity
            
            self.masterContainerView.transform = CGAffineTransformMakeScale(0.9, 0.9)
            self.masterContainerView.transform = CGAffineTransformTranslate(self.masterContainerView.transform, self.masterContainerViewOffsetX, 0)
            
            self.leftMaskView.alpha = 0
            self.masterMaskView.alpha = 0.5
            }) { (_) -> Void in
                self.leftContainerViewShowed = true
                self.view.removeGestureRecognizer(self.leftScreenEdgePan)
                self.masterMaskView.addGestureRecognizer(self.pan)
        }
    }
    func dismissLeftContainerViewAnimated(animated:Bool ,completion:() -> Void) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in

            var duration = animated ? 0.3 : 0
            
            self.leftsideContainerView.transform = CGAffineTransformMakeScale(0.5, 0.5)
            self.leftsideContainerView.transform = CGAffineTransformTranslate(self.leftsideContainerView.transform, self.leftsideContainerViewOffsetX, 0)
            
            self.masterContainerView.transform = CGAffineTransformIdentity
            
            self.leftMaskView.alpha = 1
            self.masterMaskView.alpha = 0
            }) { (_) -> Void in
                self.leftContainerViewShowed = false
                self.view.addGestureRecognizer(self.leftScreenEdgePan)
                self.masterMaskView.removeGestureRecognizer(self.pan)
        }
    }
}



















