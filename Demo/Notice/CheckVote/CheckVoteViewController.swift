//
//  CheckVoteViewController.swift
//  Demo
//
//  Created by HK on 2021/7/28.
//

import UIKit

class CheckVoteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "投票"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(sender:)))
        // Do any additional setup after loading the view.
        let data = UserDefaults.standard.data(forKey: "user")
        self.user = try!  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as! UserInfo
        
        optionList = notice.selections
        for _ in 0 ..< optionList.count {
            markList.append(0)
//            numList.append("\(i)")
        }
        if confirmed == true || notice.publisher == user.username{
            tag = 1
            selector()
            voteDetail()
        }
        setUI()
        
        getName()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
////        voteDetail()
//        selector()
//    }
    var user = UserInfo()
    
    var notice = NoticeInfo()
    var newNotice = NoticeInfo()
    
    var nameList = [UserInfo]()
    var voteList = [String]()
//    var optionList = ["option1","option2","option3","option4","option5"]
//    var markList = [0,0,0,0,0]
//    var numList = ["15","40","26","34","55"]
    var selectorList = [[String]]()
    var optionList = [String]()
    var markList = [Int]()
    var numList = [Int]()
    var tag = 0
    
    var titleLabel : UILabel!
    var nameLabel : UILabel!
    var startTime : UILabel!
    var endTime : UILabel!
    var involveButton : UIButton!
    var tableView : UITableView!
    var voteButton : UIButton!
    var errorLabel : UILabel!
    var confirmed = false
    
    func setUI() {
        titleLabel = UILabel.init()
//        titleLabel.text = "TESTLABEL"
        var type = ""
        if notice.limitation == 1 {
            type = "单选"
        } else {
            type = "多选"
        }
        titleLabel.text = "【投票】" + notice.title + "（\(type)）"
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(10)
        }
        
        nameLabel = UILabel.init()
//        nameLabel.text = "HK"
        nameLabel.text = notice.publisher
        nameLabel.textColor = UIColor.gray
        nameLabel.font = UIFont.systemFont(ofSize: 12.5)
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left).offset(5)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        
        startTime = UILabel.init()
//        startTime.text = "2021-12-12 16:30"
        startTime.text = notice.publishTime
        startTime.textColor = UIColor.gray
        startTime.font = UIFont.systemFont(ofSize: 12.5)
        self.view.addSubview(startTime)
        startTime.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.top.equalTo(nameLabel.snp.top)
        }
        
        endTime = UILabel.init()
//        endTime.text = "截止时间:"+"2021-12-13 19:00"
        endTime.text = "截止时间:"+notice.deadline
        endTime.textColor = UIColor.red
        endTime.font = UIFont.systemFont(ofSize: 12.5)
        self.view.addSubview(endTime)
        endTime.snp.makeConstraints { (make) in
            make.top.equalTo(startTime.snp.top)
            make.right.equalToSuperview().offset(-10)
        }
        
        involveButton = UIButton.init()
        involveButton.setTitle("参与情况 >", for: .normal)
        involveButton.setTitleColor(.black, for: .normal)
