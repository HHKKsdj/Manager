//
//  PhotoEditorController.swift
//  AnyImageKit
//
//  Created by 蒋惠 on 2019/10/23.
//  Copyright © 2019-2021 AnyImageProject.org. All rights reserved.
//

import UIKit

protocol PhotoEditorControllerDelegate: AnyObject {
    
    func photoEditorDidCancel(_ editor: PhotoEditorController)
    func photoEditor(_ editor: PhotoEditorController, didFinishEditing photo: UIImage, isEdited: Bool)
}

final class PhotoEditorController: AnyImageViewController {
    
    private lazy var contentView: PhotoEditorContentView = {
        let view = PhotoEditorContentView(frame: self.view.bounds, image: image, context: context)
        view.canvas.setBrush(color: options.penColors[options.defaultPenIndex].color)
        return view
    }()
    private lazy var placeholdImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.backgroundColor = .black
        view.isHidden = true
        return view
    }()
    private lazy var toolView: EditorToolView = {
        let view = EditorToolView(frame: self.view.bounds, context: context)
        view.penToolView.undoButton.isEnabled = stack.edit.canvasCanUndo
        view.mosaicToolView.undoButton.isEnabled = stack.edit.mosaicCanUndo
        view.cropToolView.currentOptionIdx = stack.edit.cropData.cropOptionIdx
        return view
    }()
    private lazy var backButton: UIButton = {
        let view = UIButton(type: .custom)
        view.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        view.setImage(BundleHelper.image(named: "ReturnBackButton", module: .editor), for: .normal)
        view.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        view.accessibilityLabel = BundleHelper.localizedString(key: "BACK", module: .core)
        return view
    }()
    
    private var image: UIImage = UIImage()
    private let resource: EditorPhotoResource
    private let options: EditorPhotoOptionsInfo
    private let context: PhotoEditorContext
    private let blurContext = CIContext()
    private weak var delegate: PhotoEditorControllerDelegate?
    
    private lazy var stack: PhotoEditingStack = {
        let stack = PhotoEditingStack(identifier: options.cacheIdentifier)
        stack.delegate = self
        return stack
    }()
    
    init(photo resource: EditorPhotoResource, options: EditorPhotoOptionsInfo, delegate: PhotoEditorControllerDelegate) {
        self.resource = resource
        self.options = options
        self.context = .init(options: options)
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar(hidden: true)
        bindAction()
        loadData()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        showHUDIfNeeded()
        toolView.selectFirstItemIfNeeded()
    }
    
    private func loadData() {
        resource.loadImage { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.image = image
                self.setupView()
                self.setupMosaicView()
            case .failure(let error):
                if error == .cannotFindInLocal {
                    showWaitHUD()
                    return
                }
                _print("Fetch image failed: \(error.localizedDescription)")
                self.delegate?.photoEditorDidCancel(self)
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = .black
        view.addSubview(contentView)
        view.addSubview(toolView)
        view.addSubview(backButton)
        view.addSubview(placeholdImageView)
        
        contentView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        toolView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        backButton.snp.makeConstraints { maker in
            if #available(iOS 11.0, *) {
                let topOffset = ScreenHelper.statusBarFrame.height <= 20 ? 20 : 10
                maker.top.equalTo(view.safeAreaLayoutGuide).offset(topOffset)
            } else {
                maker.top.equalToSuperview().offset(30)
            }
            maker.left.equalToSuperview().offset(10)
            maker.width.height.equalTo(50)
        }
        placeholdImageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        if let data = stack.edit.outputImageData, let image = UIImage(data: data) {
            setPlaceholdImage(image)
        }
    }
    
    private func setupMosaicView() {
        contentView.setupMosaicView { [weak self] _ in
            guard let self = self else { return }
            self.setupData()
            if let toolOption = self.context.toolOption, toolOption == .mosaic {
                self.contentView.mosaic?.isUserInteractionEnabled = true
            }            
            self.contentView.updateView(with: self.stack.edit) { [weak self] in
                self?.toolView.mosaicToolView.setMosaicIdx(self?.stack.edit.mosaicData.last?.idx ?? 0)
                let delay = (self?.stack.edit.mosaicData.isEmpty ?? true) ? 0.0 : 0.25
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in // 这里稍微延迟一下，给马赛克图层创建留点时间
                    self?.contentView.isHidden = false
                    self?.placeholdImageView.isHidden = true
                    hideHUD()
                }
            }
        }
    }
    
    private func setupData() {
        stack.originImage = image
        stack.mosaicImages = contentView.mosaic?.mosaicImage ?? []
        stack.originImageViewBounds = contentView.imageView.bounds
    }
    
    private func setPlaceholdImage(_ image: UIImage) {
        contentView.isHidden = true
        placeholdImageView.image = image
        placeholdImageView.isHidden = false
        placeholdImageView.contentMode = .scaleAspectFit
        let screen = ScreenHelper.mainBounds.size
        let h = image.size.height / image.size.width * screen.width
        if h > screen.height {
            let offsetY = (h - screen.height) / 2
            placeholdImageView.contentMode = .scaleAspectFill
            placeholdImageView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: offsetY)
        }
    }
}

