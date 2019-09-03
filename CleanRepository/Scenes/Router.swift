//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import UIKit

class Router {
  
  static let shared: Router = .init()
  
  public func openGithubAPIGuide() {
    guard let url = URL(string: "https://developer.github.com/v3/repos/#list-all-public-repositories") else { return }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
  
  public func openCleanRepository() {
    guard let url = URL(string: "https://github.com/GeekTree0101/CleanRepository") else { return }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
  
  public func openUserProfile(_ username: String?, from: UIViewController?) {
    guard let username = username else { return }
    let vc = UserProfileController.init()
    vc.currentState.username = username
    from?.present(vc, animated: true, completion: nil)
  }
}
