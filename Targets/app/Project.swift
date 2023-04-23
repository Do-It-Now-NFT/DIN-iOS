import Foundation
import ProjectDescription
import ProjectDescriptionHelpers
import DINTuistPlugin

// MARK: - Summery
private let productName: String = "DOITNOW"
private let projectName: String = "do-it-now"
private let organizationName = "DIN"
private var buildVersion: String = {
  let now = Date()
  let dataFormatter = DateFormatter()
  dataFormatter.dateFormat = "YYMMddHHmm"
  return "\(dataFormatter.string(from: now))009"
}()

private let prodVersion: String = "1.0.0"

private let bundleId = "com.din.ios.do-it-now"

public let appBaseInfoPlist: [String: InfoPlist.Value] = [
    "UIMainStoryboardFile": "",
    "UILaunchStoryboardName": "LaunchScreen",
    "CFBundleShortVersionString": "\(prodVersion)",
    "CFBundleVersion": "\(buildVersion)",
    "NSAppTransportSecurity":     [
      "NSAllowsArbitraryLoads": true,
      "NSAllowsArbitraryLoadsInWebContent": true
    ],
    "UISupportedInterfaceOrientations": [
      "UIInterfaceOrientationPortrait"
    ],
    "CFBundleURLTypes": [
      [
        "CFBundleTypeRole" : "Viewer",
        "CFBundleURLName" : "com.din.ios.do-it-now"
      ]
    ],
    "UIBackgroundModes": [
      "remote-notification"
    ],
    //  "NSSupportsLiveActivities": true, // 라이브액티비티 지원.
    "UIUserInterfaceStyle": "Light",  // 앱 라이트모드로 강제
]

public var baseSettings: [String: SettingValue] = [
  "GCC_PREPROCESSOR_DEFINITIONS" : "FLEXLAYOUT_SWIFT_PACKAGE=1",
  "CURRENT_PROJECT_VERSION": "\(buildVersion)", // 빌드
  "MARKETING_VERSION": "\(prodVersion)", // 버전
  "DEVELOPMENT_TEAM": "FDUY4T9LLB",
  "ENABLE_BITCODE": "NO", // SWFramework 설정,
  "CODE_SIGN_STYLE": "Automatic",
  "OTHER_LDFLAGS": "-ObjC" // Firebase 설정
]

public let actionSettings: [String: SettingValue] = [
  "CODE_SIGN_STYLE": "Manual",
  "PROVISIONING_PROFILE_SPECIFIER": "match Development \(bundleId)",
]

public let localSettings: [String: SettingValue] = [
  "OTHER_SWIFT_FLAGS": "-D LOCAL",
  "EXCLUDED_SOURCE_FILE_NAMES": "${PROJECT_DIR}/Resources/Settings.bundle" // Setting Bundle 포함안함.
]

public let releaseSettings: [String: SettingValue] = [
  "OTHER_SWIFT_FLAGS": "-D RELEASE",
  "EXCLUDED_SOURCE_FILE_NAMES": "${PROJECT_DIR}/Resources/Settings.bundle" // Setting Bundle 포함안함.
]

public let stageSettings: [String: SettingValue] = [
  "OTHER_SWIFT_FLAGS": "-D STAGE"
]

public let devSettings: [String: SettingValue] = [
  "OTHER_SWIFT_FLAGS": "-D DEV"
]

let endpoint = EndPoint(rawValue: ProcessInfo.processInfo.environment["TUIST_ENDPOINT"])

public var settings: Settings = {

  lazy var debugSchemeSettings: SettingsDictionary = {
    switch endpoint {
    case .Local, .Debug:
      return localSettings
    case .Dev:
      return .merging(devSettings, localSettings)
    case .Release:
      return releaseSettings
    }
  }()
  
  lazy var releaseSchemeSettings: SettingsDictionary = {
    switch endpoint {
    case .Local, .Debug:
      return .merging(releaseSettings, actionSettings)
    case .Release:
      return .merging(releaseSettings, actionSettings)
    case .Dev:
      return .merging(devSettings, actionSettings)
    }
  }()

  return .settings(
      base: baseSettings,
      configurations: [
        .debug(name: "Debug", settings: debugSchemeSettings),
        .release(name: "Release", settings: releaseSchemeSettings)
      ],
      defaultSettings: .recommended
  )
}()

let myappDependencyGroup = DINDependencyGroup()

let appTarget = Target(
    name: "\(projectName)-app",
    platform: .iOS,
    product: .app,
    productName: productName,
    bundleId: bundleId,
    deploymentTarget: .iOS(targetVersion: "14.0", devices: .iphone),
    infoPlist: .extendingDefault(with: appBaseInfoPlist),
//    sources: ["Sources/**", "RidingWidgetFoundation/**"],
    sources: ["Sources/**"],
    resources: [
      .glob(pattern: .relativeToManifest("Resources/**"), excluding: [.relativeToManifest([.Dev].contains(endpoint) ? "": "Resources/Settings.bundle")])
    ],
    copyFiles: nil,
//    entitlements: "com.test.ios.myapp.entitlements",
    dependencies: DependencyResolver.generateAppTargetDependencies(by: myappDependencyGroup),
    settings: settings,
    environment: ["OS_ACTIVITY_MODE": "disable"] // 불필요 로그 제거
)

var project = Project(
  name: projectName,
  organizationName: organizationName,
  options: .options(
    automaticSchemesOptions: .enabled(codeCoverageEnabled: true),
    textSettings: .textSettings(usesTabs: true, indentWidth: 2, tabWidth: 2)
  ),
  packages: DependencyResolver.generateProjectImportPackages(by: myappDependencyGroup),
  settings: settings,
  targets: [appTarget]
)

