//
//  ViewController.swift
//  jyChoiReport
//
//  Created by JuYoung choi on 4/20/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let helloWorld = UILabel()
        
        helloWorld.text = "hello world"
        
        self.view.addSubview(helloWorld)
        
        helloWorld.snp.makeConstraints({m in
            m.center.equalToSuperview()
        })
    }


}

