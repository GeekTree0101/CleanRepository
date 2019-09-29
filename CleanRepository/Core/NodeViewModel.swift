//
//  NodeViewModel.swift
//  CleanRepository
//
//  Created by Hyeon su Ha on 29/09/2019.
//  Copyright © 2019 Hyeon su Ha. All rights reserved.
//

import Foundation
import AsyncDisplayKit

protocol LiveStateDelegate: class {
  func didChangedState()
  func shouldTransitionAnimate() -> Bool
  func shouldMeasureAsync() -> Bool
  func measurementCompleted()
}

extension LiveStateDelegate {
  
  func shouldTransitionAnimate() -> Bool {
    return false
  }
  
  func shouldMeasureAsync() -> Bool {
    return false
  }
  
  func measurementCompleted() {
    
  }
}

@propertyWrapper class LiveState<State> {
  
  private var state: State
  public weak var delegate: LiveStateDelegate?
  
  init(wrappedValue state: State) {
    self.state = state
  }
  
  var wrappedValue: State {
    get {
      return self.state
    }
    set {
      self.state = newValue
      self.delegate?.didChangedState()
      
      guard let node = self.delegate as? ASDisplayNode,
        node.isNodeLoaded == true else { return }
      
      if self.delegate?.shouldTransitionAnimate() == true {
        node.transitionLayout(
          withAnimation: true,
          shouldMeasureAsync: self.delegate?.shouldMeasureAsync() ?? false,
          measurementCompletion: { [weak self] () in
            self?.delegate?.measurementCompleted()
        })
      } else {
        node.setNeedsLayout()
      }
    }
  }
}
