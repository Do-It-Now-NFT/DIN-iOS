import ProjectDescription
import ProjectDescriptionHelpers
import DINTuistPlugin

let dinOAuthDependencyGroup = DINOAuthDependencyGroup()


let appTarget = Target(
    name: "DINOAuth",
    platform: .iOS,
    product: .staticFramework,
    productName: "Do_It_Now_OAuth",
    bundleId: "com.dinOAuth.ios.do-it-now",
    deploymentTarget: .iOS(targetVersion: "14.0", devices: [.iphone]),
    infoPlist: .default,
    sources: ["Sources/**"],
    dependencies: DependencyResolver.generateAppTargetDependencies(by: dinOAuthDependencyGroup),
    environment: ["OS_ACTIVITY_MODE": "disable"] // 불필요 로그 제거
)

let project = Project(
    name: "DINOAuth",
    organizationName: "DIN",
    packages: DependencyResolver.generateProjectImportPackages(by: dinOAuthDependencyGroup),
    targets: [appTarget]
)
