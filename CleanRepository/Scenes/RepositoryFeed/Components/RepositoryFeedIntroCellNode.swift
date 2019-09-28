//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import AsyncDisplayKit
import BonMot

final class RepositoryFeedIntroCellNode: ASCellNode {
  
  private enum Const {
    
    static let infoAttr: StringStyle = .init(
      .font(UIFont.boldSystemFont(ofSize: 12.0)),
      .color(.gitGreen)
    )
    
    static let titleAttr: StringStyle = .init(
      .font(UIFont.boldSystemFont(ofSize: 40.0)),
      .color(.gitDarkGray)
    )
  }
  
  private let infoNode: ASTextNode2 = {
    
    let node = ASTextNode2()
    node.attributedText = "※ github repository >".styled(with: Const.infoAttr)
    return node
  }()
  
  private let titleNode: ASTextNode2 = {
    
    let node = ASTextNode2()
    node.attributedText = "Dicover".styled(with: Const.titleAttr)
    return node
  }()
  
  override init() {
    
    super.init()
    self.automaticallyManagesSubnodes = true
    self.backgroundColor = .clear
    self.layoutSpecBlock = { [weak self] (node, constraintedSize) -> ASLayoutSpec in
      guard let self = self else { return ASLayoutSpec() }
      return LayoutSpec {
        InsetLayout(insets: .init(top: 40.0, left: 20.0, bottom: 40.0, right: 20.0)) {
          LayoutSpec {
            VStackLayout(spacing: 5.0, justifyContent: .start, alignItems: .start) {
              self.infoNode.action({
                Router.shared.openGithubAPIGuide()
              })
              self.titleNode
            }
          }
          .styled({ $0.shrink() })
        }
      }
    }
  }
}
