//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import PromiseKit

class UserProfileUseCase {
  
  func getUser(_ username: String) -> Promise<GithubUser?> {
    
    return GithubService.UserRepo.init(username: username).request()
  }
}
