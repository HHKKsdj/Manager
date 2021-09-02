//
//  AnnouncementViewController.swift
//  Demo
//
//  Created by HK on 2021/7/22.
//

import UIKit
import UniformTypeIdentifiers
import AnyImageKit
import CryptoSwift

class AnnouncementViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(sender:)))
        self.navigationItem.title = "发布公告"
        // Do any additional setup after loading the view.
        setUI()
    }
    var classList = [ClassInfo]()
    var classTag = [Int]()
    var nameList = [[String]]()
    var nameTag = [[Int]]()
    var className : String!
    var target = [String]()
    var partList = [String]()
    var partTarget = [String]()
    var imageList = [UIImage]()
    var date : String!
    var titleText : String!
    var type : String!
    var contentText : String!
    var sendButton : UIButton!
    var tableView : UITableView!
    var imageRow = 1
    
    var filePath = ""
    var filePathList = [String]()
    var fileList = [String]()
    var SHA256List = [String]()
    var dataList = [Data]()
    var fidList = [String]()
    var imageidList = [String]()
    
    func setUI() {
        sendButton = UIButton.init()
        sendButton.setTitle("发布", for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        sendButton.backgroundColor = UIColor.link
        sendButton.layer.masksToBounds = true
        sendButton.layer.cornerRadius = 12.0
        sendButton.addTarget(self, action: #selector(send(sender:)), for: .touchUpInside)
        self.view.addSubview(sendButton)
        sendButton.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-25)
            make.width.equalToSuperview().offset(-100)
        }
        
        tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.allowsSelection = false
//        tableView.sectionHeaderHeight = 5
        tableView.sectionFooterHeight = 5
//        tableView.tableFooterView = UIView()
        
        tableView.register(TargetCell.self, forCellReuseIdentifier: "TargetCell")
        tableView.register(TitleCell.self, forCellReuseIdentifier: "TitleCell")
        tableView.register(TypeCell.self, forCellReuseIdentifier: "TypeCell")
        tableView.register(DateCell.self, forCellReuseIdentifier: "DateCell")
        tableView.register(ContentCell.self, forCellReuseIdentifier: "ContentCell")
        tableView.register(ImageCell.self, forCellReuseIdentifier: "ImageCell")
        tableView.register(FileCell.self, forCellReuseIdentifier: "FileCell")
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(sendButton.snp.top).offset(-10)
        }
        
        let tableVC = UITableViewController.init()
        tableVC.tableView = self.tableView
        self.addChild(tableVC)
    }
    
    @objc func send (sender:UIButton) {
        target.removeAll()
        if classTag.contains(1) && titleText != nil && contentText != nil {
            for i in 0..<classTag.count {
                if classTag[i] == 1 {
                    target.append(classList[i].classId)
                    if imageList.count != 0 {
                        uploadImage(classID: classList[i].classId,row: i)
                    } else if dataList.count != 0 {
                        upload(classID: classList[i].classId,row: i)
                    } else {
                        publish(id:classList[i].classId,row: i)
                    }
//                    publish(id:classList[i].classId,row: i)
//                    upload(classID: classList[i].classId)
//                    uploadImage(classID: classList[i].classId)
                }
            }
        }
    }
    
    @objc func back (sender:UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//MARK: TableViewDelegate
extension AnnouncementViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return imageRow + fileList.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TargetCell",for: indexPath) as! TargetCell
//            cell.dataDelegate = self
            if className != nil {
                cell.listLabel.text = className
            }
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell",for: indexPath) as! TitleCell
            cell.dataDelegate = self
            cell.selectionStyle = .none
            return cell
//        case 2:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell",for: indexPath) as! TypeCell
//            cell.dataDelegate = self
//            cell.typeA.setTitle("仅查看", for: .normal)
//            cell.typeB.setTitle("查看并完成", for: .normal)
//            cell.selectionStyle = .none
//            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell",for: indexPath) as! DateCell
            cell.dataDelegate = self
            cell.tag = 0
            cell.selectionStyle = .none
            return cell
        case 3:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell",for: indexPath) as! ContentCell
                cell.documentDelegate = self
                cell.photoDelegate = self
                cell.dataDelegate = self
                cell.selectionStyle = .none
                return cell
            } else if indexPath.row < imageRow {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell",for: indexPath) as! ImageCell
                cell.imageDelegate = self
                cell.imageList = imageList
                cell.row = indexPath.row
                cell.setUI()
                cell.selectionStyle = .none
                return cell
            } else {
                tableView.register(FileCell.self, forCellReuseIdentifier: "FileCell\(fileList[indexPath.row - imageRow])")
                let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell\(fileList[indexPath.row - imageRow])",for: indexPath) as! FileCell
                cell.fileName = fileList[indexPath.row - imageRow]
                cell.setUI()
                cell.deleteDelegate = self
                cell.row = indexPath.row
                cell.selectionStyle = .none
                return cell
            }
        
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 {
            if indexPath.row == 0 {
                return 300
            } else if indexPath.row < imageRow {
                return 100
            } else {
                return 50
            }
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let classListVC = ClassListViewController()
            classListVC.selectedList = target
            classListVC.delegate = self
            classListVC.isPart = true
            self.navigationController?.pushViewController(classListVC, animated: true)
        }
    }
}

