//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import Foundation

protocol RepositoryFeedInteractorLogic: class {
  
  func fetch(_ request: RepositoryFeedModels.Feed.Request)
}

protocol RepositoryFeedDataStore {
  
  var repositories: [GithubRepo] { get set }
}

class RepositoryFeedInteractor: RepositoryFeedDataStore {
  
  
  public var repositories: [GithubRepo] = []
  private var nextSince: Int?
  
  public var presenter: RepositoryFeedPresenterLogic!
  
  private var _repoService: RepositoryFeedWorker
  
  init(feedWorker: RepositoryFeedWorker = .init()) {
    self._repoService = feedWorker
  }
}

extension RepositoryFeedInteractor: RepositoryFeedInteractorLogic {
  
  
  func fetch(_ request: RepositoryFeedModels.Feed.Request) {
    
    _repoService.fetch(nextPage: request.isReload ? nil: self.nextSince)
      .threadingOnMain()
      .done({ [weak self] repos in
        guard let self = self else { return }
        let oldItems = request.isReload ? [] : self.repositories
        let newItems = oldItems + (repos ?? [])
        
        let res: RepositoryFeedModels.Feed.Response = .init(
          error: nil,
          prevItems: oldItems,
          newItems: newItems)
        
        self.repositories = newItems
        self.nextSince = newItems.last?.id
        self.presenter.presentFeed(res)
      }).catch({ [weak self] error in
        guard let self = self else { return }
        
        let res: RepositoryFeedModels.Feed.Response = .init(
          error: nil,
          prevItems: [],
          newItems: [])
        
        self.presenter.presentFeed(res)
      })
  }
}
