//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import AsyncDisplayKit
import BonMot
import MBProgressHUD

final class UserProfileController: ASViewController<ASDisplayNode> {
  
  struct UserProfileState {
    
    var username: String?
    var contentState: UserProfileContentNode.State?
  }
  
  let profileContentNode = UserProfileContentNode.init()
  
  let closeButtonNode: ASButtonNode = {
    let node = ASButtonNode()
    node.setImage(UIImage(named: "icClose")?.tintedImage(color: .gitOrange), for: .normal)
    node.style.size(.init(width: 30.0, height: 30.0))
    node.imageNode.contentMode = UIView.ContentMode.scaleAspectFit
    return node
  }()
  
  public var currentState: UserProfileState = .init()
  public var intent: UserProfileIntent = .init()
  
  init() {
    super.init(node: .init())
    self.node.automaticallyManagesSubnodes = true
    self.node.automaticallyRelayoutOnSafeAreaChanges = true
    self.node.backgroundColor = .gitIvory
    
    self.node.layoutSpecBlock = { [weak self] (node, _) -> ASLayoutSpec in
      guard let self = self else { return ASLayoutSpec() }
      
      var contentInsets: UIEdgeInsets = node.safeAreaInsets
      contentInsets.left = 15.0
      contentInsets.right = 15.0
      
      let profileContentLayout = ASInsetLayoutSpec.init(
        insets: contentInsets,
        child: self.profileContentNode)
      
      self.closeButtonNode.style.layoutPosition = .init(
        x: node.safeAreaInsets.left + 30.0,
        y: node.safeAreaInsets.top + 30.0
      )
      
      return ASWrapperLayoutSpec.init(
        layoutElements: [
          profileContentLayout,
          ASAbsoluteLayoutSpec.init(children: [self.closeButtonNode])
        ])
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    intent.reload(currentState)
      .threadingOnMain()
      .done({ [weak self] state in
        guard let self = self else { return }
        self.currentState = state
        self.profileContentNode.state = state.contentState
        self.profileContentNode.setNeedsLayout()
        self.node.setNeedsLayout()
      })
      .catch({ [weak self] err in
        MBProgressHUD.toast(err.localizedDescription, from: self?.view)
      })
    
    profileContentNode.homePageNode.tap({ [weak self] () in
      guard let url = self?.currentState.contentState?.homePageURL else { return }
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    })
    
    closeButtonNode.tap({ [weak self] () in
      self?.dismiss(animated: true, completion: nil)
    })
  }
}
