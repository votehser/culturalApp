//
//  ViewController.swift
//  RusEdit
//
//  Created by Maxim Reshetov on 05/04/2019.
//  Copyright © 2019 Maxim Reshetov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    var openSuggestions = false
    
    var originYOfUnderView: CGFloat = 0.0
    
    var top: CGFloat = 0.0
    var bottom: CGFloat = 0.0
    var tableViewHeight: CGFloat = 0.0
    
    let messagesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
    
    let suggestionsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alpha = 0
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    let navigationBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customBlue
        return view
    }()
    
    let navBarTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.text = "Сообщения"
        label.textAlignment = .center
        return label
    }()
    
    let underView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "send"), for: .normal)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    let messageTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 20
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0.5
        textField.autocorrectionType = .no
        textField.tintColor = UIColor.customBlue
        textField.setLeftPaddingPoints(15)
        textField.backgroundColor = .white
        return textField
    }()
    
    @objc func handleSend() {
        if messageTextField.text != "" {
            let message = Message(text: messageTextField.text!, isSender: true, color: UIColor.customBlue)
            messages.append(message)
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            messagesTableView.insertRows(at: [indexPath], with: .fade)
            messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            
            let answer = ChatBotAnswer(text: self.messageTextField.text!)
            let messageAnswer = Message(text: answer, isSender: false, color: UIColor.customGray)
            messages.append(messageAnswer)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let indexPath1 = IndexPath(row: messages.count - 1, section: 0)
                self.messagesTableView.insertRows(at: [indexPath1], with: .fade)
                self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            self.messageTextField.text = ""
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.tableViewHeight = 424
                self.messagesTableView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.tableViewHeight)
                self.underView.frame = CGRect(x: 0, y: self.tableViewHeight + 100, width: self.view.frame.width, height: 125)
                self.suggestionsCollectionView.alpha = 0
            })
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        showKeyboard()
        return true
    }
    
    func showKeyboard() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.tableViewHeight -= 268
            self.messagesTableView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.tableViewHeight)
            self.underView.frame = CGRect(x: 0, y: self.tableViewHeight + 100, width: self.underView.frame.width, height: 70)
            self.suggestionsCollectionView.alpha = 1
        })
    }
    
    func configureCollectionView() {
        
        suggestionsCollectionView.delegate = self
        suggestionsCollectionView.dataSource = self
        suggestionsCollectionView.register(SuggestionCell.self, forCellWithReuseIdentifier: "suggestion")
        
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messagesTableView.register(MessageCell.self, forCellReuseIdentifier: "message")
        
        let message = Message(text: "Добро пожаловать в симуляцию чата, который способствует развитию вашей письменной граммотности.", isSender: false, color: UIColor.customGray)
        messages.append(message)
        
        view.addSubview(messagesTableView)
        messagesTableView.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: tableViewHeight)
    }
    
    func configureNavBar() {
        view.addSubview(navigationBarView)
        navigationBarView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        navigationBarView.addSubview(navBarTitle)
        navBarTitle.frame = CGRect(x: (view.frame.width - 200 ) / 2, y: 50, width: 200, height: 40)
    }
    
    func configureMessageTextField() {
        messageTextField.delegate = self
        
        originYOfUnderView = view.frame.height - bottom - 70

        view.addSubview(underView)
        underView.frame = CGRect(x: 0, y: originYOfUnderView, width: view.frame.width, height: 125)
        
        [messageTextField, sendButton, suggestionsCollectionView].forEach {underView.addSubview($0)}
        messageTextField.frame = CGRect(x: 15, y: 15, width: view.frame.width - 15 - 70, height: 40)
        sendButton.frame = CGRect(x: view.frame.width - 55, y: 15, width: 40, height: 40)
        suggestionsCollectionView.frame = CGRect(x: 0, y: 70, width: view.frame.width, height: 55)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom
            top = topPadding!
            bottom = bottomPadding!
            tableViewHeight = view.frame.height - 100 - 70 - bottom
        }
        
        configureMessageTextField()
        configureCollectionView()
        configureNavBar()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(getHintsFromTextField),
            object: textField)
        self.perform(
            #selector(getHintsFromTextField),
            with: textField,
            afterDelay: 0.5)
        return true
    }
    
    @objc func getHintsFromTextField(textField: UITextField) {
        openSuggestions = offerSuggestions(textFieldText: textField.text!)
        if textField.text == "" || !openSuggestions {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.tableViewHeight = 424
                self.messagesTableView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.tableViewHeight)
                self.underView.frame = CGRect(x: 0, y: self.tableViewHeight + 100, width: self.view.frame.width, height: 125)
                self.suggestionsCollectionView.alpha = 0
            })
        } else {
            if openSuggestions {
                suggestionsCollectionView.reloadData()
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.tableViewHeight = 424 - 65
                        self.messagesTableView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.tableViewHeight)
                        self.underView.frame = CGRect(x: 0, y: self.tableViewHeight + 100, width: self.view.frame.width, height: 125)
                        self.suggestionsCollectionView.alpha = 1
                    })
                })
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath) as! MessageCell
        
        if messages[indexPath.row].isSender {
            let messageText = messages[indexPath.row].text
            
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            cell.messageTextView.frame = CGRect(x: cell.frame.width - (estimatedFrame.width + 37), y: 0, width: estimatedFrame.width + 15, height: estimatedFrame.height + 20)
            cell.textBubbleView.frame = CGRect(x: cell.frame.width - (estimatedFrame.width + 45), y: 0, width: estimatedFrame.width + 15 + 15, height: estimatedFrame.height + 20)
            cell.messageTextView.textColor = .white
        } else {
            let messageText = messages[indexPath.row].text
            
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            cell.messageTextView.frame = CGRect(x: 25, y: 0, width: estimatedFrame.width + 15, height: estimatedFrame.height + 20)
            cell.textBubbleView.frame = CGRect(x: 15, y: 0, width: estimatedFrame.width + 15 + 15, height: estimatedFrame.height + 20)
            cell.messageTextView.textColor = .black
        }
        cell.textBubbleView.backgroundColor = messages[indexPath.row].color
        cell.messageTextView.text = messages[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let messageText = messages[indexPath.row].text
        
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
        
        return estimatedFrame.height + 35
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let changedWord = changedWords[indexPath.row]
        
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        let estimatedFrame = NSString(string: changedWord).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
        return CGSize(width: estimatedFrame.width + 15, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return changedWords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "suggestion", for: indexPath) as! SuggestionCell
        
        let changedWord = changedWords[indexPath.item]
        
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        let estimatedFrame = NSString(string: changedWord).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
        cell.suggestionLabel.frame = CGRect(x: 25, y: 0, width: estimatedFrame.width, height: 40)
        cell.underView.frame = CGRect(x: 15, y: 0, width: estimatedFrame.width + 20, height: 40)
        cell.suggestionLabel.text = changedWords[indexPath.item]
        
        return cell
    }
}

