FN := find_max_val # make FN = 

all:
	as $(FN).s -o $(FN).o

	ld $(FN).o -o $(FN)

	clear

	#./$(FN) 

	# echo usd?

clean:
	rm -rf *.o
	find . -maxdepth 1 -type f -executable -delete
	clear