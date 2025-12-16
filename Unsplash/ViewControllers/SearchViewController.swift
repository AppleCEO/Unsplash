//
//  SearchViewController.swift
//  Unsplash
//
//  Created by 도미닉 on 12/16/25.
//

import UIKit
import ReactorKit
import SnapKit

final class SearchViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return cv
    }()
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [searchBar, collectionView].forEach {
            view.addSubview($0)
        }
        searchBar.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(searchBar.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func bind(reactor: SearchViewReactor) {
        
    }

}
