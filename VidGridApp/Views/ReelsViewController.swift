//
//  ReelsViewController.swift
//  VidGridApp
//
//  Created by Apple on 02/08/24.
//

import UIKit

class ReelsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    private var viewModel: ReelsViewModel!
    private var isScrolling = false
    
    
    init(viewModel: ReelsViewModel) {
        self.viewModel =  viewModel
        super.init(nibName: String(describing: ReelsViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        
        setupBindings()
        viewModel.fetchVideos()
        
    }
    
    private func setupBindings() {
        errorLabel.text = ""
        viewModel.onVideosUpdated = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            self?.activityIndicator.isHidden = !isLoading
            isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        }
        
        viewModel.onError = { [weak self] errorMessage in
            self?.errorLabel.text = errorMessage
            self?.errorLabel.isHidden = errorMessage.isEmpty ? false : true
        }
    }
    
    
    private func setupNavigationBar() {
        title = "Reels"
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: "MyCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "MyCell")
        let layout = FullScreenFlowLayout()
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        
    }
        
}

extension ReelsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewModel.videos.count + 3) / 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as? MyCell else {
            fatalError("Unable to dequeue MyCell")
        }
        
        let startIndex = indexPath.item * 4
        let endIndex = min(startIndex + 4, viewModel.videos.count)
        let reelsForCell = Array(viewModel.videos[startIndex..<endIndex])
        cell.configure(with: reelsForCell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = view.bounds.width
        let screenHeight = view.bounds.height
        return CGSize(width: screenWidth, height: screenHeight)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let visibleCells = collectionView.visibleCells as? [MyCell] else { return }
        for cell in visibleCells {
            cell.playAllVideos()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let visibleCells = collectionView.visibleCells as? [MyCell] else { return }
        for cell in visibleCells {
            cell.pauseVideos()
        }
    }
    
}
