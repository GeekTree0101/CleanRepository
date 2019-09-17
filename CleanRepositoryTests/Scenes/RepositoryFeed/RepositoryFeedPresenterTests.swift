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

class RepositoryFeedPresenterTests: XCTestCase {
  
  var displayLogic: SpyDisplayLogic!
  var presenter: RepositoryFeedPresenter!
  
  override func setUp() {
    super.setUp()
    self.displayLogic = SpyDisplayLogic()
    self.presenter = RepositoryFeedPresenter.init()
    self.presenter.displayLogic = self.displayLogic
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testReload() {
    let res = RepositoryFeedModels.Feed.Response(
      error: nil,
      prevItems: [],
      newItems: [GithubRepo(id: 100), GithubRepo(id: 200)])
    
    self.presenter.presentFeed(res)
    
    expect(self.displayLogic.displayFeedItemsOutput?.hasNext) == true
    expect(self.displayLogic.displayFeedItemsOutput?.cellViewModels.count) == 2
    expect(self.displayLogic.displayFeedItemsOutput?.errorToastMessage).to(beNil())
    
    let indexPathSet = IndexPathConverter()
      .convert(changes: self.displayLogic.displayFeedItemsOutput?.repoAreaChangeSet ?? [],
               section: 0
    )
    expect(indexPathSet.inserts.count) == 2
    expect(indexPathSet.deletes.count) == 0
    expect(indexPathSet.replaces.count) == 0
    expect(indexPathSet.moves.count) == 0
  }
  
  func testLoadMore() {
    let res = RepositoryFeedModels.Feed.Response(
      error: nil,
      prevItems: [GithubRepo(id: 100), GithubRepo(id: 200)],
      newItems: [GithubRepo(id: 100), GithubRepo(id: 200), GithubRepo(id: 300), GithubRepo(id: 400), GithubRepo(id: 500)])
    
    self.presenter.presentFeed(res)
    
    expect(self.displayLogic.displayFeedItemsOutput?.hasNext) == true
    expect(self.displayLogic.displayFeedItemsOutput?.cellViewModels.count) == 5
    expect(self.displayLogic.displayFeedItemsOutput?.errorToastMessage).to(beNil())
    
    let indexPathSet = IndexPathConverter()
      .convert(changes: self.displayLogic.displayFeedItemsOutput?.repoAreaChangeSet ?? [],
               section: 0
    )
    expect(indexPathSet.inserts.count) == 3
    expect(indexPathSet.deletes.count) == 0
    expect(indexPathSet.replaces.count) == 0
    expect(indexPathSet.moves.count) == 0
  }
  
  func testReloadEmpty() {
    let res = RepositoryFeedModels.Feed.Response(
      error: nil,
      prevItems: [],
      newItems: [])
    
    self.presenter.presentFeed(res)
    
    expect(self.displayLogic.displayFeedItemsOutput?.hasNext) == false
    expect(self.displayLogic.displayFeedItemsOutput?.cellViewModels.count) == 0
    expect(self.displayLogic.displayFeedItemsOutput?.errorToastMessage).to(beNil())
    
    let indexPathSet = IndexPathConverter()
      .convert(changes: self.displayLogic.displayFeedItemsOutput?.repoAreaChangeSet ?? [],
               section: 0
    )
    expect(indexPathSet.inserts.count) == 0
    expect(indexPathSet.deletes.count) == 0
    expect(indexPathSet.replaces.count) == 0
    expect(indexPathSet.moves.count) == 0
  }
  
  func testLoadEnded() {
    let res = RepositoryFeedModels.Feed.Response(
      error: nil,
      prevItems: [GithubRepo(id: 100), GithubRepo(id: 200)],
      newItems: [GithubRepo(id: 100), GithubRepo(id: 200)])
    
    self.presenter.presentFeed(res)
    
    expect(self.displayLogic.displayFeedItemsOutput?.hasNext) == false
    expect(self.displayLogic.displayFeedItemsOutput?.cellViewModels.count) == 2
    expect(self.displayLogic.displayFeedItemsOutput?.errorToastMessage).to(beNil())
    
    let indexPathSet = IndexPathConverter()
      .convert(changes: self.displayLogic.displayFeedItemsOutput?.repoAreaChangeSet ?? [],
               section: 0
    )
    expect(indexPathSet.inserts.count) == 0
    expect(indexPathSet.deletes.count) == 0
    expect(indexPathSet.replaces.count) == 0
    expect(indexPathSet.moves.count) == 0
  }
  
  func testOnError() {
    let res = RepositoryFeedModels.Feed.Response(
      error: NSError.init(domain: "error", code: -1, userInfo: nil),
      prevItems: [],
      newItems: [])
    
    self.presenter.presentFeed(res)
    
    expect(self.displayLogic.displayFeedItemsOutput?.hasNext) == false
    expect(self.displayLogic.displayFeedItemsOutput?.cellViewModels.count) == 0
    expect(self.displayLogic.displayFeedItemsOutput?.errorToastMessage).toNot(beNil())
    
    let indexPathSet = IndexPathConverter()
      .convert(changes: self.displayLogic.displayFeedItemsOutput?.repoAreaChangeSet ?? [],
               section: 0
    )
    expect(indexPathSet.inserts.count) == 0
    expect(indexPathSet.deletes.count) == 0
    expect(indexPathSet.replaces.count) == 0
    expect(indexPathSet.moves.count) == 0
  }
}

// MARK: - Stub & Spy Objects
extension RepositoryFeedPresenterTests {
  
  class SpyDisplayLogic: RepositoryFeedDisplayLogic {
    
    var displayFeedItemsOutput: RepositoryFeedModels.Feed.ViewModel? = nil
    
    func displayFeedItems(_ viewModel: RepositoryFeedModels.Feed.ViewModel) {
      displayFeedItemsOutput = viewModel
    }
  }
}
