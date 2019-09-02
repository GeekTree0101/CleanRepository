//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import AsyncDisplayKit
import DeepDiff
import MBProgressHUD

final class RepositoryFeedController: ASViewController<ASDisplayNode> {
  
  struct State {
    
    var nextSince: Int? = nil
    
    var hasNext: Bool {
      return nextSince != nil
    }
    
    var status: FeedUseCase.Status = .loading
    var items: [GithubRepositoryCellNode.State] = []
    var batchContext: ASBatchContext? = nil
    
    var repoAreaChangeSet: [Change<GithubRepositoryCellNode.State>] = []
  }
  
  enum Section: Int, CaseIterable {
    
    case introArea
    case repoArea
    case loadingIndicator
  }
  
  lazy var collectionNode: ASCollectionNode = {
    
    let flowLayout = UICollectionViewFlowLayout.init()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 0.0
    flowLayout.minimumInteritemSpacing = 0.0
    let node = ASCollectionNode.init(collectionViewLayout: flowLayout)
    node.registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionHeader)
    node.alwaysBounceVertical = true
    node.delegate = self
    node.dataSource = self
    node.backgroundColor = .gitIvory
    return node
  }()
  
  private var currentState: State = State()
  private var intent: RepositoryFeedIntent = .init()
  
  init() {
    
    super.init(node: ASDisplayNode.init())
    self.node.backgroundColor = .gitIvory
    self.node.automaticallyManagesSubnodes = true
    self.node.automaticallyRelayoutOnSafeAreaChanges = true
    self.node.layoutSpecBlock = { [weak self] (_, sizeRange) -> ASLayoutSpec in
      guard let self = self else { return ASLayoutSpec() }
      return self.layoutSpecThatFits(sizeRange)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    
    fatalError("init(coder:) has not been implemented")
  }
  
  private func layoutSpecThatFits(_ constraintedSize: ASSizeRange) -> ASLayoutSpec {
    
    return ASInsetLayoutSpec.init(
      insets: .zero,
      child: collectionNode
    )
  }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    intent.fetch(currentState, isReload: true).threadingOnMain()
      .done({ [weak self] state in
        guard let self = self else { return }
        self.currentState = state
        self.collectionNode.performBatch(
          changes: state.repoAreaChangeSet,
          section: Section.repoArea.rawValue,
          completion: { fin in
            state.batchContext?.completeBatchFetching(fin)
        })
      })
      .catch({ [weak self] err in
        guard let self = self else { return }
        MBProgressHUD.toast(err.localizedDescription, from: self.view)
      })
  }
}

extension RepositoryFeedController: ASCollectionDataSource {
  
  func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
    
    return Section.allCases.count
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode,
                      numberOfItemsInSection section: Int) -> Int {
    
    guard let feedSection = Section.init(rawValue: section) else { return 0 }
    
    switch feedSection {
    case .introArea:
      return 1
    case .repoArea:
      return currentState.items.count
    case .loadingIndicator:
      return 1
    }
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode,
                      nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
    
    guard let feedSection = Section.init(rawValue: indexPath.section) else {
      return { ASCellNode.init() }
    }
    
    switch feedSection {
    case .introArea:
      return { RepositoryFeedIntroCellNode.init() }
    case .repoArea:
      let cellNode = GithubRepositoryCellNode.init()
      cellNode.state = currentState.items[indexPath.item]
      
      cellNode.profileNode.tap({ [weak self, weak cellNode] () in
        guard let state = cellNode?.state else { return }
        Router.shared.openUserProfile(state.username, from: self)
      })
      
      return { cellNode }
    case .loadingIndicator:
      return { FeedLoadingIndicatorCellNode.init() }
    }
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode,
                      nodeBlockForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> ASCellNodeBlock {
    
    guard let feedSection = Section.init(rawValue: indexPath.section) else {
      return { ASCellNode.init() }
    }
    
    switch feedSection {
    case .repoArea:
      guard kind == UICollectionView.elementKindSectionHeader else { break }
      return { RepositoryFeedGuideArchtectureCellNode.init() }
    default:
      break
    }
    
    return { ASCellNode.init() }
  }
}

extension RepositoryFeedController: ASCollectionDelegate & ASCollectionDelegateFlowLayout {
  
  func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
    
    return currentState.hasNext
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode,
                      willBeginBatchFetchWith context: ASBatchContext) {
    
    currentState.batchContext = context
    
    intent.fetch(currentState, isReload: false)
      .threadingOnMain()
      .done({ [weak self] state in
        guard let self = self else { return }
        self.currentState = state
        self.collectionNode.performBatch(
          changes: state.repoAreaChangeSet,
          section: Section.repoArea.rawValue,
          completion: { fin in
            state.batchContext?.completeBatchFetching(fin)
        })
      })
      .catch({ [weak self] err in
        guard let self = self else { return }
        MBProgressHUD.toast(err.localizedDescription, from: self.view)
      })
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode,
                      constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
    
    let minSize = CGSize.init(width: collectionNode.frame.width, height: 0.0)
    let maxSize = CGSize.init(width: collectionNode.frame.width, height: .infinity)
    return ASSizeRange.init(min: minSize, max: maxSize)
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode,
                      sizeRangeForHeaderInSection section: Int) -> ASSizeRange {
    
    return ASSizeRangeUnconstrained
  }
}
