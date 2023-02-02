//
//  KINavigationController.swift
//  Genie
//
//  Created by 조승보 on 2022/04/14.
//

import UIKit

protocol CustomPopGestureResignFirstResponser {
}

protocol CustomPopGestureShouldReceiveTouch {
}

protocol AnimationTransitCheckable where Self: UIViewController {
    var onTransitionAnimating: Bool { get }
    func pushCompleted()
    func presentCompleted()
}

@available(iOS 13.0, *)
public class KINavigationController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    private struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 40
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 20
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 0
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 6
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 32
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 44
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
        
        static let ImageGap: CGFloat = 2
    }

    @objc private var customPopGestureRecognizer: UIPanGestureRecognizer!
    private var customTransition: CustomPopTransition = CustomPopTransition()

    private var isPopGestureAllow = true
    private var cancelsTouchesInView: Bool?
    private var onTransitionAnimating = false
    private var keyboardWillHide = false

    private var interactivePopTransition: UIPercentDrivenInteractiveTransition?

    private var rightButtons: [UIButton] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareCustomPop()
        setUI()
    }
        
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onTransitionAnimating = true
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onTransitionAnimating = false
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        onTransitionAnimating = false
    }
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onTransitionAnimating = true
    }

    public func addRightButton(button: UIButton, at: Int = 0) {

        button.tintColor = UIColor.textColor
        
        navigationBar.addSubview(button)
        button.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.rightAnchor.constraint(equalTo: navigationBar.rightAnchor,
                                             constant: -(Const.ImageRightMargin + Const.ImageGap * CGFloat(at) + Const.ImageSizeForLargeState * CGFloat(at))),
            button.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                              constant: -Const.ImageBottomMarginForLargeState),
            button.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            button.widthAnchor.constraint(equalTo: button.heightAnchor)
            ])

        rightButtons.append(button)
    }
    
    public func addLeftButton(button: UIButton, at: Int = 0) {

        button.tintColor = UIColor.textColor
        
        navigationBar.addSubview(button)
        button.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leftAnchor.constraint(equalTo: navigationBar.leftAnchor,
                                             constant: (Const.ImageRightMargin + Const.ImageGap * CGFloat(at) + Const.ImageSizeForLargeState * CGFloat(at))),
            button.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                              constant: -Const.ImageBottomMarginForLargeState),
            button.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            button.widthAnchor.constraint(equalTo: button.heightAnchor)
            ])

        rightButtons.append(button)
    }
    
    public func addLeftView(view: UIView, at: Int = 0) {

        navigationBar.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: navigationBar.leftAnchor,
                                             constant: (Const.ImageRightMargin + Const.ImageGap * CGFloat(at) + Const.ImageSizeForLargeState * CGFloat(at))),
            view.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                              constant: -Const.ImageBottomMarginForLargeState),
            view.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            ])
    }

    public func showRightButtons() {
        rightButtons.forEach { $0.isHidden = false }
    }
    
    public func hideRightButtons() {
        rightButtons.forEach { $0.isHidden = true }
    }
    
    private func prepareCustomPop() {
        
        customPopGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanRecognizer(_:)))
        customPopGestureRecognizer.delegate = self
        if let cancelsTouchesInView = self.cancelsTouchesInView {
            customPopGestureRecognizer.cancelsTouchesInView = cancelsTouchesInView
        }
        
        customTransition.transitionCompleteBlock = { toViewController in
            if toViewController?.hidesBottomBarWhenPushed ?? false {
                return
            }
        }
        
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setUI() {
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textColor]
    }

    @objc
    func handlePanRecognizer(_ sender: UIPanGestureRecognizer?) {
        guard let panGestureRecognizer = sender else {
            return
        }
        let velocity = panGestureRecognizer.velocity(in: view)
        let translation = panGestureRecognizer.translation(in: view)
        var progress: CGFloat = translation.x / view.bounds.size.width
        progress = min(1.0, max(0, progress))
        if panGestureRecognizer.state == .began {
            if velocity.x <= 100 {
                return
            }
            if viewControllers.last is CustomPopGestureResignFirstResponser {
                viewControllers.last?.resignFirstResponder()
            }
            interactivePopTransition = UIPercentDrivenInteractiveTransition()
            popViewController(animated: true)
        } else if panGestureRecognizer.state == .changed {
            interactivePopTransition?.update(progress)
        } else if panGestureRecognizer.state == .ended || panGestureRecognizer.state == .cancelled {
            let endPoint = panGestureRecognizer.location(in: view)
            let finishOption: Bool = (progress > 0.1 && velocity.x > 500.0 || (progress > 0.3 && (endPoint.x / view.width) > 0.95))
            if progress > 0.5 || finishOption {
                interactivePopTransition?.finish()
            } else {
                interactivePopTransition?.cancel()
            }
            interactivePopTransition = nil
        } else {
            interactivePopTransition?.cancel()
            interactivePopTransition = nil
        }
    }
    
    private func addPanGesture(_ viewController: UIViewController) {
        
        // 예외처리
        if viewController is UITableViewController {
            return
        }

        if let gestureRecognizer = customPopGestureRecognizer {
            viewController.view.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    private func isInteractivePopGestureWorking() -> Bool {
        let isInteractivePopGestureWorking: Bool = interactivePopGestureRecognizer?.state == .began ||
            interactivePopGestureRecognizer?.state == .changed ||
            interactivePopGestureRecognizer?.state == .ended
        return isInteractivePopGestureWorking
    }

    private func enableSwipeBack() {
        interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func disableSwipeBack() {
        interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func isCustomPopGestureWorking() -> Bool {
        if isInteractivePopGestureWorking() {
            return false
        }
        if responds(to: #selector(getter: KINavigationController.customPopGestureRecognizer)) {
            let isCustomPopGestureWorking: Bool = customPopGestureRecognizer?.state == .began || customPopGestureRecognizer?.state == .changed || customPopGestureRecognizer?.state == .ended
            return isCustomPopGestureWorking
        }
        return false
    }
    
    private func backButtonItem() -> UIBarButtonItem {
        return backButtonItem(target: self, action: #selector(backButtonClicked(_:)))
    }

    private func backButtonItem(target: Any, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(title: "Back",
                               style: .plain,
                               target: target,
                               action: action)
    }

    @objc
    func backButtonClicked(_ sender: UIButton? = nil) {
        popViewController(animated: true)
    }
    
    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.navigationItem.setLeftBarButton(backButtonItem(), animated: true)
        }
        
        disableSwipeBack()
        
        var completion: (() -> Void)?
        if let animationTransitCheckable = viewController as? AnimationTransitCheckable {
            weak var weakAnimationTransitCheckable = animationTransitCheckable
            completion = { [weak self] in
                self?.addPanGesture(viewController)
                weakAnimationTransitCheckable?.pushCompleted()
            }
        }
        if completion != nil {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            super.pushViewController(viewController, animated: animated)
            CATransaction.commit()
        } else {
            super.pushViewController(viewController, animated: animated)
            addPanGesture(viewController)
        }
    }

    // MARK: - GetstureRecognizer
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if !isPopGestureAllow || onTransitionAnimating {
            return false
        }
        if gestureRecognizer == interactivePopGestureRecognizer {
            if viewControllers.count == 0 {
                return false
            }
            if viewControllers[0] == visibleViewController {
                return false
            }
        }
        if gestureRecognizer == customPopGestureRecognizer && keyboardWillHide {
            return false
        }
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == customPopGestureRecognizer {
            return (touch.view is CustomPopGestureShouldReceiveTouch) == false
        }
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if !isPopGestureAllow || onTransitionAnimating {
            return false
        }
        if gestureRecognizer == customPopGestureRecognizer {
            if let panGestureRecognizer = otherGestureRecognizer as? UIPanGestureRecognizer, gestureRecognizer.view is UITableView {
                let velocity = panGestureRecognizer.velocity(in: panGestureRecognizer.view)
                if abs(velocity.x) < abs(velocity.y) {
                    return true
                }
            } else if NSStringFromClass(otherGestureRecognizer.classForCoder) == "_UISwipeActionPanGestureRecognizer" {
                return true
            } else if let screenEdgeGestureRecognizer = otherGestureRecognizer as? UIScreenEdgePanGestureRecognizer {
                if screenEdgeGestureRecognizer.edges == .right {
                    return true
                }
            }
        }
        if gestureRecognizer == interactivePopGestureRecognizer && (otherGestureRecognizer is UIPanGestureRecognizer) {
            otherGestureRecognizer.require(toFail: gestureRecognizer)
            return true
        }
        return false
    }

    // MARK: - UINavigationControllerDelegate
    open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated animate: Bool) {

        enableSwipeBack()
        if viewControllers.count > 1 && viewControllers.last == viewController {
            addPanGesture(viewController)
        }

        if viewControllers.count == 1 {
            if viewController.hidesBottomBarWhenPushed == false {
                if customPopGestureRecognizer != nil && isCustomPopGestureWorking() {
                    return
                }
            }
        }
    }
    
    public func navigationController(_ navigationController: UINavigationController,
                                     animationControllerFor operation: UINavigationController.Operation,
                                     from fromVC: UIViewController,
                                     to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop && customPopGestureRecognizer?.state == .began {
            return customTransition
        } else {
            return nil
        }
    }
    
    public func navigationController(_ navigationController: UINavigationController,
                                     interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController is CustomPopTransition {
            return interactivePopTransition
        } else {
            return nil
        }
    }
}
