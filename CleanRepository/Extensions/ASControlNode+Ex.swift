//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import AsyncDisplayKit

private var actionKey: String = "actionKey"

extension ASControlNode: AssociatedObject {
  
  @discardableResult
  public func action(_ callback: @escaping () -> Void,
                  for controlEvents: ASControlNodeEvent = .touchUpInside) -> Self {
    self.controlActionCallBack = callback
    self.addTarget(self, action: #selector(controlActionHandler), forControlEvents: controlEvents)
    return self
  }
  
  @objc private func controlActionHandler() {
    guard let execute = self.controlActionCallBack else { return }
    execute()
  }
  
  private var controlActionCallBack: (() -> Void)? {
    get {
      return self.associatedObject(forKey: &actionKey, default: nil)
    }
    set {
      self.setAssociatedObject(newValue, forKey: &actionKey)
    }
  }
}

public protocol AssociatedObject { }

extension AssociatedObject {
  
  func associatedObject<T>(forKey key: UnsafeRawPointer) -> T? {
    
    return objc_getAssociatedObject(self, key) as? T
  }
  
  func associatedObject<T>(forKey key: UnsafeRawPointer,
                           default: @autoclosure () -> T) -> T {
    
    guard let object: T = self.associatedObject(forKey: key) else {
      
      let object = `default`()
      
      self.setAssociatedObject(
        object,
        forKey: key
      )
      
      return object
    }
    
    return object
  }
  
  func setAssociatedObject<T>(_ object: T?, forKey key: UnsafeRawPointer) {
    objc_setAssociatedObject(
      self,
      key,
      object,
      .OBJC_ASSOCIATION_RETAIN_NONATOMIC
    )
  }
}
