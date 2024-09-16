PKG_ROOT    = .
PKG_VERSION = $(shell gawk '/^Version:/{print $$2}' $(PKG_ROOT)/DESCRIPTION)
PKG_NAME    = $(shell gawk '/^Package:/{print $$2}' $(PKG_ROOT)/DESCRIPTION)

CRAN = "https://cran.rstudio.com"

# Dependencies
SRC       = $(wildcard $(PKG_ROOT)/src/*.cpp)
RFILES    = $(wildcard $(PKG_ROOT)/R/*.R)
EXAMPLES  = $(wildcard $(PKG_ROOT)/examples/*.R)
TESTS     = $(wildcard $(PKG_ROOT)/tests/testthat/*.R)

# Targets
VIGNETTES    = $(PKG_ROOT)/vignettes/export.Rmd
VIGNETTES   += $(PKG_ROOT)/vignettes/api.Rmd

DATATARGETS  = $(PKG_ROOT)/data/avs_raw_project_info.rda
DATATARGETS += $(PKG_ROOT)/data/avs_raw_metadata.rda
DATATARGETS += $(PKG_ROOT)/data/avs_raw_user.rda
DATATARGETS += $(PKG_ROOT)/data/avs_raw_record.rda
DATATARGETS += $(PKG_ROOT)/data/avs_raw_core.rda
DATATARGETS += $(PKG_ROOT)/R/datasets.R

.PHONY: all check install clean codecov

all: $(PKG_NAME)_$(PKG_VERSION).tar.gz

.install_dev_deps.Rout : $(PKG_ROOT)/DESCRIPTION
	Rscript --vanilla --quiet -e "options(repo = c('$(CRAN)'))" \
		-e "options(warn = 2)" \
		-e "devtools::install_dev_deps()"
	touch $@

.document.Rout: $(SRC) $(RFILES) $(DATATARGETS) $(EXAMPLES) $(VIGNETTES) $(PKG_ROOT)/DESCRIPTION
	Rscript --vanilla --quiet -e "options(warn = 2)" \
		-e "devtools::document('$(PKG_ROOT)')"
	touch $@

$(DATATARGETS) : $(PKG_ROOT)/data-raw/avs-exports.Rout
	@if test -f $@; then :; else\
		$(RM) $<; \
		$(MAKE) $<; \
	fi

$(PKG_ROOT)/data-raw/avs-exports.Rout : $(PKG_ROOT)/data-raw/avs-exports.R $(PKG_ROOT)/R/export_redcap_project.R
	R CMD BATCH --vanilla $< $@

$(PKG_ROOT)/vignettes/%.Rmd : $(PKG_ROOT)/vignette-spinners/%.R
	R --vanilla --quiet -e "knitr::spin(hair = '$<', knit = FALSE)"
	mv $(basename $<).Rmd $@

$(PKG_NAME)_$(PKG_VERSION).tar.gz: .install_dev_deps.Rout .document.Rout $(TESTS)
	R CMD build --md5 $(build-options) $(PKG_ROOT)

check: $(PKG_NAME)_$(PKG_VERSION).tar.gz
	R CMD check $(PKG_NAME)_$(PKG_VERSION).tar.gz

check-as-cran: $(PKG_NAME)_$(PKG_VERSION).tar.gz
	R CMD check --as-cran $(PKG_NAME)_$(PKG_VERSION).tar.gz

install: $(PKG_NAME)_$(PKG_VERSION).tar.gz
	R CMD INSTALL $(PKG_NAME)_$(PKG_VERSION).tar.gz

codecov :
	R --vanilla --quiet -e 'covr::report(x = covr::package_coverage(type = "all"), file = "codecover.html")'

clean:
	$(RM) -f  $(PKG_NAME)_$(PKG_VERSION).tar.gz
	$(RM) -f  codecover.html
	$(RM) -rf $(PKG_NAME).Rcheck
	$(RM) -f .document.Rout
	$(RM) -f .install_dev_deps.Rout

