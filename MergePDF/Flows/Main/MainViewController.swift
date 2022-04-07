//
//  MainViewController.swift
//  MergePDF
//
//  Created by Ivan Dvornyk on 06.04.2022.
//

import UIKit
import UniformTypeIdentifiers
import SnapKit

class MainViewController: UIViewController {
    
    private let tableView = UITableView()
    private let mergeButton = UIButton()
    
    private let viewModel: MainViewModelProtocol = MainViewModel()
    
    private let cellHeight: CGFloat = 80
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTableView()
        
        mergeButton.addTarget(self, action: #selector(didTapMerge), for: .touchUpInside)
    }
    

    private func setupViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(mergeButton)
        mergeButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(60)
            make.height.equalTo(40)
        }
        
        mergeButton.setTitle("Merge", for: .normal)
        mergeButton.layer.cornerRadius = 12
        mergeButton.clipsToBounds = true
        mergeButton.isEnabled = false
        mergeButton.setBackgroundColor(color: .gray, forState: .disabled)
        mergeButton.setBackgroundColor(color: .systemBlue, forState: .normal)
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc private func didTapAdd() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf], asCopy: true)
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    @objc private func didTapMerge() {
        let documentDataForSaving = viewModel.getMergeData()
        
        let activity = UIActivityViewController(activityItems: [documentDataForSaving], applicationActivities: nil)
        present(activity, animated: true) {
            self.viewModel.removeFiles()
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    private func reloadData() {
        tableView.reloadData()
        mergeButton.isEnabled = viewModel.mergeButtonIsActive()
    }
    
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let fileModel = viewModel.getFile(at: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = fileModel.name
        content.secondaryText = fileModel.dateString
        content.image = fileModel.image
        
        cell.contentConfiguration = content
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fileModel = viewModel.getFile(at: indexPath)
        let url = fileModel.url
        
        let vc = PdfViewController()
        vc.url = url
        vc.title = fileModel.name
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeFile(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            mergeButton.isEnabled = viewModel.mergeButtonIsActive()
        }
    }
}

extension MainViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let url = urls.first else { return }
        
        let fileinfo = try! FileManager.default.attributesOfItem(atPath: url.path)
        
        guard let date = fileinfo[FileAttributeKey(rawValue: "NSFileModificationDate")] as? Date else { return }
        
        let fileModel = FileModel(url: url, date: date)
        
        viewModel.addFile(file: fileModel)
        reloadData()
    }
}
