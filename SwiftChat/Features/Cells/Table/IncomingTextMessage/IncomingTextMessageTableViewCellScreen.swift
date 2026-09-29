//
//  IncomingTextMessageTableViewCellScreen.swift
//  SwiftChat
//
//  Created by Juliano Sgarbossa on 28/09/26.
//

import UIKit

class IncomingTextMessageTableViewCellScreen: UIView {

    private lazy var contactMessageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 0.06)
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    lazy var messageTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.font = UIFont(name: CustomFont.poppinsMedium, size: 14)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addVisualElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addVisualElements() {
        addSubview(contactMessageView)
        contactMessageView.addSubview(messageTextLabel)
        
        configConstraints()
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            contactMessageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            contactMessageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            contactMessageView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            messageTextLabel.topAnchor.constraint(equalTo: contactMessageView.topAnchor, constant: 15),
            messageTextLabel.leadingAnchor.constraint(equalTo: contactMessageView.leadingAnchor, constant: 15),
            messageTextLabel.trailingAnchor.constraint(equalTo: contactMessageView.trailingAnchor, constant: -15),
            messageTextLabel.bottomAnchor.constraint(equalTo: contactMessageView.bottomAnchor, constant:  -15)
        ])
    }
}
