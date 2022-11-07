//
//  API.swift
//  InnocvInterviewProject
//
//  Created by Daniel Flores on 6/11/22.
//

import Foundation
import PromiseKit
import PMKFoundation
import QNetworking


private let apiBoundary = UUID().uuidString

struct APIError: Decodable, LocalizedError {
    var title: String
    var status: Int
    var detail: String
}

struct APIErrorCodeMessage: LocalizedError, Codable {
    var status: Int?
    var message: String?
}

struct DefaultError: LocalizedError {
    var messageDefault: String
}


enum API {
    case health
    case getUsers
    case postUser(name: String, birthDate: String)
    case modifyUser(name: String, birthDate: String, id: Int)
    case deleteUser(id: Int)
    case findUserById(id: Int)
}

extension API: QRequestable {
    
    var baseURL: String {
        return "https://hello-world.innocv.com"
    }
    
    
    
    var path: String {
        switch self {
        case .health:
            return "/api/Health"
        case .getUsers, .postUser, .modifyUser:
            return "/api/User"
        case .deleteUser(let id), .findUserById(let id):
            return "/api/User/\(id)"
        }
    }
    
    var query: [String: Any]? {
        var q = [String: Any]()
        switch self {
        default:
            return nil
        }
        return q
    }
    
    var method: QHTTPMethod {
        switch self {
        case .health,
                .getUsers,
                .findUserById:
            return .get
        case .postUser:
            return .post
        case .modifyUser:
            return .put
        case .deleteUser:
            return .delete
            
        }
    }
    
    var body: Data? {
        switch self {
        case .postUser(let name, let birthDate):
            return try? JSONEncoder().encode(["name": name, "birthDate": birthDate])
        case .modifyUser(let name, let birthDate, let id):
            let dto = User(id: id, name: name, birthDate: birthDate)
            return try? JSONEncoder().encode(dto)
        default:
            return nil
        }
    }
    
    var headers: [String: String]? {
        var header = API.defaultHeaders
        if let body = body {
            header["Content-Length"] = "\(body.count)"
        }
        switch self {
        default:
            break
        }
        return header
    }
    
    private static var defaultHeaders: [String: String] {
        
        return [
            "Accept": "application/json",
            "Content-Type": "application/json",
        ]
    }
}

extension API {
    
    public func response() -> Promise<(data: Data, response: URLResponse)> {
        let req = request()
        let method = self.method.rawValue.uppercased()
        var bodyString = ""
        if self.body != nil {
            bodyString = String(data: self.body!, encoding: .utf8) ?? ""
        }
        let date = Date()
        print("🚀", method, path, query ?? "", bodyString)
        
        return URLSession.shared.dataTask(.promise, with: req)
            .get {
                guard let statusCode = ($0.response as? HTTPURLResponse)?.statusCode else { return }
                
                switch statusCode {
                case 200...300:
                    print("respuesta correcta")
                case 400...1000:
                    let dec = JSONDecoder()
                    if let apiError = try? dec.decode(APIErrorCodeMessage.self, from: $0.data) {
                        throw apiError
                    }
                default:
                    let dec = JSONDecoder()
                    if let apiError = try? dec.decode(APIError.self, from: $0.data) {
                        throw apiError
                    }
                    print(String(decoding: $0.data, as: UTF8.self))
                    throw DefaultError(messageDefault: "Default error")
                    
                }
            } .tap {
                let millisecs = date.timeIntervalSinceNow * -1000
                let secs = String(format: "%3.0fms", millisecs)
                let url = req.url!.absoluteString
                switch $0 {
                case .fulfilled(let je):
                    let code = (je.response as? HTTPURLResponse)?.statusCode ?? -1
                    print("✅(\(secs)) \(method) (\(code)): \(url)")
                    let json = try? JSONSerialization.jsonObject(with: je.data, options: [])
                    print("Data: ", json ?? "No data")
                case .rejected(let e):
                    let code = (e as? HTTPURLResponse)?.statusCode ?? -1
                    print("❌(\(secs)) \(method) (\(code)): \(url)", e)
                }
            }
    }
}


