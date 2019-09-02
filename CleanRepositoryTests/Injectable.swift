//
//  Injectable.swift
//
//  Created by magi82
//  Copyright © 2019 magi82. All rights reserved.
//

import Foundation

protocol Injectable {
  associatedtype Provider = () -> Any?
  func register<Object>(_ type: Object.Type, name: String, provider: @escaping () -> Object)
  func resolve<Object>(_ type: Object.Type, name: String) -> Object?
}

private var containerKey: String = "container"

extension Injectable {
  
  private var container: DIContainer {
    get {
      if let value = objc_getAssociatedObject(self, &containerKey) as? DIContainer {
        return value
      }
      
      let container: DIContainer = .init()
      
      objc_setAssociatedObject(self,
                               &containerKey,
                               container,
                               objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      return container
    }
  }
  
  func register<Object>(_ type: Object.Type, name: String, provider: @escaping () -> Object) {
    container.register(type, name: name, provider: provider)
  }
  
  func resolve<Object>(_ type: Object.Type, name: String) -> Object? {
    return container.resolve(type, name: name)
  }
}

final class DIContainer {
  
  typealias Provider = () -> Any?
  private var container: [String: Provider] = [:]
  
  func register<Object>(_ type: Object.Type, name: String, provider: @escaping () -> Object) {
    container[name] = provider
  }
  
  func resolve<Object>(_ type: Object.Type, name: String) -> Object? {
    let provider = container[name]
    let value = provider?()
    return value as? Object
  }
}
