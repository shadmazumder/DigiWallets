//
//  HTTPClient.swift
//  CryptoLoader
//
//  Created by Shad Mazumder on 27/5/22.
//

import Foundation

public protocol HTTPClient{
    func get(from url: URL, completion: @escaping ((HTTPResult) -> Void))
}
