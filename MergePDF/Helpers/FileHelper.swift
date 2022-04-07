//
//  FileHelper.swift
//  MergePDF
//
//  Created by Ivan Dvornyk on 06.04.2022.
//

import PDFKit

protocol FileHelperProtocol {
    func mergePdf(files: [FileModel]) -> PDFDocument
}

class FileHelper: FileHelperProtocol {
    
    func mergePdf(files: [FileModel]) -> PDFDocument {
        let newDocument = PDFDocument()
        let urls = files.map { $0.url }
        
        urls.forEach {
            guard let document = PDFDocument(url: $0) else { return }
            
            for d in 0..<document.pageCount {
                let page = document.page(at: d)!
                newDocument.insert(page, at: newDocument.pageCount)
            }
        }
        return newDocument
    }
}
