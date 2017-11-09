//
//  NewsCollectionViewController.swift
//  Newscover
//
//  Created by CODE-MAC1 on 11/8/17.
//  Copyright © 2017 PT. Code Development Indonesia. All rights reserved.
//

import UIKit
import TRMosaicLayout

private let reuseIdentifier = "TRMosaicCell"

class NewsCollectionViewController: UICollectionViewController {

    let books = ["norwegianwood", "norwegianwood", "norwegianwood", "norwegianwood", "norwegianwood", "norwegianwood"] //, "norwegianwood2", "windupbird", "windupbird2", "running"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(cellType: NewsCollectionViewCell.self)
        let mosaicLayout = TRMosaicLayout()
        self.collectionView?.collectionViewLayout = mosaicLayout
        mosaicLayout.delegate = self
        
        self.collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return books.count
//    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return books.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as? NewsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
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
        print("tapped")
    }
}

    // MARK: UICollectionViewDelegate

extension NewsCollectionViewController: TRMosaicLayoutDelegate{
    
    func collectionView(_ collectionView: UICollectionView, mosaicCellSizeTypeAtIndexPath indexPath: IndexPath) -> TRMosaicCellType {
        return indexPath.item % 3 == 0 ? TRMosaicCellType.big : TRMosaicCellType.small
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: TRMosaicLayout, insetAtSection: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0)
    }
    
    func heightForSmallMosaicCell() -> CGFloat {
        return 150
    }
    
    
}
