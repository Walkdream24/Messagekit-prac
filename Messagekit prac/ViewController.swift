//
//  ViewController.swift
//  Messagekit prac
//
//  Created by 中重歩夢 on 2018/09/09.
//  Copyright © 2018年 Ayumu Nakashige. All rights reserved.
//

import UIKit
import MessageKit

class ViewController: MessagesViewController {
    
    var messageList: [MockMessage] = []
    
    lazy var formatter: DateFormatter = {
        let formatter =  DateFormatter()
        formatter.dateStyle = .medium
        return formatter
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.messageList = self.getMessges()
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToBottom()
            
            
        }
        
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
    messagesCollectionView.messageCellDelegate = self
        
    messageInputBar.delegate = self
    messageInputBar.sendButton.tintColor = UIColor.lightGray
    
    scrollsToBottomOnKeybordBeginsEditing = true
    maintainPositionOnKeyboardFrameChanged = true
    }
    
    func getMessges() -> [MockMessage] {
        return[
            
            createMessage(text: "２４歳学生です。"),
            createMessage(text: "やりますねえ"),
            createMessage(text: "こ↑こ↓"),
            createMessage(text: "ま、多少はね？"),
            createMessage(text: "まずウチさぁ...屋上あんだけど...焼いてかない？"),
            createMessage(text: "これもうわかんねぇな"),
            createMessage(text: "はっきりわかんだね"),
            createMessage(text: "イキスギィ！！"),
            createMessage(text: "114514"),
            createMessage(text: "ブッチッパ！")
        ]
    }
    
    func createMessage(text: String) -> MockMessage {
        let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.black])
        
        return MockMessage(attributedText: attributedText, sender: otherSender(), messageId: UUID().uuidString, date: Date())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
    
extension ViewController: MessagesDataSource {
        
        func currentSender() -> Sender {
            return Sender (id: "123", displayName: "Myself")
        }
        
        func otherSender() -> Sender {
            return Sender (id: "456" ,displayName: "野獣先輩")
        }
        
        func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
            
            return messageList.count
        }
        
        func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
            
            return messageList[indexPath.section]
        }
        
        func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
            
            if indexPath.section % 3 == 0 {
                return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            }
            return nil
        }
        
        func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
            
            let name = message.sender.displayName
            return NSAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)])
        }
        
        func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
            
            let dateString = formatter.string(from: message.sentDate)
            return NSAttributedString(string: dateString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2)])
        }

}

extension ViewController: MessagesDisplayDelegate {
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return isFromCurrentSender(message: message) ?
        UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1) :
        UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        
        return .bubbleTail(corner, .curved)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        let avatar = Avatar(image: UIImage(named: "beast.jpg"))
        avatarView.set(avatar: avatar)
        
    }
}

extension ViewController: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        if indexPath.section % 3 == 0 {return 10}
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 16
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 16
    }
}

extension ViewController: MessageCellDelegate {
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message Tapped")
    }
}

extension ViewController: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        for componet in inputBar.inputTextView.components {
            if let image = componet as? UIImage {
                
                let imageMessage = MockMessage(image: image, sender: currentSender(), messageId: UUID().uuidString, date: Date())
                messageList.append(imageMessage)
                messagesCollectionView.insertSections([messageList.count - 1])
                
            }else if let text = componet as? String {
                
                let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.white])
                
                let message = MockMessage(attributedText: attributedText, sender: currentSender(), messageId: UUID().uuidString, date: Date())
                
                messageList.append(message)
                messagesCollectionView.insertSections([messageList.count - 1])
            
                
            }
        }
        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom()
        
    }
}



