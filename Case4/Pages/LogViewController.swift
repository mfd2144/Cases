//
//  LogCİewController.swift
//  Case4
//
//  Created by Mehmet fatih DOĞAN on 16.03.2022.
//

import UIKit

protocol LogViewControllerDelegate:AnyObject {
    func listWasUpdated()
}
class LogViewController: UITableViewController {
    private lazy var list = [Log]()
    weak var delegate: LogViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath) as! LogCell
        cell.update(list[indexPath.row])
        return cell
    }
}

extension LogViewController {
    func log(type: Log.ContentType, content: String) {
        let log = Log(type: type, content: content)
        list.append(log)
        let index = IndexPath(row: list.count - 1, section: 0)
        tableView.insertRows(at: [index], with: .automatic)
        tableView.scrollToRow(at: index, at: .middle, animated: true)
        guard let delegate = delegate else{return}
        delegate.listWasUpdated()
    }
}

