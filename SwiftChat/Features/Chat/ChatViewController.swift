//
//  ChatViewController.swift
//  SwiftChat
//
//  Created by Juliano Sgarbossa on 28/09/26.
//

import UIKit

class ChatViewController: UIViewController {

    private var screen: ChatScreen?
    private let viewModel: ChatViewModel
    
    init(contact: Contact) {
        viewModel = ChatViewModel(contact: contact)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        screen = ChatScreen()
        view = screen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configProtocols()
        viewModel.getCurrentUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.addListinerRecoveryMessages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.removeMessagesListener()
    }
    
    private func configProtocols() {
        screen?.configTableViewProtocols(delegate: self, dataSource: self)
        screen?.configChatNavViewProtocol(delegate: self)
        screen?.delegate(delegate: self)
        viewModel.delegate(delegate: self)
    }
}

extension ChatViewController: UITableViewDelegate {
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isUserLogged(index: indexPath.row) {
            // Lado Direito
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OutgoingTextMessageTableViewCell.identifier, for: indexPath) as? OutgoingTextMessageTableViewCell else { return UITableViewCell() }
            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell.setupCell(message: viewModel.loadCurrentMessage(index: indexPath.row))
            return cell
        } else {
            // Lado Esquerdo
            guard let cell = tableView.dequeueReusableCell(withIdentifier: IncomingTextMessageTableViewCell.identifier, for: indexPath) as? IncomingTextMessageTableViewCell else { return UITableViewCell() }
            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell.setupCell(message: viewModel.loadCurrentMessage(index: indexPath.row))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let text = viewModel.loadCurrentMessageText(index: indexPath.row)
        let font = UIFont(name: CustomFont.poppinsSemiBold, size: 14) ?? UIFont()
        let estimateHeight = text.heightWithConstrainedWidth(width: 220, font: font)
        return 65 + estimateHeight
    }
}

extension ChatViewController: ChatNavViewDelegate {
    func tappedBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension ChatViewController: ChatScreenDelegate {
    func tappedSendButton() {
        let message: String = screen?.inputMessageTextField.text ?? ""
        viewModel.actionPushMessage(message: message)
    }
}

extension ChatViewController: ChatViewModelDelegate {
    func successRecoveryMessages() {
        screen?.realodTableView()
    }
}
