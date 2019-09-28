//
//  RepositoryFeedContainerNode.swift
//  CleanRepository
//
//  Created by Hyeon su Ha on 28/09/2019.
//  Copyright © 2019 Hyeon su Ha. All rights reserved.
//

import AsyncDisplayKit

final class RepositoryFeedContainerNode: ASDisplayNode {
  
  lazy var collectionNode: ASCollectionNode = {
    let flowLayout = UICollectionViewFlowLayout.init()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 0.0
    flowLayout.minimumInteritemSpacing = 0.0
    let node = ASCollectionNode.init(collectionViewLayout: flowLayout)
    node.registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionHeader)
    node.alwaysBounceVertical = true
    node.backgroundColor = .gitIvory
    return node
  }()
  
  override init() {
    super.init()
    self.backgroundColor = .gitIvory
    self.automaticallyManagesSubnodes = true
    self.automaticallyRelayoutOnSafeAreaChanges = true
    self.layoutSpecBlock = { [weak self] (_, sizeRange) -> ASLayoutSpec in
      guard let self = self else { return ASLayoutSpec() }
      return LayoutSpec {
        InsetLayout(insets: .zero) {
          self.collectionNode
        }
      }
    }
  }
}
