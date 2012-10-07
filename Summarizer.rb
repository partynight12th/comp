require 'MeCab'
require 'enumerator' # each_consを利用するため必要
require 'nkf'

module Summarizer
	def zennum2hannum(str)
		return NKF.nkf( '-Wwm0Z0', str);
	end

	def summarize(str)
		# mecabで形態素解析して、 参照テーブルを作る
		mecab = MeCab::Tagger.new("-Owakati")
		data = Array.new
		mecab.parse(str + "EOS").split(" ").each_cons(3) do |a| 
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

		# EOSを削除して、return
		return new_text.gsub!(/EOS$/,'')
	end
	module_function :summarize
end
