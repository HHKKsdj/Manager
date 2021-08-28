//
//  TargetListViewController.swift
//  Demo
//
//  Created by HK on 2021/8/6.
//

import UIKit

protocol PartDelegate : NSObjectProtocol {
    func partList (nameTag:[Int],row:Int)
}
class TargetListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = className
        // Do any additional setup after loading the view.
        
        setUI()
    }
    
    var classID = ""
    var className = ""
    var allSelect = false
    var nameList = [String]()
    var nameTag = [Int]()
//    var nameList = [UserInfo]()
    var selectedList = [String]()
    var selectedNum = 0
    var tableView : UITableView!
    var button : UIButton!
    var partDelegate : PartDelegate?
    var row = 0
    
    func setUI() {
        tableView = UITableView.init()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TargetListViewCell.self, forCellReuseIdentifier: "TargetListViewCell")
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(90)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
        }
        
        button = UIButton.init()
        button.setTitle("确定(\(selectedNum))", for: .normal)
        button.addTarget(self, action: #selector(confirm(sender:)), for: .touchUpInside)
//        button.backgroundColor = UIColor.link
        button.setTitleColor(UIColor.link, for: .normal)
        self.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom).offset(15)
            make.right.equalToSuperview().offset(-15)
//            make.width.equalTo(80)
//            make.height.equalTo(30)
        }

    }
    
    @objc func confirm (sender:UIButton) {
        partDelegate?.partList(nameTag: nameTag, row: row)
        self.navigationController?.popViewController(animated: true)
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

extension TargetListViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TargetListViewCell", for: indexPath) as! TargetListViewCell
        cell.label.text = nameList[indexPath.row]
//        cell.section = indexPath.section
        cell.row = indexPath.row
        cell.select = allSelect
        if nameTag[indexPath.row] == 0 {
            cell.mark.setImage(UIImage(systemName: "circle"), for: .normal)
            cell.select = false
        } else {
            cell.mark.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            cell.select = true
        }
        cell.nameDelegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//MARK: NameDelegate
extension TargetListViewController : NameDelegate {
    func addName(row:Int) {
        nameTag[row] = 1
        selectedNum += 1
        button.setTitle("确定(\(selectedNum))", for: .normal)
    }
    
    func deleteName(row:Int) {
        nameTag[row] = 0
        selectedNum -= 1
        button.setTitle("确定(\(selectedNum))", for: .normal)
    }
}

