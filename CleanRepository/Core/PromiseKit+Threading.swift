//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import PromiseKit

public extension Thenable {
  
  func threading(on qos: DispatchQoS.QoSClass) -> Self {
    return self.threading(on: DispatchQueue.global(qos: qos))
  }

  func threadingOnMain() -> Self {
    return self.threading(on: DispatchQueue.main)
  }
  
  func threading(on queue: DispatchQueue) -> Self {
    conf.Q.map = queue
    conf.Q.return = queue
    return self
  }
}
