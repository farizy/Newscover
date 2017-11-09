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
    
//    init(viewModel: NewsCollectionViewModel){
//        super.init(nibName: "NewsCollectionViewCell", bundle: nil)
//        self.viewModel = viewModel
//    }
////
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        //fatalError("init(coder:) has not been implemented")
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(cellType: NewsCollectionViewCell.self)
        let mosaicLayout = TRMosaicLayout()
        self.collectionView?.collectionViewLayout = mosaicLayout
        self.navigationController?.navigationItem.title = "Discover"
        mosaicLayout.delegate = self
        viewModel.getArticle()
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
        let item = viewModel.articles.value.count
            
        return item
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as? NewsCollectionViewCell else {
            return UICollectionViewCell()
        }
        let items = viewModel.articles.value
        
        let item = items[indexPath.row]
        cell.configureCell(data: item)
//            let images = self.books[indexPath.item]
//            let imageView = UIImageView()
//            let image: UIImage = UIImage(named: images)!
//            imageView.image = image
//        imageView.frame = cell.frame
//        cell.contentView.addSubview(imageView)
    
        
        // Configure the cell
    
        return cell
    }

   override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newsTitle = viewModel.articles.value[indexPath.row].title
        print(newsTitle)
    }
}

    // MARK: UICollectionViewDelegate

extension NewsCollectionViewController: TRMosaicLayoutDelegate{
    
    func collectionView(_ collectionView: UICollectionView, mosaicCellSizeTypeAtIndexPath indexPath: IndexPath) -> TRMosaicCellType {
        return indexPath.item % 3 == 0 ? TRMosaicCellType.big : TRMosaicCellType.small
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: TRMosaicLayout, insetAtSection: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func heightForSmallMosaicCell() -> CGFloat {
        return 150
    }
    
    
}
