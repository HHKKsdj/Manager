//
//  NameListViewController.swift
//  Demo
//
//  Created by HK on 2021/8/4.
//

import UIKit

class NameListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "班级成员"
        let data = UserDefaults.standard.data(forKey: "user")
        self.user = try!  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as! UserInfo
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }
    
    var classID = ""
    var user = UserInfo()
    
    var nameList = [UserInfo]()
//    var nameList = ["test","test","test","test","test","test","test","test","test"]
    var headerView : UIView!
    var label : UILabel!
    
    func setUI() {
        headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 25))
        headerView.backgroundColor = UIColor.white
        self.tableView.tableHeaderView = headerView
        
        label = UILabel.init()
        if user.role != "student" {
            label.text = "左滑可进行编辑"
        }
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.lightGray
        self.tableView.tableHeaderView?.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }

        self.tableView.tableFooterView = UIView()
        self.tableView.allowsSelection = false
        self.tableView.register(NameListCell.self, forCellReuseIdentifier: "NameListCell")
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return nameList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameListCell", for: indexPath) as! NameListCell
        cell.headImageView.image = UIImage(named: "test")
        cell.nameLabel.text = nameList[indexPath.row].username + nameList[indexPath.row].realName
        if nameList[indexPath.row].role != "student" {
            cell.roleLabel.isHidden = false
            switch nameList[indexPath.row].role {
            case "teacher":
                cell.roleLabel.text = "老师"
            case "assistant":
                cell.roleLabel.text = "管理员"
            case "monitor":
                cell.roleLabel.text = "班长"
            default:
                cell.roleLabel.text = nameList[indexPath.row].role
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if user.role == "student" || nameList[indexPath.row].role == "teacher" {
            return nil
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "删除") { (action, view, finished) in

//            self.nameList.remove(at: indexPath.row)
            self.remove(username: self.nameList[indexPath.row].username,indexPath:indexPath)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
            print("delete")

            // 回调告知执行成功，否则不会删除此行！！！
            finished(true)
        }

        var title = ""

        if nameList[indexPath.row].role == "assistant" {
            title = "取消管理员"
        } else {
            title = "设为管理员"
        }
        let managerAction = UIContextualAction(style: .normal, title: title) { (action, view, finished) in
            if title == "设为管理员"{
                self.setAssistant(assistant: self.nameList[indexPath.row].username)
            } else if title == "取消管理员"{
                self.cancelAssistant(assistant: self.nameList[indexPath.row].username)
            }
            self.tableView.reloadData()
            finished(true)
        }

        let actions = UISwipeActionsConfiguration(actions: [deleteAction, managerAction])
        actions.performsFirstActionWithFullSwipe = false
//        return UISwipeActionsConfiguration(actions: [deleteAction, archiveAction])
        return actions
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

extension NameListViewController {
    func setData() {
        ClassNetwork.shared.GetMemberRequest(classID: classID) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.studentList.count != 0 {
                self.nameList = content.teacherList + content.monitorList + content.assistantList + content.studentList
                self.tableView.reloadData()
            }
        }
    }
    func remove(username:String,indexPath:IndexPath) {
        ClassNetwork.shared.RemoveStuRequest(classID: classID, username: username) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                self.nameList.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                let alter = UIAlertController(title: "操作失败", message: "", preferredStyle: .alert)
                self.present(alter, animated: true, completion: nil)
                self.perform(#selector(alter.dismiss(animated:completion:)), with: alter, afterDelay: 1)
            }
        }
    }
    func setAssistant(assistant:String) {
        ClassNetwork.shared.SetAssistantRequest(classID: classID, assistants: assistant) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                self.setData()
                self.tableView.reloadData()
            } else {
                let alter = UIAlertController(title: "操作失败", message: "", preferredStyle: .alert)
                self.present(alter, animated: true, completion: nil)
                self.perform(#selector(alter.dismiss(animated:completion:)), with: alter, afterDelay: 1)
            }
        }
    }
    func cancelAssistant(assistant:String) {
        ClassNetwork.shared.CancelAssistantRequest(classID: classID, assistants: assistant) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                self.setData()
                self.tableView.reloadData()
            } else {
                let alter = UIAlertController(title: "操作失败", message: "", preferredStyle: .alert)
                self.present(alter, animated: true, completion: nil)
                self.perform(#selector(alter.dismiss(animated:completion:)), with: alter, afterDelay: 1)
            }
        }
    }
}
