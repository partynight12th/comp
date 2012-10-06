#!/usr/bin/ruby
# encoding: utf-8
require 'MeCab'
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'enumerator' # each_consを利用するため必要

# ヘッドラインの1行目の記事を取得する
url = 'http://www.asahi.com/'
text = String.new
nokogiri = Nokogiri::HTML.parse(open(url))
li = nokogiri.xpath('//div[@id="HeadLine"]/div[@class="Guest"]/dl[@class="FstTitle"]/dt/a')
nokogiri = Nokogiri::HTML.parse(open(url + li[0].attribute('href')))
nokogiri.xpath('//div[@class="BodyTxt"]/*').each do |body|
  text = text +  body.text
end
text.gsub!(/\n/,'')

# mecabで形態素解析して、 参照テーブルを作る
mecab = MeCab::Tagger.new("-Owakati")
data = Array.new
mecab.parse(text + "EOS").split(" ").each_cons(3) do |a| 
  data.push h = {'head' => a[0], 'middle' => a[1], 'end' => a[2]}
end

# マルコフ連鎖で要約
t1 = data[0]['head']
t2 = data[0]['middle']
new_text = t1 + t2  
while true
  _a = Array.new
  data.each_with_index do |hash, i|
    _a.push i if hash['head'] == t1 && hash['middle'] == t2
  end 
 
  break if _a.size == 0
  num = _a[rand(_a.size)] # 乱数で次の文節を決定する
  new_text = new_text + data[num]['end']
  break if data[num]['end'] == "EOS"
  t1 = data[num]['middle']
  t2 = data[num]['end']
  data.delete_at(num);
end

# EOSを削除して、結果出力
puts new_text.gsub!(/EOS$/,'')
