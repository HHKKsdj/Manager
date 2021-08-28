//
//  ClassListViewController.swift
//  Demo
//
//  Created by HK on 2021/8/6.
//

import UIKit

protocol selectDelegate: NSObjectProtocol {
    func select(classList:[ClassInfo],classTag:[Int],nameList:[[String]],nameTag:[[Int]])
}

class ClassListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "选择发送对象"
        // Do any additional setup after loading the view.
        let data = UserDefaults.standard.data(forKey: "user")
        self.user = try!  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as! UserInfo
        setData()
        setUI()
    }

    var delegate : selectDelegate?
    
    var user = UserInfo()
    var isPart = false
    
    var classList = [ClassInfo]()
    var selectedList = [String]()
//    var classList = ["高等数学","线性代数","数据结构","c语言","大学物理","英语"]
    
    var classTag = [Int]()
    var nameList = [[String]]()
    var nameTag = [[Int]]()
    var onlyOne = false
    
    var selectedNum = 0
    var tag = 0
    var partList = [[String]]()
    var partSelected = [Int]()
    var tableView : UITableView!
    
    var collectionView : UICollectionView!
    var button : UIButton!
    
    
    func setUI() {
        tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ClassListCell.self, forCellReuseIdentifier: "ClassListCell")
        if isPart == false {
            tableView.allowsSelection = false
        }
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(90)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().offset(-75)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 25, height: 10)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: "CollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(285)
            make.height.equalTo(50)
        }
        
        button = UIButton.init()
        button.setTitle("确定(\(selectedNum))", for: .normal)
        button.addTarget(self, action: #selector(confirm(sender:)), for: .touchUpInside)
//        button.backgroundColor = UIColor.link
        button.setTitleColor(UIColor.link, for: .normal)
        self.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.centerY.equalTo(collectionView.snp.centerY)
            make.right.equalToSuperview().offset(-15)
//            make.width.equalTo(80)
//            make.height.equalTo(30)
        }
    }
 
    @objc func confirm(sender:UIButton) {
        var list = [String]()
        for i in 0..<classTag.count {
            if classTag[i] == 1 {
                list.append(classList[i].classId)
            }
        }
        var part = [String]()
        for name in partList {
            part += name
        }
        delegate?.select(classList: classList, classTag: classTag, nameList: nameList, nameTag: nameTag)
        getNum(ID:list[0], i:0)
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

//MARK: TableViewDelegate

extension ClassListViewController : UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassListCell", for: indexPath) as! ClassListCell
//        allSelected.append(0)
        cell.label.text = classList[indexPath.row].name
        cell.section = indexPath.section
        cell.row = indexPath.row
        cell.targetDelegate = self
        if classTag[indexPath.row] == 1 {
            cell.mark.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            cell.select = true
        } else {
            cell.mark.setImage(UIImage(systemName: "circle"), for: .normal)
            cell.select = false
        }
        if isPart == false {
            cell.button.isHidden = true
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let targetListVC = TargetListViewController()
        targetListVC.className = classList[indexPath.row].name
        targetListVC.classID = classList[indexPath.row].classId
        targetListVC.nameTag = nameTag[indexPath.row]
        targetListVC.nameList = nameList[indexPath.row]
        targetListVC.row = indexPath.row
        targetListVC.partDelegate = self
        for tag in nameTag[indexPath.row] {
            if tag == 1 {
                targetListVC.selectedNum += 1
            }
        }
        self.navigationController?.pushViewController(targetListVC, animated: true)
    }
 
}
//MARK: CollectionViewDelegate
extension ClassListViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        cell.backgroundColor = UIColor.systemTeal
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 12.0
        for i in tag ..< classTag.count {
            if classTag[i] == 1 {
                cell.nameLabel.text = classList[i].name
                tag = i+1
                break
            }
        }
        return cell
    }
}

//MARK: TargetDelegate
extension ClassListViewController : TargetDelegate {
    func addTarget(section: Int, row: Int) {
        if onlyOne == true {
            for i in 0..<classTag.count {
                classTag[i] = 0
            }
            selectedNum = 0
        }
        classTag[row] = 1
        for i in 0..<nameTag[row].count {
            nameTag[row][i] = 1
        }
        selectedNum += 1
        tag = 0
        button.setTitle("确定(\(selectedNum))", for: .normal)
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
    
    func deleteTarget(section: Int, row: Int) {
        classTag[row] = 0
        for i in 0..<nameTag[row].count {
            nameTag[row][i] = 0
        }
        selectedNum -= 1
        tag = 0
        button.setTitle("确定(\(selectedNum))", for: .normal)
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
}
//MARK: PartDelegate
extension ClassListViewController : PartDelegate {
    func partList(nameTag: [Int],row: Int) {
        self.nameTag[row] = nameTag
        if !nameTag.contains(1) {
            selectedNum -= 1
            classTag[row] = 0
        } else if classTag[row] == 0 {
            selectedNum += 1
            classTag[row] = 1
        }
        button.setTitle("确定(\(selectedNum))", for: .normal)
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
}

//MARK: Network
extension ClassListViewController {
    func setData() {
        if self.user.role == "student" {
            ClassNetwork.shared.MyClassRequest {(error,info) in
                if let error = error {
                    print(error)
                    return
                }
                guard let content = info else {
                    print("nil")
                    return
                }
                if content.code == 200 {
                    self.classList = content.classList
                    for i in 0..<self.classList.count {
                        self.classTag.append(0)
                        self.getNum(ID:self.classList[i].classId, i:i)
                        self.nameList.append([String]())
                        self.nameTag.append([Int]())
                    }
                    self.tableView.reloadData()
                }
            }
        } else if self.user.role == "teacher" {
            ClassNetwork.shared.MyCreatedClassRequest{(error,info) in
                if let error = error {
                    print(error)
                    return
                }
                guard let content = info else {
                    print("nil")
                    return
                }
                if content.code == 200 {
                    self.classList = content.classList
                    
                    for i in 0..<self.classList.count {
                        self.classTag.append(0)
                        self.getNum(ID:self.classList[i].classId, i:i)
                        self.nameList.append([String]())
                        self.nameTag.append([Int]())
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getNum(ID:String, i:Int) {
        ClassNetwork.shared.GetStudentRequest(classID: ID) {(error,info) in
            if let error = error {
                print(error)
                return
            }
            guard let content = info else {
                print("nil")
                return
            }
            var tag = [Int]()
            var list = [String]()
            
            if content.nameList.count != 0 {
//                self.numDelegate?.getNum(list: content.nameList)
                for name in content.nameList {
                    list.append(name.username)
                    tag.append(0)
                }
            } else {
                tag.append(0)
                list.append(String())
            }
            self.nameList[i] = list
            self.nameTag[i] = tag
        }
    }
}
