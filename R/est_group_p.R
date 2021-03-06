#' @title Estimate Group Proportions
#' @description Count and estimate proportions with precision for defined grouping variables.
#' @param .data dataset
#' @param .summary_var variable to count and estimate proportions
#' @param alpha type I error rate.  Default is set at 0.05 to produce 95\%
#'   confidence intervals.
#' @param ... grouping variables
#' @author Ryan N. Kinzer
#' @import dplyr
#' @return
#' @export
#' @examples
#' car_df <- cdmsR::getDatasetView(datastoreID = 79)
#' car_dat <- clean_ReddData(car_df)
#' est_group_p(car_dat, Sex, alpha = 0.05, SurveyYear, StreamName, Species, Run)
est_group_p <- function(.data, .summary_var, alpha = 0.05, ...){

  # quote field names
  #summary_var <- enquo(.summary_var) # doesn't work for complete(nesting)
  summary_var <- ensym(.summary_var)

  # count groups first
  cnt <- cnt_groups(.data, .summary_var = !!summary_var, ...)

  all_vars <- distinct(cnt, !!summary_var)

  # cnt <- cnt %>%
  #   complete(..., nesting(!!summary_var), fill = list(n = 0))

  p_df <- cnt %>%
    nest(cnt = c(!!summary_var, n)) %>%
    mutate(cnt = map(cnt, function(df) complete(df, all_vars, fill = list(n=0)))) %>%
    mutate(p_df = map(cnt, function(df) est_proportions(x = df$n, alpha = alpha))) %>%
    unnest(cols = c(cnt, p_df))

  return(p_df)
}
