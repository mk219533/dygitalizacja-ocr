LANGUAGE_NAME = pol2
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


#25-1.tif \
	      25-2.tif #\
	      154.tif #\

TR_FILES = $(patsubst %.tif,%.tr,$(IMAGE_FILES))
TXT_FILES = $(patsubst %.tif,%.txt,$(IMAGE_FILES))
BOX_FILES = $(patsubst %.tif,%.box,$(IMAGE_FILES))


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

%.txt : %.tif
	tesseract $< $(patsubst %.txt,%,$@) -l $(LANGUAGE_NAME) batch.nochop makebox
	@echo roznice
	@diff -u $(patsubst %.txt,%.box,$@) $@ | wc -l

#%.box : %.txt
#	cp $< $@

.PHONY: clean

clean:
	rm -f $(LANGUAGE_DIR)/$(LANGUAGE_NAME).* *.log *.txt *.tr Microfeat tesseract.log freq-dawg word-dawg inttemp normproto pffmtable unicharset

.PHONY: test

test: $(LANGUAGE_FILES) $(TXT_FILES)

