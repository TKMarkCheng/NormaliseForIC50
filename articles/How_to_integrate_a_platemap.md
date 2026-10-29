# Generate + integrate a platemap and group results.

## load the library/package from github.

``` r

if(!require("remotes"))install.packages("remotes",repos="http://cran.us.r-project.org")
```

    ## Loading required package: remotes

``` r

if(!require("NormaliseForIC50"))remotes::install_github("TKMarkCheng/NormaliseForIC50",dependencies = TRUE, force = TRUE)
```

    ## Loading required package: NormaliseForIC50

``` r

library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r

options(scipen = 999) # do not use scientific notation
```

## Reading in or generating the platemap

### STEP1: Loading sample, defining output file.

``` r

search_folder = "Validation/" #CHANGE this to the folder containing all your input .xlsx data files
input_directory = paste0(here::here(search_folder),"/")
output_generated_plateMap_file <- here::here("Validation/validation_output/example_generated_platemap.xlsx") # CHANGE directory and name for yourself
```

### STEP2: Generate platemap based on the files in the specified directory.

This function fixes missing columns, and also finds the
promega_plate_path by searching the Plate_Name you have given. You need
to make sure your plate names are unique.

``` r

example_generated_plate_map <- NormaliseForIC50::generate_plate_map(input_directory,output_mode = "return")
```

    ## A total of 17 promega data plates are found out of 30 excel files in the directory /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation//.

    ## Warning: There were 2 warnings in `dplyr::mutate()`.
    ## The first warning was:
    ## ℹ In argument: `file_creation_date = get_read_date(promega_plate_path)`.
    ## ℹ In row 11.
    ## Caused by warning in `as.Date()`:
    ## ! NAs introduced by coercion
    ## ℹ Run `dplyr::last_dplyr_warnings()` to see the 1 remaining warning.

``` r

head(example_generated_plate_map)
```

``` bg-output
##   Group Negative_Control_Column Positive_Control_Column Individual_condition
## 1    NA                       1                       2                   NA
## 2    NA                       1                       2                   NA
## 3    NA                       1                       2                   NA
## 4    NA                       1                       2                   NA
## 5    NA                       1                       2                   NA
## 6    NA                       1                       2                   NA
##   Virus Plate Plate_Name Well dilution_or_concentration
## 1    NA    NA   example1   A3                  dilution
## 2    NA    NA example1kc   A3                  dilution
## 3    NA    NA   example1   A4                  dilution
## 4    NA    NA example1kc   A4                  dilution
## 5    NA    NA   example1   A5                  dilution
## 6    NA    NA example1kc   A5                  dilution
##   Starting_Dilution_or_concentration dilution_series
## 1                                 20          1 in 3
## 2                                 20          1 in 3
## 3                                 20          1 in 3
## 4                                 20          1 in 3
## 5                                 20          1 in 3
## 6                                 20          1 in 3
##                                                                                   promega_plate_path
## 1    /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation///2022-09-04_reads/example1.xlsx
## 2 /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation///anomaly_detection/example1kc.xlsx
## 3    /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation///2022-09-04_reads/example1.xlsx
## 4 /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation///anomaly_detection/example1kc.xlsx
## 5    /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation///2022-09-04_reads/example1.xlsx
## 6 /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation///anomaly_detection/example1kc.xlsx
##   file_creation_date column
## 1         2022-09-04      3
## 2               <NA>      3
## 3         2022-09-04      4
## 4               <NA>      4
## 5         2022-09-04      5
## 6               <NA>      5
```

you can choose to write to an excel file and manually add values. Or you
can feed in a pre-made excel file.

### STEP3: Manual correction of list

``` r

#NormaliseForIC50::generate_plate_map(input_directory,output_mode = "write",output_plateMap_file = output_generated_plateMap_file)
## manual correction/filling, making a new file as below
platemap <- readxl::read_excel(path="../Validation/validation_output/example_generated_platemap_manual_changes.xlsx")
platemap
```

``` bg-output
## # A tibble: 124 × 14
##    Group Negative_Control_Column Positive_Control_Column Individual_condition
##    <chr>                   <dbl>                   <dbl> <chr>               
##  1 sera                        1                       2 patient1            
##  2 sera                        1                       2 patient1            
##  3 sera                        1                       2 patient2            
##  4 sera                        1                       2 patient2            
##  5 sera                        1                       2 patient3            
##  6 sera                        1                       2 patient3            
##  7 sera                        1                       2 patient4            
##  8 sera                        1                       2 patient4            
##  9 sera                        1                       2 patient5            
## 10 sera                        1                       2 patient5            
## # ℹ 114 more rows
## # ℹ 10 more variables: Virus <chr>, Plate <lgl>, Plate_Name <chr>, Well <chr>,
## #   dilution_or_concentration <chr>, Starting_Dilution_or_concentration <dbl>,
## #   dilution_series <chr>, promega_plate_path <chr>, file_creation_date <dttm>,
## #   column <chr>
```

