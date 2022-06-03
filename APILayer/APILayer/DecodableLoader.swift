//
//  DecodableLoader.swift
//  APILayer
//
//  Created by Shad Mazumder on 3/6/22.
//

import Foundation

public enum DecodableResult {
    case success(Decodable)
    case failure(Error)
}

public protocol DecodableLoader{
    func load<T: Decodable>(from url: URL, of type:  T.Type, completion: @escaping ((DecodableResult) -> Void))
}
