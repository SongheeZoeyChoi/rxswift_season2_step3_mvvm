//
//  Menu.swift
//  RxSwift+MVVM
//
//  Created by Songhee Choi on 2021/11/14.
//  Copyright © 2021 iamchiwon. All rights reserved.
//

import Foundation

// ViewModel: View를 위한 Model 일단 만들어놓음 
struct Menu {
    var id: Int
    var name: String
    var price: Int
    var count: Int
}

extension Menu {
    static func converterFromMenuItemsToMenu(id: Int, item: MenuItem) -> Menu {
        return Menu(id: id, name: item.name, price: item.price, count: 0)
    }
}
