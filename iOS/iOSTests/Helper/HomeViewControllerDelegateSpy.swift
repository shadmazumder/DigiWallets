//
//  HomeViewControllerDelegateSpy.swift
//  iOSTests
//
//  Created by Shad Mazumder on 1/6/22.
//

import Foundation
import iOS

class HomeViewControllerDelegateSpy: HomeViewControllerErrorDelegate {
    var errorResult = [Error]()
    
    func handleErrorState(_ error: Error){
        errorResult.append(error)
    }
}
