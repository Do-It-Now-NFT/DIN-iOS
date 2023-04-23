//
//  DependencyResolver.swift
//  DINTuistPlugin
//
//  Created by 이동희 on 2023/04/23.
//

import Foundation
import ProjectDescription

open class DependencyResolver {
    /// 타겟 의존성 리스트 생성
    public static func generateAppTargetDependencies(by dependencyGroups: DependencyGroup...) -> [TargetDependency] {
        return dependencyGroups
            .map { dependencyGroups -> [[TargetDependencible]?] in
                return [
                    dependencyGroups.fetchedPacakges,
                    dependencyGroups.managedPacakges,
                    dependencyGroups.projectTargets,
                    dependencyGroups.xcframeworks
                ]
            }
            .flatMap { $0 }
            .compactMap { $0 }
            .flatMap { $0 }
            .flatMap { $0.convertToTargetDependencies() }
    }
    
    /// 프로젝트에서 추가되어야 하는 SPM 패키지 리스트 생성
    public static func generateProjectImportPackages(by dependencyGroups: DependencyGroup...) -> [Package] {
        // 중복 참조 방지
        var urlSet: Set<ImportablePath> = []
        
        return dependencyGroups
            .map { $0.managedPacakges }
            .compactMap { $0 }
            .flatMap { $0 }
            .compactMap { package -> Package? in
                guard !urlSet.contains(package.path) else { return nil }
                urlSet.insert(package.path)
                return package.convertToProjectPackage()
            }
    }
    
    /// tuist fetch를 통해 추가되어야 하는 패키지 리스트 생성
    public static func generateFetchingPackages(by dependencyGroups: DependencyGroup...) -> ProjectDescription.SwiftPackageManagerDependencies {
        // 중복 참조 방지
        var urlSet: Set<ImportablePath> = []
        
        let packages = dependencyGroups
            .map { $0.fetchedPacakges }
            .compactMap { $0 }
            .flatMap { $0 }
            .compactMap { package -> Package? in
                guard !urlSet.contains(package.path) else { return nil }
                urlSet.insert(package.path)
                return package.convertToProjectPackage()
            }
        
        return SwiftPackageManagerDependencies(packages)
    }
}
