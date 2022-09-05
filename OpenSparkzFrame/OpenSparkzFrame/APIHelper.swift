//
//  APIHelper.swift
//  OpenSparkz
//
//  Created by apple on 10/02/22.
//

import Foundation


public class ApiHelper: NSObject {
    
    
    
    class func apiCallGet(serviceName: String,param: [String:Any], isWithToken: Bool?, token: String?, showLoader: Bool? = nil,
                          completionClosure: @escaping([String: Any]?,Error?) ->())
    {
        
        guard let serviceUrl = URL(string: serviceName) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(format: "Bearer %@", token as! CVarArg), forHTTPHeaderField: "Authorization")
        
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    completionClosure(json as? [String : Any], nil)
                    
                } catch {
                    completionClosure(nil,error)
                }
            }
        }.resume()
        
    }
    
    class func apiCallPost(serviceName: String,param: [String:Any], isWithToken: Bool?, token: String?, showLoader: Bool? = nil,
                           completionClosure: @escaping([String: Any]?,Error?) ->())
    {
        
        guard let serviceUrl = URL(string: serviceName) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    completionClosure(json as? [String : Any], nil)
                    
                } catch {
                    completionClosure(nil,error)
                }
            }
        }.resume()
        
    }
    
    
}


