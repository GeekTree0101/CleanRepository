//
//  Created by Geektree0101.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import Foundation

import PromiseKit
import Alamofire

protocol APIService {
  
  static var baseURL: String { get }
}

protocol API {
  
  associatedtype Response: Decodable
  var url: String { get }
  var method: HTTPMethod { get }
  func params() -> Parameters?
}

protocol AdvencedAPI: API {
  
  var encoding: ParameterEncoding { get }
  var headers: HTTPHeaders? { get }
}

extension API {
  
  func request() -> Promise<Response?> {
    
    return Alamofire
      .request(
        url,
        method: method,
        parameters: params(),
        encoding: URLEncoding.queryString,
        headers: nil
      )
      .responseDecodable()
  }
}

extension AdvencedAPI {
  
  func request() -> Promise<Response?> {
    
    return Alamofire
      .request(
        url,
        method: method,
        parameters: params(),
        encoding: encoding,
        headers: headers
      )
      .responseDecodable()
  }
}
