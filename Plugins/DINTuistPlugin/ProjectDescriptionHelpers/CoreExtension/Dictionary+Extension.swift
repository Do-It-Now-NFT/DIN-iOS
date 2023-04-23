//
//  Dictionary+Extension.swift
//  DINTuistPlugin
//
//  Created by 이동희 on 2023/04/23.
//

import Foundation
import ProjectDescription

extension SettingsDictionary {
  public static func merging(_ targets: [Key:Value]...) -> SettingsDictionary {
    return targets.reduce([:]) { prev, target in
      return prev.merging(target, uniquingKeysWith: { return $1 })
    }
  }
}
