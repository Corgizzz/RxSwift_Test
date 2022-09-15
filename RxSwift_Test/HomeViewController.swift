//
//  HomeViewController.swift
//  RxSwift_Test
//
//  Created by 00591908 on 2022/9/7.
//

import UIKit
import RxSwift
import RxCocoa
import LocalAuthentication

class HomeViewController: UIViewController {

    let observable = Observable.of(1, 3, 7)
    @IBOutlet weak var NextPageBtn: UIButton!
    @IBOutlet weak var TestBtn: UIButton!
//    let observable = Observable<Int>.interval(.milliseconds(500), scheduler: MainScheduler.instance)
    

    let disposeBag = DisposeBag()
    let subject = PublishSubject<Int>()
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let observable = subject.scan(0) { summary, newValue in
            return summary + newValue
        }

        observable
            .subscribe(onNext: { value in
                print(value)
            })
            .disposed(by: disposeBag)

        subject.onNext(1)
        subject.onNext(3)
        subject.onNext(5)
        subject.onNext(7)
        subject.onNext(9)

        subject.onCompleted()
//        var context = LAContext()
//        context.localizedCancelTitle = "Enter Password / Account"
//        subject.onNext("1")
//        // 1, 2
//        subject
//            .debug("A")
//            .subscribe()
//            .disposed(by: disposeBag)
//
//        subject.onNext("2")
//
//        subject.onNext("3")
//
//        subject
//            .debug("B")
//            .subscribe()
//            .disposed(by: disposeBag)
//        // 3
//        subject.onError(NSError(domain: "Test", code: -1, userInfo: nil))
//        TestBtn.rx.tap.subscribe(onNext: { _ in
//            print("=== A Tap ===")
//            subject.onNext(())
//        })
//        .disposed(by: disposeBag)

//        let observable = Observable.from(optional: number)
//        observable
//            .subscribe(onNext: { element in
//                print(element)
//            }, onError: { error in
//                print(error)
//            }, onCompleted: {
//                print("onCompleted")
//            }, onDisposed: {
//                print("onDisposed")
//            })
//            .disposed(by: disposeBag)
//         Do any additional setup after loading the view.
    }

    @IBAction func NextPageBtnTapped(_ sender: Any) {
        // 創建 LAContext 實例
//        let context = LAContext()
//        // 設置取消按鈕標題
//        context.localizedCancelTitle = "Cancel"
//        // 宣告一個變數接收 canEvaluatePolicy 返回的錯誤
//        var error: NSError?
//        // 評估是否可以針對給定方案進行身份驗證
//        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
//            // 描述使用身份辨識的原因
//            let reason = "Log in to your account"
//            // 評估指定方案
//            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (success, error) in
//                if success {
//                    DispatchQueue.main.async { [unowned self] in
//                        print("111")
////                        self.showMessage(title: "Login Successful", message: nil)
//                    }
//                } else {
//                    DispatchQueue.main.async { [unowned self] in
//                        print("2222")
////                        self.showMessage(title: "Login Failed", message: error?.localizedDescription)
//                    }
//                }
//            }
//        } else {
//            print("33333")
////            showMessage(title: "Failed", message: error?.localizedDescription)
//        }
        
        // 生物辨識物件
                let context = LAContext()
                var error: NSError?
                
                /* LAPolicy tpye : Int
                 
                 只支援 FaceID 跟 指紋辨識 驗證
                 deviceOwnerAuthenticationWithBiometrics = 1
                 
                 支援 FaceID, 指紋辨識, 裝置密碼 驗證
                 deviceOwnerAuthentication = 2
                 */
                
                // 判斷是否可以用 FaceID, 指紋辨識, 裝置密碼登入 -> Bool
                if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                    // 當 FaceID 或 指紋辨識 第一次驗證失敗, 彈跳系統制式alert, alert上的取消button文字描述
                    context.localizedCancelTitle = "取消登入"
                    // localizedFallbackTitle 是在多次驗證失敗後, 會出現在系統制式alert上的button文字描述
                    context.localizedFallbackTitle = "使用輸入帳密方式登入"
                    // 當 FaceID 或 指紋辨識 驗證失敗多次, 彈跳系統制式alert, alert上的說明描述
                    // 註: 輸入裝置密碼的視窗也會出現以下文字描述
                    let reason = "選用輸入帳密方式登入或是取消登入"
                    
                    // 使用 FaceID, 指紋辨識, 裝置密碼登入驗證
                    context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (result, err) in
                        if result {
                            // 驗證成功後續處理
                            DispatchQueue.main.async { [unowned self] in
//                                self.state = .loggedin
                            }
                        } else {
                            // 驗證失敗
                            guard let nsError = err as NSError? else { return }
                            let errorCode = Int32(nsError.code)
                            switch errorCode {
                            case kLAErrorAuthenticationFailed: print("驗證資訊出錯")
                            case kLAErrorUserCancel: print("使用者取消驗證")
                            case kLAErrorUserFallback: print("使用者選擇其他驗證方式")
                            case kLAErrorSystemCancel: print("被系統取消")
                            case kLAErrorPasscodeNotSet: print("iPhone沒設定密碼")
                            case kLAErrorTouchIDNotAvailable: print("使用者裝置不支援Touch ID")
                            case kLAErrorTouchIDNotEnrolled: print("使用者沒有設定Touch ID")
                            case kLAErrorTouchIDLockout: print("功能被鎖定(五次)，下一次需要輸入手機密碼")
                            case kLAErrorAppCancel: print("在驗證中被其他app終止")
                            default: print("驗證失敗")
                            }
                        }
                    }
                } else {
                    print(error?.localizedDescription ?? "用戶拒絕使用")
                }
        
//        self.navigationController
//        self.isEven(number: 2).subscribe(onNext: { element in
//            print(element)
//        }, onError: { error in
//            print(error)
//        }, onCompleted: {
//            print("onCompleted")
//        }, onDisposed: {
//            print("onDisposed")
//        })
//        .disposed(by: disposeBag)
//        self.navigationController?.present(SecondViewController(), animated: true, completion: nil)
    }
    
    func isEven(number: Int) -> Observable<Int> {
        // 1
        return Observable.create { observer in
            
            if number % 2 == 0 {
                  // 2
                observer.onNext(number)
                observer.onCompleted()
            } else {
                  // 3
                observer.onError(NSError.init(domain: "不是偶數", code: 401, userInfo: nil))
            }
            // 4
            return Disposables.create()
            
        }
    }

}
