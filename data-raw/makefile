TARGETS =  "../data/avs_raw_project_info.rda"
TARGETS += "../data/avs_raw_metadata.rda"
TARGETS += "../data/avs_raw_user.rda"
TARGETS += "../data/avs_raw_record.rda"

all : $(TARGETS)

$(TARGETS) : avs-exports.R
	R CMD BATCH --vanilla $<
