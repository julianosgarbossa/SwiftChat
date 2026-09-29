//
//  ChatNavView.swift
//  SwiftChat
//
//  Created by Juliano Sgarbossa on 28/09/26.
//

import UIKit

protocol ChatNavViewDelegate: AnyObject {
    func tappedBackButton()
}

class ChatNavView: UIView {

    private weak var delegate: ChatNavViewDelegate?
    
    func delegate(delegate: ChatNavViewDelegate) {
        self.delegate = delegate
    }

    private lazy var navBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 35
        view.layer.maskedCorners = [.layerMaxXMaxYCorner]
        view.layer.shadowColor = UIColor(white: 0, alpha: 0.05).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
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
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(tappedBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 26
        imageView.image = UIImage(named: "perfil")
        return imageView
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
    
    @objc
    private func tappedBackButton(_ sender: UIButton) {
        delegate?.tappedBackButton()
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
        navBarView.addSubview(backButton)
        navBarView.addSubview(userImageView)
        navBarView.addSubview(searchBarView)
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
            
            backButton.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: navBarView.leadingAnchor, constant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            
            userImageView.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor),
            userImageView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 20),
            userImageView.heightAnchor.constraint(equalToConstant: 55),
            userImageView.widthAnchor.constraint(equalToConstant: 55),
            
            searchBarView.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 20),
            searchBarView.trailingAnchor.constraint(equalTo: navBarView.trailingAnchor, constant: -20),
            searchBarView.heightAnchor.constraint(equalToConstant: 55),
            
            searchLabel.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor),
            searchLabel.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor, constant: 25),
            
            searchButton.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor),
            searchButton.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor, constant: -20),
            searchButton.heightAnchor.constraint(equalToConstant: 20),
            searchButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
}
