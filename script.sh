HIFST=/home/wjb31/src/hifst.mlsalt-cpu1.5Nov15/ucam-smt/
export PATH=$PATH:$HIFST/bin
export PATH=$PATH:$HIFST/externals/openfst-1.5.0/INSTALL_DIR/bin/

#compile
fstcompile --isymbols=isyms.txt --osymbols=osyms.txt comp.txt comp.fst

fstdraw --isymbols=isyms.txt --osymbols=osyms.txt result2.fst result2.dot
dot -Tjpg result.dot > result2.jpg

fstarcsort --sort_type=olabel input.fst input_sorted.fst

fstarcsort --sort_type=ilabel model.fst model_sorted.fst

fstcompose input_sorted.fst model_sorted.fst comp.fst


fstrmepsilon result.fst | fstdeterminize | fstminimize - result2.fst

 <<'COMMENT'

COMMENT

#Part 1
#Exercise 1
DIR=/home/wjb31/MLSALT/MLSALT3/practical/files

# (a) Accepts a letter in L (including space).
fstcompile --isymbols=table1.txt --osymbols=table1.txt --acceptor letter.txt letter.fst 
fstdraw --isymbols=table1.txt --osymbols=table1.txt letter.fst letter.dot
dot -Tjpg letter.dot > letter.jpg

# (b) Accepts a single space.
c
fstdraw --isymbols=table1.txt --osymbols=table1.txt  space.fst space.dot
dot -Tjpg space.dot > space.jpg

# (c) Accepts a capitalized word
fstcompile --isymbols=table1.txt --osymbols=table1.txt --acceptor capitalword.txt capitalword.fst 
fstdraw --isymbols=table1.txt --osymbols=table1.txt capitalword.fst capitalword.dot
dot -Tjpg capitalword.dot > capitalword.jpg

#(d) Accepts a word containing the letter a
fstcompile --isymbols=table1.txt --osymbols=table1.txt --acceptor noncapword.txt noncapword.fst 
fstcompile --isymbols=table1.txt --osymbols=table1.txt --acceptor a.txt a.fst 
fstconcat noncapword.fst a.fst semiword.fst 
fstconcat semiword.fst noncapword.fst word_with_a.fst
fstdraw --isymbols=table1.txt --osymbols=table1.txt word_with_a.fst word_with_a.dot
dot -Tjpg word_with_a.dot > word_with_a.jpg

#Exercise 2
# (a) Accepts zero or more capitalized words followed by spaces.
fstconcat capitalword.fst space.fst non-closed-words.fst
fstclosure non-closed-words.fst words.fst 
fstdraw --isymbols=table1.txt --osymbols=table1.txt words.fst words.dot
dot -Tjpg words.dot > words.jpg

# (b) Accepts a word beginning or ending in a capitalized letter.
fstreverse capitalword.fst > reversedcapitalword.fst 
fstconcat capitalword.fst reversedcapitalword.fst > p2b1.fst
fstunion capitalword.fst reversedcapitalword.fst > p2b2.fst
fstunion p2b1.fst p2b1.fst > p2b.fst
fstdraw --isymbols=table1.txt --osymbols=table1.txt p2b.fst p2b.dot
dot -Tjpg p2b.dot > p2b.jpg

# (c) Accepts a word that is capitalized and contains the letter a.
fstintersect capitalword.fst a.fst p2c.fst 
fstdraw --isymbols=table1.txt --osymbols=table1.txt p2c.fst p2c.dot
dot -Tjpg p2c.dot > p2c.jpg

# (d) Accepts a word that is capitalized or does not contain an a.
fstdifference letter2.fst space.fst > letters2.fst
fstclosure letters2.fst > words_no_space2.fst
#fstrmepsilon word_with_a2.fst | fstdeterminize - word_with_a2_sorted.fst
fstdifference words_no_space2.fst  word_with_a2_sorted.fst > words_no_space_no_a.fst
fstdraw --isymbols=table1.txt --osymbols=table1.txt words_no_space_no_a.fst words_no_space_no_a.dot
dot -Tjpg words_no_space_no_a.dot > words_no_space_no_a.jpg

fstarcsort words_no_space_no_a.fst words_no_space_no_a2.fst
fstunion words_no_space_no_a2.fst capitalword.fst p2d.fst
fstdraw --isymbols=table1.txt --osymbols=table1.txt p2d.fst p2d.dot
dot -Tjpg p2d.dot > p2d.jpg 




# (e) Accepts a word that is capitalized or does not contain an a without using fstunion
\item A = \{{Capitalized words U uncapitalized words without a}\}
\item B = \{All possible words\} 
\item C = \{uncapitalized words with a\} 
\item D = \{Uncapitalized words\}
fstrmepsilon word_with_a_sorted.fst | fstdeterminize - word_with_a_sorted2.fst
fstdifference words_no_space.fst capitalword.fst uncapitalword.fst
fstdifference uncapitalword.fst word_with_a.dot 
\item D = B - \{Capitalized words\}
\item C =  D - \{a\} 
\item A = B - C

#Exercise 3
#Transducer to map numbers to their English read form
for file in singleDigit twoDigits tenth onetenth zero manyzeros thousand hundred zeroeps
do
	fstcompile --isymbols=$DIR/table3.txt --osymbols=$DIR/table3.txt  $file.txt $file.fst
