//
//  Message.swift
//  GoRide
//
//  Created by Ansh Taneja on 10/03/26.
//

import Foundation

struct Message: Equatable, Codable {
    let messageId: UUID
    var senderId: UUID
    var receiverId: UUID
    var vehicleId: UUID
    var messageText: String
    var timestamp: Date
    
    init(senderId: UUID, receiverId: UUID, vehicleId: UUID, messageText: String, timestamp: Date) {
        self.messageId = UUID()
        self.senderId = senderId
        self.receiverId = receiverId
        self.vehicleId = vehicleId
        self.messageText = messageText
        self.timestamp = timestamp
    }
    
    static func ==(lhs: Message, rhs: Message) -> Bool {
        return lhs.messageId == rhs.messageId
    }
}

class MessageDataModel {
    
    static let shared = MessageDataModel()
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let archiveURL: URL
    
    private var messages: [Message] = []
    
    private init() {
        archiveURL = documentsDirectory.appendingPathComponent("messages").appendingPathExtension("plist")
        loadMessages()
    }
    
    // MARK: - Public Methods
    
    func getAllMessages() -> [Message] {
        return messages
    }
    
    func addMessage(_ message: Message) {
        messages.append(message)
        saveMessages()
    }
    
    func updateMessage(_ message: Message) {
        if let index = messages.firstIndex(where: { $0.messageId == message.messageId }) {
            messages[index] = message
            saveMessages()
        }
    }
    
    func deleteMessage(at index: Int) {
        messages.remove(at: index)
        saveMessages()
    }
    
    // MARK: - Private Methods
    
    private func loadMessages() {
        if let savedMessages = loadMessagesFromDisk() {
            messages = savedMessages
        } else {
            messages = loadSampleMessages()
        }
    }
    
    private func loadMessagesFromDisk() -> [Message]? {
        guard let codedMessages = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([Message].self, from: codedMessages)
    }
    
    private func saveMessages() {
        let propertyListEncoder = PropertyListEncoder()
        let codedMessages = try? propertyListEncoder.encode(messages)
        try? codedMessages?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func loadSampleMessages() -> [Message] {
        let message1 = Message(senderId: UUID(), receiverId: UUID(), vehicleId: UUID(), messageText: "Hi, is this car available for next weekend?", timestamp: Date())
        let message2 = Message(senderId: UUID(), receiverId: UUID(), vehicleId: UUID(), messageText: "Yes, it is available. Would you like to book?", timestamp: Date())
        let message3 = Message(senderId: UUID(), receiverId: UUID(), vehicleId: UUID(), messageText: "Can I get a discount for a 7-day rental?", timestamp: Date())
        return [message1, message2, message3]
    }
}
