//// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NELoginKit
import UIKit

class DemoService: NSObject {
  private static let successCode = 200

  /// 注册接口
  public class func register(phoneNumber: String, password: String, token: String, completion: @escaping (NSError?, NELoginInfo?, String?) -> Void) {
    let uri = "/sms/demo/register"
    if var request = getRequest(uri: uri) {
      // 使用 URL Session 发送请求
      var paramter = [String: Any]()
      paramter["password"] = password
      paramter["mobile"] = phoneNumber
      paramter["verify_token"] = token
      request.httpBody = try? JSONSerialization.data(withJSONObject: paramter)

      // 发送请求
      dataTaskCallBackInMain(with: request, completionHandler: { data, response, error in
        if error == nil {
          guard let d = data else {
            completion(getError(msg: nil, code: nil), nil, nil)
            return
          }
          if let result = parseResult(data: d) {
            if result.code == successCode {
              let info = NELoginInfo()
              info.phoneNumber = phoneNumber
              info.password = password

              completion(nil, info, result.originData?.yx_modelToJSONString())
            } else {
              completion(getError(msg: result.msg, code: result.code), nil, result.originData?.yx_modelToJSONString())
            }
          } else {
            completion(getError(msg: nil, code: nil), nil, nil)
          }

        } else {
          completion(error, nil, nil)
        }
      })
    }
  }

  /// 重置密码
  public class func resetPassword(phoneNumber: String, password: String, token: String, completion: @escaping (NSError?, NELoginInfo?, String?) -> Void) {
    let uri = "/sms/demo/resetPassword"
    if var request = getRequest(uri: uri) {
      // 使用 URL Session 发送请求
      var paramter = [String: Any]()
      paramter["password"] = password
      paramter["mobile"] = phoneNumber
      paramter["verify_token"] = token
      request.httpBody = try? JSONSerialization.data(withJSONObject: paramter)

      // 发送请求
      dataTaskCallBackInMain(with: request, completionHandler: { data, response, error in
        if error == nil {
          guard let d = data else {
            completion(getError(msg: nil, code: nil), nil, nil)
            return
          }
          if let result = parseResult(data: d) {
            if result.code == successCode {
              let info = NELoginInfo()
              info.phoneNumber = phoneNumber
              info.password = password
              completion(nil, info, result.originData?.yx_modelToJSONString())
            } else {
              completion(getError(msg: result.msg, code: result.code), nil, result.originData?.yx_modelToJSONString())
            }
          } else {
            completion(getError(msg: nil, code: nil), nil, nil)
          }

        } else {
          completion(error, nil, nil)
        }

      })
    }
  }

  /// 登录接口
  public class func login(phoneNumber: String, password: String, completion: @escaping (NSError?, NELoginInfo?, String?) -> Void) {
    let uri = "/sms/demo/login"
    if var request = getRequest(uri: uri) {
      // 使用 URL Session 发送请求
      var paramter = [String: Any]()
      paramter["password"] = password
      paramter["mobile"] = phoneNumber
      request.httpBody = try? JSONSerialization.data(withJSONObject: paramter)

      // 发送请求
      dataTaskCallBackInMain(with: request, completionHandler: { data, response, error in
        if error == nil {
          guard let d = data else {
            completion(getError(msg: nil, code: nil), nil, nil)
            return
          }
          if let result = parseResult(data: d) {
            if result.code == successCode {
              let info = NELoginInfo()
              info.phoneNumber = phoneNumber
              info.password = password
              completion(nil, info, result.originData?.yx_modelToJSONString())
            } else {
              completion(getError(msg: result.msg, code: result.code), nil, result.originData?.yx_modelToJSONString())
            }
          } else {
            completion(getError(msg: nil, code: nil), nil, nil)
          }

        } else {
          completion(error, nil, nil)
        }
      })
    }
  }

