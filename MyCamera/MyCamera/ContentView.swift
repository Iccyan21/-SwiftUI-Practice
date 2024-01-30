//
//  ContentView.swift
//  MyCamera
//
//  Created by 水原　樹 on 2024/01/27.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    // 撮影した写真を保持する状態変数
    @State var caputureImage: UIImage? = nil
    // 撮影画面の閉会状態を管理
    @State var isShowSheet = false
    // フォトライブラリーで選択した写真を管理
    @State var photoPickerSelectedImage: PhotosPickerItem? = nil
    var body: some View {
        VStack{
            Spacer()
            // カメラを起動するボタン
            Button{
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    print("カメラを利用します")
                    // 撮影写真を初期化
                    caputureImage = nil
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
                    .foregroundColor(Color.white)
                    
            }
            // sheetを表示
            .sheet(isPresented: $isShowSheet){
                if let caputureImage = caputureImage?.resized() {
                    EffectView(isShowSheet: $isShowSheet, caputureImage: caputureImage)
                } else {
                    ImagePickerView(isShowSheet: $isShowSheet, captuerImage: $caputureImage)
                }
            }
            // フォトライブラリーから選択する
            PhotosPicker(selection: $photoPickerSelectedImage, matching: .images,preferredItemEncoding: .automatic, photoLibrary: .shared()){
                // ティスト
                Text("フォトライブラリーから選択します")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .foregroundStyle(Color.white)
                    .padding()
            }
            
            // 選択した写真を取り出す
            .onChange(of: photoPickerSelectedImage, initial: true,{ oldValue, newValue in
                // 選択した写真がある時
                if let newValue {
                    // Data型で写真を取り出す
                    newValue.loadTransferable(type: Data.self){ result in
                        switch result {
                        case .success(let data):
                            if let data {
                                caputureImage = UIImage(data: data)
                            }
                        case .failure:
                            return
                        }
                    }
                }
                
            })
            
        }
        .onChange(of: caputureImage, initial: true,{oldValue, newValue in
            if let _ = newValue {
                // 撮影した写真があるEffectView
                isShowSheet.toggle()
            }
        })
    }
}

#Preview {
    ContentView()
}