//MARK: DocumentDelegate

extension AnnouncementViewController : DocumentDelegate,UIDocumentPickerDelegate {
    func documentVC() {
        let supportedTypes: [UTType] = [UTType.image,UTType.pdf,UTType.data,UTType.audio,UTType.zip]
        let documentPickerVC = UIDocumentPickerViewController.init(forOpeningContentTypes: supportedTypes, asCopy: true)
        documentPickerVC.delegate = self
        documentPickerVC.modalPresentationStyle = .fullScreen
        self.present(documentPickerVC, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
        
            if let url = urls.first {
                filePath = url.absoluteString
                filePathList.append(filePath)
                let error = NSErrorPointer(nil)
                let fileCoor = NSFileCoordinator()
                fileCoor.coordinate(readingItemAt: url, options: [], error: error) { fileUrl in
                    print(fileUrl)
                    let fileName = fileUrl.lastPathComponent
                    print(fileName)
                    fileList.append(fileName)
                    do {
                        let data = try Data(contentsOf: fileUrl, options: .mappedRead)
                        let arr = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                        let documentPath = arr.last
                        print(documentPath as Any)
                        let localFileName = documentPath?.appending("/").appending(fileName) ?? ""
                        let desPath = URL(fileURLWithPath: localFileName)
                        try data.write(to: desPath, options: .atomic)
                        print(data.count)
                        filePath = localFileName
                    } catch let error as Error? {
                        print(error?.localizedDescription as Any)
                    }
                }
            }
        self.tableView.reloadData()
        getFile()
    }
        
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("documentPickerWasCancelled")
    }
        
