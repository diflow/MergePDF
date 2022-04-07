//
//  FileModel.swift
//  MergePDF
//
//  Created by Ivan Dvornyk on 06.04.2022.
//

import UIKit

struct FileModel {
    
    let url: URL
    let date: Date
    
    var image: UIImage {
        let image = UIImage(named: "ic_pdf") ?? UIImage()
        return image
    }
    
    var name: String {
        return url.lastPathComponent
    }
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
}
