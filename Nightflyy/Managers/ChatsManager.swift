//
//  ChatsManager.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/26/24.
//

import SwiftUI
import FirebaseFirestore

@Observable
class ChatsManager {
    
    static let shared = ChatsManager()
    
    private init() { }
    
    var chats: [Chat] = []
    var viewModels: [InboxRowViewModel] = []
    private var listener: ListenerRegistration?
    private var messagesListener: ListenerRegistration?
    
    func initChatsListener(uid: String) async {
        self.createChatsListenerChats(uid: uid) { [weak self] chats in
            guard let self = self else {return}
            if self.viewModels.isEmpty {
                self.viewModels = chats.map{InboxRowViewModel(chat: $0)}
            }
            else {
                chats.forEach { chat in
                    if let index = self.viewModels.firstIndex(where: { oldViewModel in
                        return oldViewModel.chatID == chat.id
                    }) {
                        self.viewModels[index].chat = chat
                    }
                    else {
                        self.viewModels.append(InboxRowViewModel(chat: chat))
                    }
                }
            }
            self.viewModels.sort{$0.lastUpdated > $1.lastUpdated}
                
        }
    }
    
//    func createChatsListenerChats(uid: String, completion: @escaping ([Chat]) -> Void) {
//        var chats = [Chat]()
//        listener?.remove()
//        let db = FirebaseManager.shared.db
//        let query = db.collection(FirestoreCollections.Chats.value).whereField(FirestoreCollections.Chats.members, arrayContainsAny: [uid])
//        listener = query.addSnapshotListener { snapshot, error in
//            guard let documents = snapshot?.documents else { return }
//            chats = documents.compactMap({ documentSnapshot in
//                let result = Result<Chat, Error> { try documentSnapshot.data(as: Chat.self) }
//                switch result {
//                case .success(let chat):
//                    return chat
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    return nil
//                }
//            })
//            completion(chats)
//        }
//    }
    
    func removeChat(chatId: String) {
        if let index = self.viewModels.firstIndex(where: { oldViewModel in
            return oldViewModel.chatID == chatId
        }) {
            self.viewModels.remove(at: index)
        }
    }
    
    func createChatsListenerChats(uid: String, completion: @escaping ([Chat]) -> Void) {
        var chats = [Chat]()
        listener?.remove()
        let db = FirebaseManager.shared.db
        let query = db.collection(FirestoreCollections.Chats.value).whereField(FirestoreCollections.Chats.members, arrayContainsAny: [uid])
        listener = query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach { change in
                let chat = try! change.document.data(as: Chat.self)
                switch change.type {
                case .added, .modified:
                    chats.append(chat)
                case .removed:
                    if let index = self.viewModels.firstIndex(where: { oldViewModel in
                        return oldViewModel.chatID == chat.id
                    }) {
                        self.viewModels.remove(at: index)
                    }
                }
            }
            completion(chats)
        }
    }
    
    func createMessagesListener(uid: String, completion: @escaping ([Message]) -> Void) {
        var messages = [Message]()
        messagesListener?.remove()
        let db = FirebaseManager.shared.db
        let query = db.collection(FirestoreCollections.Chats.value).document(uid).collection(FirestoreCollections.Messages.value)
//            .whereField("date", isGreaterThan: Date().addingTimeInterval(-3600))
            .order(by: FirestoreCollections.Messages.date, descending: false)
        listener = query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach { change in
                if change.type == .added {
                    let message = try! change.document.data(as: Message.self)
                    messages.append(message)
                }
            }
            completion(messages)
        }
    }
    
    func getChat(with accountId: String) -> Chat {
        let chat = viewModels.first { $0.chat.members.contains(accountId) }?.chat
        if let chat {
            return chat
        }
        else {
            let uid = AccountManager.shared.account?.uid ?? ""
            let newChat = Chat(id: UUID().uuidString, members: [accountId, uid])
            return newChat
        }
    }
    
    static func fetchChat(members: [String]) async -> Chat? {
        do {
            let db = FirebaseManager.shared.db
            let query = db.collection(FirestoreCollections.Chats.value)
                .whereField(FirestoreCollections.Chats.members, arrayContains: members)
            let snapshot = try await query.getDocuments()
            let chats = try snapshot.documents.map({ document in
                return try document.data(as: Chat.self)
            })
            return chats.first
        }
        catch {
            return nil
        }
    }
    
    static func sendMessage(chatId: String, message: Message) throws {
        let db = FirebaseManager.shared.db
        try db.collection(FirestoreCollections.Chats.value).document(chatId).collection(FirestoreCollections.Messages.value).addDocument(from: message)
    }
    
    static func updateChat(_ chat: inout Chat, with message: Message) throws {
        chat.isNew = true
        switch message.type {
        case .text:
            chat.lastMessage = message.messageData.message
        case .event:
            chat.lastMessage = "Shared an Event"
        case .account:
            chat.lastMessage = "Shared a Profile"
        }
        chat.lastMessageSender = message.sender
        chat.lastUpdated = Date()
        try chat.save()
    }
    
    static func deleteChat(chatId: String) async throws {
        let db = FirebaseManager.shared.db
        try await db.collection(FirestoreCollections.Chats.value).document(chatId).delete()
    }
}