//        involveButton.tintColor = UIColor.black
//        involveButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
//        involveButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 30)
//        involveButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: -30)
        involveButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.5)
        involveButton.contentHorizontalAlignment = .left
        involveButton.addTarget(self, action: #selector(involve(sender:)), for: .touchUpInside)
        self.view.addSubview(involveButton)
        involveButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
        }
        
        voteButton = UIButton.init()
        if confirmed == false {
            voteButton.setTitle("投票", for: .normal)
            voteButton.backgroundColor = UIColor.link
        } else {
            self.voteButton.backgroundColor = UIColor.lightGray
            self.voteButton.setTitle("已投票", for: .normal)
            self.voteButton.isEnabled = false
        }
        if notice.publisher == user.username {
            voteButton.isHidden = true
        }
        voteButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        
        voteButton.layer.masksToBounds = true
        voteButton.layer.cornerRadius = 12.0
        voteButton.addTarget(self, action: #selector(vote(sender:)), for: .touchUpInside)
        self.view.addSubview(voteButton)
        voteButton.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-25)
            make.width.equalToSuperview().offset(-100)
        }
        
        errorLabel = UILabel.init()
        errorLabel.text = "请至少选择一个选项后投票！"
        errorLabel.textColor = UIColor.red
        errorLabel.isHidden = true
        self.view.addSubview(errorLabel)
        errorLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(voteButton.snp.top).offset(-15)
        }
        
        tableView = UITableView.init()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VoteCell.self, forCellReuseIdentifier: "VoteCell")
        tableView.allowsMultipleSelection = true
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalTo(involveButton.snp.bottom).offset(50)
            make.bottom.equalTo(voteButton).offset(-75)
        }
        
    }
    
    @objc func vote (sender:UIButton) {
        if self.markList.contains(1) {
            self.errorLabel.isHidden = true
            self.involveButton.isHidden = false
            vote()
        } else {
            self.errorLabel.isHidden = false
        }
    }
    @objc func involve (sender:UIButton) {
        let involveVC = InvolveViewController()
        involveVC.nameList = nameList
        involveVC.okList = voteList
        self.navigationController?.pushViewController(involveVC, animated: true)
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

extension CheckVoteViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VoteCell", for: indexPath) as! VoteCell
        cell.selectionStyle = .none
        
        cell.tag = indexPath.row
        cell.optionLabel.text = optionList[indexPath.row]
        
        if markList[indexPath.row] == 0 {
            cell.markImageView.image = UIImage(systemName: "square")
        } else {
            cell.markImageView.image = UIImage(systemName: "checkmark.square.fill")
        }
        
        if tag == 1 && numList.count != 0 {
            if newNotice.selections.count != 0 {
                for i in 0..<newNotice.selections.count {
                    if cell.optionLabel.text == newNotice.selections[i] {
                        cell.numLabel.text = "\(newNotice.selectedNum[i])" + "票"
                    }
                }
            } else {
                cell.numLabel.text = "\(numList[indexPath.row])" + "票"
            }
            if markList[indexPath.row] == 1 {
                cell.backgroundColor = UIColor.systemTeal
                cell.markImageView.image = UIImage(systemName: "checkmark.square.fill")
            }
            if selectorList.count != 0 && selectorList[indexPath.row].contains(user.username) {
                cell.backgroundColor = UIColor.systemTeal
                cell.markImageView.image = UIImage(systemName: "checkmark.square.fill")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tag == 0 {
            if notice.limitation == 1 {
                for i in 0..<markList.count {
                    markList[i] = 0
                }
                markList[indexPath.row] = 1
            } else {
                if markList[indexPath.row] == 0 {
                    markList[indexPath.row] = 1
                } else {
                    markList[indexPath.row] = 0
                }
            }
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.tableView.reloadData()
        } else {
            let detailVC = DetailViewController()
            detailVC.option = optionList[indexPath.row]
            let selections = newNotice.selections
            for i in 0..<selections.count {
                if selections[i] == optionList[indexPath.row] {
                    detailVC.nameList = newNotice.selectorList[i]
                    break
                }
            }
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//MARK: Network
extension CheckVoteViewController {
    func voteDetail() {
        ClassNetwork.shared.VoteDetailRequest(classID: notice.classID, vid: notice.vid){(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
//                self.numList = content.noticeList[0].selectedNum
//                self.optionList = content.noticeList[0].selections
                for option in self.optionList {
                    for i in 0..<content.noticeList[0].selections.count {
                        if option == content.noticeList[0].selections[i] {
                            self.numList.append(content.noticeList[0].selectedNum[i])
                            break
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func vote() {
        var list = [String]()
        for i in 0..<markList.count {
            if markList[i] == 1 {
                list.append(optionList[i])
            }
        }
        
        ClassNetwork.shared.VoteRequest(classID: notice.classID, vid: notice.vid, selections: list){(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.code == 200 {
                let alter = UIAlertController(title: "投票成功", message: "", preferredStyle: .alert)
                self.present(alter, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    alter.dismiss(animated: true, completion: nil)
                }
//                self.perform(#selector(alter.dismiss(animated:completion:)), with: alter, afterDelay: 1)
                self.voteButton.backgroundColor = UIColor.lightGray
                self.voteButton.setTitle("已投票", for: .normal)
                self.voteButton.isEnabled = false
                
//                if self.markList.contains(1) {
                    self.errorLabel.isHidden = true
                    self.involveButton.isHidden = false
                    self.tag = 1
                    self.tableView.reloadData()
                    self.voteButton.backgroundColor = UIColor.gray
                    self.voteButton.isEnabled = false
//                } else {
//                    self.errorLabel.isHidden = false
//                }
                
                self.voteDetail()
                self.selector()
            } else {
                let alter = UIAlertController(title: "投票失败", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                alter.addAction(action)
                self.present(alter, animated: true, completion: nil)
            }
        }
    }
    
    func selector() {
        voteList.removeAll()
        ClassNetwork.shared.VoterSelectionsRequest(classID: notice.classID, vid: notice.vid){(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.noticeList.count != 0 {
                self.newNotice = content.noticeList[0]
                for nameList in self.newNotice.selectorList {
                    self.voteList += nameList
                }
                self.optionList = content.noticeList[0].selections
                self.selectorList = content.noticeList[0].selectorList
                self.tableView.reloadData()
            }
        }
        
    }
    
    func getName() {
        ClassNetwork.shared.GetStudentRequest(classID: notice.classID) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            if content.nameList.count != 0 {
                self.nameList = content.nameList
            }
        }
    }
}
