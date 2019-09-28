//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import AsyncDisplayKit
import UIKit

final class FeedLoadingIndicatorCellNode: ASCellNode {
  
  private lazy var indicatorNode = ASDisplayNode.init(viewBlock: { () -> UIView in
    let view = UIActivityIndicatorView.init(style: .whiteLarge)
    view.color = UIColor.gitOrange
    view.hidesWhenStopped = true
    return view
  })
  
  public var indicatorView: UIActivityIndicatorView? {
    return indicatorNode.view as? UIActivityIndicatorView
  }
  
  override init() {
    super.init()
    self.automaticallyManagesSubnodes = true
    self.style.height(80.0)
    self.backgroundColor = .clear
    self.layoutSpecBlock = { [weak self] (_, _) -> ASLayoutSpec in
      guard let self = self else { return ASLayoutSpec() }
      return LayoutSpec {
        self.indicatorNode.styled({ $0.alignSelf = .center })
      }
    }
  }
  
  override func didEnterVisibleState() {
    super.didEnterVisibleState()
    indicatorView?.startAnimating()
  }
  
  override func didExitVisibleState() {
    super.didExitVisibleState()
    indicatorView?.stopAnimating()
  }
}
