//
//  ViewController.swift
//  ShoppingProject
//
//  Created by piri kim on 7/26/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        NaverShoppingAPI.shared.fetchProducts(query: "이북리더기", display: 5)
        // Do any additional setup after loading the view.
    }


}

extension Int {
    var decimalString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

extension String {
    var decimalString: String {
        guard let number = Int(self) else { return self }
        return number.decimalString
    }
}
