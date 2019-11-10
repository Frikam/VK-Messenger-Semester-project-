//
//  MessagesViewController.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 06/11/2019.
//  Copyright (c) 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit

protocol MessagesDisplayLogic: class {
  func displayData(viewModel: Messages.Model.ViewModel.ViewModelData)
}

class MessagesViewController1: UIViewController, MessagesDisplayLogic {

  var interactor: MessagesBusinessLogic?
  var router: (NSObjectProtocol & MessagesRoutingLogic)?
    var id: String = "0";
    private var messagesViewModel = HistoryViewModel.init(cells: [])
    // MARK: Setup
  
    @IBOutlet weak var table: UITableView!
    
    private func setup() {
    let viewController        = self
    let interactor            = MessagesInteractor()
    let presenter             = MessagesPresenter()
    let router                = MessagesRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: Routing
  
  
    
    func setId(conversationId: Int) {
        id = "\(conversationId)"
    }
  // MARK: View lifecycle
  
    @IBOutlet weak var ViewController: NSObject!
    override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    //table.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: MessageCell.reuseId)
    //interactor?.makeRequest(request: .getHistory(id: id))

  }
  
  func displayData(viewModel: Messages.Model.ViewModel.ViewModelData) {
    switch viewModel {
    case .displayHistory(let historyViewModel):
        self.messagesViewModel = historyViewModel
        table.reloadData()
  }
 
}
}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseId, for: indexPath) as! MessageCell
        
        let cellViewModel = messagesViewModel.cells[indexPath.row]
        cell.set(viewModel: cellViewModel)
        return cell;
    }
}
