//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import PromiseKit
import DeepDiff
import AsyncDisplayKit

class RepositoryFeedUseCase {
  
  func fetch(nextPage: Int?) -> Promise<[GithubRepo]?> {
    
    return GithubService.RepositoryList(nextPage: nextPage).request()
  }
}
