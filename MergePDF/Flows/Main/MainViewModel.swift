//
//  MainViewModel.swift
//  MergePDF
//
//  Created by Ivan Dvornyk on 06.04.2022.
//

import Foundation

protocol MainViewModelProtocol {
    func getFiles() -> [FileModel]
    func filesCount() -> Int
    func getFile(at indexPath: IndexPath) -> FileModel
    func addFile(file: FileModel)
    func removeFile(at indexPath: IndexPath)
    func removeFiles()
    func mergeButtonIsActive() -> Bool
    func getMergeData() -> Data
}

class MainViewModel: MainViewModelProtocol {
    
    private var files = [FileModel]()
    private let fileHelper: FileHelperProtocol = FileHelper()
    
    func getFiles() -> [FileModel] {
        return files
    }
    
    func filesCount() -> Int {
        return files.count
    }
    
    func getFile(at indexPath: IndexPath) -> FileModel {
        return files[indexPath.row]
    }
    
    func removeFile(at indexPath: IndexPath) {
        files.remove(at: indexPath.row)
    }
    
    func addFile(file: FileModel) {
        files.append(file)
    }
    
    func getMergeData() -> Data {
        let document = fileHelper.mergePdf(files: files)
        guard let documentDataForSaving = document.dataRepresentation() else { return Data() }
        return documentDataForSaving
    }
    
    func removeFiles() {
        files.removeAll()
    }
    
    func mergeButtonIsActive() -> Bool {
        !files.isEmpty
    }
}
