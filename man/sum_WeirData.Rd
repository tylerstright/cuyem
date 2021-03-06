% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sum_WeirData.R
\name{sum_WeirData}
\alias{sum_WeirData}
\title{Summarise Fins Trapping Data}
\usage{
sum_WeirData(df)
}
\arguments{
\item{df}{the data.frame output from \code{get_FINSdata} and the
'Trapping' module}
}
\value{
a list with two objects. 1) a summary data.frame to easily pivot
  table for counts of fish trapped and their disposition, 2) a data.frame
  with the number of fish marked and released upstream and any recaptured
}
\description{
summarizes and processes \url{https://www.finsnet.org/} trapping
  module data for quick dissemination and mark/recapture analysis
}
\examples{
con <- RODBC::odbcConnect(dsn = 'Fins', uid = 'guest', pwd = 'guest')
qry <- "SELECT distinct(Facility) FROM FINS_all_trapping"
f <- RODBC::sqlQuery(con, qry) \%>\% mutate_all(as.character) \%>\% pull(Facility)
npt_f <- f[grepl('NPT', f)]
df <- get_FinsTrapping(npt_f, odbc_connection = con)
sum_df <- summarise_FinsTrapping(df)
}
