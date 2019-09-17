//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

struct GithubRepo: Codable {
  
  var id: Int = -1
  var user: GithubUser?
  var repositoryName: String?
  var desc: String?
  var isPrivate: Bool = false
  var isForked: Bool = false
  
  init(id: Int) {
    self.id = id
  }
  
  init(from decoder: Decoder) throws {
    id = try! decoder.decode("id")
    user = try? decoder.decode("owner")
    repositoryName = try? decoder.decode("full_name")
    desc = try? decoder.decode("description")
    isPrivate = (try? decoder.decode("private")) ?? false
    isForked = (try? decoder.decode("fork")) ?? false
  }
}
