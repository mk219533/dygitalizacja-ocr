LANGUAGE_NAME = lang
LANGUAGE_DIR = lang

IMAGE_FILES = 25-1.tif\
	      25-2.tif\
	      154.tif

FILES = freq-dawg\
  word-dawg\
  user-words\
  inttemp\
  normproto\
  pffmtable\
  unicharset\
  DangAmbigs 

.PHONY: all

LANGUAGE_FILES = $(patsubst %, $(LANGUAGE_DIR)/$(LANGUAGE_NAME).%, $(FILES))

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
       
pffmtable: $(patsubst %.tif, %.tr, $(IMAGE_FILES))
	mftraining $^
	rm Microfeat

normproto: $(patsubst %.tif, %.tr, $(IMAGE_FILES))
	cntraining $^

unicharset: $(patsubst %.tif, %.box, $(IMAGE_FILES))
	unicharset_extractor $^

%.tr : %.tif %.box
	tesseract $< junk nobatch box.train

%.txt : %.tif
	tesseract $< $(patsubst %.txt,%,$@) -l $(LANGUAGE_NAME) batch.nochop makebox

%.box : %.txt
	cp $< $@

.PHONY: clean

clean:
	rm -rf $(LANGUAGE_DIR) $(patsubst %.tif, %.tr, $(IMAGE_FILES)) Microfeat tesseract.log junk.txt

.PHONY: test

test: $(patsubst %.tif, %.txt, $(IMAGE_FILES))

.PHONY: copy

copy: 
	cp $(LANGUAGE_FILES) ~/local/share/tessdata/


