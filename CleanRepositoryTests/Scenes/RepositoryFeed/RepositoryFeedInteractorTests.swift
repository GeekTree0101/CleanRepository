//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import XCTest
import PromiseKit
import Nimble
import AsyncDisplayKit
import DeepDiff
@testable import CleanRepository

class RepositoryFeedIntenteractorTests: XCTestCase {

  var interactor: RepositoryFeedInteractor!
  var stubWorker = StubWorker.init()
  var spyPresenter: SpyPresenter!
  
  override func setUp() {
    super.setUp()
    self.interactor = RepositoryFeedInteractor.init(feedWorker: stubWorker)
    self.spyPresenter = SpyPresenter()
    
    interactor.presenter = self.spyPresenter
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testFetch() {
    // Given
    self.stubWorker.register(Promise<[GithubRepo]?>.self, name: "fetch", provider: {
      return Promise.value([GithubRepo(id: 100), GithubRepo(id: 200)])
    })
    
    // When
    let req = RepositoryFeedModels.Feed.Request(isReload: true)
    interactor.fetch(req)
    
    // Then
    expect(try? hang(self.spyPresenter.didPresentFeed.promise)) == true
  }

}

// MARK: - Stub & Spy Objects
extension RepositoryFeedIntenteractorTests {
  
  class SpyPresenter: RepositoryFeedPresenterLogic {
    
    var didPresentFeed = Promise<Bool>.pending()
    
    func presentFeed(_ res: RepositoryFeedModels.Feed.Response) {
      didPresentFeed.resolver.fulfill(true)
    }
  }
  
  class StubWorker: RepositoryFeedWorker, Injectable {
    
    override func fetch(nextPage: Int?) -> Promise<[GithubRepo]?> {
      return resolve(Promise<[GithubRepo]?>.self, name: "fetch")!
    }
  }
}
