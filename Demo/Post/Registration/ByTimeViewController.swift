//
//  ByTimeViewController.swift
//  Demo
//
//  Created by HK on 2021/7/24.
//

import UIKit

class ByTimeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(sender:)))
        self.navigationItem.title = "定时签到"
        // Do any additional setup after loading the view.
        setUI()
    }
    var classList = [ClassInfo]()
    var classTag = [Int]()
    var className : String!
    var target = [String]()
    var titleText : String!
    var startTime : String!
    var endTime : String!
    
    var tableView : UITableView!
    var sendButton : UIButton!
    
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
        tableView.sectionFooterHeight = 10
        
        tableView.register(TargetCell.self, forCellReuseIdentifier: "TargetCell")
        tableView.register(TitleCell.self, forCellReuseIdentifier: "TitleCell")
        tableView.register(DateCell.self, forCellReuseIdentifier: "DateCell")

        self.view.addSubview(tableView)
        tableView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(sendButton.snp.top).offset(-10)
        }
    }

    @objc func send (sender:UIButton) {
        target.removeAll()
        for i in 0..<classTag.count {
            if classTag[i] == 1 {
                target.append(classList[i].classId)
            }
        }
        publish()
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

extension ByTimeViewController : UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell",for: indexPath) as! DateCell
            cell.dataDelegate = self
            cell.titleLabel.text = "发布时间"
            cell.tag = 1
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell",for: indexPath) as! DateCell
            cell.dataDelegate = self
            cell.titleLabel.text = "截止时间"
            cell.tag = 2
            cell.selectionStyle = .none
            return cell

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
}

//MARK: Delegate

extension ByTimeViewController : DataDelegate {
//    func getTarget(target: [String]) {
//        self.target = target
//    }
    
    func getTitle(title: String) {
        self.titleText = title
    }
    
    func getDate(date: String ,tag: Int) {
        if tag == 1 {
            self.startTime = date
        } else if tag == 2 {
            self.endTime = date
        }
    }
    
    func getType(type: String) {}
    func getContent(content: String) {}
}

extension ByTimeViewController : selectDelegate {
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

extension ByTimeViewController {
    func publish() {
        if target.count != 0 && titleText != nil && startTime != nil && endTime != nil {
            for t in target {
                ClassNetwork.shared.PublishSigninRequest(classID: t, key: "0", title: titleText, startTime: startTime, deadLine: endTime){ (error,info) in
                    if let error = error {
                        print(error)
                        return
                    }
                    guard let content = info else {
                        print("nil")
                        return
                    }
                    if content.code == 200 {
                        if t == self.target.last {
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
