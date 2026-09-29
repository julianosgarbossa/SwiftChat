//
//  HomeViewController.swift
//  SwiftChat
//
//  Created by Juliano Sgarbossa on 28/09/26.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var screen: HomeScreen?
    private let viewModel: HomeViewModel = HomeViewModel()
    
    override func loadView() {
        screen = HomeScreen()
        view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNagigation()
        configProtocols()
        viewModel.getCurrentUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.addListenerRecoveryConversation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.removeConsersationListener()
    }
    
    private func configNagigation() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configProtocols() {
        screen?.configCollectionViewProtocols(delegate: self, dataSource: self)
        screen?.configNavViewProtocol(delegate: self)
        viewModel.delegate(delegate: self)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.isScreenContact {
            if indexPath.item == viewModel.getContactListCount {
                addContact { [weak self] email in
                    self?.viewModel.addContact(email: email)
                }
            } else {
                let chatViewController = ChatViewController(contact: viewModel.loadCurrentContact(index: indexPath.item))
                navigationController?.pushViewController(chatViewController, animated: true)
            }
        } else {
            guard let contact = viewModel.loadCurrentContactForConversation(index: indexPath.row) else { return }
            let chatViewController = ChatViewController(contact: contact)
            navigationController?.pushViewController(chatViewController, animated: true)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.isScreenContact {
            return viewModel.numberOfItemsInSectionContact
        } else {
            return viewModel.numberOfItemsInSectionConversation
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.isScreenContact {
            if indexPath.item == viewModel.getContactListCount {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddContactCollectionViewCell.identifier, for: indexPath) as? AddContactCollectionViewCell else { return UICollectionViewCell() }
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactOrMessageCollectionViewCell.identifier, for: indexPath) as? ContactOrMessageCollectionViewCell else { return UICollectionViewCell() }
                cell.setupCellContact(contact: viewModel.loadCurrentContact(index: indexPath.item))
                return cell
            }
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactOrMessageCollectionViewCell.identifier, for: indexPath) as? ContactOrMessageCollectionViewCell else { return UICollectionViewCell() }
            cell.setupCellConversation(conversation: viewModel.loadCurrentConversation(index: indexPath.item))
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 75)
    }
}

extension HomeViewController: NavViewDelegate {
    func typeScreenMessage(type: TypeConversationOrContact) {
        switch type {
        case .conversation:
            viewModel.changeScreen(isScreenContact: false)
            screen?.reloadCollectionView()
        case .contact:
            viewModel.changeScreen(isScreenContact: true)
            viewModel.getAllContact()
        }
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func successSaveContact(title: String, message: String) {
        showAlert(title: title, message: message) { [weak self] in
            self?.viewModel.getAllContact()
        }
    }
    
    func successGetAllContact() {
        screen?.reloadCollectionView()
    }
    
    func successGetAllConversations() {
        screen?.reloadCollectionView()
    }
    
    func alertStateError(title: String, message: String) {
        showAlert(title: title, message: message)
    }
}
