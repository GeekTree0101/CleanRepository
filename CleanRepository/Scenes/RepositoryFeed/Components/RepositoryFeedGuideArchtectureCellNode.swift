//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import AsyncDisplayKit
import BonMot

final class RepositoryFeedGuideArchtectureCellNode: ASCellNode {
  
  private enum Const {
    
    static let titleAttr: StringStyle = .init(
      .font(UIFont.boldSystemFont(ofSize: 20.0)),
      .color(.orange)
    )
    
    static let descAttr: StringStyle = .init(
      .font(UIFont.italicSystemFont(ofSize: 14.0)),
      .color(.darkGray)
    )
    
    static let copyrightAttr: StringStyle = .init(
      .font(UIFont.systemFont(ofSize: 10.0)),
      .color(.gitGreen)
    )
  }
  
  private let titleNode: ASTextNode2 = {
    
    let node = ASTextNode2()
    node.attributedText = "Welcome to CleanRepository".styled(with: Const.titleAttr)
    return node
  }()
  
  private let descNode: ASTextNode2 = {
    
    let node = ASTextNode2()
    node.attributedText = "\"A competent developer could dedicate their entire career to the pursuit of learning how to add features to software without making it harder to add more in the future.\"".styled(with: Const.descAttr)
    return node
  }()
  
  private let copyrightNode: ASTextNode2 = {
    
    let node = ASTextNode2()
    node.attributedText = "Copyright © 2019 Geektree0101. All rights reserved.".styled(with: Const.copyrightAttr)
    return node
  }()
  
  private let openRepoButtonNode: ASButtonNode = {
    
    let node = ASButtonNode()
    node.setTitle("Let's Go", with: UIFont.systemFont(ofSize: 15.0), with: .white, for: .normal)
    node.backgroundColor = UIColor.gitGreen
    node.cornerRadius = 5.0
    node.style.size(.init(width: 80.0, height: 50.0))
    return node
  }()
  
  private let contentNode: ASDisplayNode = {
    
    let node = ASDisplayNode()
    node.automaticallyManagesSubnodes = true
    node.backgroundColor = .white
    node.cornerRadius = 10.0
    return node
  }()
  
  override init() {
    
    super.init()
    self.automaticallyManagesSubnodes = true
    self.backgroundColor = .clear
    self.contentNode.layoutSpecBlock  = { [weak self] (_, _) -> ASLayoutSpec in
      return self?.contentLayoutSpec() ?? ASLayoutSpec()
    }
  }
  
  override func didLoad() {
    
    super.didLoad()
    self.openRepoButtonNode.tap({
      Router.shared.openCleanRepository()
    })
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return LayoutSpec {
      InsetLayout(insets: .init(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0)) {
        self.contentNode
      }
    }
  }
  
  private func contentLayoutSpec() -> ASLayoutSpec {
    
    return LayoutSpec {
      InsetLayout(insets: .init(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)) {
        HStackLayout(spacing: 14.0, justifyContent: .spaceBetween, alignItems: .center) {
          LayoutSpec {
            VStackLayout(spacing: 0.0, justifyContent: .start, alignItems: .start) {
              self.titleNode.styled({ $0.spacingAfter(12.0) })
              self.descNode.styled({ $0.spacingAfter(4.0) })
              self.copyrightNode
            }
          }
          .styled({ $0.shrink() })
          self.openRepoButtonNode
        }
      }
    }
  }
}
