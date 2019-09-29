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
      .color(.gitDarkGray)
    )
    
    static let descAttr: StringStyle = .init(
      .font(UIFont.systemFont(ofSize: 14.0)),
      .color(.gitDarkGray)
    )
    
    static let userInfoAttr: StringStyle = .init(
      .font(UIFont.systemFont(ofSize: 12.0)),
      .color(.gitDarkGray)
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
    node.backgroundColor = .gitContentColor
    node.cornerRadius = 10.0
    return node
  }()
  
  @LiveState var state: State? = nil
  
  override init() {
    super.init()
    self._state.delegate = self
    self.automaticallyManagesSubnodes = true
    self.backgroundColor = .clear
    
    self.layoutSpecBlock = { [weak self] (_, _) -> ASLayoutSpec in
      guard let self = self else { return ASLayoutSpec() }
      return LayoutSpec {
        InsetLayout(insets: .init(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0)) {
          self.contentNode
        }
      }
    }
    
    self.contentNode.layoutSpecBlock  = { [weak self] (_, _) -> ASLayoutSpec in
      guard let self = self else { return ASLayoutSpec() }
      return LayoutSpec {
        InsetLayout(insets: .init(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)) {
          HStackLayout(spacing: 12.0, justifyContent: .start, alignItems: .stretch) {
            self.profileNode
            LayoutSpec {
              VStackLayout(spacing: 4.0, justifyContent: .start, alignItems: .stretch) {
                self.repoNameNode
                self.repoDescNode
                self.infoNode
              }
            }
            .styled({ $0.shrink().nonGrow() })
          }
        }
      }
    }
  }
}

extension GithubRepositoryCellNode: LiveStateDelegate {
  
  func didChangedState() {
    profileNode.state = state?.profileState
    repoNameNode.attributedText = state?.repoName?.styled(with: Const.titleAttr)
    repoDescNode.attributedText = state?.repoDesc?.styled(with: Const.descAttr)
    guard let username = state?.username else { return }
    infoNode.attributedText = "Created by \(username)".styled(with: Const.userInfoAttr)
  }
}
