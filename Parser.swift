//
//  Parser.swift
//  Copyright © 2018 Grodas. All rights reserved.
//

import Foundation
import SwiftyJSON

class Parser {
    
    func parseData(_ data: Data) -> [Post] {
        var parsedArray = [Post]()
        guard let json = try? JSON(data: data) else { return parsedArray }

		for (_, subJson):(String, JSON) in json {
            parsedArray.append(parsePost(json: subJson))
        }

        return parsedArray
    }

    func parseCategory(json: JSON) -> String {
        var noSub: String = "";

		for cat in json {
            let (_, val) = cat
            let id = val["category_id"]

            if id != 149 && id != 150 && id != 1 {
                return val["name"].stringValue
            }

            noSub = val["name"].stringValue
        }
        return noSub
    }

    func parseJsonArray(json: [JSON]) -> [String]{
        var strArr: [String] = []

		for link in json {
            strArr.append(link.stringValue)
        }

        return strArr
    }

    private func parsePost(json: JSON) -> Post {
        return Post(id: String(json["id"].intValue), link: API().getOriginUrl() + "?/p=\(String(json["id"].intValue))", date: json["date"].stringValue, title: json["title"].stringValue, image: json["image"].stringValue, localImage: nil, category: " \u{2014}   " + self.parseCategory(json: json["categories"]), content: json["content"].stringValue)
    }

    func parseJournal(json: JSON) -> Journal {
        return Journal(id: String(json["id"].intValue), productId: self.generateProductId(price: String(json["price"].stringValue)),price: String(json["price"].stringValue), title: json["title"].stringValue, date: json["date"].stringValue, dateOriginal: json["origin_date"].stringValue, content: json["content"].stringValue, image: json["image"].stringValue, storedImage: nil, images: self.parseJsonArray(json: json["images"].arrayValue), files: self.parseJsonArray(json: json["files"].arrayValue))
    }
    
    func generateProductId(price: String) -> String {
        return "com.grodas.ldaily.journal\(price)uah"
    }

    func parseUser(json: JSON) -> User{
        return User(id:json["data"]["ID"].intValue, username:json["data"]["user_login"].stringValue, email:json["data"]["user_email"].stringValue)
    }

    func parseFileName(fileName: String) -> String {
        let arr = fileName.components(separatedBy: " ")
        var fileNameStr = ""

		for str in arr {
            fileNameStr += str
        }

        return fileNameStr
    }

    func parseResetPassword(json: JSON) -> Bool{
        return json["result"].boolValue;
    }

    func parsePurchases(data: Data, field: String, userDefaults: UserDefaults) {
        if let json = try? JSON(data) {
            let jsonRes = json["result"]
            var userData: [Int] = []

			for entity in jsonRes {
                let (_, value) = entity

				if let id = Int(String(describing: value)) {
                    userData.append(id)
                }
            }

            userDefaults.set(userData, forKey: field)
        }
    }

    func alreadyPurchased(id: Int, pubYear: Int, subYear: Int?, journals: [Int]?) -> Bool {
        if let subscriptionYear = subYear {
            if subscriptionYear == pubYear {
                return true
            }
        }

		if let journalsList = journals {
            if journalsList.contains(id) {
                return true
            }
        }

        return false
    }
}
