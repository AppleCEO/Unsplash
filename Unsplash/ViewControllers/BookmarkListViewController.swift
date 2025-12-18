//
//  BookmarkListViewController.swift
//  Unsplash
//
//  Created by 도미닉 on 12/18/25.
//

import UIKit
import ReactorKit
import RxCocoa
import SnapKit

class BookmarkListViewController: UIViewController, View {
    private let layout: UICollectionViewLayout
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: layout
    )
    var disposeBag = DisposeBag()
    
    init(
        reactor: BookmarkListViewReactor,
        collectionViewLayout: UICollectionViewLayout
    ) {
        self.layout = collectionViewLayout
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Bookmark"
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray5
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.register(
            SearchCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchCollectionViewCell.identifier
        )
    }
    
    func bind(reactor: BookmarkListViewReactor) {
        reactor.state.map { $0.images }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items(cellIdentifier: SearchCollectionViewCell.identifier, cellType: SearchCollectionViewCell.self)) { index, model, cell in
                cell.configure(with: model)
            }
            .disposed(by: disposeBag)
    }
}
