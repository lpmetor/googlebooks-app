//
//  ViewController+Extension.swift
//  Google_Book5
//
//  Created by jerry on 10/27/19.
//  Copyright © 2019 lpmetor. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func goToDetail(with vm: ViewModel) {

        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.viewModel = vm
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