## using the platemap - query, normalise, and merge

get a collated sheet of normalised values of all the plates and columns
described in the plate map.

``` r

df_list <- list()
for (each_plate_name in unique(platemap$Plate_Name)){
  print(each_plate_name)
  individual_platemap <- platemap %>% dplyr::filter(Plate_Name == each_plate_name)
  plate_normalised <- NormaliseForIC50::normalise_plate_using_plateMap(individual_platemap)
  #plate_normalised <- cbind(plate_name=each_plate_name,plate_normalised)
  df_list[[each_plate_name]] <- plate_normalised
}
```

``` bg-output
## [1] "example1"
```

    ## negative control = 83.75

    ## positive control = 299325

    ## negative control = 83.75

    ## positive control = 299325

    ## negative control = 83.75

    ## positive control = 299325

    ## negative control = 83.75

    ## positive control = 299325

    ## negative control = 83.75

    ## positive control = 299325

``` bg-output
## [1] "example2"
```

    ## negative control = 96.25

    ## positive control = 361825

    ## negative control = 96.25

    ## positive control = 361825

    ## negative control = 96.25

    ## positive control = 361825

    ## negative control = 96.25

    ## positive control = 361825

    ## negative control = 96.25

    ## positive control = 361825

``` bg-output
## [1] "example3"
```

    ## negative control = 96.25

    ## positive control = 354575

    ## negative control = 96.25

    ## positive control = 354575

    ## negative control = 96.25

    ## positive control = 354575

    ## negative control = 96.25

    ## positive control = 354575

    ## negative control = 96.25

    ## positive control = 354575

``` bg-output
## [1] "example4"
```

    ## negative control = 93.75

    ## positive control = 363150

    ## negative control = 93.75

    ## positive control = 363150

    ## negative control = 93.75

    ## positive control = 363150

    ## negative control = 93.75

    ## positive control = 363150

    ## negative control = 93.75

    ## positive control = 363150

``` bg-output
## [1] "example5"
```

    ## negative control = 91.25

    ## positive control = 370775

    ## negative control = 91.25

    ## positive control = 370775

    ## negative control = 91.25

    ## positive control = 370775

    ## negative control = 91.25

    ## positive control = 370775

    ## negative control = 91.25

    ## positive control = 370775

``` bg-output
## [1] "example6"
```

    ## negative control = 87.5

    ## positive control = 351112.5

    ## negative control = 87.5

    ## positive control = 351112.5

    ## negative control = 87.5

    ## positive control = 351112.5

    ## negative control = 87.5

    ## positive control = 351112.5

    ## negative control = 87.5

    ## positive control = 351112.5

``` bg-output
## [1] "example7"
```

    ## negative control = 92.5

    ## positive control = 393425

    ## negative control = 92.5

    ## positive control = 393425

    ## negative control = 92.5

    ## positive control = 393425

    ## negative control = 92.5

    ## positive control = 393425

    ## negative control = 92.5

    ## positive control = 393425

``` bg-output
## [1] "example8"
```

    ## negative control = 101.25

    ## positive control = 381600

    ## negative control = 101.25

    ## positive control = 381600

    ## negative control = 101.25

    ## positive control = 381600

    ## negative control = 101.25

    ## positive control = 381600

    ## negative control = 101.25

    ## positive control = 381600

``` bg-output
## [1] "example9"
```

    ## negative control = 91.25

    ## positive control = 385575

    ## negative control = 91.25

    ## positive control = 385575

    ## negative control = 91.25

    ## positive control = 385575

    ## negative control = 91.25

    ## positive control = 385575

    ## negative control = 91.25

    ## positive control = 385575

``` bg-output
## [1] "example10"
```

    ## negative control = 77.5

    ## positive control = 361125

    ## negative control = 77.5

    ## positive control = 361125

    ## negative control = 77.5

    ## positive control = 361125

    ## negative control = 77.5

    ## positive control = 361125

    ## negative control = 77.5

    ## positive control = 361125

``` bg-output
## [1] "Inhib1_Inhib2_Vir1Vir2"
```

    ## negative control = 30

    ## positive control = 269387.5

    ## negative control = 30

    ## positive control = 269387.5

    ## negative control = 42.5

    ## positive control = 473787.5

    ## negative control = 42.5

    ## positive control = 473787.5

``` bg-output
## [1] "Inhib1_Inhib2_Vir3Vir4"
```

    ## negative control = 62.5

    ## positive control = 371925

    ## negative control = 62.5

    ## positive control = 371925

    ## negative control = 41.25

    ## positive control = 290600

    ## negative control = 41.25

    ## positive control = 290600

