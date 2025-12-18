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

class DetailViewController: UITableViewController, View {
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
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray5
    }
    
    func bind(reactor: DetailViewReactor) {
        reactor.state
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.tableView.reloadData()
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
