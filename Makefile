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
VIGNETTES = $(PKG_ROOT)/vignettes/redcap2package.Rmd\
						$(PKG_ROOT)/vignettes/api.Rmd\
						$(PKG_ROOT)/vignettes/formatting.Rmd

DATATARGETS = $(PKG_ROOT)/data/avs_raw_project.rda\
							$(PKG_ROOT)/data/avs_raw_metadata.rda\
							$(PKG_ROOT)/data/avs_raw_user.rda\
							$(PKG_ROOT)/data/avs_raw_record.rda\
							$(PKG_ROOT)/data/avs_raw_core.rda\
							$(PKG_ROOT)/data/avs_raw_project_json.rda\
							$(PKG_ROOT)/data/avs_raw_metadata_json.rda\
							$(PKG_ROOT)/data/avs_raw_user_json.rda\
							$(PKG_ROOT)/data/avs_raw_record_json.rda\
							$(PKG_ROOT)/data/avs_raw_core_json.rda

.PHONY: all check install clean codecov

all: $(PKG_NAME)_$(PKG_VERSION).tar.gz

.install_dev_deps.Rout : $(PKG_ROOT)/DESCRIPTION
	Rscript --vanilla --quiet -e "options(repo = c('$(CRAN)'))" \
		-e "options(warn = 2)" \
		-e "devtools::install_dev_deps()"
	touch $@

.document.Rout: $(SRC) $(RFILES) $(DATATARGETS) $(EXAMPLES) $(VIGNETTES) $(PKG_ROOT)/DESCRIPTION $(PKG_ROOT)/README.md
	Rscript --vanilla --quiet -e "options(warn = 2)" \
		-e "devtools::document('$(PKG_ROOT)')"
	touch $@

$(PKG_ROOT)/README.md : $(PKG_ROOT)/README.Rmd
	Rscript --vanilla --quiet -e "options(warn = 2)" \
		-e "knitr::knit('$(PKG_ROOT)/README.Rmd', output = 'README.md')"

$(DATATARGETS) &: $(PKG_ROOT)/data-raw/avs-exports.R $(PKG_ROOT)/R/export_redcap_project.R $(PKG_ROOT)/R/keyring.R
	R CMD BATCH --vanilla $<

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
	$(RM)  $(PKG_NAME)_$(PKG_VERSION).tar.gz
	$(RM)  codecover.html
	$(RM) -r $(PKG_NAME).Rcheck
	$(RM) .document.Rout
	$(RM) .install_dev_deps.Rout
	$(RM) -r lib/
	$(RM) vignettes/*.html

