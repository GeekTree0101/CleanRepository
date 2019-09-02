//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import PromiseKit

enum GithubService: APIService {
  
  static var baseURL: String = "https://api.github.com"
  
  // API Spec & Request DTO
  struct RepositoryList: API {
    
    var nextPage: Int?
    
    typealias Response = [GithubRepo]
    
    var url: String {
      return baseURL + "/repositories"
    }
    
    var method: HTTPMethod {
      return .get
    }
    
    func params() -> Parameters? {
      return ["since": nextPage].compactMapValues({ $0 })
    }
  }
  
  struct UserRepo: API {
    
    typealias Response = GithubUser
    
    var username: String
    
    var url: String {
      return baseURL + "/users/\(username)"
    }
    
    var method: HTTPMethod {
      return .get
    }
    
    func params() -> Parameters? {
      return nil
    }
  }
}


