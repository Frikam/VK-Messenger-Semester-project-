//
//  NewsFeedViewController.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 09/10/2019.
//  Copyright (c) 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit
import CoreData

protocol NewsFeedDisplayLogic: class {
  func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData)
}

class NewsFeedViewController: UIViewController, NewsFeedDisplayLogic {

  var interactor: NewsFeedBusinessLogic?
    
    @IBOutlet weak var table: UITableView!
    // MARK: Setup
    private var messagesViewControllers: [MessagesViewController] = []
    private var dialogViewModel : [SavedConversation] =  []
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    private var ts: String!
    private var pts: String!
    private var key: String!
    private var server: String!
  
  private func setup() {
    let viewController        = self
    let interactor            = NewsFeedInteractor()
    let presenter             = NewsFeedPresenter()
    viewController.interactor = interactor
    interactor.presenter      = presenter
    presenter.viewController  = viewController
  }

  
  @objc private func refresh() {
      //interactor?.makeRequest(request: .getDialogs)
  }
    
    @objc func updateMessages() {
        interactor?.makeRequest(request: .updateHistory(ts: ts, pts: pts, key: key, server: server))
    }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    loadSavedMessages()
    interactor?.makeRequest(request: .getLongPollServer)
    table.addSubview(refreshControl)
    navigationController?.navigationBar.barTintColor = UIColor(red:0.35, green:0.49, blue:0.64, alpha:1.0)
    self.navigationItem.title = "Сообщения"
    navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

    table.register(UINib(nibName: "DialogCell", bundle: nil), forCellReuseIdentifier: DialogCell.reuseId)
    interactor?.makeRequest(request: .getDialogs)
    let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateMessages), userInfo: nil, repeats: true)
  }
    
    func loadSavedMessages() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<SavedConversation> = SavedConversation.fetchRequest()
         //fetchRequest.predicate = NSPredicate(format: "id = %@", "(dialogViewCellModel.id)")
        do {
          var results = try context.fetch(fetchRequest)
          if !results.isEmpty {
              dialogViewModel = results
          }
        } catch {
          print(error.localizedDescription)
        }
    }
    
    func saveConversation(conversationModel: DialogViewCellModel) {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let context = appDelegate.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "SavedConversation", in: context)
      let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! SavedConversation
      taskObject.id = Int64(conversationModel.id)
        taskObject.message = conversationModel.message
        taskObject.date = conversationModel.date
        taskObject.unreadMessages = Int64(conversationModel.unreadMessages)
        taskObject.photoUrlString = conversationModel.photoUrlString
        taskObject.lastMessageId = Int64(conversationModel.lastMessageId)
        taskObject.conversationMessageId = Int64(conversationModel.conversationMessageId)
        taskObject.name = conversationModel.name
        //taskObject.messagesView = conversationModel.messageViewController
        //taskObject.savedMessage = 
      do {
        try context.save()
        dialogViewModel.append(taskObject)
        print("Saved! Good Job!")
      } catch {
        print(error.localizedDescription)
      }
    }
  
  func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData) {
    switch viewModel {
    case .displayDialogs(let dialogViewModel):
        deleteData()
        for conversation in dialogViewModel.cells {
            messagesViewControllers.append(MessagesViewController())
            saveConversation(conversationModel: conversation)
        }
        //self.dialogViewModel = dialogViewModel
        table.reloadData()
        refreshControl.endRefreshing()
    case .saveLongPollServer(let serverViewModel):
        pts = serverViewModel.pts
        key = serverViewModel.key
        ts = serverViewModel.ts
        server = serverViewModel.server
    case .displayHistory(let historyViewModel):
        pts = "\(historyViewModel.newPts)"
        for message in historyViewModel.cells {
            addNewMessage(message: message)
        }
        table.reloadData()
    }
  }
    
    func addNewMessage(message: MessageViewCellModel) {
        for i in 0...messagesViewControllers.count - 1 {
            if (Int(dialogViewModel[i].id) == message.peerId) {
                messagesViewControllers[i].addMessage(message: message)
                dialogViewModel[i].message = message.text
                dialogViewModel[i].conversationMessageId = Int64(message.conversationMessageId)
                dialogViewModel[i].unreadMessages += 1
                dialogViewModel.insert(dialogViewModel[i], at: 0)
                dialogViewModel.remove(at: i + 1)
                messagesViewControllers.insert(messagesViewControllers[i], at: 0)
                messagesViewControllers.remove(at: i + 1)
            }
        }
    }
    
    func deleteData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        for savedConversaton in dialogViewModel {
            context.delete(savedConversaton)
        }
        dialogViewModel.removeAll()
    }
}

extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialogViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DialogCell.reuseId, for: indexPath) as! DialogCell
        let cellViewModel = dialogViewModel[indexPath.row]
        cell.set(viewModel: convertToDialogViewModel(conversation: cellViewModel))
        return cell
    }

    func convertToDialogViewModel(conversation: SavedConversation) -> DialogViewModel.Cell {
        return DialogViewModel.Cell.init(id: Int(conversation.id), lastMessageId: Int(conversation.lastMessageId), name: conversation.name ?? " ", message: conversation.message ?? " ", date: conversation.date ?? " ", photoUrlString: conversation.photoUrlString ?? " ", unreadMessages: Int(conversation.unreadMessages), messageViewController: MessagesViewController(), conversationMessageId: Int(conversation.conversationMessageId))
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dialogViewModel[indexPath.row].unreadMessages = 0
        table.reloadData()
        messagesViewControllers[indexPath.row].setLastMessageId(id: Int(dialogViewModel[indexPath.row].conversationMessageId))
        messagesViewControllers[indexPath.row].setDialogViewModel(dialogViewModel: convertToDialogViewModel(conversation: dialogViewModel[indexPath.row]))
        navigationController?.pushViewController(messagesViewControllers[indexPath.row], animated: true)
    }
}
