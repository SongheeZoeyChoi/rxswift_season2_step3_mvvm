//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by Songhee Choi on 2021/11/14.
//  Copyright © 2021 iamchiwon. All rights reserved.
//

import Foundation
import RxSwift

class MenuListViewModel {
    
//    let menus: [Menu] = [
//        Menu(name: "튀김1", price: 100, count: 0),
//        Menu(name: "튀김1", price: 100, count: 0),
//        Menu(name: "튀김1", price: 100, count: 0),
//        Menu(name: "튀김1", price: 100, count: 0),
//    ]
    
//    lazy var menuObservable = Observable.just(menus) // menu에 대한 Observable
    // Observable.just(menus)는 밖에서 컨트롤 할 수 없기 때문에 Subject 를 사용한다.
//    lazy var menuObservable = PublishSubject<[Menu]>() // Menu Array받을때마다 observable이 동작함  // publishSubject 데이터 이미 들어간 다음에 subscribe하면 원래데이터 안받아짐. 다음 동작할 때 데이터 나오기 때문에 BehaviorSubject를 사용함
    lazy var menuObservable = BehaviorSubject<[Menu]>(value: []) //BehaviorSubject는 초기값 설정해줘야됨.
    // 이제 구독 했을 때 아래 init()에서 넣어준 값(최근의 값)을 불러올 수 있음.

    //    var totalPrice : Observable<Int> = Observable.just(10000)
    // Subject // Observable 처럼 값을 받을 수도 있지만 외부에서 값을 통제할 수 있음
//    var totalPrice : PublishSubject<Int> = PublishSubject()
    lazy var totalPrice = menuObservable.map{ //menus in
        //menus.filter{ $0.count > 0}
        //    .map{ $0.price * $0.count }.reduce(0,+)
        $0.map{ $0.price * $0.count }.reduce(0, +)
    }
    
    lazy var itemsCount = menuObservable.map{
        $0.map{ $0.count }.reduce(0, +)
    }
    
    init() {
        let menus: [Menu] = [
                Menu(id: 0, name: "튀김1", price: 100, count: 0),
                Menu(id: 1, name: "튀김1", price: 100, count: 0),
                Menu(id: 2, name: "튀김1", price: 100, count: 0),
                Menu(id: 3, name: "튀김1", price: 100, count: 0),
        ]
        
        menuObservable.onNext(menus)
    }
    
    func clearAllItemSelections() {
        _ = menuObservable
            .map { menu in
                menu.map { m in
                    Menu(id: m.id, name: m.name, price: m.price, count: 0)
                }
            }
             
            .take(1) // observable 한 번만 사용 하도록 처리 , 이거 안쓰면 계속 또 만들어짐. 한번 사용하고 끝나게 처리하기 위해 take(1)처리
            .subscribe(onNext: {
                self.menuObservable.onNext($0)
            })
    }
    
    func changeCount(item: Menu, increase: Int) {
        _ = menuObservable
            .map { menu in
                menu.map { m in
                    if m.id == item.id {
                        return Menu(id: m.id, name: m.name, price: m.price, count: max(m.count + increase, 0))
                    } else {
                        return Menu(id: m.id, name: m.name, price: m.price, count: m.count)
                    }
                }
            }
             
            .take(1) // observable 한 번만 사용 하도록 처리 , 이거 안쓰면 계속 또 만들어짐. 한번 사용하고 끝나게 처리하기 위해 take(1)처리
            .subscribe(onNext: {
                self.menuObservable.onNext($0)
            })
    }
    
    func onOrder() {
        
    }
    
}
