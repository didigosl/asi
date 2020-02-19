//
//  Networking.swift
//  GoEatBusiness
//
//  Created by JS_Coder on 12/11/18.
//  Copyright © 2018 JS_Coder. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}


/// netWorking
struct NetWork {

    static func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }

    //MARK: - 发送Form请求
    static func formRequest(urlConnection: String, method: HTTPMethod, parameter: [String: Any]? = nil, header: [String: String]? = nil, completed: @escaping (_ json: [String: Any]?, _ error: Error?) -> Void) {

        //如果url 错误返回错误
        if let trueUrlStr = urlConnection.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: trueUrlStr) {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue

            if parameter != nil {
                guard let data =  getPostString(params: parameter!).data(using: String.Encoding.utf8) else {
                    completed(nil, AFError.ParameterEncodingFailureReason.formEncodingFailed(error: "Error Parameter") as? Error)
                    return
                }

                if header != nil {
                    for (_, dict) in header!.enumerated(){
                        request.setValue(dict.value, forHTTPHeaderField: dict.key)
                    }
                }
                request.httpBody = data
            }

            // 开始发送请求
            let defaultSession = URLSession.shared
            defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                DispatchQueue.main.async {
                    if error == nil, data != nil {
                        do {
                            if let responseJson = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                                completed(responseJson, nil)

                            }
                        } catch (let responseError){
                            completed(nil, AFError.ParameterEncodingFailureReason.jsonEncodingFailed(error: responseError) as? Error)
                        }
                    }else {
                        completed(nil, AFError.responseSerializationFailed(reason: AFError.ResponseSerializationFailureReason.jsonSerializationFailed(error: error!)))
                    }
                }}.resume()
        } else {
            completed(nil,AFError.errorUrl(url: urlConnection))
        }
    }

    //MARK: - 发送请求
    static func request(urlConnection: String, method: HTTPMethod, parameter: [String: Any]? = nil, header: [String: String]? = nil, success: @escaping (([String: Any]) -> Void), failed: @escaping ((_ error: Error?) -> Void)) {

        //如果url 错误返回错误
        if let trueUrlStr = urlConnection.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: trueUrlStr) {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            if let loginModel = GECProfileViewModel.loginModel {
                request.setValue("\(loginModel.tokenType!) \(loginModel.tokenContent!)", forHTTPHeaderField: "authorization")
            }else if let loginModel = GECLoginModel.getLoginModel() {
                request.setValue("\(loginModel.tokenType!) \(loginModel.tokenContent!)", forHTTPHeaderField: "authorization")
            }
            // 设置token
            do {
                if parameter != nil {
                    let data = try JSONSerialization.data(withJSONObject: parameter!, options: .prettyPrinted)
                    if header != nil {
                        for (_, dict) in header!.enumerated(){
                            request.setValue(dict.value, forHTTPHeaderField: dict.key)
                        }
                    }else {
                        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
                    }
                    request.httpBody = data
                }

                // 开始发送请求
                let defaultSession = URLSession.shared
                defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                    DispatchQueue.main.async {
                        if let response = response as? HTTPURLResponse {
                            if response.statusCode == 401 {
                                NotificationCenter.default.post(name: NotificationNames.needToLogin, object: nil)
                                failed(nil)
                                return
                            }
                        }
                        if error == nil, data != nil {
                            do {
                                if let responseJson = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                                    success(responseJson)
                                }
                            } catch (let responseError){
                                failed(AFError.ParameterEncodingFailureReason.jsonEncodingFailed(error: responseError) as? Error)
                            }
                        }else {

                            failed(AFError.responseSerializationFailed(reason: AFError.ResponseSerializationFailureReason.jsonSerializationFailed(error: error!)))
                        }
                    }}.resume()
            } catch (let jsonError){
                failed(AFError.ParameterEncodingFailureReason.jsonEncodingFailed(error: jsonError) as? Error)
            }
        } else {
            failed(AFError.errorUrl(url: urlConnection))
        }
    }

    //MARK: - 发送Form请求
    static func multiformRequest(urlConnection: String, method: HTTPMethod, parameter: [String: Any]? = nil, header: [String: String]? = nil,  files: [(name:String, data: Data, fileName: String)], completed: @escaping (_ json: [String: Any]?, _ error: Error?) -> Void) {

        //如果url 错误返回错误
        if let trueUrlStr = urlConnection.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: trueUrlStr) {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            let boundary = "Boundary-\(UUID().uuidString)"
            if header != nil {
                for (_, dict) in header!.enumerated(){
                    request.setValue(dict.value, forHTTPHeaderField: dict.key)
                }
            }else {
                request.setValue("multipart/form-data; boundary=\(boundary)",
                    forHTTPHeaderField: "Content-Type")
            }
            request.httpBody = try! createBody(with: parameter, files: files, boundary: boundary)

            // 开始发送请求
            let defaultSession = URLSession.shared
            defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                DispatchQueue.main.async {
                    if error == nil, data != nil {
                        do {
                            if let responseJson = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                                completed(responseJson, nil)

                            }
                        } catch (let responseError){
                            completed(nil, AFError.ParameterEncodingFailureReason.jsonEncodingFailed(error: responseError) as? Error)
                        }
                    }else {
                        completed(nil, AFError.responseSerializationFailed(reason: AFError.ResponseSerializationFailureReason.jsonSerializationFailed(error: error!)))
                    }
                }}.resume()
        } else {
            completed(nil,AFError.errorUrl(url: urlConnection))
        }
    }

    //创建表单body
    static private func createBody(with parameters: [String: Any]?,
                                   files: [(name:String, data: Data, fileName: String)],
                                   boundary: String) throws -> Data {
        var body = Data()

        //添加普通参数数据
        if parameters != nil {
            for (key, value) in parameters! {
                // 数据之前要用 --分隔线 来隔开 ，否则后台会解析失败
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }

        //添加文件数据
        for file in files {
            let mimetype = mimeType(pathExtension: "jpg")
            // 数据之前要用 --分隔线 来隔开 ，否则后台会解析失败
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; "
                + "name=\"\(file.name)\"; filename=\"\(file.fileName)\"\r\n")
            body.append("Content-Type: \(mimetype)\r\n\r\n") //文件类型
            body.append(file.data) //文件主体
            body.append("\r\n") //使用\r\n来表示这个这个值的结束符
        }

        // --分隔线-- 为整个表单的结束符
        body.append("--\(boundary)--\r\n")
        return body
    }

    //根据后缀获取对应的Mime-Type
    static private func mimeType(pathExtension: String) -> String {
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                           pathExtension as NSString,
                                                           nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?
                .takeRetainedValue() {
                return mimetype as String
            }
        }
        //文件资源类型如果不知道，传万能类型application/octet-stream，服务器会自动解析文件类
        return "application/octet-stream"
    }



    // 错误码
    public enum AFError: Error {
        public enum ParameterEncodingFailureReason {
            case missingURL
            case jsonEncodingFailed(error: Error)
            case propertyListEncodingFailed(error: Error)
            case formEncodingFailed(error: String)
        }

        public enum MultipartEncodingFailureReason {
            case bodyPartURLInvalid(url: URL)
            case bodyPartFilenameInvalid(in: URL)
            case bodyPartFileNotReachable(at: URL)
            case bodyPartFileNotReachableWithError(atURL: URL, error: Error)
            case bodyPartFileIsDirectory(at: URL)
            case bodyPartFileSizeNotAvailable(at: URL)
            case bodyPartFileSizeQueryFailedWithError(forURL: URL, error: Error)
            case bodyPartInputStreamCreationFailed(for: URL)

            case outputStreamCreationFailed(for: URL)
            case outputStreamFileAlreadyExists(at: URL)
            case outputStreamURLInvalid(url: URL)
            case outputStreamWriteFailed(error: Error)

            case inputStreamReadFailed(error: Error)
        }

        public enum ResponseValidationFailureReason {
            case dataFileNil
            case dataFileReadFailed(at: URL)
            case missingContentType(acceptableContentTypes: [String])
            case unacceptableContentType(acceptableContentTypes: [String], responseContentType: String)
            case unacceptableStatusCode(code: Int)
        }

        public enum ResponseSerializationFailureReason {
            case inputDataNil
            case inputDataNilOrZeroLength
            case inputFileNil
            case inputFileReadFailed(at: URL)
            case stringSerializationFailed(encoding: String.Encoding)
            case jsonSerializationFailed(error: Error)
            case propertyListSerializationFailed(error: Error)
        }

        case invalidURL(url: URL)
        case errorUrl(url: String)
        case parameterEncodingFailed(reason: ParameterEncodingFailureReason)
        case multipartEncodingFailed(reason: MultipartEncodingFailureReason)
        case responseValidationFailed(reason: ResponseValidationFailureReason)
        case responseSerializationFailed(reason: ResponseSerializationFailureReason)
    }
}
//扩展Data
extension Data {
    //增加直接添加String数据的方法
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}

//MARK: - JSONEncoder / JSONDecoder
func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
