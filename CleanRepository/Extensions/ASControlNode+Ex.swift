//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import AsyncDisplayKit

private var actionKey: String = "actionKey"

extension ASControlNode: AssociatedObject {
  
  public func tap(_ callback: @escaping () -> Void,
                  for controlEvents: ASControlNodeEvent = .touchUpInside) {
    self.controlActionCallBack.register(callback)
    self.addTarget(self, action: #selector(internalControlAction), forControlEvents: controlEvents)
  }
  
  @objc private func internalControlAction() {
    self.controlActionCallBack.performBatch()
  }
  
  private class ControlEventObject {
    
    private var _lock: NSRecursiveLock = .init()
    private var callbacks: [() -> Void] = []
    
    internal func register(_ callback: @escaping () -> Void) {
      self._lock.lock(); defer { self._lock.unlock() }
      callbacks.append(callback)
    }
    
    internal func performBatch() {
      self._lock.lock(); defer { self._lock.unlock() }
      callbacks.forEach({ $0() })
    }
  }
  
  private var controlActionCallBack: ControlEventObject {
    get {
      return self.associatedObject(forKey: &actionKey, default: ControlEventObject())
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
