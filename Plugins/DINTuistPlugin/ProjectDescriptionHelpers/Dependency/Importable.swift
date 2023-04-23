//
//  Importable.swift
//  DINTuistPlugin
//
//  Created by 이동희 on 2023/04/23.
//

import Foundation
import ProjectDescription

/// Project Dependency 목록
public protocol DependencyGroup {
    /// tuist fetch 통해 프로젝트로 변환시키는 라이브러리들
    var fetchedPacakges: [FetchedPackage]? { get set }
    
    /// SwiftPM 통해 추가되는 라이브러리들
    var managedPacakges: [ManagedPackage]? { get set }
    
    var xcframeworks: [XCFramework]? { get set }
    
    var projectTargets: [ProjectTarget]? { get set }
}

/// 참조하는 모듈 단위
public protocol Importable {
  /// 모듈 프로젝트 이름
  var name: String { get }
  
  /// 모듈 경로
  var path: ImportablePath { get }
  
  /// 하위 모듈
  var subModuleNames: [String]? { get }
}

public extension Importable {
  /// 로컬 추가 플래그
  var isLocalImported: Bool { path.isLocal }
}

/// Swift Package Manager로 관리될 수 있는 패키지
public protocol SwiftPackagible {
  func convertToProjectPackage() -> Package
}

/// Target 의존성
public protocol TargetDependencible {
  func convertToTargetDependencies() -> [TargetDependency]
}

/// URL, Path 둘 다 호환되도록하는 Path
public struct ImportablePath: Hashable {
  
  public var url: String!
  
  public var localPath: Path!
  
  public var isLocal: Bool
  
  public init(url: String) {
    self.url = url
    self.isLocal = false
  }
  
  public init(path: Path) {
    self.localPath = path
    self.isLocal = true
  }
}

public class SwiftPackage: Importable, SwiftPackagible {
  public var name: String
  public var path: ImportablePath
  public var subModuleNames: [String]?
  public var version: Package.Requirement?
  
  public init(name: String, path: ImportablePath, subModuleNames: [String]? = nil, version: Package.Requirement? = nil) {
    self.name = name
    self.path = path
    self.subModuleNames = subModuleNames
    self.version = version
  }
  
  public func convertToProjectPackage() -> ProjectDescription.Package {
    return isLocalImported ? Package.local(path: path.localPath) : Package.remote(url: path.url, requirement: version!)
  }
}

public class FetchedPackage: SwiftPackage, TargetDependencible {
  public func convertToTargetDependencies() -> [ProjectDescription.TargetDependency] {
    if let subModuleNames {
      return subModuleNames.map { .external(name: $0) }
    } else {
      return [.external(name: name)]
    }
  }
}

public class ManagedPackage: SwiftPackage, TargetDependencible {
  public func convertToTargetDependencies() -> [ProjectDescription.TargetDependency] {
    if let subModuleNames {
      return subModuleNames.map { .package(product: $0) }
    } else {
      return [.package(product: name)]
    }
  }
}

public class XCFramework: Importable, TargetDependencible {
  public var name: String
  
  public var path: ImportablePath
  
  public var subModuleNames: [String]?
  
  public init(name: String, path: ImportablePath, subModuleNames: [String]? = nil) {
    self.name = name
    self.path = path
    self.subModuleNames = subModuleNames
  }
  
  public func convertToTargetDependencies() -> [ProjectDescription.TargetDependency] {
    return [.xcframework(path: path.localPath)]
  }
}

public class ProjectTarget: Importable, TargetDependencible {
  public var name: String
  
  public var path: ImportablePath
  
  public var subModuleNames: [String]?
  
  public init(name: String, path: ImportablePath, subModuleNames: [String]? = nil) {
    self.name = name
    self.path = path
    self.subModuleNames = subModuleNames
  }
  
  public func convertToTargetDependencies() -> [ProjectDescription.TargetDependency] {
    if let subModuleNames {
      return subModuleNames.map { .project(target: $0, path: path.localPath) }
    } else {
      return [.project(target: name, path: path.localPath)]
    }
  }
}
