//
//  BaseViewController.swift
//  PageDemo
//
//  Created by mac on 2019/1/8.
//  Copyright © 2019 youmy. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    
    lazy var label:UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 21))
        label.textAlignment = .center
        label.center = view.center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
    }

    /// 刷新页面
    func refresh(){
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
