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
file3=ou
fstarcsort ${file3}.fst ${file3}2.fst
fstproject --project_output ${file3}2.fst ${file3}o.fst
printstrings.O2 --label-map=$DIR/table3.txt --input=${file3}o.fst -n 10 -w
fstdraw --isymbols=$DIR/table3.txt --osymbols=$DIR/table3.txt  ${file3}o.fst  ${file3}o.dot
dot -Tjpg  ${file3}o.dot >  ${file3}o.jpg



#Problem 3 #a) ./fsmcompile -t -i L.sym -o L.sym < rot13.txt > rot13.fst #b) ./fsmcompile -i L.symmessage.fsa ./fsmcompose message.fsa rot13.fst | ./fsmbestpath | ./fsminvert | ./fsmproject | ./fsmprint -i L.sym -o L.sym> encoded.txt #Problem 4 #a) ./fsmcompile -t -i L.sym -o L.sym < problem4.txt> problem4.fst ./fsmdraw -i L.sym -o L.sym problem4.sps b) ./fsmcompile -i L.symsen1.fsa ./fsmcompile -i L.symsen2.fsa ./fsmcompose sen1.fsa problem4.fst sen2.fsa | ./fsmbestpath | ./fsmprint -i L.sym -o L.sym> encoded2.txt ./fsmcompose sen1.fsa problem4.fst sen2.fsa | ./fsmbestpath -n 2 | ./fsmprint -i L.sym -o L.sym> encoded3.txt 

cat rot13.txt 0 0 a n 0 0 b o 0 0 c p 0 0 d q 0 0 e r 0 0 f s 0 0 g t 0 0 h u 0 0 i v 0 0 j w 0 0 k x 0 0 l y 0 0 m z 0 0 n a 0 0 o b 0 0 p c 0 0 q d 0 0 r e 0 0 s f 0 0 t g 0 0 u h 0 0 v i 0 0 w j 0 0 x k 0 0 y l 0 0 z m 0 0 0 cat problem4. txt 0 0 A A 0 0 0 G G 0 0 0 T T 0 0 0 C C 0 0 0 A 1 0 0 G 1 0 0 T 1 0 0 C 1 0 0 A 1 0 0 G 1 0 0 T 1 0 0 C 1 0 0 A G 1 0 0 A T 1 0 0 A C 1 0 0 T A 1 0 0 T G 1 0 0 T C 1 0 0 G A 1 0 0 G T 1 0 0 G C 1 0 0 C G 1 0 0 C T 1 0 0 C A 1 0 cat message.t xt 0 1 m 1 2 y 2 3 3 4 s 4 5 e 5 6 c 6 7 r 7 8 e 8 9 t 9 10 10 11 m 11 12 e 12 13 s 13 14 s 14 15 a 15 16 g 16 17 e 17 cat encoded.txt 0 1 z 1 2 l 2 3 3 4 f 4 5 r 5 6 p 6 7 e 7 8 r 8 9 g 9 10 10 11 z 11 12 r 12 13 f 13 14 f 14 15 n 15 16 t 16 17 r 17 cat sen1.txt 0 1 A 1 2 T 2 3 T 3 4 C 4 5 A 5 6 C 6 cat sen2.txt 0 1 A 1 2 G 2 3 T 3 4 C 4 5 C 5 cat encoded2.txt 0 1 A A 1 2 T G 1 2 3 T T 3 4 C C 4 5 A 1 5 6 C C 6 cat encoded3.txt 0 1 0 8 1 2 A A 2 3 T G 1 3 4 T T 4 5 C C 5 6 A 1 6 7 C C 7 8 9 A A 9 10 T G 1 
