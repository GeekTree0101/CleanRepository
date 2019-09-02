//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import AsyncDisplayKit
import BonMot
import DeepDiff

final class GithubRepositoryCellNode: ASCellNode {
  
  struct State: DiffAware {
    
    typealias DiffId = Int
    
    var diffId: Int {
      return repositoryID
    }
    
    var repositoryID: Int
    var profileState: UserProfileNode.State
    var repoName: String?
    var repoDesc: String?
    var username: String?
    
    static func compareContent(_ a: State,
                               _ b: State) -> Bool {
      return a.diffId == b.diffId
    }
  }
  
  private enum Const {
    
    static let titleAttr: StringStyle = .init(
      .font(UIFont.boldSystemFont(ofSize: 18.0)),
      .color(.darkGray)
    )
    
    static let descAttr: StringStyle = .init(
      .font(UIFont.systemFont(ofSize: 14.0)),
      .color(.gray)
    )
    
    static let userInfoAttr: StringStyle = .init(
      .font(UIFont.systemFont(ofSize: 12.0)),
      .color(.lightGray)
    )
    
  }
  
  public let profileNode = UserProfileNode.init(profileSize: .medium)
  
  private let repoNameNode: ASTextNode2 = {
    let node = ASTextNode2()
    node.maximumNumberOfLines = 1
    return node
  }()
  
  private let repoDescNode: ASTextNode2 = {
    let node = ASTextNode2()
    node.maximumNumberOfLines = 3
    return node
  }()
  
  private let infoNode: ASTextNode2 = {
    let node = ASTextNode2()
    node.maximumNumberOfLines = 1
    return node
  }()
  
  private let contentNode: ASDisplayNode = {
    let node = ASDisplayNode()
    node.automaticallyManagesSubnodes = true
    node.backgroundColor = .white
    node.cornerRadius = 10.0
    return node
  }()
  
  public var state: State? {
    didSet {
      self.updateWithState(state)
    }
  }
  
  override init() {
    
    super.init()
    self.automaticallyManagesSubnodes = true
    self.backgroundColor = .clear
    self.contentNode.layoutSpecBlock  = { [weak self] (_, _) -> ASLayoutSpec in
      return self?.contentLayoutSpec() ?? ASLayoutSpec()
    }
  }
  
  private func updateWithState(_ state: State?) {
    profileNode.state = state?.profileState
    repoNameNode.attributedText = state?.repoName?.styled(with: Const.titleAttr)
    repoDescNode.attributedText = state?.repoDesc?.styled(with: Const.descAttr)
    
    guard let username = state?.username else { return }
    infoNode.attributedText = "Created by \(username)".styled(with: Const.userInfoAttr)
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASInsetLayoutSpec.init(
      insets: .init(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0),
      child: contentNode)
  }
  
  private func contentLayoutSpec() -> ASLayoutSpec {
    
    let contentLayout = ASStackLayoutSpec.init(
      direction: .vertical,
      spacing: 4.0,
      justifyContent: .start,
      alignItems: .stretch,
      children: [repoNameNode,
                 repoDescNode,
                 infoNode].map({ $0.styled({ $0.shrink().nonGrow() }) }))
    
    let profileWithContentLayout = ASStackLayoutSpec.init(
      direction: .horizontal,
      spacing: 12.0,
      justifyContent: .start,
      alignItems: .stretch,
      children: [profileNode,
                 contentLayout.styled({ $0.shrink().nonGrow() })]
    )
    
    return ASInsetLayoutSpec.init(
      insets: .init(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0),
      child: profileWithContentLayout)
  }
}
