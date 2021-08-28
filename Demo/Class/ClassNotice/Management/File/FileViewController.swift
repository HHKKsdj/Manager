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
        setData()
        setUI()
    }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileViewCell", for: indexPath) as! FileViewCell
        cell.file = fileList[indexPath.row]
        cell.setUI()
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

extension FileViewController : FileDelegate {
    func respond(title: String, msg: String) {
        let alter = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        self.present(alter, animated: true, completion: nil)
        self.perform(#selector(alter.dismiss(animated:completion:)), with: alter, afterDelay: 1.5)
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
}
