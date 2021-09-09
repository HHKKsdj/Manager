//
//  FileViewController.swift
//  Demo
//
//  Created by HK on 2021/8/24.
//

import UIKit

class FileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "班级文件"
        // Do any additional setup after loading the view.
        let data = UserDefaults.standard.data(forKey: "user")
        self.user = try!  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as! UserInfo
        setData()
        setUI()
    }
    var user = UserInfo()
    
    var classID = ""
    var fileList = [FileInfo]()
    var tableView : UITableView!
    
    func setUI() {
        tableView = UITableView.init()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FileViewCell.self, forCellReuseIdentifier: "FileViewCell")
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalToSuperview().offset(90)
            make.bottom.equalToSuperview()
        }
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
extension FileViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(FileViewCell.self, forCellReuseIdentifier: "\(fileList[indexPath.row].fid)FileViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(fileList[indexPath.row].fid)FileViewCell", for: indexPath) as! FileViewCell
        cell.file = fileList[indexPath.row]
        cell.setUI()
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if user.role == "student" {
            return nil
        }
        let action = UIContextualAction(style: .destructive, title: "删除") { (action, view, finished) in
            self.deleteFile(fid: self.fileList[indexPath.row].fid,indexPath: indexPath)
            finished(true)
        }
    
        let actions = UISwipeActionsConfiguration(actions: [action])
        actions.performsFirstActionWithFullSwipe = false
        return actions
    }
}

extension FileViewController : FileDelegate {
    func respond(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
            alert.dismiss(animated: true, completion: nil)
        }
//        self.perform(#selector(alert.dismiss(animated:completion:)), with: alert, afterDelay: 1.5)
    }
}

//MARK: Network
extension FileViewController {
    func setData() {
        ClassNetwork.shared.GetFileRequest(classID: classID) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.fileList.count != 0 {
                self.fileList = content.fileList
                self.tableView.reloadData()
            }
        }
    }
    func deleteFile(fid:Int,indexPath:IndexPath) {
        ClassNetwork.shared.DeleteFileRequest(classID: classID,fid: fid) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                self.fileList.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                let alter = UIAlertController(title: "操作失败", message: "", preferredStyle: .alert)
                self.present(alter, animated: true, completion: nil)
                self.perform(#selector(alter.dismiss(animated:completion:)), with: alter, afterDelay: 1)
            }
        }
    }
}