// MARK: - Target
extension PhotoEditorController {
    
    /// 返回按钮
    @objc private func backButtonTapped(_ sender: UIButton) {
        context.action(.back)
    }
}

// MARK: - Private
extension PhotoEditorController {
    
    /// 获取最终的图片
    private func getResultImage() -> UIImage? {
        stack.cropRect = contentView.cropContext.cropRealRect
        let tmpScale = contentView.scrollView.zoomScale
        let tmpOffset = contentView.scrollView.contentOffset
        let tmpContentSize = contentView.scrollView.contentSize
        contentView.scrollView.zoomScale = 1.0
        stack.cropImageViewFrame = contentView.imageView.frame
        contentView.scrollView.zoomScale = tmpScale
        contentView.scrollView.contentOffset = tmpOffset
        contentView.scrollView.contentSize = tmpContentSize
        
        // 由于 TextView 的位置是基于放大后图片的位置，所以在输出时要改回原始比例计算坐标位置
        let textScale = stack.originImageViewBounds.size.width / contentView.imageView.bounds.width
        contentView.calculateFinalFrame(with: textScale)
        
        return stack.output()
    }
    
    /// 存储编辑记录
    private func saveEditPath() {
        if options.cacheIdentifier.isEmpty { return }
        stack.save()
    }
    
    private func showHUDIfNeeded() {
        if contentView.mosaic == nil {
            showWaitHUD()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                if self?.contentView.mosaic != nil {
                    hideHUD()
                }
            }
        }
    }
    
    private func setTool(hidden: Bool, animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.25 : 0) {
            self.toolView.alpha = hidden ? 0 : 1
            self.backButton.alpha = hidden ? 0 : 1
        }
    }
}

// MARK: - Crop
extension PhotoEditorController {
    
    /// 准备开始裁剪
    private func willBeginCrop() {
        backButton.isHidden = true
        contentView.scrollView.isScrollEnabled = true
        contentView.cropLayerLeave.isHidden = true
        contentView.deactivateAllTextView()
        let image = contentView.imageView.screenshot(self.image.size)
        contentView.cropLayerLeave.isHidden = false
        contentView.canvas.isHidden = true
        contentView.mosaic?.isHidden = true
        contentView.hiddenAllTextView()
        contentView.imageView.image = image
    }
    
    /// 已经结束裁剪
    private func didEndCroping() {
        contentView.canvas.isHidden = false
        contentView.mosaic?.isHidden = false
        contentView.updateTextFrameWhenCropEnd()
        contentView.imageView.image = contentView.image
    }
}

// MARK: - InputText
extension PhotoEditorController {
    
    /// 打开文本编辑器
    private func openInputController(_ data: TextData = TextData()) {
        willBeginInput()
        let coverImage = getInputCoverImage()
        let controller = InputTextViewController(context: context, data: data, coverImage: coverImage)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    /// 获取输入界面的占位图
    private func getInputCoverImage() -> UIImage? {
        return contentView.screenshot().gaussianImage(context: blurContext, blur: 8)
    }
    
    /// 准备开始输入文本
    private func willBeginInput() {
        backButton.isHidden = true
        toolView.topCoverView.isHidden = true
        toolView.bottomCoverView.isHidden = true
        toolView.doneButton.isHidden = true
        toolView.editOptionsView.isHidden = true
        toolView.editOptionsView.unselectButtons()
        contentView.deactivateAllTextView()
    }
    
    /// 已经结束输入文本
    private func didEndInputing() {
        backButton.isHidden = false
        toolView.topCoverView.isHidden = false
        toolView.bottomCoverView.isHidden = false
        toolView.doneButton.isHidden = false
        toolView.editOptionsView.isHidden = false
        contentView.scrollView.isScrollEnabled = true
    }
}

// MARK: - Action

extension PhotoEditorController {
    
