//
//  HomeViewControllerDelegate.swift
//  iOS
//
//  Created by Shad Mazumder on 3/6/22.
//

import Foundation

public enum HomeViewControllerError: Error {
    case unsetURLs
}

public protocol HomeViewControllerDelegate{
    func handleErrorState(_ error: Error)
}
