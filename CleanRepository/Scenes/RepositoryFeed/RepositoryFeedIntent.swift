//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import PromiseKit
import DeepDiff

class RepositoryFeedIntent {
  
  typealias FeedState = RepositoryFeedController.State
  
  public var useCase: RepositoryFeedUseCase = .init()
  
  func fetch(_ state: FeedState, isReload: Bool) -> Promise<FeedState> {
    
    return useCase.fetch(nextPage: isReload ? nil : state.nextSince)
      .map({ repositories -> FeedState in
        
        let cellViewStates = (repositories ?? []).map {
          return GithubRepositoryCellNode.State.init(
            repositoryID: $0.id,
            profileState: .init(profileImageURL: $0.user?.profileURL),
            repoName: $0.repositoryName ?? "unknown",
            repoDesc: $0.desc,
            username: $0.user?.username ?? "unknown"
          )
        }
        
        var newState = state
        
        let newItems = state.items + cellViewStates
        newState.status = cellViewStates.count > 0 ? .some : .end
        newState.nextSince = cellViewStates.last?.repositoryID
        newState.repoAreaChangeSet = diff(old: state.items, new: newItems)
        newState.items = newItems
        
        return newState
      })
  }
}
