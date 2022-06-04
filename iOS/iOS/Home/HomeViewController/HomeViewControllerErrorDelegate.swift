//
//  HomeViewControllerErrorDelegate.swift
//  iOS
//
//  Created by Shad Mazumder on 3/6/22.
//

import Foundation

public enum HomeViewControllerError: Error {
    case unsetURLs
}

public protocol HomeViewControllerErrorDelegate{
    func handleErrorState(_ error: Error)
}
