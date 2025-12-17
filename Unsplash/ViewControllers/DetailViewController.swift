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
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Detail"
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    func bind(reactor: DetailViewReactor) {
        reactor.state
            .map { $0.image }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind { [weak self] image in
                self?.configure(image)
            }
            .disposed(by: disposeBag)
    }
    
    private func configure(_ image: Image) {
        
    }
}
