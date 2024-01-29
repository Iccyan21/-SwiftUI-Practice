//
//  MapView.swift
//  MyMap
//
//  Created by 水原　樹 on 2024/01/24.
//

import SwiftUI
import MapKit

// 画面で選択したマップの種類を示す列挙型
enum MapType {
    case standrd // 標準
    case satelite // 衛生写真
    case hybrid // 衛生写真と交通衛生れべる
}

struct MapView: View {
    // 検索キーワード
    let searchKey: String
    // マップ種類
    let mapTyoe: MapType
    //キーワードから取得した緯度経度
    @State var targetCoordinate = CLLocationCoordinate2D()
    // 表示するマップの位置
    @State var cameraPosition: MapCameraPosition = .automatic
    
    // 表示するマップのスタイル
    var mapStyle: MapStyle {
        switch mapTyoe {
        case .standrd:
            return MapStyle.standard()
        case .satelite:
            return MapStyle.imagery()
        case .hybrid:
            return MapStyle.hybrid()
        }
    }
    
    var body: some View {
        Map(position: $cameraPosition){
            Marker(searchKey,coordinate: targetCoordinate)
        }
        // マップのスタイルを指定
        .mapStyle(mapStyle)
        // 検索キーワードの変更を検知
        .onChange(of: searchKey, initial: true){ oldValue, newValue in
            // 入力されたキーワードをデバックに表示
            print("検索キーワード:\(newValue)")
            // 地図の検索クエリの作成
            // MKLocalSearchはマップベースの検索を
            // 開始し結果を処理するためのオブジェクト
            let request = MKLocalSearch.Request()
            // 検索クエリにキーワードの設定
            request.naturalLanguageQuery = newValue
            // MKLocalSearchの初期化
            let search = MKLocalSearch(request: request)
            // 検索の開始
            search.start { responce, error in
                // 結果が存在する時は、１件目を取り出す
                if let mapItems = responce?.mapItems,
                   let mapItem = mapItems.first{
                    targetCoordinate = mapItem.placemark.coordinate
                    // 緯度経度表示
                    print("緯度経度\(targetCoordinate)")
                    
                    //表示するマップの利用域
                    cameraPosition = .region(MKCoordinateRegion(center: targetCoordinate, latitudinalMeters: 500.0,longitudinalMeters: 500.0))
                }
            }
        }
    }
}


#Preview {
    MapView(searchKey: "東京駅",mapTyoe: .standrd)
}
