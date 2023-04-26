//
//  PackageGroup.swift
//  ProjectDescriptionHelpers
//
//  Created by 이동희 on 2023/04/23.
//

import Foundation
import ProjectDescription
import DINTuistPlugin

@frozen public enum EndPoint: String {
    case Dev, Release, Local
    case Debug // 개발자 모드
    
    public init(rawValue: String?) {
        switch rawValue {
        case "DEV": self = .Dev
        case "RELEASE": self = .Release
        case "DEBUG": self = .Debug
        case "LOCAL", .none: self = .Local
        default: self = Self.Local
        }
    }
    
    public var needsDebugTools: Bool {
        return [.Debug].contains(self)
    }
}

public class DINDependencyGroup: DependencyGroup {
    let endpoint = EndPoint(rawValue: ProcessInfo.processInfo.environment["TUIST_ENDPOINT"])
    
    // 디버깅 패키지
    let debugerPackages: [DINTuistPlugin.ManagedPackage] = [
      .init(name: "FLEX", path: .init(url: "https://github.com/FLEXTool/FLEX"), version: .exact("5.22.10")),
      .init(name: "Inject", path: .init(url: "https://github.com/krzysztofzablocki/Inject.git"), version: .branch("main")),
      .init(name: "LookinServer", path: .init(url: "https://github.com/QMUI/LookinServer"), version: .exact("1.1.4")),
    ]
    
    public init(fetchAll: Bool = false) {
      if fetchAll { managedPacakges?.append(contentsOf: debugerPackages) }
      else if endpoint.needsDebugTools { managedPacakges?.append(contentsOf: debugerPackages) }
      
      if endpoint != .Release {
        managedPacakges?.append(.init(name: "Pulse", path: .init(url: "https://github.com/kean/Pulse.git"), subModuleNames: ["Pulse", "PulseUI"], version: .upToNextMajor(from: "3.0.0")))
      }
    }

    
    public var fetchedPacakges: [DINTuistPlugin.FetchedPackage]?
    
    public var managedPacakges: [DINTuistPlugin.ManagedPackage]? = []
    
    public var xcframeworks: [DINTuistPlugin.XCFramework]?
    
    public var projectTargets: [DINTuistPlugin.ProjectTarget]? = [
        .init(name: "DINDependencyKit", path: .init(path: .relativeToRoot("Plugins/DINTuistPlugin/DINDependencyKit")), subModuleNames: ["DINDevelopKit"]),
        .init(name: "DINOAuth", path: .init(path: .relativeToManifest("../DINOAuth")))
    ]
}

public class DINOAuthDependencyGroup: DependencyGroup {
    public init() {}
    
    public var fetchedPacakges: [DINTuistPlugin.FetchedPackage]? = [
        
    ]
    
    public var managedPacakges: [DINTuistPlugin.ManagedPackage]? = [
        .init(name: "GoogleSignIn", path: .init(url: "https://github.com/google/GoogleSignIn-iOS"), version: .exact("6.0.0"))
    ]
    
    public var xcframeworks: [DINTuistPlugin.XCFramework]?
    
    public var projectTargets: [DINTuistPlugin.ProjectTarget]?
}
