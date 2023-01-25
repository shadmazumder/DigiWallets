//
//  ErrorMapper.swift
//  MyCryptoApp
//
//  Created by Shad Mazumder on 5/6/22.
//

import Foundation
import CryptoLoader

typealias AlertContent = (title: String, message: String, action: String)

struct ErrorMapper {
    static func alertContent(for error: Error) -> AlertContent?{
        switch error {
        case ResultError.connectivity:
            return connectivityAlertContent()
        default:
            RemoteTracker.track(error)
            return nil
        }
    }
    
    static private func connectivityAlertContent() -> AlertContent{
        let title = "Oops!"
        let message = "😬 We lost the connection 🙈"
        let action = "Try again later"
        return (title, message, action)
    }
}