``` bg-output
## [1] "Inhib1_Inhib2_Vir5Vir6"
```

    ## negative control = 16.25

    ## positive control = 266337.5

    ## negative control = 16.25

    ## positive control = 266337.5

    ## negative control = 28.75

    ## positive control = 200875

    ## negative control = 28.75

    ## positive control = 200875

``` r

merge_cols = c("Group","dilution_or_concentration","dilution_serie")
plates_merged <- Reduce(function (x,y) merge(x,y,by=merge_cols, all = TRUE),df_list) %>% dplyr::arrange(across(all_of(merge_cols)))

print(glue::glue("{dim(plates_merged)[2] -3} different unique experiment conditions.")) 
```

``` bg-output
## 124 different unique experiment conditions.
```

## filtering and grouping by virus or condition of interest

### filtering

``` r

# if you want to pick by specific conditions or viruses
filter_by_condition = NULL
filter_by_virus = c("Virus1","VIrus2")

plates_merged_filter <- NormaliseForIC50::filter_merged(plates_merged,condition=filter_by_condition,virus = filter_by_virus)

openxlsx::write.xlsx(plates_merged_filter,
           here::here(paste0(
             "Validation/validation_output/PlatesMerged",
             "_",(if (!is.null(filter_by_condition)) paste(filter_by_condition,collapse='-') else 'AllCondition'),
             "_",(if (!is.null(filter_by_virus)) paste(filter_by_virus,collapse='-') else 'AllVirus'),
             ".xlsx"))
           )
```

### Grouping

#### Grouping by virus

Alternatively, you can group by the virus or individual condition and
generate sheets per virus or individual condition.

``` r

#groupby viruses
output_file_groupby_virus <- here::here("Validation/validation_output/PlatesMerged_Grouped_by_virus.xlsx")

library(openxlsx)
wb<-createWorkbook()
virues <- unique(platemap$Virus)
for (virus in virues){
  plates_merged_filter <- NormaliseForIC50::filter_merged(plates_merged,virus = virus)
  sheetName=virus
  addWorksheet(wb,sheetName=sheetName)
  writeData(wb, sheet = sheetName,
            x=plates_merged_filter)
  print(glue::glue("data for virus:{virus} calculated, grouped and written."))
}
```

``` bg-output
## data for virus:Virus1 calculated, grouped and written.
## data for virus:Virus2 calculated, grouped and written.
## data for virus:Virus3 calculated, grouped and written.
## data for virus:Virus4 calculated, grouped and written.
## data for virus:Virus5 calculated, grouped and written.
## data for virus:Virus6 calculated, grouped and written.
```

``` r

saveWorkbook(wb,file=output_file_groupby_virus,overwrite = TRUE)
```

#### Grouping by condition

``` r

#groupby condition
output_file_groupby_condition <- here::here("Validation/validation_output/PlatesMerged_Grouped_by_condition.xlsx")

library(openxlsx)
wb<-createWorkbook()
conditions <- unique(platemap$Individual_condition)
for (condition in conditions){
  plates_merged_filter <- NormaliseForIC50::filter_merged(plates_merged,condition = condition)
  sheetName=condition
  addWorksheet(wb,sheetName=sheetName)
  writeData(wb, sheet = sheetName,
            x=plates_merged_filter)
  
  print(glue::glue("data for condition:{condition} calculated, grouped and written."))
}
```

``` bg-output
## data for condition:patient1 calculated, grouped and written.
## data for condition:patient2 calculated, grouped and written.
## data for condition:patient3 calculated, grouped and written.
## data for condition:patient4 calculated, grouped and written.
## data for condition:patient5 calculated, grouped and written.
## data for condition:patient6 calculated, grouped and written.
## data for condition:patient7 calculated, grouped and written.
## data for condition:patient8 calculated, grouped and written.
## data for condition:patient9 calculated, grouped and written.
## data for condition:patient10 calculated, grouped and written.
## data for condition:patient11 calculated, grouped and written.
## data for condition:patient12 calculated, grouped and written.
## data for condition:patient13 calculated, grouped and written.
## data for condition:patient14 calculated, grouped and written.
## data for condition:patient15 calculated, grouped and written.
## data for condition:patient16 calculated, grouped and written.
## data for condition:patient17 calculated, grouped and written.
## data for condition:patient18 calculated, grouped and written.
## data for condition:patient19 calculated, grouped and written.
## data for condition:patient20 calculated, grouped and written.
## data for condition:patient21 calculated, grouped and written.
## data for condition:patient22 calculated, grouped and written.
## data for condition:patient23 calculated, grouped and written.
## data for condition:patient24 calculated, grouped and written.
## data for condition:patient25 calculated, grouped and written.
## data for condition:E64d calculated, grouped and written.
## data for condition:Camostat calculated, grouped and written.
```

``` r

saveWorkbook(wb,file=output_file_groupby_condition,overwrite = TRUE)
```
