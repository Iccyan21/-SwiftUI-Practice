//
//  ContentView.swift
//  MyTimer
//
//  Created by 水原　樹 on 2024/01/25.
//

import SwiftUI

struct ContentView: View {
    // タイマー変数
    @State var timeHander: Timer?
    // カウントの変数を作成
    @State var count = 0
    // 永続化する秒数設定
    @AppStorage("timer_value") var timerValue = 10
    // アラート表示有無
    @State var showAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack{
                // 背景画像
                Image(.backgroundTimer)
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                
                // 垂直型にレイアウト
                VStack(spacing: 30.0){
                    Text("残り\(timerValue-count)秒")
                        .font(.largeTitle)
                    
                    HStack {
                        Button{
                            startTimer()
                        } label: {
                            Text("スタート")
                                .font(.title)
                                .foregroundStyle(Color.white)
                                .frame(width: 140,height: 140)
                                .background(Color.start)
                                // 円形にする
                                .clipShape(Circle())
                        }
                        Button{
                            if let timeHander {
                                if timeHander.isValid == true {
                                    timeHander.invalidate()
                                }
                            }
                            
                        } label: {
                            Text("ストップ")
                                .font(.title)
                                .foregroundStyle(Color.white)
                                .frame(width: 140,height: 140)
                                .background(Color.stop)
                            // 円形にする
                                .clipShape(Circle())
                        }
                    }
                }
            }
            // 画面が表示される時に表示する
            .onAppear(){
                count = 0
            }
            .toolbar {
                // ナビゲーションバーの右にボタンを追加
                ToolbarItem(placement: .topBarTrailing){
                    NavigationLink{
                        SettingView()
                    } label: {
                        // テキスト表示
                        Text("秒数設定")
                    }
                }
            }
            // 状態変数showAlertがtrueの場合実行される
            .alert("終了",isPresented: $showAlert){
                Button("OK"){
                    print("OKタップされました")
                }
            } message: {
                Text("タイマー終了時間だよん")
            }
        }
    }
    func countDownTimer() {
        count += 1
        
        // 残り時間が0以下の時タイマーを止める
        if timerValue - count <= 0 {
            timeHander?.invalidate()
            // アラートを表示する
            showAlert = true
        }
    }
    // タイマータイムライン開始にする関数
    func startTimer() {
        if let timeHander {
            // もしタイマーが実行中ならスタートしない
            if timeHander.isValid == true {
                // 何もしない
                return
            }
        }
        // 残り時間が０以下の時、coutを増加させる
        if timerValue - count == 0 {
            count = 0
        }
        // タイマーをスタート
        timeHander = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ _ in
            countDownTimer()
        }
    }
}

#Preview {
    ContentView()
}
