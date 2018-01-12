import UIKit

/// メッセージ表示処理共通
struct Alert {

    static let shared = Alert()

    /// アラート表示
    ///
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - handler: OKボタン押下後のアクション
    func alert(title: String, message: String, actions: [UIAlertAction]? = nil, handler: ((UIAlertAction) -> Void)? = nil) {

        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve

        if let actions = actions {
            actions.forEach { action in
                controller.addAction(action)
            }
        } else {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
            controller.addAction(okAction)
        }

        let viewController = getTopMostViewController()

        viewController.present(controller, animated: true, completion: nil)

        return
    }

    /// 確認表示
    ///
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - okTitle: OKボタンタイトル
    ///   - cancelTitle: キャンセルボタンタイトル
    ///   - okHandler: OKボタン押下後のアクション
    ///   - cancelHandler: キャンセルボタン押下後のアクション
    func confirm(title: String, message: String, okTitle: String = "はい", cancelTitle: String = "いいえ", okHandler: ((UIAlertAction) -> Void)? = nil, cancelHandler: ((UIAlertAction) -> Void)? = nil) {

        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve

        let okAction = UIAlertAction(title: okTitle, style: .default, handler: okHandler)
        controller.addAction(okAction)

        let cancelAction = UIAlertAction(title: cancelTitle, style: .default, handler: cancelHandler)
        controller.addAction(cancelAction)

        let viewController = getTopMostViewController()

        viewController.present(controller, animated: true, completion: nil)
        return
    }

    /// 最前面のViewControler取得
    ///
    /// - Returns: UIViewController
    func getTopMostViewController() -> UIViewController {
        var baseView = UIApplication.shared.keyWindow?.rootViewController
        while baseView?.presentedViewController != nil {
            baseView = baseView?.presentedViewController
        }
        return baseView!
    }
}
