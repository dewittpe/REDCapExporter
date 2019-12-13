TARGETS =  "../data/avs_raw_project_info.rda"
TARGETS += "../data/avs_raw_metadata.rda"
TARGETS += "../data/avs_raw_user.rda"
TARGETS += "../data/avs_raw_record.rda"
TARGETS += "../R/datasets.R"

all : $(TARGETS)

$(TARGETS) : avs-exports.Rout
	@if test -f $@; then :; else\
		$(RM) $<; \
		$(MAKE) $<; \
	fi

avs-exports.Rout : avs-exports.R
	R CMD BATCH --vanilla $<
