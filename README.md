＝＝＝＝＝サンプル起動方法
☆iPhone側

git clone git://github.com/facebook/facebook-ios-sdk.git

PKGのインストール　
https://developers.facebook.com/docs/ios/

iPhoneのサンプル内
>||
pod install
||<

☆Rails側
MySQLをインストール
>||
brew install mysql
||<
 
起動する。
>||
mysql.server start
||<

データベース。
travelphoto_dev
を作成しておく。

>||
rake db:migrate 
||<

・Redisのインストール
>||
brew install redis
||<


>||
redis-server /usr/local/etc/redis.conf
||<


>||
bundle install
||<

