//
//  ViewController.swift
//  jyChoiReport
//
//  Created by JuYoung choi on 4/20/24.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    let viewModel = NewsViewModel()
    let disposeBag = DisposeBag()
    
    func drawView() {
        
        self.viewModel.requestNewsList()
        
        self.viewModel.newsList.asDriver().drive(onNext: {[unowned self] list in
            guard let list = list else {
                return
            }
            
            assert(list.count > 0)
        }).disposed(by: self.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.drawView()
    }


}

