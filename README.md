# Youbiker

這個程式會去拉[Youbike](http://www.youbike.com.tw/)目前開放的即時資料，輸出兩種檔案

1. 場站資料：抓取現在各場站的車位數量
2. 地理資料：抓取現在各場站的地理相關資訊

## 使用方法

ruby >= 2.0.0

安裝 gem

    bundle install

接著跑`youbike.rb`

    ruby youbiker.rb

就會幫你把現在的場站資訊抓下來

## 參數

輸入 `ruby youbiker.rb --help` 可以查看可以輸入的參數

| 參數 | 預設值 | 說明                                         |
|------|--------|----------------------------------------------|
| -n   | true   | [boolean]是否要抓取場站資料                  |
| -s   | false  | [boolean]是否要抓取地理資料                  |
| -d   | nil    | [string]資料要存放的位置。若無輸入則存在`./` |
| -w   | false  | [boolean]是否要每十分鐘抓取一次              |

舉例來說，若希望抓取地理資料以及每十分鐘抓一次並且存在`data`資料夾：

    ruby youbiker.rb -s -w -d data

## 官方文件

[YouBike 微笑單車介接說明文件](http://www.dot.taipei.gov.tw/public/mmo/dot/YouBike%E5%BE%AE%E7%AC%91%E5%96%AE%E8%BB%8A%E4%BB%8B%E6%8E%A5%E8%AA%AA%E6%98%8E%E6%96%87%E4%BB%B6.pdf)

## License

MIT [@ctxhou](https://github.com/ctxhou)