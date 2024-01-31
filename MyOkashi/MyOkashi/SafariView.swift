//
//  SafariView.swift
//  MyOkashi
//
//  Created by 水原　樹 on 2024/01/31.
//

import SwiftUI
import SafariServices

// SFSafariContorollerを起動する構造体
struct SafariView: UIViewControllerRepresentable {
    // 表示するホームページのURl
    let url: URL
    
    // 表示するViewを生成する時に実行
    func makeUIViewController(context: Context) -> some UIViewController {
        // Safariを起動
        return SFSafariViewController(url: url)
    }
    // Viewが更新された時に実行
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // 処理なし
    }
}

