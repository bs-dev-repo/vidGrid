//
//  AppSetup.swift
//  VidGridApp
//
//  Created by Apple on 02/08/24.
//

import UIKit

func createRootViewController() -> UINavigationController {
    
    
    // For Local JSON
    let localJSONService = LocalJSONService()
    let viewModel = ReelsViewModel(videoService: localJSONService)
    let reelsViewController = ReelsViewController(viewModel: viewModel)

    reelsViewController.navigationItem.largeTitleDisplayMode = .never
    let navigationController = UINavigationController(rootViewController: reelsViewController)

    
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .white
    appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
    appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
            
    
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    
    return navigationController
}

