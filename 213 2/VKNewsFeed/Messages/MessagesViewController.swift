//
//  MessagesViewController.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 06/11/2019.
//  Copyright (c) 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit
import CoreData

protocol MessagesDisplayLogic: class {
  func displayData(viewModel: Messages.Model.ViewModel.ViewModelData)
}

class MessagesViewController: UIViewController, MessagesDisplayLogic {

  var interactor: MessagesBusinessLogic?
    //var id: String = "0";
    var lastSavedMessageId: Int!
    var lastMessageId = 20
    private var messagesViewModel: [SavedMessage] = []
    private var dialogViewCellModel: DialogViewCellModel!
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var ViewController: NSObject!
    
    
    private func setup() {
    let viewController        = self
    let interactor            = MessagesInteractor()
    let presenter             = MessagesPresenter()
    viewController.interactor = interactor
    interactor.presenter      = presenter
    presenter.viewController  = viewController
  }
    
    func getLastSavedMessageId() -> Int {
        return lastSavedMessageId
    }
    
    func setLastMessageId(id: Int) {
        lastMessageId = id
    }
    
    @objc private func refresh() {
        //interactor?.makeRequest(request: .getHistory(id: "\(dialogViewCellModel.id)"))
    }
  
    @IBAction func sendMessageButton(_ sender: Any) {
        interactor?.makeRequest(request: .sendMessage(userId: "\(dialogViewCellModel.id)", message: text.text ?? " "))
        //interactor?.makeRequest(request: .getHistory(id: "\(dialogViewCellModel.id)"))
        text.text = ""
        
    }
    
    func addMessage(message: MessageViewCellModel) {
        if table == nil {
            saveMessage(historyViewModel: message)
        } else {
            //messagesViewModel.append(saveMessage(historyViewModel: message))
            messagesViewModel.insert(saveMessage(historyViewModel: message), at: 0)
            table.reloadData()
        }
    }
    
    func setDialogViewModel(dialogViewModel: DialogViewCellModel) {
        self.dialogViewCellModel = dialogViewModel
    }
    
    @objc func updateMessages() {
        interactor?.makeRequest(request: .updateHistory)
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.navigationItem.title = dialogViewCellModel.name
        navigationController?.navigationBar.tintColor = .white
        let timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateMessages), userInfo: nil, repeats: true)
        showAndHideKeyBoard()
        rotateTable()
        table.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: MessageCell.reuseId)
        loadSavedMessages()
        interactor?.makeRequest(request: .getHistory(id: "\(dialogViewCellModel.id)", count: lastMessageId - lastSavedMessageId))
  }
    
    func loadSavedMessages() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<SavedMessage> = SavedMessage.fetchRequest()
          fetchRequest.predicate = NSPredicate(format: "conversationId == %i", Int64(dialogViewCellModel.id))
        let sort = NSSortDescriptor(key: "conversationMessageId", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        do {
          let results = try context.fetch(fetchRequest)
          if !results.isEmpty {
              messagesViewModel = results
              lastSavedMessageId = Int(messagesViewModel[0].conversationMessageId)
          } else {
            lastSavedMessageId = 0
            }
        } catch {
          print("Мне похуя я рэпер")
          //print(error.localizedDescription)
        }
    }
    
    
    func saveMessage(historyViewModel: MessageViewCellModel) -> SavedMessage {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let context = appDelegate.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "SavedMessage", in: context)
      let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! SavedMessage
      taskObject.id = Int64(historyViewModel.id)
        taskObject.message = historyViewModel.text
        taskObject.fromId = Int64(historyViewModel.fromId)
        taskObject.date = historyViewModel.date
        taskObject.conversationMessageId = Int64(historyViewModel.conversationMessageId)
        taskObject.conversationId = Int64(historyViewModel.peerId)
        lastSavedMessageId = historyViewModel.conversationMessageId
      do {
        try context.save()
        print("Saved! Good Job! \(taskObject.message)")
      } catch {
        print(error.localizedDescription)
      }
        return taskObject
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.1 {
            //interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.getNextBatch)
        }
    }
    
  func displayData(viewModel: Messages.Model.ViewModel.ViewModelData) {
    switch viewModel {
    case .displayHistory(let historyViewModel):
        for history in historyViewModel.cells {
            messagesViewModel.insert(saveMessage(historyViewModel: history), at: 0)
            
        }
        table.reloadData()
        refreshControl.endRefreshing()
    case .displayNewMessages(let historyViewModel):
        for history in historyViewModel.cells {
            messagesViewModel.insert(saveMessage(historyViewModel: history), at: 0)
        }
        table.reloadData()
        refreshControl.endRefreshing()
    }
   }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardFrame.height
        }

    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func rotateTable() {
        table.transform = CGAffineTransform (scaleX: 1, y: -1);
        table.addSubview(refreshControl)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 1
    }
    
    func showAndHideKeyBoard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        table.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
        messagesViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseId, for: indexPath) as! MessageCell
        
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        let cellViewModel = convertToHistoryViewModel(message: messagesViewModel[indexPath.section])
        cell.set(viewModel: cellViewModel)
        cell.transform = CGAffineTransform(scaleX: 1, y: -1);
        return cell;
    }
    
    func convertToHistoryViewModel(message: SavedMessage) -> HistoryViewModel.Cell {
        return HistoryViewModel.Cell.init(text: message.message!, date: message.date!, fromId: Int(message.fromId), id: Int(message.id), conversationMessageId: Int(message.conversationMessageId), peerId: Int(message.conversationId))
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
