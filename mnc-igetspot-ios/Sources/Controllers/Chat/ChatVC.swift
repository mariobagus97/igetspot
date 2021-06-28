////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import DKImagePickerController
import MapKit
import SendBirdSDK
import SwiftDate
import SDWebImage
import FloatingPanel
import SnapKit
import Photos
import SwiftMessages
import Kingfisher

class ChatVC: MessagesViewController, UIGestureRecognizerDelegate {
    
    let userStringAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font:  R.font.barlowRegular(size: 14)!,
        NSAttributedString.Key.foregroundColor: UIColor.white
    ]
    
    let opponentStringAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font:  R.font.barlowRegular(size: 14)!,
        NSAttributedString.Key.foregroundColor: UIColor.black
    ]
    
    private var delegateIdentifier: String!
    private let callButton = UIButton(type: .custom)
    
    var attachmentPanel: FloatingPanelController?
    var confirmPanel : FloatingPanelController!
    
    var currentUserMessageStyle: MessageStyle!
    var otherUserMessageStyle: MessageStyle!
    var mediaImageMessageStyle: MessageStyle!
    
    var messageList: [ChatMessage] = []
    var messageSentArray:[SBDBaseMessage] = []
    var messageArray:[String:SBDBaseMessageParams] = [:]
    var chatterName:String!
    var chatterUserId:String!
    var chatterImageUrl:String!
    var phoneNumber:String!
    var chatterAvatarImage:UIImage!
    var sendbirdChannelUrl:String!
    var userSender: ChatUser!
    var currentUserAvatarImage: UIImage?
    var chatterSender: ChatUser!
    var channel:SBDGroupChannel?
    var igsMessageImages: [String:ImageMediaItem] = [:]
    var imageUrls: [String:String] = [:]
    var chosenImage = UIImage()
    var isImage: Bool = false
    weak var timer: Timer?

    // MARK: - Life Cycle
    
    // MARK:- Init
    init(chatterName: String, chatterUserId:String, sendbirdChannelUrl:String, chatterImageUrl:String, phoneNumber:String) {
        self.chatterName = chatterName
        self.chatterUserId = chatterUserId
        self.sendbirdChannelUrl = sendbirdChannelUrl
        self.chatterImageUrl = chatterImageUrl
        self.phoneNumber = phoneNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        guard let userId = TokenManager.shared.getUserId(), let chatterUserId = self.chatterUserId else {
            return
        }
        
        self.delegateIdentifier = self.description
        self.title = chatterName
        chatterSender = ChatUser(senderId: chatterUserId, displayName: chatterName ?? "")
        userSender = ChatUser(senderId: userId, displayName: "")
        
        sideMenuController?.isLeftViewSwipeGestureEnabled = false
        setupBarButtonItem()
        updateMessageStyle()
        configureMessageCollectionView()
        configureMessageInputBar()
        getCurrentChannel()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.presentIGSNavigationBar()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        SBDMain.add(self as SBDChannelDelegate, identifier: self.delegateIdentifier)
        ChatManager.shared.add(connectionObserver: self as ChatManagerConnectionDelegate)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
        SBDMain.removeChannelDelegate(forIdentifier: self.description)
        ChatManager.shared.remove(connectionObserver: self as ChatManagerConnectionDelegate)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messagesCollectionView.contentInset.bottom = messageInputBar.frame.height
        messagesCollectionView.scrollIndicatorInsets.bottom = messageInputBar.frame.height
    }
    
    deinit {
        print("deinit ChatVC")
    }
    
    // MARK: = Actions
    @objc func callButtonDidClicked() {
        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber ?? "")") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    // MARK: - Helpers
    private func getCurrentChannel() {
        guard let channelUrl = self.sendbirdChannelUrl else {
            return
        }
        showLoadingHUD()
        SBDGroupChannel.getWithUrl(channelUrl, completionHandler: { [weak self] (channel, error) in
            
            self?.hideLoadingHUD()
            if error != nil {
                self?.showErrorMessageBanner(error?.localizedDescription ?? NSLocalizedString("Ooops, we cannot get the channel room, please try again", comment: ""))
                return
            }
            // Successfully fetched the channel.
            // Do something with openChannel.
            self?.channel = channel
            self?.loadPreviousMessages(true)
        })
    }
    
    // MARK: - Handle Messages
    func loadPreviousMessages(_ fromCurrent:Bool = false) {
        guard let channel = self.channel else {
            return
        }
        let previousMessageQuery = channel.createPreviousMessageListQuery()
        previousMessageQuery?.loadPreviousMessages(withLimit: 100, reverse: false, completionHandler: {[weak self] (messages, error) in
            if error != nil {
                print("Error: %@", error!)
                if(fromCurrent){
                    self?.showErrorMessageBanner("Please check your connection.")
                }
                return
            }
        
            DispatchQueue.global(qos: .userInitiated).async {
                var chatMessageArray = [ChatMessage]()
                if let messagesArray = messages {
                    for message in messagesArray {
                        if let chatMessage = self?.parseSendbirdMessage(message: message, isFromLoadPreviousMessage: true) {
                            chatMessageArray.append(chatMessage)
                        }
                        channel.markAsRead()
                    }
                }
                
                DispatchQueue.main.async {
                    self?.messageList = chatMessageArray
                    self?.messagesCollectionView.reloadData()
                    self?.messagesCollectionView.scrollToBottom()
                    self?.hideLoadingHUD()
                    
                }
            }
        })
    }
    
    func loadNextMessages() {
        showLoadingHUD()
        let lastMessage = messageList.max(by: {
            $0.sentDate < $1.sentDate
        })
        let lastMessageSendDate = lastMessage?.sentDate ?? Date()
        guard let channel = self.channel else { return }
        channel.getPreviousAndNextMessages(byTimestamp: Int64(lastMessageSendDate.timeIntervalSince1970), prevLimit: 0,nextLimit:200, reverse: false, messageType: SBDMessageTypeFilter.all, customType: "") {[weak self] (messages, error) in
            self?.hideLoadingHUD()
            if error != nil {
                print("Error: %@", error!)
                return
            }
            if let messagesArray = messages {
                for message in messagesArray {
                    if let chatMessage = self?.parseSendbirdMessage(message: message, isFromLoadPreviousMessage: true) {
                        
                    }
                    channel.markAsRead()
                }
            }
        }
    }
    
    func parseSendbirdMessage(message:SBDBaseMessage,isFromLoadPreviousMessage:Bool) -> ChatMessage? {
        
        if message is SBDUserMessage {
            let userMessage = message as! SBDUserMessage
            let chatMessage = parseUserMessage(userMessage: userMessage, isFromLoadPreviousMessage: isFromLoadPreviousMessage)
            return chatMessage
        } else if message is SBDFileMessage {
            let fileMessage = message as! SBDFileMessage
            let chatMessage = parseFileMessage(fileMessage: fileMessage, isFromLoadPreviousMessage: isFromLoadPreviousMessage)
            return chatMessage
        }
        return nil
    }
    
    func parseUserMessage(userMessage:SBDUserMessage, isFromLoadPreviousMessage:Bool) -> ChatMessage {
        let sender = userMessage.sender
        var messageStatus:MessageStatus = isFromLoadPreviousMessage ? .read : .sending
        let messageType:IGSMessageType = .text
        if sender?.userId != SBDMain.getCurrentUser()?.userId {
            messageStatus = .read
        }
        let userID = sender?.userId
        let userName = sender?.nickname
        let messageText = userMessage.message ?? ""
        let createdAt = Int64(userMessage.createdAt)
        let messageID = userMessage.messageId
        let requestID = userMessage.requestId
        
        let messageDate  = Date(timeIntervalSince1970:Double(createdAt)/1000)
        let messageSender:ChatUser!
        let attributes:[NSAttributedString.Key:Any]!
        if userID == TokenManager.shared.getUserId() {
            messageSender = userSender
            attributes = userStringAttributes
        } else {
            messageSender = chatterSender
            attributes = opponentStringAttributes
        }
        
        let selfAttributed = NSAttributedString.init(string: messageText, attributes: attributes)
        let chatMessage = ChatMessage(attributedText: selfAttributed, sender: messageSender, messageId: "\(messageID)", date: messageDate)
        
        return chatMessage
    }
    
    func parseFileMessage(fileMessage: SBDFileMessage, isFromLoadPreviousMessage:Bool) -> ChatMessage {
        PrintDebug.printDebugGeneral(fileMessage.type, message: "fileMessage.type")
        
        let sender = fileMessage.sender
        var messageStatus:MessageStatus = isFromLoadPreviousMessage ? .read : .sending
        if sender?.userId != SBDMain.getCurrentUser()?.userId {
            messageStatus = .read
        }
        var messageType:IGSMessageType = .image
        var caption = fileMessage.name
        if (caption.isImageType()) {
            caption = ""
        }
        
        let messageData = fileMessage.serialize()
        let userID = sender?.userId
        let userName = sender?.nickname
        let messageText = caption
        let createdAt = fileMessage.createdAt
        let messageID = fileMessage.messageId
        let imageUrl = fileMessage.url
        let requestID = fileMessage.requestId
        if fileMessage.type == "audio/m4a" {
            messageType = .audio
        } else if fileMessage.type.isImageType(){
            messageType = .image
        } else {
            messageType = .unknown
        }
        
        let messageDate  = Date(timeIntervalSince1970:Double(createdAt)/1000)
        let messageSender:ChatUser!
        if userID == TokenManager.shared.getUserId() {
            messageSender = userSender
        } else {
            messageSender = chatterSender
        }
        
        let igsMessageImage = ImageMediaItem(imageUrl: imageUrl)
        self.igsMessageImages["\(messageID)"] = igsMessageImage
        self.imageUrls["\(messageID)"] = imageUrl
        
        if (imageUrl != ""){
            let chatMessage = ChatMessage(imageUrl: imageUrl, sender: messageSender, messageId: "\(messageID)", date: messageDate)
            return chatMessage
        } else {
            let chatMessage = ChatMessage(image: UIImage(data: messageData!)!, sender: messageSender, messageId: "\(messageID)", date: messageDate)
            return chatMessage
        }
     
    }
    
    func sendChatMessage(messageText:String) {
        guard let channel = self.channel else {
            return
        }
        print.self("ini coba sent data ", messageText)
        let preSendMessage = channel.sendUserMessage(messageText, completionHandler: {[weak self] (userMessage, error) in
            if (error != nil) {
                PrintDebug.printDebugGeneral(error!, message: "sendUserMessage error")
                self?.messageInputBar.sendButton.stopAnimating()
                self?.messageInputBar.inputTextView.text = messageText
            } else {
                if let message = userMessage {
                    self?.messageSentArray.append(message)
                    if let chatMessage = self?.parseSendbirdMessage(message: message, isFromLoadPreviousMessage: false) {
                        DispatchQueue.main.async {
                            self?.messageInputBar.sendButton.stopAnimating()
                            self?.messageInputBar.inputTextView.placeholder = NSLocalizedString("Write a message…", comment: "")
                            self?.insertMessage(chatMessage)
                        }
                    }
                }
            }
        })
    }
    
    func sendChatMessage(messageParam:SBDFileMessageParams, image: UIImage) {
        guard let channel = self.channel else {
            return
        }
        let index = messageList.endIndex + messageArray.count
        messageInputBar.sendButton.isEnabled = false
        let messageDate  = Date()
        let message = ChatMessage(image: image, sender: self.userSender, messageId: "loading\(index)", date: messageDate)
        self.insertMessage(message, index: messageList.endIndex)
        self.messageArray["error\(index)"] = messageParam
        self.messagesCollectionView.scrollToBottom()
        
        let preSendMessage = channel.sendFileMessage(with: messageParam, progressHandler: {(didSendBodyData, totalBytesSent, totalBytesExpectedToSend) in
            
            print("this progress = sent \(didSendBodyData) totalSent \(totalBytesSent) expected \(totalBytesExpectedToSend)")
           
            
        }){[weak self] (userMessage, error) in
            if (error != nil) {
                if let row = self?.messageList.index(where: {$0.messageId == "loading\(index)"}) {
                    var newMessage = self?.messageList[row]
                    newMessage?.messageId = "error\(index)"
                    self?.messageList.remove(at: row)
                    self?.messageList.append(newMessage!)
                    print("first message id \(String(describing: self?.messageList[row].messageId))")
                }
                self?.messagesCollectionView.reloadData()
                self?.messagesCollectionView.scrollToBottom()
                PrintDebug.printDebugGeneral(error!, message: "sendUserMessage error")
                self?.messageInputBar.sendButton.stopAnimating()
            } else {
                if let message = userMessage {
                    if let row = self?.messageList.index(where: {$0.messageId == "loading\(index)"}){
                        self?.messageList.remove(at: row)
                    }
                    self?.messagesCollectionView.reloadData()
                    self?.messagesCollectionView.scrollToBottom()
                    if let chatMessage = self?.parseSendbirdMessage(message: message, isFromLoadPreviousMessage: false) {
                        DispatchQueue.main.async {
                            self?.messageInputBar.sendButton.stopAnimating()
                            self?.messageInputBar.inputTextView.placeholder = NSLocalizedString("Write a message…", comment: "")
                            self?.insertMessage(chatMessage)
                            
                        }
                    }
                }
            }
        }

    }
    
    func updateStatusMessage(messageId:String) {
        
    }
    
    //MARK: - Handle Background
    @objc func applicationBecomeActive(_ notification: Notification) {
        self.loadNextMessages()
    }
    
    private func insertMessage(_ message: ChatMessage) {
        if messageList.contains(where: { $0.messageId == message.messageId }) {
            return
        }
        
        let index = messageList.insertionIndexOf(elem: message) { $0.sentDate < $1.sentDate }
        messageList.insert(message, at: index)
        
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messageList.count - 1])
            if messageList.count >= 2 {
                messagesCollectionView.reloadSections([messageList.count - 2])
            }
        }, completion: { [weak self] _ in
//            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
//            }
        })
    }
    
    private func insertMessage(_ message: ChatMessage, index: Int) {
        messageList.insert(message, at: index)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messageList.count - 1])
            if messageList.count >= 2 {
                messagesCollectionView.reloadSections([messageList.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }

    func isLastSectionVisible() -> Bool {
        
        guard !messageList.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messageList.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    private func updateMessageStyle() {
        otherUserMessageStyle = MessageStyle.custom({ (containerView) in
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [Colors.chatBubleGray.cgColor, Colors.chatBubleGray.cgColor]
            gradientLayer.locations = [0.0 , 1.0]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: containerView.frame.size.width, height: containerView.frame.size.height)
            containerView.layer.insertSublayer(gradientLayer, below: containerView.layer.sublayers?.last)
            containerView.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 15.0)
        })
        
        currentUserMessageStyle = MessageStyle.custom({ (containerView) in
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [Colors.gradientThemeTwo.cgColor, Colors.gradientThemeOne.cgColor]
            gradientLayer.locations = [0.0 , 1.0]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: containerView.frame.size.width, height: containerView.frame.size.height)
            containerView.layer.insertSublayer(gradientLayer, below: containerView.layer.sublayers?.last)
            containerView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 15.0)
        })
        
        mediaImageMessageStyle = MessageStyle.custom({ (containerView) in
            containerView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 15.0)
        })
    }
    
    // MARK: - Private Functions
    private func setupBarButtonItem() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(R.image.backBlack(), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonDidClicked), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
        
        if (phoneNumber.isPhoneNumber()) {
            callButton.setImage(R.image.callBlack(), for: .normal)
            callButton.addTarget(self, action: #selector(callButtonDidClicked), for: .touchUpInside)
            let callBarButtonItem = UIBarButtonItem(customView: callButton)
            self.navigationItem.rightBarButtonItem = callBarButtonItem
        }
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func configureMessageCollectionView() {
        
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        
        // Hide the outgoing avatar and adjust the label alignment to line up with the messages
        layout?.setMessageOutgoingAvatarSize(.zero)
        layout?.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
        layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
        
        
        layout?.setMessageIncomingAccessoryViewSize(CGSize(width: 30, height: 30))
        layout?.setMessageIncomingAccessoryViewPadding(HorizontalEdgeInsets(left: 8, right: 0))
        layout?.setMessageIncomingAccessoryViewPosition(.messageBottom)
        layout?.setMessageOutgoingAccessoryViewSize(CGSize(width: 30, height: 30))
        layout?.setMessageOutgoingAccessoryViewPadding(HorizontalEdgeInsets(left: 0, right: 8))
        
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
        
    }
    
    private func configureMessageInputBar() {
        let attachfileButton = self.makeButton(named: R.image.contactAttachment.name)
       
        messageInputBar.setMiddleContentView(messageInputBar.inputTextView, animated: false)
        
        messageInputBar.delegate = self
        messageInputBar.backgroundColor = .white
        messageInputBar.inputTextView.tintColor = Colors.blueTwo
        messageInputBar.sendButton.tintColor = Colors.blueTwo
        messageInputBar.sendButton.image = R.image.sendChat()
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.setSize(CGSize(width: 30, height: 30), animated: false)
        messageInputBar.inputTextView.backgroundColor = Colors.inputTextGray
        messageInputBar.inputTextView.layer.cornerRadius = 10.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.placeholder = NSLocalizedString("Write a message…", comment: "")
        messageInputBar.inputTextView.placeholderTextColor = Colors.gray
        messageInputBar.inputTextView.font = R.font.barlowRegular(size: 14)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 32, bottom: 8, right: 15)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 34, bottom: 8, right: 15)
        messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
        messageInputBar.middleContentViewPadding.top = 5
        messageInputBar.middleContentViewPadding.bottom = 5
        messageInputBar.middleContentViewPadding.left = -30
        
        messageInputBar.setLeftStackViewWidthConstant(to: 30, animated: false)
        messageInputBar.setStackViewItems([InputBarButtonItem.fixedSpace(2), attachfileButton], forStack: .left, animated: false)

    }
    
    func makePreviewView(image: UIImage){
        let containerPreview = UIView()
        let containerImage = UIView()
        containerPreview.addSubview(containerImage)
//        containerImage.backgroundColor = .brown
        containerImage.snp.makeConstraints{ (make) in
            make.top.bottom.equalTo(containerPreview)
            make.height.equalTo(self.view.frame.size.height / 3)
            make.width.equalTo(self.view.frame.size.width / 2)
            make.centerX.equalTo(containerPreview)
        }
        
        let previewImageView = UIImageView()
        previewImageView.image = image
        containerImage.addSubview(previewImageView)
        previewImageView.snp.makeConstraints{ (make) in
            make.top.left.right.bottom.equalTo(containerImage)
        }
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.clipsToBounds = true
        containerImage.addSubview(previewImageView)
        
        let hideButton = UIButton()
        hideButton.setImage(R.image.icHideBlack(), for: .normal)
        hideButton.addTarget(self, action: #selector(deletePhoto), for: .touchUpInside)
        containerImage.addSubview(hideButton)
        hideButton.snp.makeConstraints{ (make) in
            make.top.left.equalTo(containerImage).offset(-10)
            make.height.width.equalTo(25)
        }
        hideButton.backgroundColor = Colors.chatBubleGray
        hideButton.makeItRounded(width: 0.0, borderColor: UIColor.clear.cgColor, cornerRadius: 12.5)
        
        previewImageView.layoutIfNeeded()
        containerImage.layoutIfNeeded()
        
        messageInputBar.setLeftStackViewWidthConstant(to: 0.0, animated: false)
        messageInputBar.setMiddleContentView(containerPreview, animated: false)
        
        messageInputBar.sendButton.isEnabled = true
    }
    
    @objc func deletePhoto(sender: UIButton!) {
        configureMessageInputBar()
    }
    
    @objc func addAttachment() {
        attachmentPanel = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        attachmentPanel?.surfaceView.cornerRadius = 8.0
        attachmentPanel?.surfaceView.shadowHidden = false
        attachmentPanel?.isRemovalInteractionEnabled = true
        attachmentPanel?.delegate = self
        
        let contentVC = ChatAttachmentVC()
        contentVC.delegate = self
        attachmentPanel?.set(contentViewController: contentVC)
        self.present(attachmentPanel!, animated: true, completion: nil)
        messageInputBar.sendButton.isEnabled = false
    }
    
    private func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
                $0.tintColor = Colors.gray
                $0.contentEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 5,right: 0)
                $0.setSize(CGSize(width: 30, height: 30), animated: false)
            }.onSelected {
                $0.tintColor = Colors.blueTwo
            }.onDeselected {
                $0.tintColor = UIColor(white: 0.8, alpha: 1)
            }.onTouchUpInside { _ in
                self.addAttachment()
        }
    }
    
    private func makePreview(url: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = R.image.bgBack()
                $0.tintColor = Colors.gray
                $0.contentEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 5,right: 0)
                $0.setSize(CGSize(width: 100, height: 150), animated: false)
            }
    }
    
    private func getAvatarFor(message: MessageType, avatar: @escaping (_ image:UIImage?, _ initials:String)->()){
        let firstName = message.sender.displayName.components(separatedBy: " ").first
        let lastName = message.sender.displayName.components(separatedBy: " ").first
        let initials = "\(firstName?.first ?? "A")\(lastName?.first ?? "A")"
        var avatarImageURL:URL!
        if isFromCurrentSender(message: message) {
            avatar(nil, initials)
        } else {
            if let imageURL = URL(string: IGSImageUrlHelper.getImageUrl(forPathUrl: chatterImageUrl)) {
                avatarImageURL = imageURL
            } else {
                avatar(nil, initials)
            }
        }
        
        SDWebImageManager.shared().imageDownloader?.downloadImage(with: avatarImageURL, options: .continueInBackground, progress: { (recieved, expected, nil) in
        }, completed: { (image, data, error, true) in
            if (error != nil) {
                avatar(nil, initials)
            } else {
                if let avatarImage = image {
                    avatar(avatarImage, initials)
                }
            }
        })
    }
    
    private func getMediaImageFor(message: MessageType, imageMessage: @escaping (_ image:UIImage?)->()){
        var messageImageURL:URL!
        guard let igsMessageImage = self.igsMessageImages[message.messageId] else { return }
        if let imageURL = igsMessageImage.url {
            messageImageURL = imageURL
        } else {
            imageMessage(nil)
        }
        
        SDWebImageManager.shared().imageDownloader?.downloadImage(with: messageImageURL, options: .continueInBackground, progress: { (recieved, expected, nil) in
        }, completed: { (image, data, error, true) in
            if (error != nil) {
                imageMessage(nil)
            } else {
                if let messageImage = image {
                    imageMessage(messageImage)
                }
            }
        })
    }

    func hideAttachmentPanel(){
        if let attachmentPanel = self.attachmentPanel {
            attachmentPanel.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func backButtonDidClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    func isNextMessageSameDate(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messageList.count else { return false }
        return Calendar.current.isDate(messageList[indexPath.section].sentDate, inSameDayAs:messageList[indexPath.section + 1].sentDate)
    }
    
    func isPreviousMessageSameDate(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return Calendar.current.isDate(messageList[indexPath.section].sentDate, inSameDayAs:messageList[indexPath.section - 1].sentDate)
    }
    
    func setTypingIndicatorViewHidden(_ isHidden: Bool, performUpdates updates: (() -> Void)? = nil) {
        setTypingIndicatorViewHidden(isHidden, animated: true, whilePerforming: updates) { [weak self] success in
            if success, self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    
    private func updateStatusTyping(_ isTyping:Bool) {
        if (isTyping) {
            channel?.startTyping()
        } else {
            channel?.endTyping()
        }
    }
    
    func showRetryAlert(index : IndexPath, message: MessageType){
        showAlertMessage(title: NSLocalizedString("Sending Message", comment: ""), message: NSLocalizedString("Message sent failed. Would you like to retry?", comment:""), iconImage: nil, okButtonTitle: NSLocalizedString("Retry", comment: ""), okAction: { [weak self] in
            SwiftMessages.hide()
            switch message.kind {
            case .photo:
                let retryChat = self?.messageArray[message.messageId] as! SBDFileMessageParams
                self?.messageList.remove(at: index.section)
                self?.messagesCollectionView.reloadData()
                self?.messagesCollectionView.scrollToBottom()
                let image = retryChat.file
                print("this data image \(String(describing: retryChat.file))")
                let thisimage = UIImage(data: image!)!
                self?.sendChatMessage(messageParam: retryChat, image: thisimage)
            default: break
            }
            
//            self?.sendChatMessage(messageText: self?.messageArray[index.section]., image: )
            }, cancelButtonTitle: NSLocalizedString("Delete", comment: ""), cancelAction: {
                self.messageList.remove(at: index.section)
                self.messagesCollectionView.reloadData()
                SwiftMessages.hide()
        })
    }
}

// MARK: - MessagesDataSource
extension ChatVC: MessagesDataSource {
    func currentSender() -> SenderType {
        return userSender
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if (isPreviousMessageSameDate(at: indexPath) == false) {
            var dateString:String!
            if (message.sentDate.isToday) {
                dateString = NSLocalizedString("Today", comment: "")
            } else {
                dateString = message.sentDate.toFormat("EEEE, dd MMM yyyy")
            }
            return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
        }
        return nil
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isFromCurrentSender(message: message) {
            if (!(message.messageId.contains("loading") || message.messageId.contains("error"))){
                let dateString = message.sentDate.toFormat("HH:mm")
                return NSAttributedString(string: "Delivered \(dateString)", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
            }
        }
        let dateString = message.sentDate.toFormat("HH:mm")
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])

    }
}

// MARK: - MessageCellDelegate
extension ChatVC: MessageCellDelegate {
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        let masterVC = MasterDetailVC()
        masterVC.masterId = chatterUserId
        masterVC.masterName = chatterName
        masterVC.masterProfileImageUrl = chatterImageUrl
        self.navigationController?.pushViewController(masterVC, animated: true)
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
        
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
            let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
                print("Failed to identify message when message cell receive tap gesture")
                return
        }
        
        switch message.kind {
        case .photo:
            let imageUrl = self.imageUrls[message.messageId]
            let urlImageArray = self.imageUrls.values.sorted()
            let index = urlImageArray.index(of: imageUrl ?? "")
            IGSLightbox.show(imageSrcs: urlImageArray, index: index)
        default:
            break
        }
    }
    
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }
    
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }
    
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }
    
    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
            let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
                print("Failed to identify message when message cell receive tap gesture")
                return
        }
        if (message.messageId.contains("error")){
            showRetryAlert(index: indexPath, message: message)
        }
        print("Accessory view tapped")
    }
    
}

