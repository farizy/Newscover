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
import XLPagerTabStrip

private let reuseIdentifier = "TRMosaicCell"

enum ChildCategory: String {
    case all = "All"
    case general = "General"
    case business = "Business"
    case entertaiment = "Entertainment"
    case gaming = "Gaming"
    case music = "Music"
    case politics = "Politics"
    case science = "Science"
    case sport = "Sports"
    case technology = "Technology"
}

class NewsCollectionViewController: UICollectionViewController, NVActivityIndicatorViewable {

    var viewModel: NewsCollectionViewModel?
    fileprivate let disposeBag = DisposeBag()

    var category: ChildCategory?
    
    let progressView = CGSize(width: 80, height: 80)
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.black
        return refreshControl
    }()
    
    func handleRefresh(_ refreshControl: UIRefreshControl){
        self.viewModel?.getSource()
        self.collectionView?.reloadData()
        refreshControl.endRefreshing()
    }
    @IBOutlet var newsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.register(cellType: NewsCollectionViewCell.self)
        let mosaicLayout = TRMosaicLayout()
        self.collectionView?.collectionViewLayout = mosaicLayout
        
        self.title = "Discover"
        mosaicLayout.delegate = self
        
        self.collectionView?.addSubview(self.refreshControl)
        
        switch category {
        case .some(.all):
            viewModel = NewsCollectionViewModel()
        case .some(.general):
            viewModel = NewsCollectionViewModel(category: Category.general)
        case .some(.business):
            viewModel = NewsCollectionViewModel(category: Category.business)
        case .some(.entertaiment):
            viewModel = NewsCollectionViewModel(category: Category.entertaiment)
        case .some(.gaming):
            viewModel = NewsCollectionViewModel(category: Category.gaming)
        case .some(.music):
            viewModel = NewsCollectionViewModel(category: Category.music)
        case .some(.politics):
            viewModel = NewsCollectionViewModel(category: Category.politics)
        case .some(.science):
            viewModel = NewsCollectionViewModel(category: Category.science)
        case .some(.sport):
            viewModel = NewsCollectionViewModel(category: Category.sport)
        case .some(.technology):
            viewModel = NewsCollectionViewModel(category: Category.technology)
        case .none:
            break
        }
        
        configureViewModelObserver()
        configurePlaceholderView()
        
        viewModel?.getSource()
        
        startLoading()
        startAnimating(self.progressView, message: "Loading",  type: .ballClipRotateMultiple, color: UIColor.black, backgroundColor: UIColor.clear, textColor: UIColor.black)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureViewModelObserver(){
        viewModel?.sources
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                self?.newsCollectionView.reloadData()
                self?.endLoading()
                self?.stopAnimating()
            })
            .addDisposableTo(disposeBag)
        
        viewModel?.errorObserver
        .asObservable()
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] errorMessage in
                self?.endLoading()
                self?.stopAnimating()
                self?.setMessageForErrorView(errorMessage)
                if let errorView = self?.errorView as? CustomErrorView{
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
        errorView = CustomErrorView(frame: view.frame)
        if let errorView = errorView as? CustomErrorView {
            errorView.retryButtonTapped = { [weak self] in
                self?.startAnimating(self?.progressView, message: "Loading",  type: .ballClipRotateMultiple, color: UIColor.black, backgroundColor: UIColor.clear, textColor: UIColor.black)
                self?.viewModel?.getSource()
                self?.collectionView?.reloadData()
            }
        }
    }
    
    func setMessageForErrorView(_ message: String){
        if let errorView = errorView as? CustomErrorView {
            errorView.setMessage(message)
        }
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        let item = viewModel?.sources.value.count

        return item ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as? NewsCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let items = viewModel?.sources.value else { return UICollectionViewCell() }
        let item = items[indexPath.row]
        cell.configureCell(source: item)
        
        return cell
    }

   override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let source = viewModel?.sources.value[indexPath.row] else { return }
        let VM = GestureViewModel(source: source)
    
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GestureViewControllerID") as? GestureViewController else { return }
        vc.viewModel = VM
        self.present(vc, animated: true, completion: nil)
        print("Tapped \(source.id)")
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
        guard let count = viewModel?.sources.value.count else { return false }
        return count > 0
    }
}

extension NewsCollectionViewController: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: category?.rawValue)
    }
}
