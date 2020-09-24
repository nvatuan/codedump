#!usr/bin/evn ruby
############### ------------------------ ###############
############### CREATED ON 2017 FEB 16th ###############
############## JAPANESE ROMANJI GENERATOR ##############
############### ------------------------ ###############

=begin
## UPDATE
 ||"v0.9 Prototyped first on Pascal"
 ||"v1.0 RomanjiGen written by Ruby"
 ||"v1.2 Add mode, testing Mode::Export"
 ||"v1.3 2017/04/13
 		| Removed Mode::Export,
 		| used external textfiles to store data, 
 		| added Hiragana chars
 		Changes are primal, lack in consistency and delicacy, will update in few more next patchs"
######
=end

def introduce
	puts "##     Japanese Romanji Generator v1.3       ##"
	puts "##      Port to Ruby-script from Pascal      ##"
	puts "===============================================\n\n"
end

def practice_intro
	puts "Leave blank if continue, to terminate type in anything\n"
end

def loop_intro
	puts "This is the main console window, input 'list' for a list of command"
	1
end
# ======================= MAIN ================================================
def init
	$command = [:list, :practice, :exit, :write]
	$b_romanji = ["a","i","u","e","o","ka","ki","ku","ke","ko","ga","gi","gu","ge","go","sa","shi","su","se","so","za","ji","zu","ze","zo","ta","chi","tsu","te","to","da","ji(chi')","zu(tsu')","de","do","na","ni","nu","ne","no","ha","hi","fu","he","ho","ba","bi","bu","be","bo","pa","pi","pu","pe","po","ma","mi","mu","me","mo","ya","yu","yo","ra","ri","ru","re","ro","wa","(w)o","N"]
	$b_hiragana = ["あ","い","う","え","お","か","き","く","け","こ","が","ぎ","ぐ","げ","ご","さ","し","す","せ","そ","ざ","じ","ず","ぜ","ぞ","た","ち","つ","て","と","だ","ぢ","づ","で","ど","な","に","ぬ","ね","の","は","ひ","ふ","へ","ほ","ば","び","ぶ","べ","ぼ","ぱ","ぴ","ぷ","ぺ","ぽ","ま","み","む","め","も","や","ゆ","よ","ら","り","る","れ","ろ","わ","を","ん"]
	$b_katakana = ["ア","イ","ウ","エ","オ","カ","キ","ク","ケ","コ","ガ","ギ","グ","ゲ","ゴ","サ","シ","ス","セ","ソ","ザ","ジ","ズ","ゼ","ゾ","タ","チ","ツ","テ","ト","ダ","ヂ","ヅ","デ","ド","ナ","ニ","ヌ","ネ","ノ","ハ","ヒ","フ","ヘ","ホ","バ","ビ","ブ","ベ","ボ","パ","ピ","プ","ペ","ポ","マ","ミ","ム","メ","モ","ヤ","ユ","ヨ","ラ","リ","ル","レ","ロ","ワ","ヲ","ン"]
	$times = 0

	$size = $b_romanji.size

	loop {
		puts "Auto show answer after a delay of seconds? Input 0 for 'no', float is acceptable."
		print "delay< "; $delay = gets.chomp

		begin
			$delay = Float($delay) 
			break
		rescue ArgumentError
			puts "Input is not a number, please reinput"
		end
	}
end

introduce
init
loop {
	print "< "; inp = gets.chomp
	case inp
		when ""
			$times += 1
			r = rand(0...$size)
			print "  #{$b_romanji[r].chomp} "
			unless $delay == 0
				sleep $delay
			else
				gets
			end
		else
			puts "Script ended after #{$times} time(s)."
			exit
		end
	puts ">> [#{$b_hiragana[r]}],[#{$b_katakana[r]}]" 
}