// MARK: - MessageLabelDelegate

extension ChatVC: MessageLabelDelegate {
    
    func didSelectAddress(_ addressComponents: [String: String]) {
        print("Address Selected: \(addressComponents)")
    }
    
    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
    }
    
    func didSelectURL(_ url: URL) {
        print("URL Selected: \(url)")
    }
    
    func didSelectTransitInformation(_ transitInformation: [String: String]) {
        print("TransitInformation Selected: \(transitInformation)")
    }
    
}

// MARK: - InputBarAccessoryViewDelegate
extension ChatVC: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        if (self.isImage){
            guard let params = SBDFileMessageParams.init(file: chosenImage.jpeg(.medium)!) else { return }
            sendChatMessage(messageParam: params, image: chosenImage)
            configureMessageInputBar()
        } else {
            let components = inputBar.inputTextView.components
            messageInputBar.inputTextView.text = String()
            messageInputBar.invalidatePlugins()
            
            for component in components {
                if let str = component as? String {
                    // Send button activity animation
                    channel?.endTyping()
                    messageInputBar.sendButton.startAnimating()
                    messageInputBar.inputTextView.placeholder = NSLocalizedString("Sending...", comment: "")
                    sendChatMessage(messageText: str)
                }
            }
        }
        
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        isImage = false
        if (text.isEmpty) {
            updateStatusTyping(false)
        } else {
            updateStatusTyping(true)
        }
    }
}

