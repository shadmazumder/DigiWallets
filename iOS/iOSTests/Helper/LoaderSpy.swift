//
//  LoaderSpy.swift
//  iOSTests
//
//  Created by Shad Mazumder on 4/6/22.
//

import Foundation
import APILayer

class LoaderSpy: DecodableLoader {
    typealias Result = (url: URL, completion: ((DecodableResult) -> Void))
    var loadRequest = [Result]()
    
    func load<T>(from url: URL, of type: T.Type, completion: @escaping ((DecodableResult) -> Void)) where T : Decodable {
        loadRequest.append((url, completion))
    }
    
    func completeWithSuccess(_ decodableModel: Decodable, index: Int = 0){
        loadRequest[index].completion(.success(decodableModel))
    }
    
    func completeWithError(_ error: Error, index: Int = 0){
        loadRequest[index].completion(.failure(error))
    }
}
