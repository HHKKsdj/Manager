//
//  VoteViewController.swift
//  Demo
//
//  Created by HK on 2021/7/22.
//

import UIKit

class VoteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(sender:)))
        self.navigationItem.title = "发布投票"
        // Do any additional setup after loading the view.
        setUI()
    }
    var classList = [ClassInfo]()
    var classTag = [Int]()
    var className : String!
    var target = [String]()
    var date : String!
    var titleText : String!
    var type : String!
    var optionList = [String]()
    var optionNum = 0
    var sendButton : UIButton!
    var tableView : UITableView!
    
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
        tableView.register(HeadCell.self, forCellReuseIdentifier: "HeadCell")
        tableView.register(OptionCell.self, forCellReuseIdentifier: "OptionCell")
        
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
        if classTag.contains(1) && optionList.count != 0 && titleText != nil && type != nil {
            var limit = 0
            if type! == "单选" {
                limit = 1
            } else {
                limit = optionList.count
            }
            for i in 0..<classTag.count {
                if classTag[i] == 1 {
                    target.append(classList[i].classId)
                    CreatVote(id: classList[i].classId, limit: limit)
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

extension VoteViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 {
            return optionNum + 1
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
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell",for: indexPath) as! TypeCell
            cell.dataDelegate = self
            cell.typeA.setTitle("单选", for: .normal)
            cell.typeB.setTitle("多选", for: .normal)
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell",for: indexPath) as! DateCell
            cell.dataDelegate = self
            cell.tag = 0
            cell.selectionStyle = .none
            return cell
        case 4:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HeadCell",for: indexPath) as! HeadCell
                cell.addDelegate = self
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell",for: indexPath) as! OptionCell
                cell.optionDelegate = self
                cell.titleLabel.text = "选项\(indexPath.row)"
                cell.tag = indexPath.row
                print(indexPath.row)
                print(optionNum)
                if indexPath.row <= optionList.count {
                    cell.contentText.text = optionList[indexPath.row-1]
                } else {
                    cell.contentText.text = ""
                }
                cell.selectionStyle = .none
                return cell
            }
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let classListVC = ClassListViewController()
            classListVC.selectedList = target
            classListVC.delegate = self
            self.navigationController?.pushViewController(classListVC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            if optionList.count != 0 {
                optionList.remove(at: indexPath.row - 1)
            }
            
            optionNum -= 1
            self.tableView.reloadData()
        }
//        print(indexPath.row)
        
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?{
        if indexPath.row != 0 {
            return "删除"
        } else {
            return nil
        }
        
    }
}

//MARK: Delegate

extension VoteViewController : AddDelegate {
    func add() {
        optionNum += 1
        optionList.append("")
        let newRowIndex = optionNum
        let indexPath = IndexPath(row: newRowIndex, section: 4)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
}

extension VoteViewController : OptionDelegate {
    func getOption(option:String, tag:Int) {
        optionList[tag-1] = option
    }
}

extension VoteViewController : DataDelegate {
//    func getTarget(target: [String]) {
//        self.target = target
//    }
    
    func getTitle(title: String) {
        self.titleText = title
    }
    
    func getType(type: String) {
        self.type = type
    }
    
    func getDate(date: String ,tag: Int) {
        self.date = date
    }
    
    func getContent(content: String) {}
}

extension VoteViewController : selectDelegate {
    func select(classList: [ClassInfo], classTag: [Int], nameList: [[String]], nameTag: [[Int]]) {
        self.classList = classList
        self.classTag = classTag
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

extension VoteViewController {
    func CreatVote(id:String,limit:Int) {
        ClassNetwork.shared.PublishVoteRequest(classID: id, title: titleText, selections: optionList, limitation: limit, anonymous: false, deadLine: date){ (error,info) in
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
                let alter = UIAlertController(title: "发送失败", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                alter.addAction(action)
                self.present(alter, animated: true, completion: nil)
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
}

