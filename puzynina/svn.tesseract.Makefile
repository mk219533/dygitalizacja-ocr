NAME = puzynina

IMAGE_FILES = 154.tif\
	      155.tif\
	      161.tif\
	      51.tif#\
	      25-1.tif\
	      25-2.tif#\

TESSDATA_PREFIX = /home/marcel/local/share/

TR_FILES = $(patsubst %.tif,%.tr,$(IMAGE_FILES))
BOX_FILES = $(patsubst %.tif,%.box,$(IMAGE_FILES))
HTML_FILES = $(patsubst %.tif,%.html,$(IMAGE_FILES))

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
	tesseract $< $(patsubst %.tr,%,$@) nobatch box.train.stderr 2>$(patsubst %.tr,%.log,$@)
	wc -l $(patsubst %.tr,%.txt,$@)
	rm $(patsubst %.tr,%.txt,$@)

.PHONY: clean

clean:
	rm -f $(TRAINED_DATA) $(NAME).* *.plain *.log *.txt *.tr *.html Microfeat tesseract.log freq-dawg word-dawg inttemp normproto pffmtable unicharset mfunicharset

.PHONY: test

test:  $(TESTS)

.PHONY: $(TESTS)

$(TESTS) : test_% : %.box.plain %.txt.plain
	@echo TEST $@
	@echo -n "Liczba bledow: "
	@diff -y --suppress-common-lines -W 30 $^ > $@.error | true
	@wc -l $@.error | cut -f1 -d" "
	@echo Błędy:
	@cat $@.error
	@rm -f $@.error
	@echo

%.plain : %
	./../utils/make_plain.pl < $< > $@

%.txt : %.tif $(TRAINED_DATA)
	tesseract $< $(patsubst %.txt,%,$@) -l $(NAME) batch.nochop makebox

.PHONY: hocr

hocr: $(HTML_FILES)

$(HTML_FILES) : %.html : %.tif $(TRAINED_DATA)
	tesseract $< $(patsubst %.html,%,$@) -l $(NAME) nobatch hocr



