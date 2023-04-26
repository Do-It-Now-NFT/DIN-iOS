//
//  Target+Extension.swift
//  ProjectDescriptionHelpers
//
//  Created by 이동희 on 2023/04/26.
//

import ProjectDescription

public extension Target {
    static func makeFrameworkTargets(
      name: String,
      isDynamic: Bool,
      infoPlist: [String: InfoPlist.Value] = [:],
      settings: [String: SettingValue] = [:],
      dependencies: [TargetDependency],
      needTestTarget: Bool
    ) -> [Target] {
      var result: [Target] = []
      
      let defaultSettings: [String: SettingValue] = ["DEVELOPMENT_TEAM": "FDUY4T9LLB"]
      
      result.append(Target(
        name: name,
        platform: .iOS,
        product: isDynamic ? .framework : .staticFramework,
        productName: name,
        bundleId: "com.din.\(name)",
        deploymentTarget: .iOS(targetVersion: "14.0", devices: .iphone),
        infoPlist: .extendingDefault(with: infoPlist),
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        dependencies: dependencies,
        settings: .settings(base: .merging(settings, defaultSettings), configurations: [], defaultSettings: .recommended)
      ))
      
      if needTestTarget {
        result.append(
          Target(
            name: "\(name)Tests",
            platform: .iOS,
            product: .unitTests,
            productName: "\(name)Tests",
            bundleId: "com.din.\(name)Tests",
            deploymentTarget: .iOS(targetVersion: "14.0", devices: .iphone),
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [.target(name: name)],
            settings: .settings(base: .merging(settings, defaultSettings), configurations: [], defaultSettings: .recommended)
          )
        )
      }
      
      return result
    }
}
