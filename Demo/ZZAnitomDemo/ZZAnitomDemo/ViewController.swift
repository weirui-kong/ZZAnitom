//
//  ViewController.swift
//  ZZAnitomDemo
//
//  Created by 孔维锐 on 4/26/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    
    /// Demo 列表
    let demoList = [
        "Image Stack Demo"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "ZZAnitom Demo"
        setupTableView()
        setupNavigationBar()
        navigationController?.pushViewController(ZZAImageStackViewDemoViewController(), animated: true)

    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "关于",
            style: .plain,
            target: self,
            action: #selector(showAbout)
        )
    }
    
    @objc private func showAbout() {
        let alert = UIAlertController(title: "关于", message: "ZZAnitom Demo App", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "好", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds // 如果你用 SnapKit，也可以写 tableView.snp.makeConstraints
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DemoCell")
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoCell", for: indexPath)
        cell.textLabel?.text = demoList[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(ZZAImageStackViewDemoViewController(), animated: true)

        default:
            break
        }
    }
}