// MARK: - MessagesDisplayDelegate
extension ChatVC: MessagesDisplayDelegate {
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .darkText // not working since use nsattributestring
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        return MessageLabel.defaultAttributes
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url,.phoneNumber]
    }
    
    // MARK: - All Messages
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        switch message.kind {
        case .photo:
            return mediaImageMessageStyle
        default:
            break
        }
        
        if isFromCurrentSender(message: message) {
            return currentUserMessageStyle
        } else {
            return otherUserMessageStyle
        }
    }
    
    func backgroundColor(for message: MessageType, at  indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return Colors.chatBubleGray
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        getAvatarFor(message: message, avatar: { (image, initials) in
            let avatar = Avatar(image: image, initials: initials)
            avatarView.set(avatar: avatar)
            })
    
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        switch message.kind {
        case .photo(let photoItem):
                guard let url = photoItem.url else {
                    imageView.kf.indicator?.startAnimatingView()
                    return
                }
                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(with: url)
        default:
            break
        }
    }
    
    func configureAccessoryView(_ accessoryView: UIView,
                                for message: MessageType,
                                at indexPath: IndexPath,
                                in messagesCollectionView: MessagesCollectionView) {
        // Remove old views from the previous use
        accessoryView.subviews.forEach { $0.removeFromSuperview() }
        
        // Handle retry logic, you can display this button only if the upload fail as example
        
        accessoryView.isUserInteractionEnabled = true
        if (self.messageList[indexPath.section].messageId.contains("error")){
            let button = UIButton(type: .infoLight)
            button.tintColor = .red
            accessoryView.addSubview(button)
            
            button.frame = accessoryView.bounds
            button.isUserInteractionEnabled = false // respond to accessoryView tap through `MessageCellDelegate`
            accessoryView.layer.cornerRadius = accessoryView.frame.height / 2
        } else if (self.messageList[indexPath.section].messageId.contains("loading")) {
            
            let loadingView = CustomIndicatorActivityView()
            loadingView.frame = accessoryView.bounds
            loadingView.isUserInteractionEnabled = false // respond to accessoryView tap through `MessageCellDelegate`
            accessoryView.layer.cornerRadius = accessoryView.frame.height / 2
            loadingView.startAnimating()
            accessoryView.addSubview(loadingView)
        } else {
            accessoryView.isUserInteractionEnabled = false
        }
        
    }
    
}