    func getFile() {
        let url = URL(fileURLWithPath: filePath)
        // 带throws的方法需要抛异常
        do {
            /*
                * try 和 try! 的区别
                * try 发生异常会跳到catch代码中
                * try! 发生异常程序会直接crash
            */
            let data = try Data(contentsOf: url)
            //let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            self.dataList.append(data)
            print(data.count)
            
        } catch let error as Error? {
            print(error?.localizedDescription as Any)
        }
    }

}
//MARK: PhotoDelegate
extension AnnouncementViewController : PhotoDelegate, ImagePickerControllerDelegate {
    func PhotoVC() {
        let options = PickerOptionsInfo()
        let controller = ImagePickerController(options: options, delegate: self)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    func imagePickerDidCancel(_ picker: ImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePicker(_ picker: ImagePickerController, didFinishPicking result: PickerResult) {
        let images = result.assets.map { $0.image }
        imageList = images
        picker.dismiss(animated: true, completion: nil)
        imageRow += 1
        self.tableView.reloadData()
    }
}
//MARK: ImageDelegate
extension AnnouncementViewController : imageDelegate {
    func imageNum(imageNum: Int) {
        imageList.remove(at: imageNum)
        if imageList.count == 0 {
            imageRow -= 1
        }
        self.tableView.reloadSections([3], with: .fade)
    }
}
//MARK: DataDelegate
extension AnnouncementViewController : DataDelegate {
//    func getTarget(target: [String]) {
//        self.target = target
//    }
    
    func getTitle(title: String) {
        self.titleText = title
    }
    
    func getType(type: String) {
        self.type = type
    }
    
    func getContent(content: String) {
        self.contentText = content
    }
    
    func getDate(date: String ,tag: Int) {
          self.date = date
    }
}
//MARK: SelectDelegate
extension AnnouncementViewController : selectDelegate {
    func select(classList: [ClassInfo], classTag: [Int], nameList: [[String]], nameTag: [[Int]]) {
        self.classList = classList
        self.classTag = classTag
        self.nameList = nameList
        self.nameTag = nameTag
        for i in 0..<classTag.count {
            if classTag[i] == 1 {
                if className == nil {
                    className = classList[i].name
                } else {
                    className += " 等"
                    break
                }
            }
        }
        self.tableView.reloadData()
    }
}
//MARK: DeleteDelegate
extension AnnouncementViewController : DeleteDelegate {
    func delete(row:Int) {
        fileList.remove(at: row-imageRow)
        filePathList.remove(at: row-imageRow)
        dataList.remove(at: row-imageRow)
        self.tableView.reloadSections([3], with: .fade)
    }
}

//MARK: Network
extension AnnouncementViewController {
    func addID(text:String) -> String {
        var str = text
        str += "{"
        if imageidList.count != 0 {
            str += imageidList[0]
            for i in 1..<imageidList.count {
                str += "," + imageidList[i]
            }
        }
        str += ":"
        if fidList.count != 0 {
            str += fidList[0]
            for i in 1..<fidList.count {
                str += "," + fidList[i]
            }
        }
        str += "}"
        print(str)
        return str
    }
    
    func publish(id:String,row:Int) {
        var name = [String]()
        for i in 0..<nameTag[row].count {
            if nameTag[row][i] == 1 {
                name.append(nameList[row][i])
            }
        }
        let contentText = addID(text: self.contentText)
        ClassNetwork.shared.PublishNoticeRequest(classID: id, title: self.titleText, body: contentText, deadLine: self.date!,isPublic: true,students: name){ (error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                if id == self.target.last {
                    self.done()
                }
            } else {
                self.error(msg: content.msg)
            }
        }
    }

    func upload(classID:String,row:Int) {
        for i in 0..<dataList.count {
            let hash = dataList[i].sha256().toHexString()
            ClassNetwork.shared.UploadRequest(classID: classID, hash: hash, fileName: fileList[i], fileURL: filePathList[i], data: dataList[i]){ (error,info) in
                if let error = error {
                    print(error)
                    return
                }
                guard let content = info else {
                    print("nil")
                    return
                }
                if content.code == 200 {
                    self.fidList.append(content.data)
                    if i == self.dataList.count-1 {
                        self.publish(id: classID, row: row)
                    }
                } else {
                    self.error(msg: content.msg)
                }
            }
        }
    }
    
    func uploadImage(classID:String,row:Int) {
        for i in 0..<imageList.count {
            let data = imageList[i].jpegData(compressionQuality: 0.5)!
            ClassNetwork.shared.UploadImageRequest(classID: classID, data: data, fileName: "\(self.titleText!):\(i).jpeg"){ (error,info) in
                if let error = error {
                    print(error)
                    return
                }
                guard let content = info else {
                    print("nil")
                    return
                }
                if content.code == 200 {
                    self.imageidList.append(content.data)
                    if i == self.imageList.count-1 {
                        if self.dataList.count != 0 {
                            self.upload(classID: classID,row: row)
                        } else {
                            self.publish(id:classID,row: row)
                        }
                    }
                } else {
                    self.error(msg: content.msg)
                }
            }
        }
        
    }
    
    func done() {
        let alter = UIAlertController(title: "发送成功", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default, handler: {_ in
            self.dismiss(animated: true, completion: nil)
        })
        alter.addAction(action)
        self.present(alter, animated: true, completion: nil)
    }
    func error(msg:String) {
        let alter = UIAlertController(title: "发送失败", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default, handler: nil)
        alter.addAction(action)
        self.present(alter, animated: true, completion: nil)
    }
    
}
