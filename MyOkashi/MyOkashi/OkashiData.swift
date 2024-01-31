//
//  OkashiData.swift
//  MyOkashi
//
//  Created by 水原　樹 on 2024/01/30.
//

import SwiftUI

// Identifibleプロコトルを利用して、お菓子の情報まとめる
struct OkashiItem: Identifiable {
    let id = UUID()
    let name: String
    let link: URL
    let image: URL
}

// お菓子データ検索クラス
@Observable class OkashiData {
    // JSONのデータ構造
    struct ResultJson: Codable {
        // JSONのitem内のデーター構造
        struct Item: Codable {
            // お菓子の名前
            let name: String?
            // 掲載URl
            let url: URL?
            // 画像URL
            let image: URL?
        }
        // 複数要素
        let item: [Item]?
    }
    // お菓子のリスト
    var okashiList: [OkashiItem] = []
    // クリックされたWebページのURL情報
    var okashiLink: URL?
    // Web API　検索用メゾット　第一引数 KeyBord 検索したいワード
    func searchOkashi(keyword: String){
        print("受け取った値:\(keyword)")
        // Task は非同期で処理を続ける
        Task {
            // ここから先は非同期で処理させる
            // 非同期でお菓子を検索する
            await search(keyword:keyword)
        }
    }
    @MainActor
    // 非同期でお菓子データを取得
    private func search(keyword: String) async {
        // お菓子の検索ワードをUPLにエンコードする
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {
            return
        }
        // リクエストURLの組み立て
        guard let req_url = URL(string: "https://sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r")
        else {
            return
        }
         // デバックエリアに出力
        print(req_url)
        
        do {
            // リクエストURLからダウンロード
            let (data, _) = try await URLSession.shared.data(from: req_url)
            // JSONDecoderのインスタンスを取得
            let decoder = JSONDecoder()
            // 受け取ったJSONデータをバースして格納
            let json = try decoder.decode(ResultJson.self, from: data)
            
            // お菓子の情報が取得できているかを追加
            guard let items = json.item else {return}
            
            // お菓子の情報を初期化
            okashiList.removeAll()
            
            //取得しているお菓子の数だけ初期化
            for item in items {
                // お菓子　掲載URL 画像のURLアンラップ
                if let name = item.name,
                   let link = item.url,
                   let image = item.image {
                    // 一つのお菓子をまとめて構造体で管理
                    let okashi = OkashiItem(name: name, link: link, image: image)
                    // お菓子の配列へ追加
                    okashiList.append(okashi)
                }
            }
        } catch {
            print("エラーが発生しました")
        }
    }
}
