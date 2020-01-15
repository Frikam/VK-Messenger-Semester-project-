import Foundation

struct API {
    static let scheme = "https"
    static let host = "api.vk.com"
    static let version = "5.101"
    static let hostServer = ""

    
    static let history = "/method/messages.getHistory"
    static let messages = "/method/messages.getConversations"
    static let send = "/method/messages.send"
    static let longPollServer = "/method/messages.getLongPollServer"
    static let longPollHistory = "/method/messages.getLongPollHistory"
}
