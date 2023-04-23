//
//  Dependencies.swift
//  Config
//
//  Created by 이동희 on 2023/04/23.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DINTuistPlugin

let dependencies = Dependencies(
    swiftPackageManager: DependencyResolver.generateFetchingPackages(
        by: DINDevelopKitDependencyGroup(), DINTestKitDependencyGroup()
    )
)
