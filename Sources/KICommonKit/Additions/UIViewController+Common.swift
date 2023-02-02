//
//  UIViewController+Common.swift
//  KICommon
//
//  Created by 조승보 on 2022/05/26.
//

import UIKit

public protocol ChildrenTopVisibleCheckDisabling {
}

@available(iOS 13.0, *)
extension UIViewController {
    
    public class var topViewController: UIViewController? {

        let mainWindow = UIApplication.shared.keyWindow
        let rootViewController: UIViewController? = mainWindow?.rootViewController
        if rootViewController == nil {
            KILogger.error("topViewController : rootViewController is nil")
        }
        return rootViewController?.topVisibleViewController
    }

    public var topVisibleViewController: UIViewController? {
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.topVisibleViewController
        } else if let navigationController = self as? UINavigationController {
            if navigationController.visibleViewController != nil {
                return navigationController.visibleViewController?.topVisibleViewController
            } else {
                if presentedViewController != nil {
                    return presentedViewController?.topVisibleViewController
                }
            }
        } else if let splitViewController = self as? UISplitViewController {
            if splitViewController.isCollapsed {
                return splitViewController.viewControllers.first?.topVisibleViewController
            } else {
                return splitViewController.viewControllers.last?.topVisibleViewController
            }
        } else if presentedViewController != nil {
            return presentedViewController?.topVisibleViewController
        } else if self is ChildrenTopVisibleCheckDisabling == false && children.count > 0 {
            return children.last?.topVisibleViewController
        }
        return self
    }

    public var topVisibleViewControllerWithoutPresented: UIViewController? {
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.topVisibleViewControllerWithoutPresented
        } else if let navigationController = self as? UINavigationController {
            if let lastViewController = navigationController.viewControllers.last {
                return lastViewController.topVisibleViewControllerWithoutPresented
            } else {
                // do nothing
            }
        } else if let splitViewController = self as? UISplitViewController {
            if splitViewController.isCollapsed {
                return splitViewController.viewControllers.first?.topVisibleViewControllerWithoutPresented
            } else {
                return splitViewController.viewControllers.last?.topVisibleViewControllerWithoutPresented
            }
        } else if self is ChildrenTopVisibleCheckDisabling == false && children.count > 0 {
            return children.last?.topVisibleViewControllerWithoutPresented
        }
        return self
    }
}

