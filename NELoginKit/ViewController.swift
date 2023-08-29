// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NECommonUIKit
import NECoreKit
import NELoginKit
import UIKit
import CommonCrypto

class ViewController: UIViewController, NELoginDelegate {
  private let textView = UITextView()

  let bundle = Bundle.main

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    let config = NELoginSetupConfig(appKey: AppConfig.appKey, smsTemplateId: AppConfig.smsTemplateId)
    let userInfo = NEAgreementInfo()
      
    // 测试使用，后续替换为自己链接
    userInfo.agreementTitle = bundle.localizedString(forKey: "user_agreement", value: nil, table: "LaunchScreen")
    userInfo.agreementLink = "https://yunxin.163.com/m/clauses/user"
    let privateInfo = NEAgreementInfo()
    privateInfo.agreementTitle = bundle.localizedString(forKey: "user_privacy", value: nil, table: "LaunchScreen")
    privateInfo.agreementLink = "https://yx-web-nosdn.netease.im/quickhtml/assets/yunxin/protocol/clauses.html"
    config.agreementList.append(userInfo)
    config.agreementList.append(privateInfo)
    
    NELoginSDK.shared.setup(with: config)
    NELoginSDK.shared.delegate = self

    NELoginSDK.shared.homeClass = NECustomLoginHome.self
    NELoginSDK.shared.registerClass = NECustomRegister.self
    NELoginSDK.shared.verifyClass = NECustomVerifyViewController.self
    NELoginSDK.shared.passwordClass = NECustomPasswordLogin.self

