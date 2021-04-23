URL := https://xdmod.your.site/controllers/user_interface.php
OPTS := -s -X POST -H "Content-Type: application/x-www-form-urlencoded"
START_DATE := 2001-01-01
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
# Mac date command
END_DATE_GRAPH := $(shell date -v-$$(($$(date +%-d)))d +%Y-%m-%d)
TEXPATH := /Library/TeX/texbin
endif
ifeq ($(UNAME_S),Linux)
# GNU date command
END_DATE_GRAPH := $(shell date -d "-$$(date +-%d) days -0 month" +%Y-%m-%d)
TEXPATH := /usr/local/texlive/bin
endif
END_DATE_TEXT := $(shell date +%Y-%m-%d)
POSTCOMMON := public_user=true&realm=Jobs&start_date=$(START_DATE)&dataset_type=timeseries&operation=get_data
TEXTOPTS := aggregation_unit=Year&format=csv&end_date=$(END_DATE_TEXT)
TEXTPROC := grep -A10 Year | tail +2 | grep , | cut -d, -f2 | paste -sd+ - | bc
GRAPHOPTS := show_title=n&legend_type=off&width=916&height=484&font_size=3&aggregation_unit=Month&format=png&end_date=$(END_DATE_GRAPH)

export PATH := $(PATH):$(TEXPATH)

all: very-brief-overview-hpc.pdf

data:
	/usr/bin/curl $(OPTS) -d "$(POSTCOMMON)&$(TEXTOPTS)&statistic=job_count" $(URL) | $(TEXTPROC) > jobs.csv
	/usr/bin/curl $(OPTS) -d "$(POSTCOMMON)&$(TEXTOPTS)&statistic=total_cpu_hours" $(URL) | $(TEXTPROC) > hours.csv
	/usr/bin/curl $(OPTS) -d "$(POSTCOMMON)&$(GRAPHOPTS)&statistic=total_cpu_hours" $(URL) > hpc-usage.png
	# echo $(START_DATE)
	# echo $(END_DATE_GRAPH) $(END_DATE_TEXT)

# %.pdf: data %.tex
%.pdf: %.tex
	$(TEXPATH)/latexmk -quiet -pdf -synctex=1 $(patsubst %.pdf,%.tex,$@)
