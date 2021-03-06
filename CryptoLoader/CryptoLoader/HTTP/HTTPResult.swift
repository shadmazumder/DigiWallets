//
//  HTTPResult.swift
//  CryptoLoader
//
//  Created by Shad Mazumder on 27/5/22.
//

import Foundation

public enum HTTPResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public enum ResultError: Error {
    case connectivity
    case non200HTTPResponse
    case unexpectedError
}
