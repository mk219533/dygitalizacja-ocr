NAME = puzynina

IMAGE_FILES = 7.tif\
	      8.tif\
	      9.tif\
	      10.tif

TESSDATA_PREFIX = $(HOME)/local/share/

TR_FILES = $(patsubst %.tif,%.tr,$(IMAGE_FILES))
BOX_FILES = $(patsubst %.tif,%.box,$(IMAGE_FILES))
HTML_FILES = $(patsubst %.tif,%.html,$(IMAGE_FILES))
DIFF_FILES = $(patsubst %.tif,%.diff,$(IMAGE_FILES))

TESTS = $(patsubst %.tif,test_%, $(IMAGE_FILES))

FILES = freq-dawg\
  word-dawg\
  user-words\
  inttemp\
  normproto\
  pffmtable\
  unicharset\
  DangAmbigs

TRAINED_DATA = $(TESSDATA_PREFIX)tessdata/$(NAME).traineddata
LANGUAGE_FILES = $(patsubst %,$(NAME).%,$(FILES))

.PHONY: all

all: $(TRAINED_DATA)

$(TRAINED_DATA) : $(LANGUAGE_FILES)
	combine_tessdata `pwd`/$(NAME).
	cp $(NAME).traineddata $(TRAINED_DATA)

$(LANGUAGE_FILES) : $(NAME).% : %
	cp $< $@

freq-dawg: frequent_words_list unicharset
	wordlist2dawg $< $@ unicharset

word-dawg: words_list unicharset
	wordlist2dawg $< $@ unicharset

inttemp: pffmtable
       
pffmtable: $(TR_FILES)
	mftraining $^

normproto: $(TR_FILES) 
	cntraining $^
	
unicharset: $(BOX_FILES) 	
	unicharset_extractor $^

%.tr : %.tif %.box
	tesseract $< $* nobatch box.train.stderr 2>$*.log
	wc -l $*.txt
	rm $*.txt

.PHONY: clean

clean:
	rm -f $(TRAINED_DATA) $(NAME).* *.plain *.log *.txt *.tr Microfeat tesseract.log freq-dawg word-dawg inttemp normproto pffmtable unicharset mfunicharset

.PHONY: test

test:  $(TESTS)

$(TESTS) : test_% : %.box.plain %.txt.plain
	@echo TEST $*.tif
	@echo -n "Liczba bledow: "
	@diff -y --suppress-common-lines -W 30 $^ | wc -l
	@echo

%.plain : %
	./../utils/make_plain.pl < $< > $@

%.txt : %.tif $(TRAINED_DATA)
	tesseract $< $* -l $(NAME) batch.nochop makebox

tesseract-results:
	mkdir -p $@

.PHONY: hocr

hocr: $(HTML_FILES) tesseract-results
	mv $^ 

$(HTML_FILES) : %.html : %.tif $(TRAINED_DATA)
	tesseract $< $* -l $(NAME) nobatch hocr

.PHONY: diff 

diff: $(DIFF_FILES) tesseract-results
	mv $^

$(DIFF_FILES): %.diff : %.box.plain %.txt.plain
	@diff -y -W 30 $^ > $@ | true



