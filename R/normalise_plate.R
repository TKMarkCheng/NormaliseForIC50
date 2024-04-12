#' Reads in dataframe of Promega data, and normalise.
#'
#' This function assumes that the left most row is cell/negative control, and second column from the left as virus/positive control.
#'
#'
#' @param df dataframe to normalise, where left most column is negative control, and second left column is positive control.
#' @param control_neg_column The column(s) which negative/cell control are located (column number from left, integer)
#' @param control_pos_column The column(s) which positive/cell control are located (column number from left, integer)
#' @return A normalised dataframe where negative and positive control columns are removed.
#' @export

normalise <- function(df, control_neg_column=c(1),control_pos_column=c(2)){
  check_max(8,df[c(3:12)]) #warning if last row values are not the largest in the column 
  check_min(1,df[c(3:12)]) #warning if first row values are not the smallest in the column 
  lim <- data.frame(
    lower_lim = apply(df[c(3:12)], 2, min),
    upper_im = apply(df[c(3:12)], 2, max)
  )
  control.neg <- k_clustering(unlist(df[,control_neg_column]), unlist(lim[,1]), na.rm=TRUE) 
  control.pos <- k_clustering(unlist(df[,control_pos_column]), unlist(lim[,2]), na.rm=TRUE)
  print(paste0("negative control = ",control.neg))
  print(paste0("positive control = ",control.pos))
  #exclude positive and negative control columns
  df.values<-df[,-c(control_neg_column,control_pos_column)]

  normalise_cell <- function(value){ #nested function - the normalization of individual cells
    return(
      round(
        (1-scale(value,center=control.neg,scale=control.pos-control.neg)/1 #actual normalization
        ) # express as inverse value (neutralization activity)
        *100 #express as percentage
        ,3 #round to 3 decimal points (Prism standard)
      ))
  }
  normalised_df<- data.frame(
    sapply(df.values,FUN = normalise_cell)
  )#apply nested function to all cells in subset dataframe
  rownames(normalised_df) <- rownames(df) #recall rownames
  return(normalised_df)
}