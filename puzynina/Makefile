LANGUAGE_NAME = puzynina
LANGUAGE_DIR = /home/marcel/local/share/tessdata

IMAGE_FILES = 154.tif\
	      155.tif\
	      161.tif\
	      51.tif#\
	      25-1.tif\
	      25-2.tif#\

TR_FILES = $(patsubst %.tif,%.tr,$(IMAGE_FILES))
BOX_FILES = $(patsubst %.tif,%.box,$(IMAGE_FILES))

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
	tesseract $< junk nobatch box.train.stderr 2>$(patsubst %.tr,%.log,$@)

#.PHONY: clean

clean:
	rm -f $(LANGUAGE_DIR)/$(LANGUAGE_NAME).* *.error *.plain *.log *.txt *.tr Microfeat tesseract.log freq-dawg word-dawg inttemp normproto pffmtable unicharset

#.PHONY: test

test:  $(TESTS)

$(TESTS) : test_% : %.error 
	@echo TEST $@
	@echo -n "Liczba bledow: "
	@wc -l $< | cut -f1 -d" "
	@echo

%.error : %.box.plain %.txt.plain
	@diff -y -W 30 $^ > $@ | true
#	@diff -y --suppress-common-lines -W 30 $^ > $@ | true

%.plain : %
	./../utils/make_plain.pl < $< > $@

%.txt : %.tif $(LANGUAGE_FILES)
	tesseract $< $(patsubst %.txt,%,$@) -l $(LANGUAGE_NAME) batch.nochop makebox


