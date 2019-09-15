//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import DeepDiff

enum RepositoryFeedModels {
  
  enum Feed {
    
    struct Request {
      
      var isReload: Bool
    }
    
    struct Response {
      
      var error: Error?
      var prevItems: [GithubRepo]
      var newItems: [GithubRepo]
    }
    
    struct ViewModel {
      
      var errorToastMessage: String? = nil
      var hasNext: Bool = false
      var cellViewModels: [GithubRepositoryCellNode.State] = []
      var repoAreaChangeSet: [Change<GithubRepositoryCellNode.State>] = []
    }
  }
}
