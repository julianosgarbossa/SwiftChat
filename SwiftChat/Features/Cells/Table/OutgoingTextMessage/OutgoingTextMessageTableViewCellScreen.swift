//
//  OutgoingTextMessageTableViewCellScreen.swift
//  SwiftChat
//
//  Created by Juliano Sgarbossa on 28/09/26.
//

import UIKit

class OutgoingTextMessageTableViewCellScreen: UIView {

    private lazy var myMessageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = CustomColor.appPurple
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    lazy var messageTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont(name: CustomFont.poppinsSemiBold, size: 14)
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
        addSubview(myMessageView)
        myMessageView.addSubview(messageTextLabel)
        
        configConstraints()
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            myMessageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            myMessageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            myMessageView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            messageTextLabel.topAnchor.constraint(equalTo: myMessageView.topAnchor, constant: 15),
            messageTextLabel.leadingAnchor.constraint(equalTo: myMessageView.leadingAnchor, constant: 15),
            messageTextLabel.trailingAnchor.constraint(equalTo: myMessageView.trailingAnchor, constant: -15),
            messageTextLabel.bottomAnchor.constraint(equalTo: myMessageView.bottomAnchor, constant:  -15)
        ])
    }
}
