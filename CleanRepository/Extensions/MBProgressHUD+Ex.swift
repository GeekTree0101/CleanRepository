//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import MBProgressHUD

extension MBProgressHUD {
  
  static func toast(_ message: String, from fromView: UIView?) {
    
    guard let view = fromView else { return }
    let progress = MBProgressHUD.showAdded(to: view, animated: true)
    progress.label.text = message
    progress.minShowTime = 1.0
    progress.mode = .determinate
  }
}
