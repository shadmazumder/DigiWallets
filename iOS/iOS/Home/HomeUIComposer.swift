//
//  HomeUIComposer.swift
//  iOS
//
//  Created by Shad Mazumder on 4/6/22.
//

import UIKit
import APILayer

public protocol HomeViewControllerDelegate {
    func didRequestHomeRefresh()
}

public final class HomeUIComposer{
    private init(){}
    
    public static func homeComposeWith(loader: DecodableLoader, errorDelegate: HomeViewErrorDelegate, walletURL: URL?, transactionURL: URL?) -> HomeViewController{
        let presentationAdapter = HomeLoaderPresentationAdapter(remoteLoader: MainQueueDispatchDecorator(decoratee: loader))
        let homeViewController = HomeViewController.makeWith(delegate: presentationAdapter)
        presentationAdapter.presenter = HomePresenter(homeView: homeViewController, loadingView: homeViewController, errorDelegate: errorDelegate, walletURL: walletURL, transactionURL: transactionURL)
        return homeViewController
    }
}

private extension HomeViewController{
    static func makeWith(delegate: HomeViewControllerDelegate) -> HomeViewController{
        let bundle = Bundle(for: HomeViewController.self)
        let storyboard = UIStoryboard(name: "Home", bundle: bundle)
        let homeViewController = storyboard.instantiateInitialViewController() as! HomeViewController
        homeViewController.delegate = delegate
        return homeViewController
    }
}

private final class MainQueueDispatchDecorator: DecodableLoader{
    private let decoratee: DecodableLoader
    
    init(decoratee: DecodableLoader) {
        self.decoratee = decoratee
    }
    
    func load<T>(from url: URL, of type: T.Type, completion: @escaping ((DecodableResult) -> Void)) where T : Decodable {
        decoratee.load(from: url, of: T.self) { result in
            if Thread.isMainThread{
                completion(result)
            }else{            
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
}
