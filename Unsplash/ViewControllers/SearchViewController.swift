//
//  SearchViewController.swift
//  Unsplash
//
//  Created by 도미닉 on 12/16/25.
//

import UIKit
import ReactorKit
import SnapKit
import RxCocoa

final class SearchViewController: UIViewController, View {
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 1
        let itemsPerRow: CGFloat = 4
        let totalSpacing = (spacing * 2) + (spacing * (itemsPerRow - 1))
        let width = (UIScreen.main.bounds.width - totalSpacing) / itemsPerRow
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.itemSize = CGSize(width: width, height: width)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell")
        return collectionView
    }()
    private let searchBar = UISearchBar()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Search"
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray5
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
        searchBar.rx.text
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.updateQuery($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.images }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items(cellIdentifier: "SearchCollectionViewCell", cellType: SearchCollectionViewCell.self)) { index, model, cell in
                cell.configure(with: model)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self, weak reactor] indexPath in
              guard let self else { return }
              self.view.endEditing(true)
              guard let image = reactor?.currentState.images[indexPath.row] else { return }
                let detailViewController = DetailViewController(reactor: DetailViewReactor(initialState: .init(image: image)))
              self.navigationController?.pushViewController(detailViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.contentOffset
            .flatMap { [weak collectionView] offset -> Observable<Void> in
                guard let cv = collectionView else { return .empty() }

                let visibleHeight = cv.frame.height
                    - cv.contentInset.top
                    - cv.contentInset.bottom

                let y = offset.y + cv.contentInset.top
                let threshold = max(
                    0,
                    cv.contentSize.height - visibleHeight - 300
                )

                return y > threshold ? .just(()) : .empty()
            }
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
