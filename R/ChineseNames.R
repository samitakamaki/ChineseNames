#' ChineseNames: Chinese Name Database 1930-2008
#'
#' A full database of Han Chinese names provided by
#' \emph{Beijing Meiming Science and Technology Company} and
#' originally obtained from the National Citizen Identity Information Center
#' (NCIIC) of China.
#' @references
#' Please cite the following three references if you use this database.
#'
#' Bao, H.-W.-S. (2020). ChineseNames: Chinese Name Database 1930-2008 [R package]. \link{https://github.com/psychbruce/ChineseNames}
#'
#' Bao, H.-W.-S., Cai, H., DeWall, C. N., Gu, R., Chen, J., & Luo, Y. L. L. (2020). Name uniqueness predicts career choice and career achievement. Preprint at \emph{PsyArXiv} \link{https://doi.org/10.31234/osf.io/53j86}
#'
#' Bao, H.-W.-S., Wang, J., & Cai, H. (2020). Blame crime on name? People with bad names are more likely to commit crime. Preprint at \emph{PsyArXiv} \link{https://doi.org/10.31234/osf.io/txhqg}
#' @docType package
#' @name ChineseNames-package
NULL


.onAttach=function(libname, pkgname) {
  if(require(bruceR)==FALSE) {
    cat("Citation:\nBao, H.-W.-S. (2020). ChineseNames: Chinese Name Database 1930-2008 [R package]. https://github.com/psychbruce/ChineseNames")
    cat("\nBao, H.-W.-S., Cai, H., DeWall, C. N., Gu, R., Chen, J., & Luo, Y. L. L. (2020). Name uniqueness predicts career choice and career achievement. Preprint at PsyArXiv https://doi.org/10.31234/osf.io/53j86")
    cat("\nBao, H.-W.-S., Wang, J., & Cai, H. (2020). Blame crime on name? People with bad names are more likely to commit crime. Preprint at PsyArXiv https://doi.org/10.31234/osf.io/txhqg")
    message("NOTE:
    To use the function `compute_name_index()` in `ChineseNames`,
    you should also install the package `bruceR` from GitHub.
    For an installation guide of `bruceR`, please see:
      https://github.com/psychbruce/bruceR")
    # devtools::install_github("psychbruce/bruceR")
  } else {
    Print("
    <<bold
    <<magenta {rep_char('=', 56)}>>

    <<blue Loaded package:>>
    <<green \u2714 ChineseNames (version {as.character(packageVersion('ChineseNames'))})>>

    <<blue Citation:>>
    >>
    - Bao, H.-W.-S. (2020). ChineseNames: Chinese Name Database 1930-2008 [R package]. <<underline https://github.com/psychbruce/ChineseNames>>

    - Bao, H.-W.-S., Cai, H., DeWall, C. N., Gu, R., Chen, J., & Luo, Y. L. L. (2020). Name uniqueness predicts career choice and career achievement. Preprint at <<italic PsyArXiv>> <<underline https://doi.org/10.31234/osf.io/53j86>>

    - Bao, H.-W.-S., Wang, J., & Cai, H. (2020). Blame crime on name? People with bad names are more likely to commit crime. Preprint at <<italic PsyArXiv>> <<underline https://doi.org/10.31234/osf.io/txhqg>>
    ")
  }
}


#### Databases ####

#' Chinese surname database
#'
#' A list of 1,806 Chinese surnames with their proportions in the Chinese population.
#' @name familyname
#' @usage familyname
NULL


#' Chinese given-name database (character level)
#'
#' A list of 2,614 characters used in Chinese given names with their proportions in the Chinese population.
#' @name givenname
#' @usage givenname
NULL


#' Population for name databases
#' @name population
#' @usage population
NULL


#' Top 1,000 given names (character combinations) for 31 Chinese mainland provinces
#' @name top1000name.prov
#' @usage top1000name.prov
NULL


#' Top 100 given names (character combinations) for 6 birth cohorts
#' @name top100name.year
#' @usage top100name.year
NULL


#' Top 50 given-name characters for 6 birth cohorts
#' @name top50char.year
#' @usage top50char.year
NULL


#### Functions ####

#' Easily compute variables of given names and surnames for scientific research
#'
#' To use this function, you should also install the package \code{bruceR} from GitHub.
#' For an installation guide of \code{bruceR}, see \link{https://github.com/psychbruce/bruceR}
#' @import data.table
#' @import stringr
#' @param data \code{data.frame} or \code{data.table}.
#' @param var.fullname Variable of Chinese full names (e.g., \code{"name"}).
#' @param var.surname [Only if \code{var.fullname==NULL}] Variable of surnames (e.g., \code{"surname"}).
#' @param var.givenname [Only if \code{var.fullname==NULL}] Variable of given names (e.g., \code{"givenname"}).
#' @param var.birthyear [Optional] Variable of birth year (e.g., \code{"birth"}).
#' @param index [Optional] Which indexes to compute?
#'
#' By default, it will compute all available variables.
#' \itemize{
#'   \item NLen: full-name length (2~4).
#'   \item SNU: surname uniqueness (1~6).
#'   \item SNI: surname initial (alphabetical order; 1~26).
#'   \item NU: given-name uniqueness (1~6).
#'   \item CCU: character uniqueness in contemporary Chinese corpus (1~6).
#'   \item NG: given-name gender (-1~1).
#'   \item NV: given-name valence (1~5).
#'   \item NW: given-name warmth (1~5).
#'   \item NC: given-name competence (1~5).
#' }
#'
#' For details about these variables, see \link{https://github.com/psychbruce/ChineseNames}
#' @param NU_approx Whether to \emph{approximately} compute given-name uniqueness
#' using the nearest \emph{two} birth cohorts with relative weights
#' (which could be more precise than just using the corresponding birth cohort).
#' @param digits Number of decimal places. Default is 4.
#' @param return.namechar Whether to return separate name characters. Default is \code{TRUE}.
#' @param return.all Whether to return all temporary variables when computing the final variables. Default is \code{FALSE}.
#' @return A new \code{data.frame} or \code{data.table} with name variables appended.
#' @examples
#' ## Compute for one name
#' myname=demodata[1, "name"]
#' mybirth=1995
#' compute_name_index(name=myname, birth=mybirth, index="NU")
#'
#' ## Compute for a dataset with a list of names
#' demodata  # a data frame
#' compute_name_index(demodata, var.fullname="name")  # not adjust for birth cohort
#' compute_name_index(demodata, var.fullname="name", var.birthyear="birth")  # adjust for birth cohort
#' compute_name_index(demodata,
#'                    var.fullname="name",
#'                    var.birthyear="birth",
#'                    return.all=T)  # return temporary variables
#' @export
compute_name_index=function(data=NULL,
                            var.fullname=NULL,
                            var.surname=NULL,
                            var.givenname=NULL,
                            var.birthyear=NULL,
                            name=NA, birth=NA,
                            index=c("NLen",
                                    "SNU", "SNI",
                                    "NU", "CCU", "NG",
                                    "NV", "NW", "NC"),
                            NU.approx=FALSE,
                            digits=4,
                            return.namechar=TRUE,
                            return.all=FALSE) {
  if(is.na(name)==FALSE) {
    data=data.frame(name=name, birth=birth)
    var.fullname="name"
    var.birthyear="birth"
  }
  if(is.null(data)) stop("Please input your data.")
  if(is.null(var.fullname) & is.null(var.surname) & is.null(var.givenname))
    stop("Please input variable(s) of full/family/given names.")

  data=as.data.frame(data)
  if(!is.null(var.fullname)) {
    d=data.table(name=data[[var.fullname]])
    d[,name:=as.character(name)]
    d[,NLen:=nchar(name)]
    d[,fx:=(str_sub(name, 1, 2) %in% fuxing) & NLen>2]
    d[,name0:=str_sub(name, 1, ifelse(fx, 2, 1))]
    d[,name1:=str_sub(name, ifelse(fx, 3, 2), ifelse(fx, 3, 2)) %>% ifelse(.=="", NA, .)]
    d[,name2:=str_sub(name, ifelse(fx, 4, 3), ifelse(fx, 4, 3)) %>% ifelse(.=="", NA, .)]
    d[,name3:=str_sub(name, ifelse(fx, 5, 4), ifelse(fx, 5, 4)) %>% ifelse(.=="", NA, .)]
  } else {
    if(!is.null(var.surname) & !is.null(var.givenname)) {
      d=data.table(sur.name=data[[var.surname]], given.name=data[[var.givenname]])
      names(d)=c("sur.name", "given.name")
    } else {
      if(!is.null(var.surname)) {
        d=data.table(sur.name=data[[var.surname]])
        d$given.name=""
      }
      if(!is.null(var.givenname)) {
        d=data.table(given.name=data[[var.givenname]])
        d$sur.name=""
      }
    }
    d[,name:=paste0(sur.name, given.name)]
    d[,NLen:=nchar(name)]
    d[,fx:=sur.name %in% fuxing]
    d[,name0:=sur.name]
    d[,name1:=str_sub(given.name, 1, 1) %>% ifelse(.=="", NA, .)]
    d[,name2:=str_sub(given.name, 2, 2) %>% ifelse(.=="", NA, .)]
    d[,name3:=str_sub(given.name, 3, 3) %>% ifelse(.=="", NA, .)]
    d$sur.name=NULL
    d$given.name=NULL
  }
  if(!is.null(var.birthyear)) {
    d=cbind(d, year=data[[var.birthyear]])
  } else {
    d=cbind(d, year=NA)
  }

  # now: d[,.(name, NLen, fx, name0, name1, name2, name3)]
  d=d[,.(name0, name1, name2, name3, year, NLen)]

  log=(nrow(d)>=100000)

  if("SNU" %in% index) {
    d[,SNU:=LOOKUP(d, "name0", familyname, "surname", "surname.uniqueness", return="new.value") %>% round(digits)]
    if(log) Print("SNU computed.")
  }

  if("SNI" %in% index) {
    d[,SNI:=LOOKUP(d, "name0", familyname, "surname", "initial.rank", return="new.value")]
    if(log) Print("SNI computed.")
  }

  if("NU" %in% index) {
    d[,`:=`(nu1=mapply(compute_NU_char, name1, year, NU.approx),
            nu2=mapply(compute_NU_char, name2, year, NU.approx),
            nu3=mapply(compute_NU_char, name3, year, NU.approx)
            )]
    d[,NU:=MEAN(d, "nu", 1:3) %>% round(digits)]
    if(log) Print("NU computed.")
  }

  if("CCU" %in% index) {
    d[,`:=`(ccu1=LOOKUP(d, "name1", givenname, "character", "corpus.uniqueness", return="new.value"),
            ccu2=LOOKUP(d, "name2", givenname, "character", "corpus.uniqueness", return="new.value"),
            ccu3=LOOKUP(d, "name3", givenname, "character", "corpus.uniqueness", return="new.value")
            )]
    d[,CCU:=MEAN(d, "ccu", 1:3) %>% round(digits)]
    if(log) Print("CCU computed.")
  }

  if("NG" %in% index) {
    d[,`:=`(ng1=LOOKUP(d, "name1", givenname, "character", "name.gender", return="new.value"),
            ng2=LOOKUP(d, "name2", givenname, "character", "name.gender", return="new.value"),
            ng3=LOOKUP(d, "name3", givenname, "character", "name.gender", return="new.value")
            )]
    d[,NG:=MEAN(d, "ng", 1:3) %>% round(digits)]
    if(log) Print("NG computed.")
  }

  if("NV" %in% index) {
    d[,`:=`(nv1=LOOKUP(d, "name1", givenname, "character", "name.valence", return="new.value"),
            nv2=LOOKUP(d, "name2", givenname, "character", "name.valence", return="new.value"),
            nv3=LOOKUP(d, "name3", givenname, "character", "name.valence", return="new.value")
            )]
    d[,NV:=MEAN(d, "nv", 1:3) %>% round(digits)]
    if(log) Print("NV computed.")
  }

  if("NW" %in% index) {
    d[,`:=`(nw1=LOOKUP(d, "name1", givenname, "character", "name.warmth", return="new.value"),
            nw2=LOOKUP(d, "name2", givenname, "character", "name.warmth", return="new.value"),
            nw3=LOOKUP(d, "name3", givenname, "character", "name.warmth", return="new.value")
            )]
    d[,NW:=MEAN(d, "nw", 1:3) %>% round(digits)]
    if(log) Print("NW computed.")
  }

  if("NC" %in% index) {
    d[,`:=`(nc1=LOOKUP(d, "name1", givenname, "character", "name.competence", return="new.value"),
            nc2=LOOKUP(d, "name2", givenname, "character", "name.competence", return="new.value"),
            nc3=LOOKUP(d, "name3", givenname, "character", "name.competence", return="new.value")
            )]
    d[,NC:=MEAN(d, "nc", 1:3) %>% round(digits)]
    if(log) Print("NC computed.")
  }

  if(return.namechar)
    data=cbind(data, d[,.(name0, name1, name2, name3)])
  data.new=cbind(data, as.data.frame(d)[index]) %>% as.data.table()
  if(return.all)
    return(d)
  else
    return(data.new)
}


compute_NU_char=function(char, year=NA, approx=FALSE) {
  raw=!approx
  if(is.na(char))
    ppm="NA"
  else if(is.na(year) | year<1930)
    ppm=ref0[char]  # overall
  else if(year<1960)
    ppm=ifelse(
      raw | year<1955,
      ref1[char],  # 1930-1959
      (ref1[char]*(1965-year) + ref2[char]*(year-1955))/10
    )
  else if(year<1970)
    ppm=ifelse(
      raw,
      ref2[char],  # 1960-1969
      ifelse(year<1965,
             (ref1[char]*(1965-year) + ref2[char]*(year-1955))/10,
             (ref2[char]*(1975-year) + ref3[char]*(year-1965))/10)
    )
  else if(year<1980)
    ppm=ifelse(
      raw,
      ref3[char],  # 1970-1979
      ifelse(year<1975,
             (ref2[char]*(1975-year) + ref3[char]*(year-1965))/10,
             (ref3[char]*(1985-year) + ref4[char]*(year-1975))/10)
    )
  else if(year<1990)
    ppm=ifelse(
      raw,
      ref4[char],  # 1980-1989
      ifelse(year<1985,
             (ref3[char]*(1985-year) + ref4[char]*(year-1975))/10,
             (ref4[char]*(1995-year) + ref5[char]*(year-1985))/10)
    )
  else if(year<2000)
    ppm=ifelse(
      raw,
      ref5[char],  # 1990-1999
      ifelse(year<1995,
             (ref4[char]*(1995-year) + ref5[char]*(year-1985))/10,
             (ref5[char]*(2005-year) + ref6[char]*(year-1995))/10)
    )
  else if(year<2010)
    ppm=ifelse(
      raw,
      ref6[char],  # 2000-2009 (2008)
      ifelse(year<2005,
             (ref5[char]*(2005-year) + ref6[char]*(year-1995))/10,
             (ref6[char]*(2015-year) + ref7[char]*(year-2005))/10)
    )
  else if(year<2020)
    ppm=ifelse(
      raw,
      ref7[char],  # 2010-2019 (forecast by time-series models)
      ifelse(year<2015,
             (ref6[char]*(2015-year) + ref7[char]*(year-2005))/10,
             (ref7[char]*(2025-year) + ref8[char]*(year-2015))/10)
    )
  else if(year<2030)
    ppm=ref8[char]  # 2020-2029 (forecast by time-series models)
  else
    ppm="NA"
  if(is.na(ppm)) ppm=0
  if(ppm=="NA") ppm=NA
  return(as.numeric( -log10((ppm+1)/10^6) ))
}


