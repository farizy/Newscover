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

private let reuseIdentifier = "TRMosaicCell"

class NewsCollectionViewController: UICollectionViewController {

    
    fileprivate let viewModel = NewsCollectionViewModel()
    fileprivate let disposeBag = DisposeBag()

    let books = ["norwegianwood", "norwegianwood", "norwegianwood", "norwegianwood", "norwegianwood", "norwegianwood"] //, "norwegianwood2", "windupbird", "windupbird2", "running"]
    
    @IBOutlet var newsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(cellType: NewsCollectionViewCell.self)
        let mosaicLayout = TRMosaicLayout()
        self.collectionView?.collectionViewLayout = mosaicLayout
        self.title = "Discover"
        mosaicLayout.delegate = self
        //makeCorner(withRadius: 10)
//        viewModel.getArticle()
        viewModel.getSource()
        configureViewModelObserver()
        
        
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
            })
            .addDisposableTo(disposeBag)
        
        viewModel.errorObserver
        .asObservable()
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] errorMessage in
                let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                let noAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(noAction)
                self?.present(alert, animated: true, completion: nil)
        })
        .addDisposableTo(disposeBag)
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
