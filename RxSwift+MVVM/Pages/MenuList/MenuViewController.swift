//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa // RxCocoa : RxSwift의 요소들을 UIKit Extension으로 접목시킨 아이임.

class MenuViewController: UIViewController {
    // MARK: - Life Cycle
    
    let cellId = "MenuItemTableViewCell"
    
    let viewModel = MenuListViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // RxCocoa
        viewModel.menuObservable // RxCocoa 로 bind 하면 tableView의 DataSource 필요없어짐 // dataSource 끊어주도록 함!
            .bind(to: tableView.rx.items(cellIdentifier: cellId, cellType: MenuItemTableViewCell.self)) { index, item, cell in
                cell.title.text = item.name
                cell.price.text = "\(item.price)"
                cell.count.text = "\(item.count)"
                
                cell.onChange = { [weak self] increase in
                    self?.viewModel.changeCount(item: item, increase: increase)
                }
            }
            .disposed(by: disposeBag)
        
        
        viewModel.itemsCount
            .map{ "\($0)"}
            .observeOn(MainScheduler.instance)
            .bind(to: itemCountLabel.rx.text) // RxCocoa : 아래 [weak self]처럼 순환참조 할 필요가 없음
//            .subscribe(onNext: { [weak self] in
//                self?.itemCountLabel.text = $0
//            })
            .disposed(by: disposeBag)
        
        
        // 한번 subscribe하면 값이 바뀔때 마다 text값을 바꿔주기 때문에 더이상 updateUI()를 쓸 필요가 없어짐
        viewModel.totalPrice
            .scan(0, accumulator: +)
            .map{ $0.currencyKR() }
            .observeOn(MainScheduler.instance)
            .bind(to: totalPrice.rx.text)
//            .subscribe(onNext: {
//                self.totalPrice.text = $0
//            })
            .disposed(by: disposeBag)
        
        
        //        updateUI()
        
        
    }


//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let identifier = segue.identifier ?? ""
//        if identifier == "OrderViewController",
//            let orderVC = segue.destination as? OrderViewController {
//            // TODO: pass selected menus
//        }
//    }
//
//    func showAlert(_ title: String, _ message: String) {
//        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alertVC, animated: true, completion: nil)
//    }
    
    
    

    // MARK: - InterfaceBuilder Links

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var itemCountLabel: UILabel!
    @IBOutlet var totalPrice: UILabel!

    @IBAction func onClear() {
        viewModel.clearAllItemSelections()
    }

    @IBAction func onOrder(_ sender: UIButton) {
        // TODO: no selection
        // showAlert("Order Fail", "No Orders")
        // performSegue(withIdentifier: "OrderViewController", sender: nil)
//        viewModel.totalPrice += 100 // Int일때
//        updateUI()
        
        // 이제 여기서 Observable처럼 값을 받기만하는게 아니고, Observable 외부에서 컨트롤 할 수 없는 경우를 찾아야함!
        // 이게 바로 Subject //
//        viewModel.totalPrice.onNext(100)
        
//        // RxCocoa 쓰면서 - datasource 안쓰고 Menu Array 값만 바꿨는데 바뀌는 test
//        viewModel.menuObservable.onNext([
//            Menu(name: "changed", price: 200, count: 2)
//        ])
        
//        viewModel.menuObservable.onNext([
//            Menu(name: "changed", price: Int.random(in: 1000...30000), count: Int.random(in: 0...5)),
//            Menu(name: "changed", price: Int.random(in: 1000...30000), count: Int.random(in: 0...5)),
//            Menu(name: "changed", price: Int.random(in: 1000...30000), count: Int.random(in: 0...5))
//        ])
        
        viewModel.onOrder()
    }
    
    
    
//    func updateUI() {
//        itemCountLabel.text = "\(viewModel.itemsCount)"
////        totalPrice.text = "\(viewModel.totalPrice.currencyKR())" // totalPrice Int일때
//    }
    
    
}



//extension MenuViewController: UITableViewDataSource { // RxCocoa 쓰면서 필요없어짐 //
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.menus.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell") as! MenuItemTableViewCell
//
//        let menu = viewModel.menus[indexPath.row]
//        cell.title.text = menu.name
//        cell.price.text = "\(menu.price)"
//        cell.count.text = "\(menu.count)"
//
//        return cell
//    }
//}
