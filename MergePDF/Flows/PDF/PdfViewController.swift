//
//  PdfViewController.swift
//  MergePDF
//
//  Created by Ivan Dvornyk on 06.04.2022.
//

import UIKit
import PDFKit

class PdfViewController: UIViewController, PDFViewDelegate {
    
    private let pdfView = PDFView()
    
    public var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPdfView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pdfView.frame = view.bounds
    }
    
    private func setupPdfView() {
        view.addSubview(pdfView)
        pdfView.delegate = self
        pdfView.autoScales = true
        
        let document = PDFDocument(url: url)
        pdfView.document = document
    }
}