    setupCommonUI()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func setupCommonUI() {
    let loginButton = UIButton(type: .custom)
    loginButton.setTitle("登录", for: .normal)
    loginButton.setTitleColor(UIColor.black, for: .normal)
    loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
    loginButton.frame = CGRect(x: 0, y: 60, width: 200, height: 50)
    view.addSubview(loginButton)

    let resetButton = UIButton(type: .custom)
    resetButton.setTitle("清除日志", for: .normal)
    resetButton.setTitleColor(UIColor.black, for: .normal)
    resetButton.addTarget(self, action: #selector(clearLog), for: .touchUpInside)
    resetButton.frame = CGRect(x: 0, y: 100, width: 200, height: 50)
    view.addSubview(resetButton)

    view.addSubview(textView)
    textView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      textView.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 20),
      textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
    ])
    textView.isEditable = false
  }

  @objc func loginAction() {
    NELoginSDK.shared.startLogin { error, info in
      if let err = error {
        print(err)
      } else {
        print("登录成功")
      }
    }
  }

  @objc func clearLog() {
    textView.text = nil
  }

  func didClickLogin(info: NELoginInfo?, completion: @escaping (Bool, String?) -> Void) {
      
      NELoginSDK.shared.dismissLogin()
      
      /* 示意代码
    if let phone = info?.phoneNumber, let password = info?.password {
      DemoService.login(phoneNumber: phone, password: password) { error, info, result in
        if let response = result {
          self.textView.text.append("\(response) \n")
        } else if let loginInfo = info, let string = loginInfo.yx_modelToJSONString() {
          self.textView.text.append("\(string) \n")
        }
        if let err = error {
          if err.code == 505 {
            NELoginSDK.shared.showLoginHomeToRegister()
            return
          }
          completion(false, err.localizedDescription)
        } else {
          NELoginSDK.shared.dismissLogin()
        }
      }
    } */
  }

  func loginVerifyCodeSuccess(info: NELoginInfo?) {
      NELoginSDK.shared.dismissLogin()

      /* 示意代码
    if let mobile = info?.phoneNumber, let token = info?.token {
      DemoService.loginWithToken(phoneNumber: mobile, token: token) { error, info, result in

        if let response = result {
          self.textView.text.append("\(response) \n")
        } else if let loginInfo = info, let string = loginInfo.yx_modelToJSONString() {
          self.textView.text.append("\(string) \n")
        }
        if let err = error {
          if err.code == 505 {
            NELoginSDK.shared.showLoginHomeToRegister()
            return
          }
          NELoginSDK.shared.setSMSLoginErrorPrompt(err.localizedDescription)
        } else {
          NELoginSDK.shared.dismissLogin()
        }
      }
    } */
  }

  func resetPasswordSuccess(info: NELoginInfo?, completion: @escaping (Bool) -> Void) {
      NELoginSDK.shared.dismissLogin()

      /* 示意代码
    if let phone = info?.phoneNumber, let password = info?.password, let token = info?.token {
      DemoService.resetPassword(phoneNumber: phone, password: password, token: token) { error, info, result in
        if let response = result {
          self.textView.text.append("\(response) \n")
        } else if let loginInfo = info, let string = loginInfo.yx_modelToJSONString() {
          self.textView.text.append("\(string) \n")
        }
        if let err = error {
          NELoginSDK.shared.setRegisterOrResetErrorPrompt(err.localizedDescription)
        } else {
          completion(true)
        }
      }
    } */
  }

  func registerVerifyCodeSuccess(info: NELoginInfo?, completion: @escaping (Bool) -> Void) {
      NELoginSDK.shared.dismissLogin()

    /* 示意代码
    if let phone = info?.phoneNumber, let password = info?.password, let token = info?.token {
      DemoService.register(phoneNumber: phone, password: password, token: token) { error, info, result in
        if let response = result {
          self.textView.text.append("\(response) \n")
        } else if let loginInfo = info, let string = loginInfo.yx_modelToJSONString() {
          self.textView.text.append("\(string) \n")
        }
        if let err = error {
          if err.code == 506 {
            NELoginSDK.shared.showToLoginINRegister()
            return
          }
          NELoginSDK.shared.setRegisterOrResetErrorPrompt(err.localizedDescription)
        } else {
          DemoService.login(phoneNumber: phone, password: password) { error, info, result in
            if let response = result {
              self.textView.text.append("\(response) \n")
            } else if let loginInfo = info, let string = loginInfo.yx_modelToJSONString() {
              self.textView.text.append("\(string) \n")
            }
            NELoginSDK.shared.dismissLogin()
          }
        }
      }
    } */
  }

  func tokenCompletionHandler(mobile: String, completion: @escaping (String) -> Void) {
      
      let token = getLocalToken(mobile: mobile)
      print("token: \(token)")
      completion(token)
      
    /* 示意代码
    DemoService.getToken(phoneNumber: mobile) { token, error in
      if error != nil {
        UIApplication.shared.keyWindow?.ne_makeToast(error?.localizedDescription ?? "获取token失败", duration: 3, position: YXToastPositionCenter)
      } else {
        if token.count > 0 {
          completion(token)
        } else {
          UIApplication.shared.keyWindow?.ne_makeToast("获取token失败", duration: 3, position: YXToastPositionCenter)
        }
      }
    } */
  }
    
    /// 此方法只是本地调试使用，生成token的逻辑只能放在服务端
    func getLocalToken(mobile: String) -> String{
        let appkey = AppConfig.appKey
        let currentTimeMillis = Int64(Date().timeIntervalSince1970 * 1000)
        let ttl = 600
        let appsecret = "<#appkey secret 不能放在客户端，这里这是便于调试#>"
        let all = "\(appkey)\(mobile)\(currentTimeMillis)\(ttl)\(appsecret)"
        let signature = calculateSHA1(for: all)
        
        var json = [String: Any]()
        json["signature"] = signature
        json["ttl"] = ttl
        json["curTime"] = currentTimeMillis
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) {
            let base64String = jsonData.base64EncodedString()
            return base64String
        }
        return ""
    }
    
    func calculateSHA1(for string: String) -> String? {
        let data = string.data(using: String.Encoding.utf8)!
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &hash)
        }
        let sha1String = hash.map { String(format: "%02x", $0) }.joined()
        return sha1String
    }
}
