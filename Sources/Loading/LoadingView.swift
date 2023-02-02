//
//  LoadingView.swift
//  KICommon
//
//  Created by 조승보 on 2022/05/02.
//

import UIKit
import Lottie

public final class LoadingView: UIView {
    
    static let indicatorWidth: CGFloat = 60.0
    static let defaultFrame: CGRect = CGRect(x: 0, y: 0, width: LoadingView.indicatorWidth, height: LoadingView.indicatorWidth)
    
    private let animationView: AnimationView = .init(name: "loading", bundle: Bundle.Common)
    private var loadingTask: DispatchWorkItem?
    public static let loadingView: LoadingView = LoadingView(frame: LoadingView.defaultFrame)
    
    deinit {
        KILogger.info("LoadingView deinit")
    }
    
    public static func show(animated: Bool = true,
                            delay: TimeInterval = .zero,
                            dimmed: Bool = false,
                            userInteraction: Bool = true,
                            parentView: UIView? = nil) {

        loadingView.removeLoadingTask()
        loadingView.loadingTask = DispatchWorkItem {
            
            let keywindow = UIApplication.shared.keyWindow
            loadingView.show(animated: animated, parentView: keywindow)
            
            KILogger.info("LoadingView show")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if let task = loadingView.loadingTask {
                if Thread.isMainThread && delay == .zero {
                    task.perform()
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: task)
                }
            }
        }
    }
    
    private func removeLoadingTask() {
        if loadingTask != nil {
            loadingTask?.cancel()
            loadingTask = nil
        }
    }
    
    private func show(animated: Bool, parentView: UIView?) {
        
        guard let parentView = parentView else { return }

        self.center = parentView.center
        self.backgroundColor = .lightGray.withAlphaComponent(0.1)
        
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 1.0
        animationView.play()
        animationView.frame = self.bounds
        self.addSubview(animationView)
        self.roundView()
        
        if animated {
            self.alpha = 0.0
            parentView.addSubview(self)
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.alpha = 1.0
            })
        } else {
            parentView.addSubview(self)
        }
    }
    
    public static func hide(animated: Bool = true) {
        
        KILogger.info("LoadingView hide")
        loadingView.removeLoadingTask()
        loadingView.hide(animated: animated)
    }
    
    private func hide(animated: Bool = true) {
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.alpha = 0.0
            }, completion: { [weak self] _ in
                self?.removeFromSuperview()
            })
        } else {
            removeFromSuperview()
        }
    }
}
