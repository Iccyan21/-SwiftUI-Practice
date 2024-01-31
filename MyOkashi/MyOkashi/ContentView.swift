//
//  ContentView.swift
//  MyOkashi
//
//  Created by 水原　樹 on 2024/01/30.
//

import SwiftUI

struct ContentView: View {
    // OkashiDataを参照する変数
    var okashiDataList = OkashiData()
    // 入力された文字数を保持する状態変数
    @State var inputText = ""
    // SafariViewの表示の有無を管理する変数
    @State var isShowSafari = false
    
    var body: some View {
        VStack {
            TextField("キーワード",text: $inputText,prompt: Text("キーワードを入力してください"))
                .onSubmit {
                    okashiDataList.searchOkashi(keyword: inputText)
                }
            // キーボードの改行を検索に変更する
                .submitLabel(.search)
            // 上下左右に空白を開ける
                .padding()
        }
        // リストを表示させる
        List(okashiDataList.okashiList){ okashi in
            Button {
                // 選択したら
                okashiDataList.okashiLink = okashi.link
                // SafariViewを表示する
                isShowSafari.toggle()
            } label: {
                HStack{
                    // 画像を読み込み表示させる
                    AsyncImage(url: okashi.image){ image in
                        // 画像を表示
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height:40)
                    } placeholder: {
                        // 読み込み中はインジゲーターを表示
                        ProgressView()
                    }
                    Text(okashi.name)
                }
            }
        }
        .sheet(isPresented: $isShowSafari, content: {
            // SafariViewを表示する
            SafariView(url: okashiDataList.okashiLink!)
                .ignoresSafeArea(edges:[.bottom])
        })
    }
}

#Preview {
    ContentView()
}
