//
//  ContentView.swift
//  MyCamera
//
//  Created by 水原　樹 on 2024/01/27.
//

import SwiftUI

struct ContentView: View {
    // 許可が必要
    // 撮影した写真を保持する状態変数
    @State var caputureImage: UIImage? = nil
    // 撮影画面の閉会状態を管理
    @State var isShowSheet = false
    var body: some View {
        VStack{
            Spacer()
            // もし撮影した写真がある時
            if let caputureImage {
                Image(uiImage: caputureImage)
                    .resizable()
                    .scaledToFit()
            }
            Spacer()
            // カメラを起動するボタン
            Button{
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    print("カメラを利用します")
                    // カメラを使えるなら、isShowSheetをtrue
                    // toggleはtrueとfalseに切り替えれる
                    isShowSheet.toggle()
                } else {
                    print("カメラが利用してない")
                }
                
            } label: {
                Text("カメラを起動する")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(.white)
            }
            .padding()
            // sheetを表示
            .sheet(isPresented: $isShowSheet){
                ImagePickerView(isShowSheet: $isShowSheet, captuerImage: $caputureImage)
            }
        }
    }
}

#Preview {
    ContentView()
}
