SOURCES = $(wildcard *.R)
TARGETS = $(addsuffix .Rmd, $(basename $(SOURCES)))

all: $(TARGETS)

%.Rmd: %.R
	Rscript --vanilla -e "knitr::spin(hair = '$<', knit = FALSE)"
	if [ ! -d ../vignettes/ ]; then mkdir ../vignettes; fi
	mv $@ ../vignettes/$@

#%.html : %.Rmd
	#Rscript --vanilla -e "rmarkdown::render('$<')"
	#if [ ! -d ../vignettes/ ]; then mkdir ../vignettes; fi
	#if [ ! -f ../vignettes/$@ ]; then ln -s ../vignette-spinners/$@ ../vignettes/$@; fi
	#echo "%\VignetteIndexEntry{$(basename $<)}\n%\VignetteEngine{R.rsp::asis}\n" > ../vignettes/$@.asis
