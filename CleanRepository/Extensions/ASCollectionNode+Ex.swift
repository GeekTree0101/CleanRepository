//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import AsyncDisplayKit
import DeepDiff

extension ASCollectionNode {
  
  public func performBatch<T: DiffAware>(
    changes: [Change<T>],
    section: Int = 0,
    animated: Bool = true,
    completion: @escaping (Bool) -> Void) {
    
    let changesWithIndexPath = IndexPathConverter().convert(changes: changes, section: section)
    
    performBatch(animated: animated, updates: {
      internalBatchUpdates(changesWithIndexPath: changesWithIndexPath)
    }, completion: completion)
    
    changesWithIndexPath.replaces.executeIfPresent {
      self.reloadItems(at: $0)
    }
  }
  
  private func internalBatchUpdates(changesWithIndexPath: ChangeWithIndexPath) {
    changesWithIndexPath.deletes.executeIfPresent {
      deleteItems(at: $0)
    }
    
    changesWithIndexPath.inserts.executeIfPresent {
      insertItems(at: $0)
    }
    
    changesWithIndexPath.moves.executeIfPresent {
      $0.forEach { move in
        moveItem(at: move.from, to: move.to)
      }
    }
  }
}
