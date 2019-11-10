//
//  NewsFeedViewController.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 09/10/2019.
//  Copyright (c) 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit

protocol NewsFeedDisplayLogic: class {
  func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData)
}

class NewsFeedViewController: UIViewController, NewsFeedDisplayLogic {

  var interactor: NewsFeedBusinessLogic?
  var router: (NSObjectProtocol & NewsFeedRoutingLogic)?
    
    @IBOutlet weak var table: UITableView!
    // MARK: Setup
    
    private var dialogViewModel =  DialogViewModel.init(cells: [])
  
  private func setup() {
    let viewController        = self
    let interactor            = NewsFeedInteractor()
    let presenter             = NewsFeedPresenter()
    let router                = NewsFeedRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    //self.view.largeContentTitle = "Сообщения"
    self.navigationItem.title = "Сообщения"
    table.register(UINib(nibName: "DialogCell", bundle: nil), forCellReuseIdentifier: DialogCell.reuseId)
    interactor?.makeRequest(request: .getDialogs)
  }
  
  func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData) {
    switch viewModel {
    case .displayDialogs(let dialogViewModel):
        self.dialogViewModel = dialogViewModel
        table.reloadData()
    }
  }
}

extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialogViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DialogCell.reuseId, for: indexPath) as! DialogCell
        let cellViewModel = dialogViewModel.cells[indexPath.row]
        cell.set(viewModel: cellViewModel)
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dialogViewController = DialogViewController()
        let photo: WebImageView! = WebImageView()
        photo.set(imageURL: dialogViewModel.cells[indexPath.row].photoUrlString)
        let name = dialogViewModel.cells[indexPath.row].name
        dialogViewController.set(name: name, photo: photo)
        let messagesViewController = MessagesViewController()
        messagesViewController.setDialogViewModel(dialogViewModel: dialogViewModel.cells[indexPath.row])
        navigationController?.pushViewController(messagesViewController, animated: true)
        
    }
}
