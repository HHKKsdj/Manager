//
//  DetailViewController.swift
//  Demo
//
//  Created by HK on 2021/7/29.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "详情"
        // Do any additional setup after loading the view.
        setUI()
    }
    
    var option = ""
    var nameList = [String]()
    
    var titleLabel : UILabel!
    var contentLabel : UILabel!
    var numLabel : UILabel!
    var tableView : UITableView!
    
    func setUI() {
        titleLabel = UILabel.init()
        titleLabel.text = "选项："
        titleLabel.textColor = UIColor.gray
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(10)
        }
        
        contentLabel = UILabel.init()
        contentLabel.text = option
        contentLabel.numberOfLines = 0
        self.view.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.top)
            make.left.equalTo(titleLabel.snp.right)
            make.right.equalToSuperview().offset(-20)
        }
        
        numLabel = UILabel.init()
        numLabel.text = "共\(nameList.count)票"
        numLabel.textColor = UIColor.lightGray
        numLabel.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(numLabel)
        numLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(contentLabel.snp.bottom).offset(35)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvolveCell", for: indexPath) as! InvolveCell
        cell.headImageView.image = UIImage(named: "test")
        cell.nameLabel.text = nameList[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
