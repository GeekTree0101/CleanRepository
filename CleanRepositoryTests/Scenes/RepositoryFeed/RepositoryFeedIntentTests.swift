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

class RepositoryFeedIntentTests: XCTestCase {
  
  var intent: RepositoryFeedIntent!
  var useCase: Stub_RepositoryFeedUseCase!
  
  override func setUp() {
    intent = RepositoryFeedIntent.init()
    useCase = Stub_RepositoryFeedUseCase.init()
    intent.useCase = useCase
  }
  
  override func tearDown() {
    
  }
  
  func testFetch() {
    
    useCase.register(Promise<[GithubRepo]?>.self, name: "fetch", provider: {
      return Promise.value([GithubRepo(id: 100), GithubRepo(id: 200)])
    })
    
    let output = try? hang(self.intent.fetch(.init(), isReload: true))
    
    expect(output?.nextSince) == 200
    expect(output?.items.count) == 2
    expect(output?.hasNext) == true
  }
  
  func testFetchNext() {
    
    let prevState = RepositoryFeedController.State(
      nextSince: 200,
      status: .some,
      items: [
        .init(
          repositoryID: 100,
          profileState: .init(),
          repoName: "test",
          repoDesc: "test",
          username: "test"),
        .init(
          repositoryID: 200,
          profileState: .init(),
          repoName: "test",
          repoDesc: "test",
          username: "test")],
      batchContext: nil,
      repoAreaChangeSet: [])
    
    useCase.register(Promise<[GithubRepo]?>.self, name: "fetch", provider: {
      return Promise.value([GithubRepo(id: 300), GithubRepo(id: 400), GithubRepo(id: 500)])
    })
    
    let output = try? hang(self.intent.fetch(prevState, isReload: true))
    
    expect(output?.nextSince) == 500
    expect(output?.items.count) == 5
    expect(output?.hasNext) == true
  }
  
  func testFetchEnded() {
    
    let prevState = RepositoryFeedController.State(
      nextSince: 200,
      status: .some,
      items: [
        .init(
          repositoryID: 100,
          profileState: .init(),
          repoName: "test",
          repoDesc: "test",
          username: "test"),
        .init(
          repositoryID: 200,
          profileState: .init(),
          repoName: "test",
          repoDesc: "test",
          username: "test")],
      batchContext: nil,
      repoAreaChangeSet: [])
    
    useCase.register(Promise<[GithubRepo]?>.self, name: "fetch", provider: {
      return Promise.value([])
    })
    
    let output = try? hang(self.intent.fetch(prevState, isReload: true))
    
    expect(output?.nextSince).to(beNil())
    expect(output?.items.count) == 2
    expect(output?.hasNext) == false
  }
  
  
  class Stub_RepositoryFeedUseCase: RepositoryFeedUseCase, Injectable {
    
    override func fetch(nextPage: Int?) -> Promise<[GithubRepo]?> {
      return resolve(Promise<[GithubRepo]?>.self, name: "fetch")!
    }
  }
}

