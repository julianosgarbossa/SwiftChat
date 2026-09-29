//
//  ChatScreen.swift
//  SwiftChat
//
//  Created by Juliano Sgarbossa on 28/09/26.
//

import UIKit
import AVFoundation

protocol ChatScreenDelegate: AnyObject {
    func tappedSendButton()
}

class ChatScreen: UIView {

    private weak var delegate: ChatScreenDelegate?
    
    func delegate(delegate: ChatScreenDelegate) {
        self.delegate = delegate
    }
    
    private var player: AVAudioPlayer?
    
    private lazy var chatNavView: ChatNavView = {
        let view = ChatNavView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var messageInputView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var messageBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = CustomColor.appLight
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = CustomColor.appPink
        button.layer.cornerRadius = 22.5
        button.layer.shadowColor = CustomColor.appLight.cgColor
        button.layer.shadowRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowOpacity = 0.3
        button.setImage(UIImage(named: "send"), for: .normal)
        button.addTarget(self, action: #selector(tappedSendButton), for: .touchUpInside)
        return button
    }()
    
    lazy var inputMessageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Digite aqui"
        textField.font = UIFont(name: CustomFont.poppinsSemiBold, size: 14)
        textField.textColor = .darkGray
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(IncomingTextMessageTableViewCell.self, forCellReuseIdentifier: IncomingTextMessageTableViewCell.identifier)
        tableView.register(OutgoingTextMessageTableViewCell.self, forCellReuseIdentifier: OutgoingTextMessageTableViewCell.identifier)
        return tableView
    }()
    
    @objc
    private func tappedSendButton(_ sender: UIButton) {
        sendButton.touchAnimation(s: sendButton)
        delegate?.tappedSendButton()
        playSound()
        startPushMessage()
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        if inputMessageTextField.text == "" {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.sendButton.isEnabled = false
                self.sendButton.layer.opacity = 0.4
                self.sendButton.transform = .init(scaleX: 0.8, y: 0.8)
            }, completion: { _ in
                
            })
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.sendButton.isEnabled = true
                self.sendButton.layer.opacity = 1
                self.sendButton.transform = .identity
            }, completion: { _ in
                
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addVisualElements()

        sendButton.isEnabled = false
        sendButton.layer.opacity = 0.4
        sendButton.transform = .init(scaleX: 0.8, y: 0.8)
        inputMessageTextField.becomeFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addVisualElements() {
        backgroundColor = .white
        
        addSubview(chatNavView)
        addSubview(tableView)
        addSubview(messageInputView)
        messageInputView.addSubview(messageBar)
        messageBar.addSubview(inputMessageTextField)
        messageBar.addSubview(sendButton)
        
        configConstraints()
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            chatNavView.topAnchor.constraint(equalTo: topAnchor),
            chatNavView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chatNavView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chatNavView.heightAnchor.constraint(equalToConstant: 140),
            
            tableView.topAnchor.constraint(equalTo: chatNavView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageInputView.topAnchor),
            
            messageInputView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor),
            messageInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
            messageInputView.heightAnchor.constraint(equalToConstant: 80),
            
            messageBar.centerYAnchor.constraint(equalTo: messageInputView.centerYAnchor),
            messageBar.leadingAnchor.constraint(equalTo: messageInputView.leadingAnchor, constant: 20),
            messageBar.trailingAnchor.constraint(equalTo: messageInputView.trailingAnchor, constant: -20),
            messageBar.heightAnchor.constraint(equalToConstant: 55),
            
            sendButton.bottomAnchor.constraint(equalTo: messageBar.bottomAnchor, constant: -10),
            sendButton.trailingAnchor.constraint(equalTo: messageBar.trailingAnchor, constant: -15),
            sendButton.widthAnchor.constraint(equalToConstant: 55),
            sendButton.heightAnchor.constraint(equalToConstant: 55),

            inputMessageTextField.centerYAnchor.constraint(equalTo: messageBar.centerYAnchor),
            inputMessageTextField.leadingAnchor.constraint(equalTo: messageBar.leadingAnchor, constant: 20),
            inputMessageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -5),
            inputMessageTextField.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    private func startPushMessage() {
        inputMessageTextField.text = ""
        sendButton.isEnabled = false
        sendButton.layer.opacity = 0.4
        sendButton.transform = .init(scaleX: 0.8, y: 0.8)
    }
    
    private func playSound() {
        guard let url = Bundle.main.url(forResource: "send", withExtension: "wav") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            guard let player = player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func configChatNavViewProtocol(delegate: ChatNavViewDelegate) {
        chatNavView.delegate(delegate: delegate)
    }
    
    func configTableViewProtocols(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
    
    func realodTableView() {
        tableView.reloadData()
    }
}
