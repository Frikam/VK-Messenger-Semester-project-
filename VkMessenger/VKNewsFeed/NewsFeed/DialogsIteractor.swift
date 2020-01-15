import UIKit

protocol NewsFeedBusinessLogic {
  func makeRequest(request: Dialogs.Model.Request.RequestType)
}

class DialogsInteractor: NewsFeedBusinessLogic {

  var presenter: NewsFeedPresentationLogic?
  
    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())

  func makeRequest(request: Dialogs.Model.Request.RequestType) {
    
    switch request {
        case .getDialogs:
            fetcher.getDialogs { [weak self] (dialogResponse) in
                guard let dialogResponse = dialogResponse else { return }
                self?.presenter?.presentData(response: .presentDialogs(dialog: dialogResponse))
                }
        case .getLongPollServer:
            fetcher.getLongPollServer { [weak self] (serverResponse) in
                guard let serverResponse = serverResponse else { return }
                self?.presenter?.presentData(response: .presentLongPollServer(server: serverResponse))
                }
        case .updateHistory(let ts, let pts, let key, let server):
            fetcher.getLongPollHistory(ts: ts, pts: pts, key: key, server: server) { [weak self] (history) in
                guard let history = history else { return }
                self?.presenter?.presentData(response: .presentHistory(history: history))
                }

    }
  }
}
