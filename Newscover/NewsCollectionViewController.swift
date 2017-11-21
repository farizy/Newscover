//
//  NewsCollectionViewController.swift
//  Newscover
//
//  Created by CODE-MAC1 on 11/8/17.
//  Copyright © 2017 PT. Code Development Indonesia. All rights reserved.
//

import UIKit
import TRMosaicLayout
import RxCocoa
import RxSwift
import NVActivityIndicatorView
import StatefulViewController

private let reuseIdentifier = "TRMosaicCell"

class NewsCollectionViewController: UICollectionViewController, NVActivityIndicatorViewable {

    
    fileprivate let viewModel = NewsCollectionViewModel()
    fileprivate let disposeBag = DisposeBag()
    
    let progressView = CGSize(width: 80, height: 80)
    

    let books = ["norwegianwood", "norwegianwood", "norwegianwood", "norwegianwood", "norwegianwood", "norwegianwood"] //, "norwegianwood2", "windupbird", "windupbird2", "running"]
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.black
        return refreshControl
    }()
    
    func handleRefresh(_ refreshControl: UIRefreshControl){
        self.viewModel.getSource()
        self.collectionView?.reloadData()
        refreshControl.endRefreshing()
    }
    @IBOutlet var newsCollectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(cellType: NewsCollectionViewCell.self)
        let mosaicLayout = TRMosaicLayout()
        self.collectionView?.collectionViewLayout = mosaicLayout
        self.title = "Discover"
        mosaicLayout.delegate = self
        
        self.collectionView?.addSubview(self.refreshControl)
        viewModel.getSource()
        configureViewModelObserver()
        configurePlaceholderView()
        
        startAnimating(self.progressView, message: "Loading",  type: .ballClipRotateMultiple, color: UIColor.black, backgroundColor: UIColor.clear, textColor: UIColor.black)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureViewModelObserver(){
        viewModel.articles
        .asObservable()
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: {[weak self] _ in
            self?.newsCollectionView.reloadData()
        })
        .addDisposableTo(disposeBag)
        
        viewModel.sources
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                self?.newsCollectionView.reloadData()
                self?.stopAnimating()
            })
            .addDisposableTo(disposeBag)
        
        viewModel.errorObserver
        .asObservable()
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] errorMessage in
                self?.stopAnimating()
                //self?.setMessageForErrorView(errorMessage)
                if let errorView = self?.errorView as? ErrorView{
                    errorView.setMessage(errorMessage)
                }
//                let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
//                let noAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
//                alert.addAction(noAction)
//                self?.present(alert, animated: true, completion: nil)
        })
        .addDisposableTo(disposeBag)
    }
    
    func configurePlaceholderView(){
        
        errorView = ErrorView(frame: view.frame)
        if let errorView = errorView as? ErrorView {
            errorView.retryButtonTapped = { [weak self] in
                self?.startAnimating(self?.progressView, message: "Loading",  type: .ballClipRotateMultiple, color: UIColor.black, backgroundColor: UIColor.clear, textColor: UIColor.black)
                self?.viewModel.getSource()
            }
        }
    }
    
    func setMessageForErrorView(_ message: String){
        if let errorView = errorView as? ErrorView{
            errorView.setMessage(message)
        }
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
//        let item = viewModel.articles.value.count
        let item = viewModel.sources.value.count

        return item
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as? NewsCollectionViewCell else {
            return UICollectionViewCell()
        }
//        let items = viewModel.articles.value
        let items = viewModel.sources.value
        let item = items[indexPath.row]
        cell.configureCell(source: item)
        
        return cell
    }

   override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let newsTitle = viewModel.articles.value[indexPath.row].title
//        print(newsTitle)
    
        let apapun = viewModel.sources.value
        let itemApapun = apapun[indexPath.row]
        let VM = GestureViewModel(source: itemApapun)
    
    guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GestureViewControllerID") as? GestureViewController else{
            return
    }
    vc.viewModel = VM
        self.present(vc, animated: true, completion: nil)
    print("Tapped \(viewModel.sources.value[indexPath.row].id)")
    }
}

    // MARK: UICollectionViewDelegate

extension NewsCollectionViewController: TRMosaicLayoutDelegate{
    
    func collectionView(_ collectionView: UICollectionView, mosaicCellSizeTypeAtIndexPath indexPath: IndexPath) -> TRMosaicCellType {
        return indexPath.item % 3 == 0 ? TRMosaicCellType.big : TRMosaicCellType.small
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: TRMosaicLayout, insetAtSection: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 2, bottom: 3, right: 3)
    }
    
    func heightForSmallMosaicCell() -> CGFloat {
        return 150
    }
    
}

extension NewsCollectionViewController: StatefulViewController{
    func hasContent() -> Bool {
        return viewModel.sources.value.count > 0
    }
}
