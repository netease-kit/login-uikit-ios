# 概述

网易云信 LoginKit 登录组件封装了云信短信能力，提供发送短信、验证短信验证码以及验证结果抄送功能。通过该组件您可以将短信验证能力快速集成至自身应用中，实现短信验证登录的场景。

**Demo 效果图：**
<img src="https://yx-web-nosdn.netease.im/common/c42aafff418acc8bc2149547515dbfa1/登录.png" width=900 />

## 技术支持

网易云信提供多种服务，包括客服、技术支持、热线服务、全流程数据监控等，建议扫码添加我们的技术支持，协助接入、测试以及定制需求。
| 微信咨询 | 在线咨询 | 电话咨询 |
| :--: | :--: | :--: |
| <img src="https://yx-web-nosdn.netease.im/common/bbe362067ecfb9c0aafa41b3c2a9e90a/扫码咨询.png" width=100 /> | [点击在线咨询](https://qiyukf.com/client?k=10f5d3378752b7b73aa90daf2bd4fc8a&u=&d=96oshbhiofhds8zt8ej3&uuid=emoobdra0otce0bnxjfz&gid=0&sid=0&qtype=0&welcomeTemplateId=0&dvctimer=0&robotShuntSwitch=0&hc=0&robotId=0&pageId=1691392062019BDH8BhIoTI&shuntId=0&ctm=LS0xNjkxMzkyMTI1NDg4&wxwId=&language=&isShowBack=0&shortcutTemplateId=&t=%25E7%25BD%2591%25E6%2598%2593%25E4%25BA%2591%25E4%25BF%25A1%2520-%2520IM%25E5%258D%25B3%25E6%2597%25B6%25E9%2580%259A%25E8%25AE%25AF%25E4%25BA%2591%2520-%25E9%259F%25B3%25E8%25A7%2586%25E9%25A2%2591%25E9%2580%259A%25E8%25AF%259D) | 4009-000-123 |

## 更新日志

【V1.0.0】

- 支持发送短信验证码
- 支持验证短信验证码
- 完成登录组件 UI 能力
- 实现主题颜色自定义
- 实现内部主要 UI 类通过子类再注入的方式实现深度 UI 自定义


## 准备工作

提前获取应用 AppKey 和短信模版 ID。

1. 创建云信账号。

    如果您还没有网易云信账号，请访问[注册](https://app.netease.im/regist)。如果您已经有网易云信账号，请直接[登录](https://app.netease.im/login)。具体请参考云信控制台的[注册与登录文档](https://doc.yunxin.163.com/console/docs/DU0ODE4NTA?platform=console)。


2. 创建应用。

    创建应用是体验或使用网易云信各款产品和服务的首要前提，您可以参考[创建应用文档](https://doc.yunxin.163.com/console/docs/TIzMDE4NTA?platform=console)在网易云信控制台创建一个应用，并查看该应用的 App Key。



3. 开通短信并购买资源包。

    由于短信为资源型产品，开通功能后还需要购买相应的资源包短信条数才可正常使用，否则短信将会由于无资源包而无法正常使用，具体请参考[开通短信并购买资源包](https://doc.yunxin.163.com/sms/docs/TE1ODQ0NDY?platform=server#3-开通短信并购买资源包)。

4. 申请短信签名并创建短信模板。

    申请和创建后等待云信审核，审核通过后获取短信模版 ID，具体请参考[申请签名](https://doc.yunxin.163.com/sms/docs/TE1ODQ0NDY?platform=server#4-申请短信签名)和[创建模板](https://doc.yunxin.163.com/sms/docs/TE1ODQ0NDY?platform=server#5-创建短信正文模板)。

## 组件引入

```
pod 'NELoginKit', '1.0.0'
```


## 组件初始化

接口：

```swift
let config = NELoginSetupConfig(appKey: "your appkey", smsTemplateId: 短信模版id(长整型))
let userInfo = NEAgreementInfo()
//可选
userInfo.agreementTitle = "用户隐私协议"
userInfo.agreementLink = "xxxx"
let privateInfo = NEAgreementInfo()
privateInfo.agreementTitle = "用户使用协议"
privateInfo.agreementLink = "xxxxx"
config.agreementList.append(userInfo)
config.agreementList.append(privateInfo)
```

`NELoginSetupConfig` 参数说明：
```swift
@objcMembers
public class NELoginSetupConfig: NSObject {
  // 短信模版ID
  public var smsTemplateId: Int

  // app key
  public var appKey: String

  // MARK: - 数据类配置字段

  /// 底部隐私协议查看链接列表
  public var agreementList = [NEAgreementInfo]()

  /// 用户协议内容
  public var userAgreement: String?

  /// 用户协议弹框 title
  public var agreementTittle: String?

  /// 用户协议弹框同意按钮文案
  public var agreeButtonText: String?

  /// 用户协议弹框拒绝按钮文案
  public var rejectbuttonText: String?

  /// 用户自定义注册页面标题
  public var registerTitle: String?

  /// 自定义服务器域名，非自私有化用户或者有特殊业务需求不建议使用
  public var host: String?

  /// 号段配置，默认使用中国区 +86 配置，点击下拉
  private var internationalSegment: NSDictionary?

  /// 再次发送短信倒计时，默认60，单位: 秒，正整数
  public var timeCountdown: Int = 60

  /// 如果开通了短信上行抄送功能，该参数需要设置为true
  public var needUp = false

  // MARK: - UI类配置字段

  /// 返回按钮图标片自定义
  public var backButtonImage: UIImage?

  /// 是否显示关闭页面按钮， 默认显示
  public var isShowCloseButton: Bool = true

  /// 是否需要同意用户协议，默认需要
  public var isNeedAgree = true

}
```

## 启动登录首页

接口：

```swift
NELoginSDK.shared.startLogin { error, info in
      if let err = error {
        print(err)
      } else {
        print("登录成功")
      }
    }
```

## 回调说明

回调协议：

```swift
public protocol NELoginDelegate {
  ///  账号密码登录回调
  ///  completion 回调是否登录成功，如果登录失败，需要传入失败原因
  @objc optional func didClickLogin(info: NELoginInfo?, completion: @escaping (Bool, String?) -> Void)

  /// 手机号验证码验证成功回调(验证码校验成功，其他逻辑需要外部处理)
  @objc optional func loginVerifyCodeSuccess(info: NELoginInfo?)

  /// 手机号验证码注册成功回调(验证码校验成功，其他逻辑需要外部处理)
  @objc optional func registerVerifyCodeSuccess(info: NELoginInfo?, completion: @escaping (Bool) -> Void)

  /// 密码重置成功回调(验证码校验成功，其他逻辑需要外部处理)
  @objc optional func resetPasswordSuccess(info: NELoginInfo?, completion: @escaping (Bool) -> Void)

  /// 用户回填 token 数据， 每次请求的时候向外部请求使用
  /// completion 回调token值
  @objc optional func tokenCompletionHandler(mobile: String, completion: @escaping (String) -> Void)
}
```

示例代码：

>以下示例仅提供逻辑参考，具体请根据实际情况进行修改。


- 密码登录回调示例

    ```swift
    func didClickLogin(info: NELoginInfo?, completion: @escaping (Bool, String?) -> Void) {
        if let phone = info?.phoneNumber, let password = info?.password {
        DemoService.login(phoneNumber: phone, password: password) { error, info, result in
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
        }
    }
    ```

- 短信登录回调示例

    ```swift
    func loginVerifyCodeSuccess(info: NELoginInfo?) {
        if let mobile = info?.phoneNumber, let token = info?.token {
        DemoService.loginWithToken(phoneNumber: mobile, token: token) { error, info, result in
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
        }
    }
    ```

- 重置密码回调示例

    ```swift
    func resetPasswordSuccess(info: NELoginInfo?, completion: @escaping (Bool) -> Void) {
    if let phone = info?.phoneNumber, let password = info?.password, let token = info?.token {
        DemoService.resetPassword(phoneNumber: phone, password: password, token: token) { error, info, result in
        if let err = error {
            NELoginSDK.shared.setRegisterOrResetErrorPrompt(err.localizedDescription)
                } else {
            completion(true)
                }
            }
        }
    }
    ```

- 注册回调示例

    ```swift
    func registerVerifyCodeSuccess(info: NELoginInfo?, completion: @escaping (Bool) -> Void) {
        if let phone = info?.phoneNumber, let password = info?.password, let token = info?.token {
        DemoService.register(phoneNumber: phone, password: password, token: token) { error, info, result in
            if let err = error {
            if err.code == 506 {
                NELoginSDK.shared.showToLoginINRegister()
                return
            }
            NELoginSDK.shared.setRegisterOrResetErrorPrompt(err.localizedDescription)
            } else {
            /// 注册成功之后再登录，用户也可根据自己的业务逻辑外部决定是否直接登录

            DemoService.login(phoneNumber: phone, password: password) { error, info, result in
                NELoginSDK.shared.dismissLogin()
                }
            }
        }
        }
    }
    ```

- 安全 token 回填回调
    ```swift
    func tokenCompletionHandler(mobile: String, completion: @escaping (String) -> Void) {
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
        }
    }
    ```

## 主题说明

主题类 `NELoginThemeManager` 说明:

```swift
public
class NELoginThemeManager: NSObject {
  static let shared = NELoginThemeManager()

  override private init() {
    super.init()
  }

  /// 深色字体
  public var darkTextColor = UIColor(hexString: "#222222")

  /// 灰色字体
  public var grayTextColor = UIColor(hexString: "#666666")

  /// 浅色字体
  public var lightTextColor = UIColor(hexString: "#999999")

  /// 主题蓝色
  public var themeColor = UIColor(hexString: "#2155EE")

  /// 按钮不可点击颜色
  public var disableThemeColor = UIColor(hexString: "#2155EE", 0.6)

  /// 错误提示字体颜色(默认红色)
  public var errorColor = UIColor(hexString: "#E74646")

  ///  输入框未编辑状态的颜色
  public var inputDividerLineColor = UIColor(hexString: "#DCDFE5")

  public var navTinColor = UIColor(hexString: "#333333")
}
```

示例：
```swift
NELoginThemeManager.shared.themeColor = UIColor.red
```

## 复杂 UI 自定义

>如果UI改动比较大，主题以及配置项无法满足的情况下，需要继承内部视图控制器再注册进来进行 UI 调整。

继承示例：

```swift
import NELoginKit
import UIKit

class NECustomLoginHome: NELoginHomeController {
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
}

class NECustomVerifyViewController: VerifyLoginViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }
}

class NECustomPasswordLogin: PasswordLoginViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }
}

class NECustomRegister: NERegisterViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }
}

```

注入示例：
```swift
NELoginSDK.shared.homeClass = NECustomLoginHome.self
NELoginSDK.shared.registerClass = NECustomRegister.self
NELoginSDK.shared.verifyClass = NECustomVerifyViewController.self
NELoginSDK.shared.passwordClass = NECustomPasswordLogin.self
```
