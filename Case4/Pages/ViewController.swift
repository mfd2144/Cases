//
//  ViewController.swift
//  Case4
//
//  Created by Mehmet fatih DOĞAN on 16.03.2022.
//

import UIKit

final class ViewController:UIViewController{
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cautionButton: UIBarButtonItem!
    
    weak var logVC: LogViewController?
    var viewModel:ViewModelProtocol!
    var openCloseLogic: Bool = true
    var constraintOpen:NSLayoutConstraint!
    var constraintClose:NSLayoutConstraint!
    var albums: Array<ShortAlbum> = []
    lazy var stack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [httpsRequestButton, httpsRequestFailButton, printButton])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let httpsRequestButton: UIButton = {
        let button = createButton("Https Request Button")
        return button
    }()
    
    let httpsRequestFailButton: UIButton = {
        let button = createButton("Https Request-for fail")
        return button
    }()
    
    let printButton: UIButton = {
        let button = createButton("Print Button")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logVC?.log(type: .info, content: "View did load")
        viewModel = ViewModel()
        viewModel.delegate = self
        tableView.backgroundColor = .white
        view.backgroundColor = .white
        containerView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AlbumCell")
        addSubviews()
        addTargets()
        setNavigationBar()
    }
    private func   setNavigationBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = false
    }
    private func addSubviews() {
        view.addSubview(stack)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        constraintOpen = containerView.heightAnchor.constraint(equalToConstant: 150)
        constraintClose = containerView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            constraintOpen,
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.heightAnchor.constraint(equalToConstant: view.bounds.height/4),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -50),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
    private static func createButton(_ titleText:String)->UIButton{
        let button = UIButton()
        button.setTitle(titleText, for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }
    
    private func addTargets(){
        printButton.addTarget(self, action: #selector(printButtonPressed), for: .touchUpInside)
        httpsRequestButton.addTarget(self, action: #selector(httpsRequestPressed), for: .touchUpInside)
        httpsRequestFailButton.addTarget(self, action: #selector(mockHttpsRequest), for: .touchUpInside)
    }
    
    @objc private func printButtonPressed() {
        logVC?.log(type: .warning, content: "buttonPressed")
    }
    
    @objc private func httpsRequestPressed() {
        viewModel.httpsRequest()
    }
    @objc private func mockHttpsRequest() {
        viewModel.mockHttpsRequest()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        if identifier == "EmbedLogViewController",
           let vc = segue.destination as? LogViewController {
            vc.delegate = self
            logVC = vc
        }
    }
    
    @IBAction func cautionButtonPressed(_ sender: UIBarButtonItem) {
        openCloseLogic = !openCloseLogic
        if openCloseLogic{
            cautionButton.tintColor = .blue
            constraintClose.isActive = false
            constraintOpen.isActive = true
        }else{
            constraintOpen.isActive = false
            constraintClose.isActive = true
        }
        
    }
}

extension ViewController:ViewModelDelegate{
    func handleOutput(_ output: ViewModelOutputs) {
        DispatchQueue.main.async {[unowned self] in
            switch output {
            case .logPrintCaution(let string):
                logVC?.log(type: .print, content: string)
            case .respondToRequest(let shortAlbums):
                albums = shortAlbums
                tableView.reloadData()
            case .mockError:
                logVC?.log(type: .error, content: "mock error")
            case .anyError(let string):
                logVC?.log(type: .error, content: string)
            }
        }
    }
}

extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath)
        cell.backgroundColor = .clear
        var content = UIListContentConfiguration.cell()
        content.text = albums[indexPath.row].artistName
        content.secondaryText = albums[indexPath.row].genres.joined(separator: ", ")
        content.textProperties.color = .black
        content.secondaryTextProperties.color = .black
        cell.contentConfiguration = content
        return cell
    }
}
extension ViewController:LogViewControllerDelegate {
    func listWasUpdated() {
        if !openCloseLogic{
            cautionButton.tintColor = .red
        }
    }
}
