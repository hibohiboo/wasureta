# ソフトウェアエンジニアリングについてのメモ

* 常に「なぜ」を考える

## 開発プロセス

* 要求定義・要件定義
* 設計
* 製造
* テスト

[^1]

```plantuml
@startuml process

(*) -> 要求定義
要求定義 -> 要件定義
要件定義 -> 設計
設計 -> 製造
製造 -> テスト

@enduml
```

## アジャイル宣言 

* プロセスやツールより、個人そのものや個人間の交流を重視せよ
* 広範にわたる大量の文書作成より、きっちり動くソフトウェアの作成に注力せよ
* 契約にかかわる交渉より、顧客と協調することに重点をおけ
* 無理に計画に従うより、目の前の変化へ柔軟に対応せよ[*1][*1]

### 手法

* 顧客が実現したいことを整理する
  * １つ１つカードに書き出す
  * このカードをユーザストーリーと呼ぶ（スクラムではプロダクトバックログ）
  * ユーザストーリーに優先順位をつける
* イテレーション計画会議でストーリをタスクに分割

## 基本的なルール

### 作業の標準化と作業標準

[作業標準](./base.md)



## 注釈

[^1]: markdown-preview-enhancedでvscodeを拡張

## 参考

[*1]:https://agilemanifesto.org/iso/ja/manifesto.html