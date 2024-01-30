//
//  EffectView.swift
//  MyCamera
//
//  Created by 水原　樹 on 2024/01/30.
//

import SwiftUI

struct EffectView: View {
    // エフェクト編集画面の開閉状態を管理
    @Binding var isShowSheet: Bool
    // 撮影した写真
    let caputureImage: UIImage
    // 表示する写真
    @State var showImage: UIImage?
    
    // フォルダ名を列挙した配列
    let fillterArray = [
        "CIPhotoEffectMono",
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNori",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone",
    ]
    @State var fillterSelectNumber = 0
    
    var body: some View {
        // 縦方向にレイアウト
        VStack {
            // スペースを確認
            Spacer()
            
            if let showImage {
                Image(uiImage: showImage)
                // リサイズする
                    .resizable()
                // アスペクト比
                    .scaledToFit()
            }
            Spacer()
            
            Button {
                // フィルタ名を指定
                let filterName = fillterArray[fillterSelectNumber]
                
                // 次回運用するフィルダ
                fillterSelectNumber += 1
                
                // 次回に運用するフィルタを決めておく
                if fillterSelectNumber == fillterArray.count {
                    fillterSelectNumber = 0
                }
                
                // 元々の画像の回転角度を取得
                let rotate = caputureImage.imageOrientation
                // UIImage形式の画像をCIImageに変換
                let inputImage = CIImage(image: caputureImage)
                
                //　フィルタを指定してCFImageのインスタンスを取得
                guard let effectFillter = CIFilter(name: filterName) else {
                    return
                }
                // フィルタの初期化
                effectFillter.setDefaults()
                // インスタンスにフィルタ加工する元画像
                effectFillter.setValue(inputImage, forKey: kCIInputImageKey)
                // フィルタ加工を行う情報を生成
                guard let outputImage = effectFillter.outputImage else {
                    return
                }
                
                let ciContext = CIContext(options: nil)
                
                guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else {
                    return
                }
                
                // UIImage形式に変更
                showImage = UIImage(
                    cgImage: cgImage,
                    scale: 1.0,
                    orientation: rotate
                    )
            } label: {
                Text("エフェクト")
                // 横幅いっぱい
                    .frame(maxWidth: .infinity)
                // 高さ50ポイント
                    .frame(height: 50)
                //文字列のセンタリング
                    .multilineTextAlignment(.center)
                //　背景を青色に限定
                    .background(Color.blue)
                // 文字色を白色に限定
                    .foregroundStyle(Color.white)
            }
            .padding()
            
            // showImageをアンラップする
            if let showImage = showImage?.resized() {
                // caputreから共有するがぞう生成する
                let shareImage = Image(uiImage: showImage)
                // 共有シート
                ShareLink(item: shareImage, subject: nil, message: nil, preview: SharePreview("Photo",image: shareImage)){
                    Text("シェア")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                }
                .padding()
            }
            // 閉じる
            Button {
                isShowSheet.toggle()
            } label: {
                Text("閉じる")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundStyle(Color.white)
            }
            .padding()
        }
        // 写真が表示される時に実行される
        .onAppear{
            // 撮影した写真を表示する写真を設定
            showImage = caputureImage
        }
    }
}

#Preview {
    EffectView(
        isShowSheet: .constant(true), caputureImage: UIImage(named: "preview_use")!
    
    )
}
