//
//  WKWebViewController.swift
//  RxSwiftWebViewPractice
//
//  Created by 田澤歩 on 2021/01/08.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
    }
    
    private func setupWebView() {
        //webView.isLoadingの値の変化を監視
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        //webView.estimatedProgressの値の変化を監視
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        let url = URL(string: "https://www.google.com/")
        let urlReqest = URLRequest(url: url!)
        webView.load(urlReqest)
        progressView.setProgress(0.1, animated: true)
    }

    deinit {
        //監視を解除
        webView?.removeObserver(self, forKeyPath: "loading")
        webView?.removeObserver(self, forKeyPath: "estimatedProgerss")
    }
   
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading" {
            UIApplication.shared.isNetworkActivityIndicatorVisible = webView.isLoading
            if !webView.isLoading {
                //ロード完了時にProgressViewの進捗を0.0(非表示)にする
                progressView.setProgress(0.0, animated: false)
                //ロード完了時にNavigationTitleに読み込んだページのタイトルをセット
                navigationItem.title = webView.title
            }
        }
        
        if keyPath == "estimatedProgress" {
            //Progress Viewの進捗状態を更新
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }

}
