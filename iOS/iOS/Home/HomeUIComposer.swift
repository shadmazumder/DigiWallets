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
        let presentationAdapter = HomeLoaderPresentationAdapter(remoteLoader: loader)
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
