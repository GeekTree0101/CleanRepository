//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import Codextended

struct GithubUser: Codable {
  
  var username: String = ""
  var profileURL: URL?
  var homePageURL: URL?
  var orignalName: String?
  var company: String?
  var location: String?
  var followerCount: Int = 0
  var repoCount: Int = 0
  var bio: String?
  
  init(from decoder: Decoder) throws {
    username = try! decoder.decode("login")
    profileURL = try? decoder.decode("avatar_url")
    homePageURL = try? decoder.decode("blog")
    orignalName = try? decoder.decode("name")
    company = try? decoder.decode("company")
    location = try? decoder.decode("location")
    followerCount = (try? decoder.decode("followers")) ?? 0
    repoCount = (try? decoder.decode("public_repos")) ?? 0
    bio = try? decoder.decode("bio")
  }
}
