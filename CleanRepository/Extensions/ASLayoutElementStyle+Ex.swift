//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import AsyncDisplayKit

extension ASLayoutElementStyle {
  
  @discardableResult
  func shrink(value: CGFloat = 1.0) -> ASLayoutElementStyle {
    self.flexShrink = value
    return self
  }
  
  @discardableResult
  func grow(value: CGFloat = 1.0) -> ASLayoutElementStyle {
    self.flexGrow = value
    return self
  }
  
  @discardableResult
  func nonShrink() -> ASLayoutElementStyle {
    self.flexShrink = 0.0
    return self
  }
  
  @discardableResult
  func nonGrow() -> ASLayoutElementStyle {
    self.flexGrow = 0.0
    return self
  }
  
  @discardableResult
  func width(_ value: CGFloat, unit: ASDimensionUnit = .points) -> ASLayoutElementStyle {
    self.width = ASDimension.init(unit: unit, value: value)
    return self
  }
  
  @discardableResult
  func height(_ value: CGFloat, unit: ASDimensionUnit = .points) -> ASLayoutElementStyle {
    self.height = ASDimension.init(unit: unit, value: value)
    return self
  }
  
  @discardableResult
  func maxWidth(_ value: CGFloat, unit: ASDimensionUnit = .points) -> ASLayoutElementStyle {
    self.maxWidth = ASDimension.init(unit: unit, value: value)
    return self
  }
  
  @discardableResult
  func maxHeight(_ value: CGFloat, unit: ASDimensionUnit = .points) -> ASLayoutElementStyle {
    self.maxHeight = ASDimension.init(unit: unit, value: value)
    return self
  }
  
  @discardableResult
  func minWidth(_ value: CGFloat, unit: ASDimensionUnit = .points) -> ASLayoutElementStyle {
    self.minWidth = ASDimension.init(unit: unit, value: value)
    return self
  }
  
  @discardableResult
  func minHeight(_ value: CGFloat, unit: ASDimensionUnit = .points) -> ASLayoutElementStyle {
    self.minHeight = ASDimension.init(unit: unit, value: value)
    return self
  }
  
  @discardableResult
  func size(_ value: CGSize) -> ASLayoutElementStyle {
    self.preferredSize = value
    return self
  }
  
  @discardableResult
  func maxSize(_ value: CGSize) -> ASLayoutElementStyle {
    self.maxSize = value
    return self
  }
  
  @discardableResult
  func minSize(_ value: CGSize) -> ASLayoutElementStyle {
    self.minSize = value
    return self
  }
  
  @discardableResult
  func spacingAfter(_ value: CGFloat) -> ASLayoutElementStyle {
    self.spacingAfter = value
    return self
  }
  
  @discardableResult
  func spacingBefore(_ value: CGFloat) -> ASLayoutElementStyle {
    self.spacingBefore = value
    return self
  }
}