done

# A = 10, 11, 12
fstconcat onetenth.fst twoDigits.fst ten.fst
# B = 20, 30, 40 ... 21, 22, 23 , ... , 31, 32 ... 
fstunion zeroeps.fst singleDigit.fst semitwenty.fst
fstconcat tenth.fst semitwenty.fst twenty.fst
# C = 01, 02, 03, 04, 05
fstconcat zeroeps.fst singleDigit.fst zeroone.fst
# D = B U C
fstunion twenty.fst zeroone.fst twentyandone.fst
# E = D U A
fstunion twentyandone.fst ten.fst alltwodigits.fst
# F = 00
fstconcat zeroeps.fst zeroeps.fst twozeros.fst
# J = E U F
fstunion twozeros.fst alltwodigits.fst alltwodigitszeros.fst
# K = 100, 101, 111, 120, 121 ...
fstconcat hundred.fst alltwodigitszeros.fst allhundreds.fst
fstconcat singleDigit.fst allhundreds.fst fullhundreds.fst

# L = 0J
fstconcat zeroeps.fst alltwodigitszeros.fst alltwodigitszerozero.fst
# M = eps100, eps001, eps011, eps011, etc.
fstunion alltwodigitszerozero.fst fullhundreds.fst semiL.fst
fstconcat thousand.fst semiL.fst allthousands.fst

# O = A U C
fstunion twentyandone.fst ten.fst tenzeroone.fst
# P = ON 2001, 2011, etc.
fstconcat tenzeroone.fst allthousands.fst fullthousands.fst

fstunion zero.fst fullthousands.fst Q.fst
fstunion Q.fst fullhundreds.fst R.fst
fstunion R.fst tenzeroone.fst allnumbers.fst
fstconcat manyzeros.fst allnumbers.fst fullnumbers.fst
fstrmepsilon fullnumbers.fst fullnumbersnoeps.fst
fstminimize fullnumbersnoeps.fst fullnumbersdisambuaguated.fst

#draw
file=fullnumbersdisambuaguated
fstdraw --isymbols=$DIR/table3.txt --osymbols=$DIR/table3.txt  $file.fst  $file.dot
dot -Tjpg  $file.dot >  $file.jpg


#testinput
file=in
fstcompile --isymbols=$DIR/table3.txt --osymbols=$DIR/table3.txt --acceptor  $file.txt $file.fst
file2=fullnumbersnoeps
fstcompose  ${file}.fst ${file2}.fst  ou.fst
file3=ous
fstarcsort ${file3}.fst ${file3}2.fst
fstproject --project_output ${file3}2.fst ${file3}o.fst
printstrings.O2 --label-map=$DIR/table3.txt --input=${file3}o.fst -n 10 -w
fstdraw --isymbols=$DIR/table3.txt --osymbols=$DIR/table3.txt  ${file3}o.fst  ${file3}o.dot
dot -Tjpg  ${file3}o.dot >  ${file3}o.jpg

#Exercise 4
# (a) Create a transducer that implements the rot13 cipher
for file in rot13 rot16
do 
	fstcompile --isymbols=$DIR/table4.txt --osymbols=$DIR/table4.txt  $file.txt $file.fst
	fstdraw --isymbols=$DIR/table4.txt --osymbols=$DIR/table4.txt  ${file}.fst  ${file}.dot
	dot -Tjpg  ${file}.dot >  ${file}.jpg
done

#b) Encode and decode the message ’my secret message’
fstcompose mymessage.fst rot13.fst   output3b.fst 
fstarcsort output3b.fst outsorted.fst
fstinvert outsorted.fst ouinverted.fst
fstproject  --project_output outsorted.fst outsortedpr.fst
printstrings.O2 --label-map=$DIR/table4.txt --input=outsortedpr.fst -n s10 -w
printstrings.O2 --label-map=$DIR/table4.txt --input=output3b.fst -n 10 -w

for file in ouinvertedpr mymessage output3b ouinverted
do 
	fstdraw --isymbols=$DIR/table4.txt --osymbols=$DIR/table4.txt  ${file}.fst  ${file}.dot
	dot -Tjpg  ${file}.dot >  ${file}.jpg
done

#c Two simultaneous transductions
fstunion rot13.fst rot16.fst | fstclosure | fstrmepsilon - rot1316.fst
fstcompose $DIR/4.encoded1.fst rot1316.fst | fstproject --project_output - output3c.fst 
printstrings.O2 --label-map=$DIR/table4.txt --input=output3c.fst -n 10 -w 2> /dev/null
fstinfo output3c.fst
fstrmepsilon output3c.fst | fstdeterminize | fstminimize - output3c2.fst
fstinfo output3c2.fst

#d Composing with LM
fstcompose output3c2.fst $DIR/4.lm.fst output3d.fst
printstrings.O2 --label-map=$DIR/table4.txt --input=output3d.fst -n 10 -w 2> /dev/null 

#e decoding tranducer by allowing some pairs of consecutive letters to be swapped

#draw
file=rot1316
fstdraw --isymbols=$DIR/table4.txt --osymbols=$DIR/table4.txt  ${file}.fst  ${file}.dot
dot -Tjpg  ${file}.dot >  ${file}.jpg



