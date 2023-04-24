import ProjectDescription
import DINTuistPlugin

let setting: Settings = .settings(base: [
    "GCC_PREPROCESSOR_DEFINITIONS" : "FLEXLAYOUT_SWIFT_PACKAGE=1", // Flexlayout 설정
    "OTHER_LDFLAGS": "-ObjC -all_load", // Firebase 설정
    "IPHONEOS_DEPLOYMENT_TARGET": "14.0"
    ]
)

var dinDevelopKit = Target(
    name: "DINDevelopKit",
    platform: .iOS,
    product: .framework,
    productName: "DINDevelopKit",
    bundleId: "com.din.DINDevelopKit",
    deploymentTarget: .iOS(targetVersion: "14.0", devices: .iphone),
    infoPlist: .default,
    sources: [],
    resources: [],
    dependencies:
        DependencyResolver.generateAppTargetDependencies(by: DINDevelopKitDependencyGroup())
)

var dinTestKit = Target(
    name: "DINTestKit",
    platform: .iOS,
    product: .framework,
    productName: "DINTestKit",
    bundleId: "com.din.DINTestKit",
    deploymentTarget: .iOS(targetVersion: "14.0", devices: .iphone),
    infoPlist: .default,
    sources: ["Sources/**"],
    resources: [],
    dependencies: DependencyResolver.generateAppTargetDependencies(by: DINTestKitDependencyGroup())
    )
    

var project = Project(
    name: "DINDependencyKit",
    organizationName: "DIN",
    packages: DependencyResolver.generateProjectImportPackages(by: DINDevelopKitDependencyGroup(), DINTestKitDependencyGroup()),
    settings: setting,
    targets: [dinDevelopKit, dinTestKit]
)

