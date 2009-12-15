LANGUAGE_NAME = puzynina
LANGUAGE_DIR = $(HOME)/local/share/tessdata

IMAGE_FILES = 7.tif\
	      8.tif\
	      9.tif\
	      10.tif

CUNEIFORM_DIR = cuneiform-results
GOCR_DIR = gocr-results

DIRS = $(GOCR_DIR)\
       $(CUNEIFORM_DIR)

TR_FILES = $(patsubst %.tif,%.tr,$(IMAGE_FILES))
BOX_FILES = $(patsubst %.tif,%.box,$(IMAGE_FILES))
DIFF_FILES = $(patsubst %.tif,%.diff,$(IMAGE_FILES))
ERROR_FILES = $(patsubst %.tif,%.error,$(IMAGE_FILES))
GOCR_FILES = $(patsubst %.tif,$(GOCR_DIR)/%.txt,$(IMAGE_FILES))
CUNEIFORM_TXT_FILES = $(patsubst %.tif,$(CUNEIFORM_DIR)/%.txt,$(IMAGE_FILES))
CUNEIFORM_HOCR_FILES = $(patsubst %.tif,$(CUNEIFORM_DIR)/%.html,$(IMAGE_FILES))

TESTS = $(patsubst %.tif,test_%, $(IMAGE_FILES))

FILES = freq-dawg\
  word-dawg\
  user-words\
  inttemp\
  normproto\
  pffmtable\
  unicharset\
  DangAmbigs 

.PHONY: all

LANGUAGE_FILES = $(patsubst %,$(LANGUAGE_DIR)/$(LANGUAGE_NAME).%,$(FILES))

all: $(LANGUAGE_DIR) $(LANGUAGE_FILES)

$(LANGUAGE_DIR):
	mkdir -p $(LANGUAGE_DIR)

$(LANGUAGE_FILES) : $(LANGUAGE_DIR)/$(LANGUAGE_NAME).% : %
	cp $< $@

freq-dawg: frequent_words_list
	wordlist2dawg $< $@

word-dawg: words_list
	wordlist2dawg $< $@

inttemp: pffmtable
       
pffmtable: $(TR_FILES)
	mftraining $^

normproto: $(TR_FILES) 
	cntraining $^

unicharset: $(BOX_FILES) 	
	unicharset_extractor $^

%.tr : %.tif %.box
	tesseract $< junk nobatch box.train.stderr 2>$*.log

.PHONY: clean

clean:
	rm -f $(LANGUAGE_DIR)/$(LANGUAGE_NAME).* *.bmp  *.plain *.log *.txt *.tr Microfeat tesseract.log freq-dawg word-dawg inttemp normproto pffmtable unicharset

.PHONY: test

test:  $(TESTS)

$(TESTS) : test_% : %.box.plain %.txt.plain
	@echo TEST $*.tif
	@echo -n "Liczba bledow: "
	@diff -y --suppress-common-lines -W 30 $^ | wc -l
	@echo

%.plain : %
	./../utils/make_plain.pl < $< > $@

%.txt : %.tif $(LANGUAGE_FILES)
	tesseract $< $* -l $(LANGUAGE_NAME) batch.nochop makebox

tesseract-results:
	mkdir -p $@

.PHONY: diff

diff: $(DIFF_FILES) tesseract-results
	mv $^

$(DIFF_FILES): %.diff : %.box.plain %.txt.plain
	@diff -y -W 30 $^ > $@ | true

.PHONY: errors

errors: $(ERROR_FILES) tesseract-results
	        mv $^

$(ERROR_FILES): %.error : %.box.plain %.txt.plain
	        @diff -y --suppress-common-lines -W 30 $^ > $@ | true

$(DIRS): % :
	mkdir -p $@

.PHONY: gocr

gocr: $(GOCR_DIR) $(GOCR_FILES)

$(GOCR_FILES): $(GOCR_DIR)/%.txt : %.tif
	tifftopnm $< | gocr -o $@

.PHONY: cuneiform

cuneiform: $(CUNEIFORM_DIR) $(CUNEIFORM_TXT_FILES) $(CUNEIFORM_HOCR_FILES)

$(CUNEIFORM_TXT_FILES): $(CUNEIFORM_DIR)/%.txt : %.bmp
	cuneiform -l pol -o $@ $<

$(CUNEIFORM_HOCR_FILES): $(CUNEIFORM_DIR)/%.html : %.bmp
	cuneiform -f hocr -l pol -o $@ $<

%.bmp: %.tif
	convert $< $@
