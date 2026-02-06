//
//  DetailViewController.swift
//  Unsplash
//
//  Created by 도미닉 on 12/18/25.
//

import UIKit
import RxSwift
import ReactorKit
import RxCocoa
import SnapKit

class DetailViewController: UITableViewController, View {
    let bookmarkButton = BookmarkButton()
    var disposeBag = DisposeBag()
    
    init(reactor: DetailViewReactor) {
        super.init(style: .insetGrouped)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Detail"
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.identifier)
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: InfoTableViewCell.identifier)
        setupUI()
        tableView.reloadData()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray5
        view.addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints {
            $0.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func bind(reactor: DetailViewReactor) {
        bookmarkButton.rx.tap
            .map { DetailViewReactor.Action.tapBookmark }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isBookmarked }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind { [weak self] isLiked in
                self?.bookmarkButton.setLiked(isLiked, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configure(_ image: Image) {
        
    }
}

extension DetailViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let reactor else { return 0 }
        switch section {
        case 0:
            return 1
        case 1:
            return reactor.currentState.infoItems.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let reactor else { return .init() }
        switch indexPath.section {
        case 0:
            guard let imageCell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as? ImageTableViewCell else {
                return .init()
            }
            imageCell.configure(image: reactor.currentState.image)
            return imageCell
        case 1:
            guard let infoCell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as? InfoTableViewCell else {
                return .init()
            }
            let item = reactor.currentState.infoItems[indexPath.row]
            infoCell.configure(title: item.title, value: item.value)
            return infoCell
        default:
            return .init()
        }
    }
}
