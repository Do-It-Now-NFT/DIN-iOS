//
//  DependencyKitDependencyGroup.swift
//  DINTuistPlugin
//
//  Created by 이동희 on 2023/04/23.
//

import ProjectDescription

open class DINDevelopKitDependencyGroup: DependencyGroup {
    public var fetchedPacakges: [FetchedPackage]? = [
        .init(name: "Swinject", path: .init(url: "https://github.com/Swinject/Swinject.git"), subModuleNames: ["Swinject"], version: .exact("2.8.1")),
        .init(name: "SwinjectAutoregistration", path: .init(url: "https://github.com/Swinject/SwinjectAutoregistration.git"), subModuleNames: ["SwinjectAutoregistration"], version: .exact("2.8.1")),
        .init(name: "Lottie", path: .init(url: "https://github.com/airbnb/lottie-ios.git"), subModuleNames: ["Lottie"], version: .exact("3.2.1")),

    ]
    
    public var managedPacakges: [ManagedPackage]? = [
        .init(name: "Moya", path: .init(url: "https://github.com/Moya/Moya.git"), subModuleNames: ["Moya", "Alamofire", "RxMoya"], version: .exact("15.0.0")),
        .init(name: "RxCocoa", path: .init(url: "https://github.com/ReactiveX/RxSwift.git"), version: .exact("6.5.0")),
        .init(name: "RxGesture", path: .init(url: "https://github.com/RxSwiftCommunity/RxGesture"), subModuleNames: ["RxGesture"], version: .exact("4.0.3")),
        .init(name: "Nuke", path: .init(url: "https://github.com/kean/Nuke"), subModuleNames: ["Nuke"], version: .exact("10.6.1")),
        .init(name: "FlexLayout", path: .init(url: "https://github.com/layoutBox/FlexLayout"), subModuleNames: ["FlexLayout"], version: .exact("1.3.25")),
        .init(name: "Then", path: .init(url: "https://github.com/devxoul/Then"), subModuleNames: ["Then"],version: .exact("3.0.0")),
        .init(name: "SnapKit", path: .init(url: "https://github.com/SnapKit/SnapKit"), subModuleNames: ["SnapKit"], version: .exact("5.6.0")),
        .init(name: "Hero", path: .init(url: "https://github.com/HeroTransitions/Hero.git"), subModuleNames: ["Hero"], version: .exact("1.6.2")),
        .init(name: "PinLayout", path: .init(url: "https://github.com/layoutBox/PinLayout"), subModuleNames: ["PinLayout"], version: .exact("1.10.3"))
    ]
    
    public var xcframeworks: [XCFramework]?
    
    public var projectTargets: [ProjectTarget]?
    
    public init() {}
}

open class DINTestKitDependencyGroup: DependencyGroup {
    public var fetchedPacakges: [DINTuistPlugin.FetchedPackage]? = [
      .init(name: "Nimble", path: .init(url: "https://github.com/Quick/Nimble.git"), version: .exact("10.0.0")),
    ]
    
    public var managedPacakges: [DINTuistPlugin.ManagedPackage]? = [
      .init(name: "RxSwift", path: .init(url: "https://github.com/ReactiveX/RxSwift.git"), subModuleNames: ["RxTest", "RxBlocking"], version: .exact("6.5.0")),
    ]
    
    public var xcframeworks: [XCFramework]?
    
    public var projectTargets: [ProjectTarget]?
    
    public init() {}
}

