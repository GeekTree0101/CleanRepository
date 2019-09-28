//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import UIKit

extension UIColor {
  
  static let gitGreen: UIColor = {
    let defaultColor = UIColor.init(red: 145 / 255, green: 176 / 255, blue: 41 / 255, alpha: 1.0)
    let darkModeColor = UIColor.init(red: 185 / 255, green: 206 / 255, blue: 61 / 255, alpha: 1.0)
    if #available(iOS 13.0, *) {
      return UIColor.init(dynamicProvider: { trait in
        return trait.userInterfaceStyle == .dark ? darkModeColor: defaultColor
      })
    } else {
      return defaultColor
    }
  }()
  
  static let gitOrange: UIColor = {
    let defaultColor = UIColor.init(red: 230 / 255, green: 164 / 255, blue: 0.0, alpha: 1.0)
    let darkModeColor = UIColor.init(red: 1.0, green: 184 / 255, blue: 61.0 / 255, alpha: 1.0)
    if #available(iOS 13.0, *) {
      return UIColor.init(dynamicProvider: { trait in
        return trait.userInterfaceStyle == .dark ? darkModeColor: defaultColor
      })
    } else {
      return defaultColor
    }
  }()
  
  static let gitIvory: UIColor = {
    let defaultColor = UIColor.init(red: 234 / 255, green: 235 / 255, blue: 216 / 255, alpha: 1.0)
    let darkModeColor = UIColor.black
    if #available(iOS 13.0, *) {
      return UIColor.init(dynamicProvider: { trait in
        return trait.userInterfaceStyle == .dark ? darkModeColor: defaultColor
      })
    } else {
      return defaultColor
    }
  }()
  
  static let gitDarkGray: UIColor = {
    let defaultColor = UIColor.darkGray
    let darkModeColor = UIColor.white
    if #available(iOS 13.0, *) {
      return UIColor.init(dynamicProvider: { trait in
        return trait.userInterfaceStyle == .dark ? darkModeColor: defaultColor
      })
    } else {
      return defaultColor
    }
  }()
  
  static let gitContentColor: UIColor = {
    let defaultColor = UIColor.white
    let darkModeColor = UIColor.darkGray
    if #available(iOS 13.0, *) {
      return UIColor.init(dynamicProvider: { trait in
        return trait.userInterfaceStyle == .dark ? darkModeColor: defaultColor
      })
    } else {
      return defaultColor
    }
  }()
}
