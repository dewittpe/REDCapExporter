#' ODM
#'
#' Opertaional Data Model Export, parse, and save
#'
#' REDCap projects can/should be exported using the ODM.
#'
#' @references \url{https://www.cdisc.org/standards/data-exchange/odm}
#'
#' @param uri The URI for the REDCap API.  This is passed to
#' \code{\link[RCurl]{postForm}}.
#' @param token The API token for a REDCap project.
#'
#' @export
export_odm <- function(uri, token) {

  raw_xml <- export_content(uri = uri,
                            token = token,
                            content = "project_xml",
                            returnMetadataOnly = FALSE,
                            records = NULL,
                            fields = NULL,
                            returnFormat = "xml",
                            exportSurveyFields = TRUE,
                            exportDataAccessGroups = TRUE,
                            filterLogic = NULL,
                            exportFiles = TRUE)

  # odm <- XML::xmlRoot(XML::xmlParse("temp.xml"))
  odm <- XML::xmlRoot(XML::xmlParse(raw_xml))

  # names(odm)
  #          Study   ClinicalData
  #        "Study" "ClinicalData"

  XML::xmlAttrs(odm)
  # study <- XML::xmlToList(odm[["Study"]])
  # clinicaldata <- XML::xmlToList(odm[["ClinicalData"]])
  # names(study)
  # names(clinicaldata)


  odm[["Study"]][["GlobalVariables"]]

  # odm[["Study"]][["MetaDataVersion"]] %>% names %>% table
# .
#     CodeList      FormDef      ItemDef ItemGroupDef
#            9            5           69           26


  xmlChildren(odm[["Study"]][["MetaDataVersion"]])


  codelists_nodes    <- odm[["Study"]][["MetaDataVersion"]][grepl("^CodeList$",     names(XML::xmlChildren(odm[["Study"]][["MetaDataVersion"]])))]
  formdef_nodes      <- odm[["Study"]][["MetaDataVersion"]][grepl("^FormDef$",      names(XML::xmlChildren(odm[["Study"]][["MetaDataVersion"]])))]
  itemdef_nodes      <- odm[["Study"]][["MetaDataVersion"]][grepl("^ItemDef$",      names(XML::xmlChildren(odm[["Study"]][["MetaDataVersion"]])))]
  itemgroupdef_nodes <- odm[["Study"]][["MetaDataVersion"]][grepl("^ItemGroupDef$", names(XML::xmlChildren(odm[["Study"]][["MetaDataVersion"]])))]

  XML::xmlAttrs(codelists_nodes[[1]])
  XML::xmlChildren(codelists_nodes[[1]])
  XML::xmlChildren(codelists_nodes[[1]])
  XML::xmlSize(codelists_nodes[[1]])

  codelist_df <- data.frame()


  lapply(codelists_nodes,
         function(x) {
           out <- as.data.frame(as.list(XML::xmlAttrs(x)), stringsAsFactors = FALSE)
           CodeListItems <- XML::xmlChildren(x)
           # out <- cbind(out,
           lapply(CodeListItems,
                  function(x) {
                    one <- as.data.frame(as.list(XML::xmlAttrs(x)), stringsAsFactors = FALSE)
                    # one <- cbind(one, "TranslatedText" =
                                 xmlAttrs(x[["Decode"]][["TranslatedText"]])
                    # )
                    # one$TranslatedText <- x[["Decode"]][["TranslatedText"]][["text"]]
                    # one
                  }
           )
           # )
         })







  #   names(study)
  #   study$GlobalVariables
  #
  #   study$MetaDataVersion %>% names
  #   study$MetaDataVersion[2]
  #   study$MetaDataVersion[17]
  #   study$MetaDataVersion[101]
  #
  #   head(metadata)
  #   metadata[metadata$form_name == "regular_season_scoring", ]

}







library(xml2)
odm2 <- read_xml(x = "temp.xml", n = Inf)

xml_attrs(odm2)


odm2 %>%
  xml_child(ns = "Study") %>%
  xml_child(ns = "MetaDataVersion") %>%
  xml_child(ns = "FormDef") %>%
  I