// MARK: - MessagesLayoutDelegate
extension ChatVC: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if (isPreviousMessageSameDate(at: indexPath) == false) {
            return 18
        }
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
}

// MARK: ChatManagerConnectionDelegate
extension ChatVC: ChatManagerConnectionDelegate {
    func didConnect(isReconnection: Bool) {
        
    }
    
    func didDisconnect() {
        
    }
}

// MARK: SBDChannelDelegate
extension ChatVC: SBDChannelDelegate {
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        if sender == self.channel {
            channel?.markAsRead()
            
            if let message = parseSendbirdMessage(message: message, isFromLoadPreviousMessage: false) {
                insertMessage(message)
            }
        }
    }
    
    func channelDidUpdateReadReceipt(_ sender: SBDGroupChannel) {
        if sender == self.channel {
            
        }
    }
    
    func channelDidUpdateTypingStatus(_ sender: SBDGroupChannel) {
        if sender == self.channel {
            if sender.isTyping() {
                setTypingIndicatorViewHidden(false)
            } else {
                setTypingIndicatorViewHidden(true)
            }
        }
    }
    
    func channel(_ sender: SBDGroupChannel, userDidJoin user: SBDUser) {
        
    }
    
    func channel(_ sender: SBDGroupChannel, userDidLeave user: SBDUser) {
        
    }
    
    func channel(_ sender: SBDOpenChannel, userDidEnter user: SBDUser) {
        
    }
    
    func channel(_ sender: SBDOpenChannel, userDidExit user: SBDUser) {
        
    }
    
    func channel(_ sender: SBDBaseChannel, userWasMuted user: SBDUser) {
        
    }
    
    func channel(_ sender: SBDBaseChannel, userWasUnmuted user: SBDUser) {
        
    }
    
    func channel(_ sender: SBDBaseChannel, userWasBanned user: SBDUser) {
        
    }
    
    func channel(_ sender: SBDBaseChannel, userWasUnbanned user: SBDUser) {
        
    }
    
    func channelWasFrozen(_ sender: SBDBaseChannel) {
        
    }
    
    func channelWasUnfrozen(_ sender: SBDBaseChannel) {
        
    }
    
    func channelWasChanged(_ sender: SBDBaseChannel) {
        
    }
    
    func channelWasDeleted(_ channelUrl: String, channelType: SBDChannelType) {
        
    }
    
    func channel(_ sender: SBDBaseChannel, messageWasDeleted messageId: Int64) {
        
    }
}

// MARK: FloatingPanelControllerDelegate
extension ChatVC: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return IntrinsicPanelLayout()
    }
}

// MARK: ChatAttachmentVCDelegate
extension ChatVC : ChatAttachmentVCDelegate {
    func photoSelected(image: UIImage) {
        makePreviewView(image: image)
        self.chosenImage = image
        self.isImage = true
        self.messageInputBar.becomeFirstResponder()
    }
    
    func documentSelected() {
        
    }
    
    func locationSelected() {
        
    }
    
    func showErrorMessage(message: String) {
//        hideAttachmentPanel()
        showErrorMessageBanner(message)
    }
    
    func hidePanel(){
        hideAttachmentPanel()
    }
    
}
