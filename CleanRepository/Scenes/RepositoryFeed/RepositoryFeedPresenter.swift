//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import Foundation
import DeepDiff

protocol RepositoryFeedPresenterLogic: class {
  
  func presentFeed(_ res: RepositoryFeedModels.Feed.Response)
}

class RepositoryFeedPresenter: RepositoryFeedPresenterLogic {
  
  public weak var displayLogic: RepositoryFeedDisplayLogic!
  
  func presentFeed(_ res: RepositoryFeedModels.Feed.Response) {
    
    if let error = res.error {
      let viewModel = RepositoryFeedModels.Feed.ViewModel(
        errorToastMessage: error.localizedDescription,
        hasNext: false,
        cellViewModels: [],
        repoAreaChangeSet: []
      )
      
      displayLogic.displayFeedItems(viewModel)
    } else {
      // TODO: Needs more effective diff check logic
      let oldCellViewModels = res.prevItems.map {
        
        return GithubRepositoryCellNode.State.init(
          repositoryID: $0.id,
          profileState: .init(profileImageURL: $0.user?.profileURL),
          repoName: $0.repositoryName ?? "unknown",
          repoDesc: $0.desc,
          username: $0.user?.username ?? "unknown"
        )
      }
      
      let newCellViewModels = res.newItems.map {
        
        return GithubRepositoryCellNode.State.init(
          repositoryID: $0.id,
          profileState: .init(profileImageURL: $0.user?.profileURL),
          repoName: $0.repositoryName ?? "unknown",
          repoDesc: $0.desc,
          username: $0.user?.username ?? "unknown"
        )
      }
      
      let changeSet = diff(old: oldCellViewModels, new: newCellViewModels)
      let hasNext: Bool = Array(changeSet)
        .map({ $0.insert?.item })
        .compactMap({ $0 })
        .isEmpty == false
      
      let viewModel = RepositoryFeedModels.Feed.ViewModel(
        errorToastMessage: nil,
        hasNext: hasNext,
        cellViewModels: newCellViewModels,
        repoAreaChangeSet: changeSet
      )
      
      displayLogic.displayFeedItems(viewModel)
    }
  }
}
