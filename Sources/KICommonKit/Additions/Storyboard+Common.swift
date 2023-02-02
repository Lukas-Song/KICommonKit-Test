//
//  Storyboard+Common.swift
//  Genie
//
//  Created by 조승보 on 2022/03/22.
//

import UIKit

public enum Target {
    case vietnam
    case indonesia
}

public enum GenieStoryBoard: String {
    
    case home = "Home"
    case search = "Search"
    case discover = "Discover"
    case portfolio = "Portfolio"
    case invest = "Invest"
    case assets = "Assets"
    case more = "More"
    case login = "Login"
    case stock = "Stock"
    case common = "Common"
    case detail = "Detail"
}

public protocol StoryboardInstantiable: NSObjectProtocol {
    
    associatedtype ViewController
    associatedtype ViewModel
    static func instantiateViewController(in storyboard: GenieStoryBoard, target: Target) -> ViewController
    static func create(with viewModel: ViewModel) -> ViewController
}

public extension StoryboardInstantiable where Self: UIViewController {
    
    static func instantiateViewController(in storyboard: GenieStoryBoard, target: Target) -> Self {
        
        let bundle: Bundle = target == .vietnam ? Bundle(identifier: "com.lovelyhoy.Vietnam")! : Bundle(identifier: "com.lovelyhoy.Indonesia")!
        
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: bundle)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "\(Self.self)") as? Self else {
            fatalError("🚫 Fail to instantiate UIViewController [\(Self.self)] from Storyboard [\(storyboard)]")
        }
        return viewController
    }
}
