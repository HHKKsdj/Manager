//
//  CheckDrawViewController.swift
//  Demo
//
//  Created by HK on 2021/7/28.
//

import UIKit

class CheckDrawViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(sender:)))
        self.navigationItem.title = "活动抽签"
        // Do any additional setup after loading the view.
        setUI()
    }
    var notice = NoticeInfo()
    
    var titleLabel : UILabel!
    var nameLabel : UILabel!
    var startTime : UILabel!
    var numLabel : UILabel!
    var tableView : UITableView!
    
    func setUI() {
        titleLabel = UILabel.init()
        titleLabel.text = "【活动抽签】"
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(10)
        }
        
        startTime = UILabel.init()
//        startTime.text = "2021-12-12 16:30"
        startTime.text = notice.publishTime
        startTime.textColor = UIColor.gray
        startTime.font = UIFont.systemFont(ofSize: 12.5)
        self.view.addSubview(startTime)
        startTime.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        nameLabel = UILabel.init()
//        nameLabel.text = "HK"
        nameLabel.text = notice.publisher
        nameLabel.textColor = UIColor.gray
        nameLabel.font = UIFont.systemFont(ofSize: 12.5)
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.right.equalTo(startTime.snp.left).offset(-10)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        numLabel = UILabel.init()
        numLabel.text = "共\(notice.drawList.count)人"
        numLabel.textColor = UIColor.gray
        numLabel.font = UIFont.systemFont(ofSize: 12.5)
        self.view.addSubview(numLabel)
        numLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.equalToSuperview().offset(15)
        }
        
        tableView = UITableView.init()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(InvolveCell.self, forCellReuseIdentifier: "InvolveCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(numLabel.snp.bottom).offset(15)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
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

extension CheckDrawViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notice.drawList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvolveCell", for: indexPath) as! InvolveCell
        cell.headImageView.image = UIImage(named: "test")
        cell.nameLabel.text = notice.drawList[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