  /// 获取校验 token 接口
  public class func getToken(phoneNumber: String, completion: @escaping (String, NSError?) -> Void) {
    let uri = "/sms/demo/getToken"
    if var request = getRequest(uri: uri) {
      // 使用 URL Session 发送请求
      var paramter = [String: Any]()
      paramter["mobile"] = phoneNumber
      request.httpBody = try? JSONSerialization.data(withJSONObject: paramter)

      // 发送请求
      dataTaskCallBackInMain(with: request, completionHandler: { data, response, error in

        print("response data : ", data as Any)
        print("response : ", response as Any)
        print("response error : ", error as Any)
        let string = String(data: data!, encoding: .utf8)!
        print("data : ", string)
        if error == nil {
          guard let d = data else {
            completion("", getError(msg: nil, code: nil))
            return
          }

          let result = parseResult(data: d)
          if let token = result?.originData?["data"] as? String {
            completion(token, nil)
          } else {
            completion("", error)
          }
        } else {
          completion("", error)
        }
      })
    }
  }

  /// 短信验证码登录
  public class func loginWithToken(phoneNumber: String, token: String, completion: @escaping (NSError?, NELoginInfo?, String?) -> Void) {
    let uri = "/sms/demo/loginByVerifyToken"
    if var request = getRequest(uri: uri) {
      // 使用 URL Session 发送请求
      var paramter = [String: Any]()
      paramter["verify_token"] = token
      paramter["mobile"] = phoneNumber
      request.httpBody = try? JSONSerialization.data(withJSONObject: paramter)

      // 发送请求
      dataTaskCallBackInMain(with: request, completionHandler: { data, response, error in
        if error == nil {
          guard let d = data else {
            completion(getError(msg: nil, code: nil), nil, nil)
            return
          }
          if let result = parseResult(data: d) {
            if result.code == successCode {
              let info = NELoginInfo()
              info.phoneNumber = phoneNumber
              completion(nil, info, result.originData?.yx_modelToJSONString())
            } else {
              completion(getError(msg: result.msg, code: result.code), nil, nil)
            }
          } else {
            completion(getError(msg: nil, code: nil), nil, nil)
          }

        } else {
          completion(error, nil, nil)
        }
      })
    }
  }

  private class func getHost() -> String {
    if let config = NELoginSDK.shared.getSetupConfig(), let host = config.host, host.count > 0 {
      return host
    }
    return AppConfig.host
  }

  private class func getRequest(uri: String) -> URLRequest? {
    guard let config = NELoginSDK.shared.getSetupConfig() else {
      return nil
    }
    let requestUrl = getHost() + uri
    guard let url = URL(string: requestUrl) else {
      return nil
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    let uuid = UUID()
    let uuidString = uuid.uuidString
    request.setValue(config.appKey, forHTTPHeaderField: "appkey")
    request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.setValue("deviceId", forHTTPHeaderField: uuidString)
    request.setValue("clientType", forHTTPHeaderField: "ios")
    request.setValue("versionCode", forHTTPHeaderField: NELoginSDK.shared.getVersion())
    return request
  }

  private class func parseResult(data: Data) -> NECommonResult? {
    do {
      print("json string : ", String(data: data, encoding: .utf8) ?? "")
      if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
        let result = NECommonResult()
        if let code = jsonObject["code"] as? Int {
          result.code = code
        }
        if let msg = jsonObject["msg"] as? String {
          result.msg = msg
        }
        result.originData = jsonObject
        return result
      }
    } catch {
      print("Error: \(error.localizedDescription)")
    }
    return nil
  }

  private class func getError(msg: String?, code: Int?) -> NSError {
    if let message = msg, let errorCode = code {
      return NSError(domain: "com.netease.login", code: errorCode, userInfo: [NSLocalizedDescriptionKey: message])
    }
    return NSError(domain: "com.netease.login", code: -1, userInfo: [NSLocalizedDescriptionKey: "operation failed"])
  }

  private class func callbackInMain(completion: @escaping () -> Void) {
    DispatchQueue.main.async {
      completion()
    }
  }

  private class func dataTaskCallBackInMain(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, NSError?) -> Void) {
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      DispatchQueue.main.async {
        completionHandler(data, response, error as NSError?)
      }
    }
    task.resume()
  }
}
