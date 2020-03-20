//
//  Downloader.swift
//  Copyright © 2018 Grodas. All rights reserved.
//

import Foundation
import SwiftHTTP

class Downloader {

    var localization = Locale(locale: Language.language.english)

    private var dataPath = URL(string: "")
    private var urlToFile: String
    private var fileName: String
    private var ldDirectoryPath = ""

    private let fs = FileSystemHelper()

    init(urlToFile: String, fileName: String) {
        self.urlToFile = urlToFile
        self.fileName = Parser().parseFileName(fileName: fileName)
        self.localization = Language.language.getLocalization()
    }

    func downloadImage(urlstr: String, imageview: UIImageView){
        let url=URL(string: urlstr)!
        DispatchQueue.global().async {
            do {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let data = data {
                        DispatchQueue.main.async { // Correct
                            imageview.image = UIImage(data: data)
                        }
                    }
                }
                task.resume()
            }
        }
    }

    func downloadJournal(button: PurchaseButton, progress: UILabel, journalToArchive: JournalArchived) {
        let mainPath = self.fs.getFilesFolderUrl()
        let storage = Storage()

        if (self.fs.isDirectoryExists(path: self.ldDirectoryPath)) {
            self.downloadData(path: mainPath, button: button, progressLabel: progress)
        } else {
            self.fs.createProjectFolder(path: mainPath)
            self.downloadData(path: mainPath, button: button, progressLabel: progress)
        }

        if var storedJournals = storage.getStoredJournals() {
            let result = storedJournals.filter {$0.id == journalToArchive.id}
            let hasElement = result.isEmpty
            if hasElement {
                storedJournals.append(journalToArchive)
                storage.saveJournals(journalsList: storedJournals)
            }
        } else {
            var journalsToStore = [JournalArchived]()
            journalsToStore.append(journalToArchive)
            storage.saveJournals(journalsList: journalsToStore)
        }
    }

    private func downloadData(path: String, button: PurchaseButton, progressLabel: UILabel) {
        let req = URLRequest(urlString: self.urlToFile)
        let task = HTTP(req!)
        button.hideLoading()

        task.progress = { progress in
            DispatchQueue.main.async {
                button.setTitle("", for: .normal)
                progressLabel.isHidden = false
                progressLabel.text = "\(Int(progress*100)) %"
            }
        }

        task.run { response in
            self.fs.createFile(data: response.data, fileName: self.fileName, path: path)
            DispatchQueue.main.async {
                button.isUserInteractionEnabled = true
                progressLabel.isHidden = true
                button.setTitle(self.localization.openTitle, for: .normal)
            }
        }
    }
    
    
}
