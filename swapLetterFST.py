def swapLetterFST(fstName):
for lopop in range(1):
    with open( 'swapletters.txt', 'w') as f:
        f.write("""0 9999 <space> <space>
0 9999 . .
0 9999 , ,
""")
        for i, m in enumerate([chr(n) for n in range(ord('a'), ord('c')+1)]):
            f.write("0 {0} {1} {1}\n".format(9999, m))
            # 0 1 a eps - 0 2 b eps etc.
            f.write("0 {0} {1} <eps>\n".format(i+1, m))
            for k, z in enumerate([chr(l) for l in range(ord('a'), ord('c')+1)]):
                #  1 11 a a - 1 12 b b 
                f.write("{0} {1}{2} {3} {4}\n".format(i+1, i+1, k, z, z))
		#  11 9999 eps a - 12 9999 eps a 
		f.write("{0}{1} 9999 <eps> {2}\n".format(i+1, k, m))
        f.write("9999\n")

