//
//  API.swift
//  Copyright © 2018 Grodas. All rights reserved.
//

import Foundation
import SwiftHTTP
import SwiftyJSON

class API {

    typealias Completion = ((Response) -> Void)
    typealias Params = [String:String]

    private let ORIGIN_URL: String = "https://somesite.test/"
    private let MAIN_ROUTE: String = "wp-json/mob-api/" // error
    private let VERSION: String = "v1/"
    private let POSTS_URL: String = "getPosts?"
    private let CATEGORIES_URL: String = "getCategories?"
    private let PRODUCT_URL: String = "getProduct"
    private let AUTH_URL: String = "loginUser?"
    private let REGISTER_URL: String = "createNewUser?"
    private let RESET_PASSWORD_URL: String = "resetPassword?";

    private let CATEGORY_PARAM: String = "category="
    private let CATEGORY_ID_PARAM: String = "category_id="
    private let PER_PAGE_PARAM: String = "&page="

    func getPosts(category_id: Int, page: Int, locale: String, completion: @escaping Completion) {
        let url = getUrl(category: category_id, page: page, locale: locale)
        let params = Params()
        let headers = ["Content-Type":"application/json"]
        send(url: url, params: params, headers: headers, completion: completion)
    }

    func getMagazines(completion: @escaping Completion) {
        let url = getProductsUrl()
        let params = Params()
        let headers = ["Content-Type":"application/json"]
        send(url: url, params: params, headers: headers, completion: completion)
    }

    private func send(url: String, params: Params, headers: Params, completion: @escaping Completion) {
        HTTP.GET(url, parameters: params, headers: headers, requestSerializer: JSONParameterSerializer(), completionHandler: completion)
    }

    func getOriginUrl() -> String {
        return self.ORIGIN_URL
    }

    private func getUrl(category: Int, page: Int = 1, locale: String) -> String {
        switch(locale) {
			case Language.language.ukrainian:
				return self.ORIGIN_URL + "\(Language.language.ukrainian)/" + self.MAIN_ROUTE + self.VERSION + self.POSTS_URL + self.CATEGORY_PARAM + String(category) + self.PER_PAGE_PARAM + String(page)
			case Language.language.russian:
				return self.ORIGIN_URL + self.MAIN_ROUTE + self.VERSION + self.POSTS_URL + self.CATEGORY_PARAM + String(category) + self.PER_PAGE_PARAM + String(page)
			default:
				return self.ORIGIN_URL + "\(Language.language.english)/" + self.MAIN_ROUTE + self.VERSION + self.POSTS_URL + self.CATEGORY_PARAM + String(category) + self.PER_PAGE_PARAM + String(page)
        }
    }

    func getCategoryUrl(subcategory: Int, locale: String) -> String {
        if locale != Language.language.russian {
            return self.ORIGIN_URL + "\(locale)/" + self.MAIN_ROUTE + self.VERSION + self.CATEGORIES_URL + self.CATEGORY_ID_PARAM + String(subcategory)
        } else {
            return self.ORIGIN_URL + self.MAIN_ROUTE + self.VERSION + self.CATEGORIES_URL + self.CATEGORY_ID_PARAM + String(subcategory)
        }
    }

    func getProductsUrl() -> String {
        return self.ORIGIN_URL + self.MAIN_ROUTE + self.VERSION + self.PRODUCT_URL
    }

    func getAuthUrl(email: String, password: String, locale: String) -> String {
        if locale != Language.language.russian {
            return self.ORIGIN_URL + "\(locale)/" + self.MAIN_ROUTE + self.VERSION + self.AUTH_URL + "email=\(email)&password=\(password)"
        } else {
            return self.ORIGIN_URL + self.MAIN_ROUTE + self.VERSION + self.AUTH_URL + "email=\(email)&password=\(password)"
        }
    }

    func getRegisterUrl(email: String, login: String, password: String, locale: String) -> String {
        if locale != Language.language.russian {
            return self.ORIGIN_URL + "\(locale)/" + self.MAIN_ROUTE + self.VERSION + self.REGISTER_URL + "login=\(login)&email=\(email)&password=\(password)"
        } else {
            return self.ORIGIN_URL + self.MAIN_ROUTE + self.VERSION + self.REGISTER_URL + "login=\(login)&email=\(email)&password=\(password)"
        }
    }

    func resetPassword(email: String, locale: String) -> String {
        if locale != Language.language.russian {
            return self.ORIGIN_URL + "\(locale)/" + self.MAIN_ROUTE + self.VERSION + self.RESET_PASSWORD_URL+"user_login=\(email)&wc_reset_password=1"
        } else {
            return self.ORIGIN_URL + self.MAIN_ROUTE + self.VERSION + self.RESET_PASSWORD_URL+"user_login=\(email)&wc_reset_password=1"
        }
    }

    func setAuthPurchases(userId: String, fieldName: String, value: Int, locale: String) {
        HTTP.GET(self.ORIGIN_URL + self.MAIN_ROUTE + self.VERSION + "addUserData?user_id=\(userId)&key=\(fieldName)&value=\(value)")
    }

    func getUserPurchases(num_id: Int, field: String, completion: @escaping Completion) {
        HTTP.GET(self.getAuthPurchasesUrl(userId: num_id, fieldName: field), completionHandler: completion)
    }

    private func getAuthPurchasesUrl(userId: Int, fieldName: String) -> String {
        return self.ORIGIN_URL + self.MAIN_ROUTE + self.VERSION + "getUserData?user_id=\(userId)&key=\(fieldName)"
    }
}
