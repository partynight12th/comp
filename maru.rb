#!/usr/bin/ruby
# encoding: utf-8
$LOAD_PATH.push('.') #require対象ディレクトリにカレントを追加
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'Summarizer'


# ヘッドラインの1行目の記事を取得する
url = 'http://www.asahi.com/'
text = String.new
nokogiri = Nokogiri::HTML.parse(open(url))
li = nokogiri.xpath('//div[@id="HeadLine"]/div[@class="Guest"]/dl[@class="FstTitle"]/dt/a')
nokogiri = Nokogiri::HTML.parse(open(url + li[0].attribute('href')))
nokogiri.xpath('//div[@class="BodyTxt"]/p').each do |body|
  text = text +  body.text
end
text.gsub!(/\n/,'')

puts Summarizer::summarize(text)

