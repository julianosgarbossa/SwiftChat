//
//  ContactOrMessageCollectionViewCell.swift
//  SwiftChat
//
//  Created by Juliano Sgarbossa on 28/09/26.
//

import UIKit

class ContactOrMessageCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = String(describing: ContactOrMessageCollectionViewCell.self)
    
    private lazy var screen: ContactOrMessageCollectionViewCellScreen = {
        let screen = ContactOrMessageCollectionViewCellScreen()
        screen.translatesAutoresizingMaskIntoConstraints = false
        return screen
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addVisualElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addVisualElements() {
        contentView.addSubview(screen)
        
        configConstraints()
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            screen.topAnchor.constraint(equalTo: contentView.topAnchor),
            screen.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            screen.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            screen.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    private func setOnlyUserName(userName: String) {
        let attributedText = NSMutableAttributedString(string: userName, attributes: [NSAttributedString.Key.font : UIFont(name: CustomFont.poppinsMedium, size: 16) ?? UIFont(), NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        screen.userNameLabel.attributedText = attributedText
        
    }
    
    private func setUserNameAndLastMessage(name: String, lastMessage: String) {
        let attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.font : UIFont(name: CustomFont.poppinsMedium, size: 16) ?? UIFont(), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        attributedText.append(NSAttributedString(string: "\n\(lastMessage)", attributes: [NSAttributedString.Key.font: UIFont(name: CustomFont.poppinsMedium, size: 14) ?? UIFont(), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        screen.userNameLabel.attributedText = attributedText
    }
    
    func setupCellContact(contact: Contact) {
        setOnlyUserName(userName: contact.name ?? "")
    }
    
    func setupCellConversation(conversation: Conversation) {
        setUserNameAndLastMessage(name: conversation.name ?? "", lastMessage: conversation.lastMessage ?? "")
    }
}
