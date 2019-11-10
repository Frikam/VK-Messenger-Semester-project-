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

class MessagesViewController: UIViewController, MessagesDisplayLogic {

  var interactor: MessagesBusinessLogic?
  var router: (NSObjectProtocol & MessagesRoutingLogic)?
    var id: String = "0";
    private var messagesViewModel = HistoryViewModel.init(cells: [])
    private var dialogViewCellModel: DialogViewCellModel!
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
  
  
    
    func setDialogViewModel(dialogViewModel: DialogViewCellModel) {
        self.dialogViewCellModel = dialogViewModel
    }
  // MARK: View lifecycle
  
     @IBOutlet weak var ViewController: NSObject!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = dialogViewCellModel.name
        setup()
        //table.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.table.transform = CGAffineTransform (scaleX: 1, y: -1);

        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 1
        table.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: MessageCell.reuseId)
        interactor?.makeRequest(request: .getHistory(id: "\(dialogViewCellModel.id)"))
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
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        messagesViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseId, for: indexPath) as! MessageCell
        
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 8
        //cell.clipsToBounds = true
        
        let cellViewModel = messagesViewModel.cells[indexPath.section]
        cell.set(viewModel: cellViewModel)
        cell.transform = CGAffineTransform(scaleX: 1, y: -1);
        return cell;
    }
    
     // There is just one row in every section
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 1
     }

     // Set the spacing between sections
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 5
     }


}
