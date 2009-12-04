LANGUAGE_NAME = pol
LANGUAGE_DIR = /home/marcel/local/share/tessdata

IMAGE_FILES = sample_pl-part0-courier.tif\
	      sample_pl-part0-helvetica.tif\
	      sample_pl-part0-times.tif\
	      sample_pl-part1-courier-digital_cam.tif\
	      sample_pl-part1-helvetica-digital_cam.tif\
	      sample_pl-part1-times-digital_cam.tif\
	      sample_pl-part2-courier-scanner_HP_DeskJet_F4180_300dpi.tif\
	      sample_pl-part2-helvetica-scanner_HP_DeskJet_F4180_300dpi.tif\
	      sample_pl-part2-times-scanner_HP_DeskJet_F4180_300dpi.tif\
	      sample_pl-part3-courier-scanner_Brother_DCP-135C_300dpi.tif\
	      sample_pl-part3-helvetica-scanner_Brother_DCP-135C_300dpi.tif\
	      sample_pl-part3-times-scanner_Brother_DCP-135C_300dpi.tif


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

.PHONY: clean

clean:
	rm -f $(LANGUAGE_DIR)/$(LANGUAGE_NAME).* *.plain *.log *.txt *.tr Microfeat tesseract.log freq-dawg word-dawg inttemp normproto pffmtable unicharset

.PHONY: test

test:  $(TESTS)

.PHONY: $(TESTS)

$(TESTS) : test_% : %.box.plain %.txt.plain
	@echo TEST $@
	@echo -n "Liczba bledow: "
	@diff -y --suppress-common-lines -W 30 $^ > $@.error | true
	@wc -l $@.error | cut -f1 -d" "
#	@echo Błędy:
#	@cat $@.error
	@rm -f $@.error
	@echo

%.plain : %
	./../utils/make_plain.pl < $< > $@

%.txt : %.tif $(LANGUAGE_FILES)
	tesseract $< $(patsubst %.txt,%,$@) -l $(LANGUAGE_NAME) batch.nochop makebox


