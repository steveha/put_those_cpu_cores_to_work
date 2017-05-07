.DUMMY: sync

sync: $(HOME)/Music/mp3/Camel/Rain\ Dances $(HOME)/Music/mp3/Genesis/Lamb\ Lies\ Down\ on\ Broadway\ Disc\ 1 $(HOME)/Music/mp3/Genesis/Lamb\ Lies\ Down\ on\ Broadway\ Disc\ 2 $(HOME)/Music/mp3/Soundtrack/Blade\ Runner $(HOME)/Music/mp3/Soundtrack/Star\ Wars/Star\ Wars\ --\ A\ New\ Hope\ Disc\ 1 $(HOME)/Music/mp3/Soundtrack/Star\ Wars/Star\ Wars\ --\ A\ New\ Hope\ Disc\ 2 $(HOME)/Music/mp3/Soundtrack/Tron\ Legacy
	
$(HOME)/Music/mp3/Camel/Rain\ Dances:
	mp3_sync.py -v $(HOME)/Music/flac $(HOME)/Music/mp3 Camel/Rain\ Dances
$(HOME)/Music/mp3/Genesis/Lamb\ Lies\ Down\ on\ Broadway\ Disc\ 1:
	mp3_sync.py -v $(HOME)/Music/flac $(HOME)/Music/mp3 Genesis/Lamb\ Lies\ Down\ on\ Broadway\ Disc\ 1
$(HOME)/Music/mp3/Genesis/Lamb\ Lies\ Down\ on\ Broadway\ Disc\ 2:
	mp3_sync.py -v $(HOME)/Music/flac $(HOME)/Music/mp3 Genesis/Lamb\ Lies\ Down\ on\ Broadway\ Disc\ 2
$(HOME)/Music/mp3/Soundtrack/Blade\ Runner:
	mp3_sync.py -v $(HOME)/Music/flac $(HOME)/Music/mp3 Soundtrack/Blade\ Runner
$(HOME)/Music/mp3/Soundtrack/Star\ Wars/Star\ Wars\ --\ A\ New\ Hope\ Disc\ 1:
	mp3_sync.py -v $(HOME)/Music/flac $(HOME)/Music/mp3 Soundtrack/Star\ Wars/Star\ Wars\ --\ A\ New\ Hope\ Disc\ 1
$(HOME)/Music/mp3/Soundtrack/Star\ Wars/Star\ Wars\ --\ A\ New\ Hope\ Disc\ 2:
	mp3_sync.py -v $(HOME)/Music/flac $(HOME)/Music/mp3 Soundtrack/Star\ Wars/Star\ Wars\ --\ A\ New\ Hope\ Disc\ 2
$(HOME)/Music/mp3/Soundtrack/Tron\ Legacy:
	mp3_sync.py -v $(HOME)/Music/flac $(HOME)/Music/mp3 Soundtrack/Tron\ Legacy
