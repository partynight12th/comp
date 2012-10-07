#!/usr/bin/ruby
# encoding: utf-8
$LOAD_PATH.push('.') #require対象ディレクトリにカレントを追加
require "twitter" # you need 'gem install twitter'
require "pp"
require 'Summarizer'

pp ARGV[0]

#related http://rdoc.info/gems/twitter

## you need settings twitter api key.
## copy "twitterconfigure.rb.sample" as "twitterconfigure.rb" and specify API KEY.
## get API KEY from Twitter Developers https://dev.twitter.com
require 'twitterconfigure'

text = ""
Twitter.search(ARGV[0]+" -rt", :lang => "ja", :count => 100, :result_type => "recent").results.map do |status|
	addedtext = status.text.gsub(%r(http://[\w/!>#&.]+), "").gsub(/(\s|#[^\s]+)+$/,"")
	text += addedtext
end

#text.gsub!(Regexp.new(ARGV[0]), "")
#text.gsub!(%r(http://[a-zA-Z0-9/!?#&.]+), "")

puts Summarizer::summarize(text)
