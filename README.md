# アプリケーション名
Furusato Share

# アプリケーション概要
ふるさと納税返礼品や故郷の食材をシェアすることができる

# ＵＲＬ
https://furusato-share-41311.onrender.com/splashes

# テスト用アカウント
・Bacic認証パスワード ：admin
・Bacic認証ID : 2222
・メールアドレス : test@mail.com
・パスワード : test123456

# 利用方法

# アプリケーションを作成した背景
私は田舎出身で、上京して一人暮らしを始めました。都会での生活は便利な反面、近所付き合いの希薄さを感じていました。故郷では、野菜や手作り料理のおすそ分けが日常的で、それが地域のつながりを深めていました。
一方、都会での一人暮らしでは、食材の使い切りに苦労し、特にふるさと納税で得た地元の特産品や実家からの贈り物が無駄になることが多くありました。また、集合住宅では隣人とほとんど交流がなく、閉鎖的な環境に居心地の悪さを感じていました。
これらの経験から、食品ロスの削減と住民同士の交流促進を同時に解決できないかと考えました。ふるさと納税や故郷からの贈り物を共有することで、食品を無駄にせず、同時に住民同士の自然な交流のきっかけを作れるのではないか。
そこで、同じ建物内の住民間で食品を共有できるアプリケーションを開発しました。このアプリを通じて、都市部でも適度な近所付き合いを実現し、食品ロスを減らしながら、多様な地域の味を楽しめる環境を作りたいと考えています。

# 実装した機能についての画像やGIFおよびその説明

# 実装予定の機能

# データベース設計
## テーブル設計

## users テーブル

| Column             | Type   | Options     |
| ------------------ | ------ | ----------- |
| nickname           | string | null: false |
| email              | string | null: false ,unique: true |
| encrypted_password | string | null: false |
| name         | string | null: false |
| name_kana          | string | null: false |
| birth_date    | string | null: false |
| allergies     | string | null: false |
|references         | d pate   | null: false |
|share_count         | d pate   | null: false |



### Association

- has_many :items
- has_many :orders

## items テーブル

| Column                 | Type       | Options     |
| ---------------------- | ---------- | ----------- |
| name                   | string     | null: false |
| description            | text       | null: false |
| quantity            | integer    | null: false |
| expiration_date           | integer    | null: false |
| allergen_info | integer    | null: false |
| category_id          | integer    | null: false |
| status        | integer    | null: false |
| available_from                  | integer    | null: false |
| available_until                   | references | null: false, foreign_key:true |


### Association

- belongs_to :user
- has_one :order


## Transaction テーブル

| Column       | Type       | Options                        |
| ------------ | ---------- | ------------------------------ |
| user         | references | null: false, foreign_key: true |
| item         | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :item
- has_one :shipping_address


## Point テーブル

| Column        | Type       | Options                        |
| ------------- | ---------- | ------------------------------ |
| postal_code   | string     | null: false                    |
| prefecture_id | integer    | null: false                    |
| city          | string     | null: false                    |
| address       | string     | null: false                    |
| building      | string     |                                |
| phone_number  | string     | null: false                    |
| order         | references | null: false, foreign_key: true |

## Message テーブル

| Column        | Type       | Options                        |
| ------------- | ---------- | ------------------------------ |
| postal_code   | string     | null: false                    |
| prefecture_id | integer    | null: false                    |
| city          | string     | null: false                    |
| address       | string     | null: false                    |
| building      | string     |                                |
| phone_number  | string     | null: false                    |
| order         | references | null: false, foreign_key: true |


### Association

- belongs_to :order
# 画面遷移図
![alt text](画面遷移図.png)

# 開発環境

# ローカルでの動作環境

# 工夫したポイント

# 改善点

# 制作時間