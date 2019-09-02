//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import AsyncDisplayKit
import BonMot

final class UserProfileContentNode: ASScrollNode {
  
  struct State {
    
    var profileState: UserProfileNode.State
    var displayNickname: String
    var originalName: String
    var company: String?
    var location: String?
    var homePageURL: URL?
    var bio: String?
  }
  
  private enum Const {
    
    static let nicknameAttr: StringStyle = .init(
      .font(UIFont.boldSystemFont(ofSize: 24.0)),
      .color(.gitGreen),
      .alignment(.center)
    )
    
    static let orignalNameAttr: StringStyle = .init(
      .font(UIFont.boldSystemFont(ofSize: 20.0)),
      .color(.darkGray),
      .alignment(.center)
    )
    
    static let bioAttr: StringStyle = .init(
      .font(UIFont.boldSystemFont(ofSize: 16.0)),
      .color(.darkGray),
      .alignment(.center)
    )
    
    static let infoAttr: StringStyle = .init(
      .font(UIFont.systemFont(ofSize: 14.0)),
      .color(.darkGray),
      .alignment(.center)
    )
  }
  
  public let profileNode = UserProfileNode.init(profileSize: .large)
  
  public let nickNameNode: ASTextNode2 = {
    let node = ASTextNode2()
    node.maximumNumberOfLines = 1
    return node
  }()
  
  public let originNameNode: ASTextNode2 = {
    let node = ASTextNode2()
    node.maximumNumberOfLines = 1
    return node
  }()
  
  public let bioNode: ASTextNode2 = {
    let node = ASTextNode2()
    node.maximumNumberOfLines = 0
    return node
  }()
  
  public let locationNode: ASTextNode2 = {
    let node = ASTextNode2()
    node.maximumNumberOfLines = 1
    return node
  }()
  
  public let companyNode: ASTextNode2 = {
    let node = ASTextNode2()
    node.maximumNumberOfLines = 1
    return node
  }()
  
  public let homePageNode: ASButtonNode = {
    let node = ASButtonNode()
    node.backgroundColor = UIColor.gitGreen
    node.cornerRadius = 8.0
    node.setTitle("Go to blog",
                  with: UIFont.boldSystemFont(ofSize: 15.0),
                  with: .white,
                  for: .normal)
    node.style.height(40.0)
    return node
  }()
  
  public var state: State? {
    didSet {
      self.updateWithState(state)
    }
  }
  
  override init() {
    super.init()
    self.automaticallyManagesContentSize = true
    self.automaticallyManagesSubnodes = true
    self.backgroundColor = .gitIvory
  }
  
  override func didLoad() {
    super.didLoad()
    self.view.alwaysBounceVertical = true
  }
  
  private func updateWithState(_ state: State?) {
    
    profileNode.state = state?.profileState
    nickNameNode.attributedText = state?.displayNickname.styled(with: Const.nicknameAttr)
    originNameNode.attributedText = state?.originalName.styled(with: Const.orignalNameAttr)
    locationNode.attributedText = state?.location?.styled(with: Const.infoAttr)
    companyNode.attributedText = state?.company?.styled(with: Const.infoAttr)
    bioNode.attributedText = state?.bio?.styled(with: Const.bioAttr)
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    var contentCompontents: [ASLayoutElement] = [
      profileNode.styled({
        $0.spacingAfter(12.0)
          .spacingBefore(constrainedSize.max.width / 4.0)
      }),
      nickNameNode.styled({ $0.shrink().spacingAfter(4.0) }),
      originNameNode.styled({ $0.shrink().spacingAfter(10.0) })
    ]
    
    if state?.bio != nil {
      contentCompontents.append(bioNode.styled({ $0.shrink().spacingAfter(8.0) }))
    }
    
    if state?.location != nil {
      contentCompontents.append(locationNode.styled({ $0.shrink().spacingAfter(4.0) }))
    }
    
    if state?.company != nil {
      contentCompontents.append(companyNode.styled({ $0.shrink().spacingAfter(4.0) }))
    }
    
    if state?.homePageURL != nil {
      let buttonInsetLayout = ASInsetLayoutSpec.init(
        insets: .init(top: 0.0, left: 60.0, bottom: 0.0, right: 60.0),
        child: homePageNode)
        .styled({
          $0.spacingBefore(20.0)
          $0.alignSelf = .stretch
        })
      contentCompontents.append(buttonInsetLayout)
    }
    
    return ASStackLayoutSpec.init(
      direction: .vertical,
      spacing: 0.0,
      justifyContent: .start,
      alignItems: .center,
      children: contentCompontents)
  }
}
