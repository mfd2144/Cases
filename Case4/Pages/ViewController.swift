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
    @IBOutlet weak var clearButton: UIBarButtonItem!
    weak var logVC: LogViewController?
    var viewModel:ViewModelProtocol!
    var openCloseLogic: Bool = true
    var constraintOpen:NSLayoutConstraint!
    var constraintClose:NSLayoutConstraint!
    var albums: Array<ShortAlbum> = []
    lazy var stack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [asynchronousHttpRequest, synchronousHttpRequest, mockErrorButton,warningButton])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let asynchronousHttpRequest: UIButton = {
        let button = createButton("Asynchronous Http Request")
        return button
    }()
    
    let synchronousHttpRequest: UIButton = {
        let button = createButton("Synchronous Http Request")
        return button
    }()
    
    let mockErrorButton: UIButton = {
        let button = createButton("Mock Https Button")
        return button
    }()
    
    let warningButton:UIButton = {
        let button = createButton("Warning Button")
        return button
    }()
//MARK: - life cycle of controller
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
    //MARK: - Set subviews
    private func   setNavigationBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = false
    }
    private func addSubviews() {
        view.addSubview(stack)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        constraintOpen = containerView.heightAnchor.constraint(equalToConstant: 300)
        constraintClose = containerView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: stack.topAnchor,constant: -50),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            constraintOpen,
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.heightAnchor.constraint(equalToConstant: view.bounds.height/3),
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
    
    // TARGETS
    private func addTargets(){
        mockErrorButton.addTarget(self, action: #selector(mockErrorButtonPressed), for: .touchUpInside)
        asynchronousHttpRequest.addTarget(self, action: #selector(asynchronousHttpRequestPressed), for: .touchUpInside)
        synchronousHttpRequest.addTarget(self, action: #selector(synchronousHttpRequestPressed), for: .touchUpInside)
        warningButton.addTarget(self, action: #selector(warningButtonPressed), for: .touchUpInside)
    }
   
    @objc private func mockErrorButtonPressed() {
        viewModel.mockHttpsRequest()
    }
    @objc private func warningButtonPressed() {
        logVC?.log(type: .warning, content: "Warning Button Pressed")
    }
    
    @IBAction func clearButtonPressed(_ sender: UIBarButtonItem) {
        guard openCloseLogic else {return}
        logVC?.clearList()
    }
    @objc private func asynchronousHttpRequestPressed() {
        viewModel.asynchronousHttpsRequest()
    }
    @objc private func synchronousHttpRequestPressed() {
        viewModel.synchronousHttpsRequest()
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
//MARK: - ViewModelDelegate
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
            case .anyInfo(let string):
                logVC?.log(type: .info, content: string)
            }
        }
    }
}
//MARK: - UITableViewDataSource
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
//MARK: - LogViewControllerDelegate
extension ViewController:LogViewControllerDelegate {
    func cellSelected(_ item: String) {
        let alertView = UIAlertController(title: "Cell Text", message: item, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alertView.addAction(action)
        present(alertView, animated: true, completion: nil)
    }
    
    func listWasUpdated() {
        if !openCloseLogic{
            cautionButton.tintColor = .red
        }
    }
}
