//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import PromiseKit

class UserProfileIntent {
  
  typealias UserProfileState = UserProfileController.UserProfileState
  
  public var userProfileUseCase: UserProfileUseCase = UserProfileUseCase()
  
  func reload(_ state: UserProfileState) -> Promise<UserProfileState> {
    
    return userProfileUseCase.getUser(state.username ?? "")
      .threading(on: .default)
      .map({ user -> UserProfileState in
        var newState = state
        
        newState.contentState = UserProfileContentNode.State(
          profileState: UserProfileNode.State(profileImageURL: user?.profileURL),
          displayNickname: user?.username ?? "???",
          originalName: user?.orignalName ?? user?.username ?? "unknown",
          company: user?.company,
          location: user?.location,
          homePageURL: user?.homePageURL,
          bio: user?.bio)
        
        return newState
      })
  }
}
