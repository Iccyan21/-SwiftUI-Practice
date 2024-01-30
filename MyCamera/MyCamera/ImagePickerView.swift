//
//  ImagePickerView.swift
//  MyCamera
//
//  Created by 水原　樹 on 2024/01/28.
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    // 写真が表示されているかの管理
    @Binding var isShowSheet: Bool
    // 撮影した写真を格納する変数
    @Binding var captuerImage: UIImage?
    
    // Coordinatorでコントローラーのdelegateを管理
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
        // ImagePickerの定数を用意
        let parent: ImagePickerView
        
        // イニシャライザ
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        // 撮影時に呼ばれるdelegateメゾット,必ず必要
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
            // UIImagePickerControllerを閉じる、isShowSheetがfalseになる
            picker.dismiss(animated: true){
                if let originalImage =
                    info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    self.parent.captuerImage = originalImage
                }
            }
        }
        // キャンセルボタンが選択された時に呼ばれるメゾット
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // sheetを閉じる
            parent.isShowSheet.toggle()
        }
    }
    // Coordinatorを呼び出し
    func makeCoordinator() -> Coordinator {
        
        Coordinator(self)
    }
    // Viewを生成するときに実行
    func makeUIViewController(context: Context) -> UIImagePickerController {
        // UIImagePickerConrollerのインスタンス作成
        let myImagePickerContoller = UIImagePickerController()
        // sourceTypeをカメラに設定
        myImagePickerContoller.sourceType = .camera
        // delegateを設定
        myImagePickerContoller.delegate = context.coordinator
        // UIImageを返す
        return myImagePickerContoller
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
}
