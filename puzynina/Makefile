LANGUAGE_NAME = lang
LANGUAGE_DIR = lang

IMAGE_FILES = 25-1.tif\
	      25-2.tif\
	      154.tif

BOX_FILES = $(patsubst %.tif, %.box, $(IMAGE_FILES))
TR_FILES = $(patsubst %.tif, %.tr, $(IMAGE_FILES))

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
	mv $< $@

freq-dawg: frequent_words_list
	wordlist2dawg $<

word-dawg: words_list
	wordlist2dawg $<

inttemp: pffmtable
       
pffmtable: $(TR_FILES)
	mftraining $^

normproto: $(TR_FILES)
	cntraining $^

unicharset: $(BOX_FILES)
	unicharset_extractor $^

%.tr : %.tif %.box
	tesseract $< junk nobatch box.train

