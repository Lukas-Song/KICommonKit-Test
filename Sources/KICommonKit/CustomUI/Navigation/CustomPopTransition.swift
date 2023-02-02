//
//  CustomPopTransition.swift
//  TalkAppBase
//
//  Created by iPart on 2021/05/26.
//  Copyright © 2021 Kakao. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
public class CustomPopTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let customPopTransitionDuration: TimeInterval = 0.25
    
    public var transitionCompleteBlock: ((_ toViewController: UIViewController?) -> Void)?
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return customPopTransitionDuration
    }
    
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        fromViewController.view.layer.shadowColor = UIColor.black.cgColor
        fromViewController.view.layer.shadowOffset = CGSize(width: 0, height: 2)
        fromViewController.view.layer.masksToBounds = false
        fromViewController.view.layer.shadowOpacity = 0.5
        fromViewController.view.layer.shadowPath = UIBezierPath(rect: fromViewController.view.bounds).cgPath
        
        let fromNavigationBar = fromViewController.navigationController?.navigationBar
        let toNavigaionController = toViewController.navigationController
        if let fromNavigationBar = fromNavigationBar,
           let toNavigaionController = toNavigaionController,
           toNavigaionController.isNavigationBarHidden == true {
            fromNavigationBar.alpha = 1
            fromNavigationBar.isTranslucent = false
        }
        
        let finalFrameForToViewController = transitionContext.finalFrame(for: toViewController)
        toViewController.view.frame = CGRect(x: -toViewController.view.width.divide(3),
                                             y: finalFrameForToViewController.origin.y,
                                             width: toViewController.view.width,
                                             height: finalFrameForToViewController.size.height)
        
        if let toTitleView = toViewController.navigationItem.titleView {
            toTitleView.x = toTitleView.width
        }
        if let toNavigaionController = toNavigaionController,
           toNavigaionController.isNavigationBarHidden && toViewController.view.y != 0 {
            toViewController.view.height += toViewController.view.y
            toViewController.view.y = 0
        }
        
        let containerView = transitionContext.containerView
        if let view = toViewController.view {
            containerView.addSubview(view)
        }
        
        // toView를 addSubview 하는 순간 Keyboard가 Dismiss 되는 이슈가 있음.
        // KeybaordWindow가 있을 경우엔 Capture를 해서 Transition함.
        // 위의 방식으로 Transition 진행 중엔 실시간으로 ChatsView update가 반영안되는 문제가 생길수 있음.
        var captureView: UIImageView?
        let keyboardWindow = UIApplication.shared.keyboardWindow
        if let keyboardWindow = keyboardWindow {
            let imageView = UIImageView(frame: toViewController.view.frame)
            imageView.backgroundColor = UIColor.blue
            imageView.image = toViewController.view.capture()
            containerView.addSubview(imageView)
            captureView = imageView
            
            toViewController.view.removeFromSuperview()
            keyboardWindow.becomeFirstResponder()
        }
        
        let tabBarController = fromViewController.tabBarController
        let tabBar = tabBarController?.tabBar
        let wasTabBarHidden = tabBar?.isHidden ?? false
        
        let tabBarImageView = UIImageView(frame: tabBar?.frame ?? .zero)
        tabBarImageView.image = tabBar?.capture()
        
        if fromViewController.hidesBottomBarWhenPushed {
            tabBar?.isHidden = true
            tabBarImageView.frame = CGRect(x: -tabBarImageView.width.divide(3),
                                           y: tabBarImageView.y,
                                           width: tabBarImageView.width,
                                           height: tabBarImageView.height)
            containerView.addSubview(tabBarImageView)
        }
        
        if let view = fromViewController.view {
            containerView.addSubview(view)
        }
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0.0,
            options: .curveLinear,
            animations: {
                if let fromNavigationBar = fromNavigationBar,
                   let toNavigaionController = toNavigaionController,
                   toNavigaionController.isNavigationBarHidden {
                    fromNavigationBar.x = fromNavigationBar.width
                    fromNavigationBar.alpha = 1
                }
                
                fromViewController.view.x = fromViewController.view.width
                toViewController.view.frame = finalFrameForToViewController
                
                if let captureView = captureView {
                    captureView.frame = finalFrameForToViewController
                }
                
                if let inputView = fromViewController.inputAccessoryView {
                    inputView.frame = CGRect(x: inputView.width,
                                             y: inputView.y,
                                             width: inputView.width,
                                             height: inputView.height)
                }
                
                if fromViewController.hidesBottomBarWhenPushed {
                    tabBarImageView.x = 0
                }
                
                if let keyboardWindow = keyboardWindow {
                    keyboardWindow.x = keyboardWindow.width
                }
                
                if !transitionContext.isInteractive,
                   let splitViewController = fromViewController.splitViewController {
                    let childViewControllers = splitViewController.children
                    if childViewControllers.count > 1 {
                        let splitSecondaryViewController = childViewControllers[1]
                        if splitSecondaryViewController.children.count <= 1 {
                            if splitViewController.displayMode != .oneBesideSecondary {
                                splitViewController.preferredDisplayMode = .oneBesideSecondary
                            }
                        }
                    }
                }
            }, completion: { [weak self] _ in
                let success = !transitionContext.transitionWasCancelled
                
                if success == true {
                    if let view = toViewController.view {
                        containerView.addSubview(view)
                    }
                } else {
                    toViewController.view.removeFromSuperview()
                }
                
                if let captureView = captureView {
                    captureView.removeFromSuperview()
                }
                
                if success, let inputAccessoryView = fromViewController.inputAccessoryView {
                    inputAccessoryView.removeFromSuperview()
                }
                
                if let tabBar = tabBar,
                   fromViewController.hidesBottomBarWhenPushed && wasTabBarHidden == false {
                    tabBar.isHidden = false
                }
                
                transitionContext.completeTransition(success)
                
                // iOS 12.1.1 테마적용 시 챗방에서 목록으로 나올 때 backgroundView height가 줄어듬
                // - [transitionContext completeTransition:success]; 호출 후 tabBarController.view 의 height가 줄어들어서
                // superview height로 변경 후 layoutIfNeeded 호출함
                // tabBarController?.view.height = tabBarController?.view.superview?.height ?? 0
                if let tabBarController = tabBarController {
                    tabBarController.view.layoutIfNeeded()
                }
                
                if success {
                    self?.transitionCompleteBlock?(toViewController)
                }
            }
        )
    }
}
