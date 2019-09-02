//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import AsyncDisplayKit

final class UserProfileNode: ASNetworkImageNode {
  
  enum ProfileSize {
    case small
    case medium
    case large
    
    var size: CGSize {
      switch self {
      case .small:
        return .init(width: 20.0, height: 20.0)
      case .medium:
        return .init(width: 40.0, height: 40.0)
      case .large:
        return .init(width: 80.0, height: 80.0)
      }
    }
  }
  
  struct State {
    
    var profileImageURL: URL?
  }
  
  public var state: State? {
    didSet {
      self.updateWithState(state)
    }
  }
  
  init(profileSize: ProfileSize) {
    super.init(cache: nil, downloader: ASBasicImageDownloader.shared)
    
    self.automaticallyManagesSubnodes = true
    self.borderWidth = 1.0
    self.borderColor = UIColor.lightGray.cgColor
    self.backgroundColor = .lightGray
    self.style.size(profileSize.size)
    self.cornerRadius = (profileSize.size.height) * 0.5
  }
  
  private func updateWithState(_ state: State?) {
    self.setURL(state?.profileImageURL, resetToDefault: true)
  }
}
