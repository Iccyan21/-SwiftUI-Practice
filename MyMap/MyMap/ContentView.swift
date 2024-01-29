//
//  ContentView.swift
//  MyMap
//
//  Created by 水原　樹 on 2024/01/24.
//

import SwiftUI

struct ContentView: View {
    // 入力中の文字を保持する
    @State var inputText: String = ""
    // マップ種類　最初は標準から
    @State var displayMapType: MapType = .standrd
    
    // 検索キーワードを保持する状態変数、初期値は東京
    @State var displaySearchKey: String = "東京駅"
    var body: some View {
        VStack {
            TextField("キーワード",text: $inputText,prompt: Text("キーワードを入力してください"))
            // 入力が完了しとき
                .onSubmit {
                    // 検索ワードに指定
                    displaySearchKey = inputText
                }
                .padding()
            
            ZStack(alignment: .bottomTrailing){
                // マップを表示
                MapView(searchKey: displaySearchKey,mapTyoe: displayMapType)
                
                Button {
                    if displayMapType == .standrd {
                        displayMapType = .satelite
                    } else if  displayMapType == .satelite {
                        displayMapType = .hybrid
                    } else {
                        displayMapType = .standrd
                    }
                } label: {
                    // マップアイコンの表示
                    Image(systemName: "map")
                        .resizable()
                        .frame(width: 35.0,height: 35.0)
                }
                .padding(.trailing, 20.0)
                // 下の余白を30開ける
                .padding(.bottom,30.0)
            }
        }
    }
}

#Preview {
    ContentView()
}
