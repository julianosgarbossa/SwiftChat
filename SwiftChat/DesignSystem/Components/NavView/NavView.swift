//
//  NavView.swift
//  SwiftChat
//
//  Created by Juliano Sgarbossa on 28/09/26.
//

import UIKit

enum TypeConversationOrContact {
    case conversation
    case contact
}

protocol NavViewDelegate: AnyObject {
    func typeScreenMessage(type: TypeConversationOrContact)
}

class NavView: UIView {
    private weak var delegate: NavViewDelegate?
    
    func delegate(delegate: NavViewDelegate) {
        self.delegate = delegate
    }
    
    private lazy var navBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 35
        view.layer.maskedCorners = [.layerMaxXMaxYCorner]
        view.layer.shadowColor = UIColor.white.withAlphaComponent(0.02).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 10
        return view
    }()
    
    private lazy var navBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.maskedCorners = [.layerMaxXMaxYCorner]
        view.layer.cornerRadius = 35
        return view
    }()
    
    private lazy var searchBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = CustomColor.appLight
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var searchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Digite aqui"
        label.font = UIFont(name: CustomFont.poppinsMedium, size: 16)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "search"), for: .normal)
        return button
    }()
    
    private lazy var conversationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "message")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .systemPink
        button.addTarget(self, action: #selector(tappedConversationButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var contactButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "group")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(tappedContactButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [conversationButton, contactButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    @objc
    private func tappedConversationButton(_ sender: UIButton) {
        delegate?.typeScreenMessage(type: .conversation)
        conversationButton.tintColor = .systemPink
        contactButton.tintColor = .black
    }
    
    @objc
    private func tappedContactButton(_ sender: UIButton) {
        delegate?.typeScreenMessage(type: .contact)
        contactButton.tintColor = .systemPink
        conversationButton.tintColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addVisualElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addVisualElements() {
        addSubview(navBackgroundView)
        navBackgroundView.addSubview(navBarView)
        navBarView.addSubview(searchBarView)
        navBarView.addSubview(stackView)
        searchBarView.addSubview(searchLabel)
        searchBarView.addSubview(searchButton)
        
        configConstraints()
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            navBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            navBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            navBarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            navBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navBarView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            searchBarView.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: navBarView.leadingAnchor, constant: 30),
            searchBarView.trailingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -20),
            searchBarView.heightAnchor.constraint(equalToConstant: 55),
            
            stackView.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: navBarView.trailingAnchor, constant: -30),
            stackView.heightAnchor.constraint(equalToConstant: 30),
            stackView.widthAnchor.constraint(equalToConstant: 100),
            
            searchLabel.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor),
            searchLabel.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor, constant: 25),
            
            searchButton.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor),
            searchButton.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor, constant: -20),
            searchButton.widthAnchor.constraint(equalToConstant: 20),
            searchButton.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