    private func bindAction() {
        context.didReceiveAction { [weak self] (action) in
            self?.didReceive(action: action)
        }
    }
    
    private func didReceive(action: PhotoEditorAction) {
        switch action {
        case .empty:
            if toolView.currentOption != .crop {
                setTool(hidden: toolView.alpha == 1)
            }
        case .back:
            delegate?.photoEditorDidCancel(self)
        case .done:
            contentView.deactivateAllTextView()
            guard let image = getResultImage() else { return }
            setPlaceholdImage(image)
            stack.setOutputImage(image)
            saveEditPath()
            delegate?.photoEditor(self, didFinishEditing: image, isEdited: stack.edit.isEdited)
        case .toolOptionChanged(let option):
            context.toolOption = option
            toolOptionsDidChanged(option: option)
        case .penBeginDraw, .mosaicBeginDraw:
            setTool(hidden: true)
        case .penUndo:
            stack.canvasUndo()
        case .penChangeColor(let color):
            contentView.canvas.setBrush(color: color)
        case .penFinishDraw(let dataList):
            setTool(hidden: false)
            stack.setPenData(dataList)
        case .mosaicUndo:
            stack.mosaicUndo()
        case .mosaicChangeImage(let idx):
            contentView.mosaic?.setMosaicCoverImage(idx)
        case .mosaicFinishDraw(let dataList):
            setTool(hidden: false)
            stack.setMosaicData(dataList)
        case .cropUpdateOption(let option):
            contentView.setCrop(option)
        case .cropReset:
            contentView.cropReset()
        case .cropCancel:
            if options.toolOptions.count == 1 {
                context.action(.back)
                return
            }
            backButton.isHidden = false
            contentView.cropCancel { [weak self] (_) in
                self?.didEndCroping()
            }
        case .cropDone:
            backButton.isHidden = false
            contentView.cropDone { [weak self] (_) in
                guard let self = self else { return }
                self.didEndCroping()
                if self.options.toolOptions.count == 1 {
                    self.context.action(.done)
                }
            }
        case .cropFinish(let data):
            stack.setCropData(data)
        case .textWillBeginEdit(let data):
            openInputController(data)
        case .textBringToFront(let data):
            stack.moveTextDataToTop(data)
        case .textWillBeginMove(_):
            setTool(hidden: true)
        case .textDidFinishMove(let data, let delete):
            setTool(hidden: false)
            if delete {
                stack.removeTextData(data)
            }
        case .textCancel:
            didEndInputing()
            contentView.restoreHiddenTextView()
        case .textDone(let data):
            didEndInputing()
            contentView.removeHiddenTextView()
            if !data.text.isEmpty {
                stack.addTextData(data)
            }
        }
    }
    
    private func toolOptionsDidChanged(option: EditorPhotoToolOption?) {
        contentView.canvas.isUserInteractionEnabled = false
        contentView.mosaic?.isUserInteractionEnabled = false
        contentView.scrollView.isScrollEnabled = option == nil
        guard let option = option else { return }
        switch option {
        case .pen:
            contentView.canvas.isUserInteractionEnabled = true
            trackObserver?.track(event: .photoPen, userInfo: [:])
        case .text:
            openInputController()
            trackObserver?.track(event: .photoText, userInfo: [:])
        case .crop:
            willBeginCrop()
            if let option = options.cropOptions.first, !contentView.cropContext.didCrop {
                toolView.cropToolView.currentOption = option
                contentView.cropStart(with: option)
            } else {
                contentView.cropStart()
            }
            trackObserver?.track(event: .photoCrop, userInfo: [:])
        case .mosaic:
            if contentView.mosaic == nil {
                showWaitHUD()
            }
            contentView.mosaic?.isUserInteractionEnabled = true
            trackObserver?.track(event: .photoMosaic, userInfo: [:])
        }
    }
}

extension PhotoEditorController: PhotoEditingStackDelegate {
    
    func editingStack(_ stack: PhotoEditingStack, needUpdatePreview edit: PhotoEditingStack.Edit) {
        toolView.penToolView.undoButton.isEnabled = edit.canvasCanUndo
        toolView.mosaicToolView.undoButton.isEnabled = edit.mosaicCanUndo
        contentView.updateView(with: edit)
    }
}
