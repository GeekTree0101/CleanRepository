//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import AsyncDisplayKit
import DeepDiff
import MBProgressHUD

protocol RepositoryFeedDisplayLogic: class {
  
  func displayFeedItems(_ viewModel: RepositoryFeedModels.Feed.ViewModel)
}

final class RepositoryFeedController: ASViewController<ASDisplayNode> {
  
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
  
  private var batchContext: ASBatchContext?
  private var feedViewModel: RepositoryFeedModels.Feed.ViewModel = .init()
  
  public var interactor: RepositoryFeedInteractorLogic!
  
  init() {
    
    super.init(node: ASDisplayNode.init())
    self.node.backgroundColor = .gitIvory
    self.node.automaticallyManagesSubnodes = true
    self.node.automaticallyRelayoutOnSafeAreaChanges = true
    self.node.layoutSpecBlock = { [weak self] (_, sizeRange) -> ASLayoutSpec in
      guard let self = self else { return ASLayoutSpec() }
      return self.layoutSpecThatFits(sizeRange)
    }
    self.configuration()
  }
  
  required init?(coder aDecoder: NSCoder) {
    
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configuration() {
    let interactor = RepositoryFeedInteractor.init()
    let presenter = RepositoryFeedPresenter.init()
    interactor.presenter = presenter
    presenter.displayLogic = self
    self.interactor = interactor
  }
  
  private func layoutSpecThatFits(_ constraintedSize: ASSizeRange) -> ASLayoutSpec {
    
    return ASInsetLayoutSpec.init(
      insets: .zero,
      child: collectionNode
    )
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let request = RepositoryFeedModels.Feed.Request(isReload: true)
    interactor.fetch(request)
  }
}

extension RepositoryFeedController: RepositoryFeedDisplayLogic {
  
  func displayFeedItems(_ viewModel: RepositoryFeedModels.Feed.ViewModel) {
    
    if let errorMessage = viewModel.errorToastMessage {
      MBProgressHUD.toast(errorMessage, from: self.view)
    } else {
      self.feedViewModel = viewModel
      
      self.collectionNode.performBatch(
        changes: viewModel.repoAreaChangeSet,
        section: Section.repoArea.rawValue,
        completion: { [weak self] fin in
          self?.batchContext?.completeBatchFetching(fin)
      })
    }
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
      return self.feedViewModel.cellViewModels.count
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
      cellNode.state = self.feedViewModel.cellViewModels[indexPath.item]
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
    return feedViewModel.hasNext
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode,
                      willBeginBatchFetchWith context: ASBatchContext) {
    self.batchContext = context
    interactor.fetch(RepositoryFeedModels.Feed.Request(isReload: false))
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
