# Introduction to how to use Normalisation Package

## Setting up

load the library/package from github.

``` r

if(!require("remotes"))install.packages("remotes",repos="http://cran.us.r-project.org")
```

    ## Loading required package: remotes

``` r

remotes::install_github("TKMarkCheng/NormaliseForIC50",dependencies = TRUE, force = TRUE)
```

    ## Using github PAT from envvar GITHUB_PAT. Use `gitcreds::gitcreds_set()` and unset GITHUB_PAT in .Renviron (or elsewhere) if you want to use the more secure git credential store instead.

    ## Downloading GitHub repo TKMarkCheng/NormaliseForIC50@HEAD

``` bg-output
## RcppArmad... (NA -> 15.6.2-1 ) [CRAN]
## RcppEigen    (NA -> 0.3.4.0.2) [CRAN]
## cpp11        (NA -> 0.5.5    ) [CRAN]
## prettyunits  (NA -> 1.2.0    ) [CRAN]
## hms          (NA -> 1.1.4    ) [CRAN]
## progress     (NA -> 1.2.3    ) [CRAN]
```

    ## Installing 6 packages: RcppArmadillo, RcppEigen, cpp11, prettyunits, hms, progress

    ## Installing packages into '/home/runner/work/_temp/Library'
    ## (as 'lib' is unspecified)

``` bg-output
## ── R CMD build ─────────────────────────────────────────────────────────────────
## * checking for file ‘/tmp/RtmpvKb6r0/remotes1ade480e1545/TKMarkCheng-NormaliseForIC50-f54d19a/DESCRIPTION’ ... OK
## * preparing ‘NormaliseForIC50’:
## * checking DESCRIPTION meta-information ... OK
## * checking for LF line-endings in source and make files and shell scripts
## * checking for empty or unneeded directories
## * building ‘NormaliseForIC50_2.2.0.tar.gz’
```

    ## Installing package into '/home/runner/work/_temp/Library'
    ## (as 'lib' is unspecified)

## Loading sample, defining output file, and plate rotation (if any)

It is very important for you to change the following file paths and
settings to fit your data. (Where are they stored? Where and what do you
what the output excel file to be called? Are your plates rotated?)

``` r

input_file <- here::here("Validation/2022-09-04_reads/example1.xlsx") #CHANGE to example file in your directory for troubleshooting
input_directory = here::here("Validation/2022-09-04_reads/") #CHANGE this to directory of input .xlsx data files
output_file <- here::here("Validation/test.xlsx") # CHANGE directory and name for yourself
```

It is also important that you communicate how your plates are setup, and
they should be consistent for each folder that you use this script on.
i.e. don’t have horizontal plates and vertical plates mixed in the same
folder, and positive and negative controls should be in consistent
columns in each folder this script is used on.

``` r

rotate_by <- 0 # clockwise degrees, multiples of 90, useful when doing 12 fold dilutions.
control_neg_column <- c(1) # default negative control column is on first column from the left
control_pos_column <- c(2) # default positive control column is on second column from the left
```

## Getting the filenames from our directory

What are the names of all of our input files?

``` r

neut_raw_files <- Sys.glob(paste0(
  paste0(input_directory,"/*.xlsx")) # find all .xlsx file in input directory
)
neut_raw_files
```

``` bg-output
##  [1] "/home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example1.xlsx" 
##  [2] "/home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example10.xlsx"
##  [3] "/home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example2.xlsx" 
##  [4] "/home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example3.xlsx" 
##  [5] "/home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example4.xlsx" 
##  [6] "/home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example5.xlsx" 
##  [7] "/home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example6.xlsx" 
##  [8] "/home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example7.xlsx" 
##  [9] "/home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example8.xlsx" 
## [10] "/home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example9.xlsx"
```

## Example case: Plate 1

An inital view of plate 1

``` r

plate1 <- NormaliseForIC50::read_promega_plate_excel(input_promega_excel_file_path = input_file)
plate1
```

``` bg-output
##   neg    pos sample one sample one.1 sample two     NA sample three
## A  90 376100     182200       229100     171100 186500           80
## B  80 277500     289200       292000     275900 245400          100
## C 100 287200     288400       292000     278800 277700          380
## D 110 301300     309500       301100     304800 313300        24090
## E  50 280600     293000       286400     309400 292500        99030
## F  90 272600     266000       289600     303000 309200       175700
## G 100 251200     295100       286500     311100 283200       244100
## H  50 348100     350900       345000     386400 364800       343600
##   sample three.1      9     10     11     12
## A             90 133200 143600  55510  96660
## B            110 266000 269900 259500 298000
## C            830 291200 293900 275200 327900
## D          27390 314900 289400 314200 397400
## E         119800 300700 322300 293400 360300
## F         203000 302600 294500 293000 379000
## G         239600 287200 307500 295000 372400
## H         351700 360300 332200 350300 368300
```

The Name assigned to each column can be any string of characters, as
long as there’s no excessively weird symbols.

``` r

plate1_normalised <- NormaliseForIC50::final_func(neut_raw_files[1],control_neg_column = c(1),control_pos_column = c(2), rotation_deg_needed = rotate_by)
```

    ## processing input file: /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example1.xlsx

    ## negative control = 83.75

    ## positive control = 299325

    ## Finished processing: /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example1.xlsx

``` r

plate1_normalised
```

``` bg-output
##   sample one sample one.1 sample two      NA sample three sample three.1
## 1     39.141       23.468     42.850  37.704      100.001         99.998
## 2      3.384        2.448      7.828  18.021       99.995         99.991
## 3      3.651        2.448      6.859   7.227       99.901         99.751
## 4     -3.400       -0.593     -1.830  -4.670       91.978         90.875
## 5      2.114        4.319     -3.367   2.281       66.934         59.993
## 6     11.136        3.250     -1.228  -3.300       41.313         32.190
## 7      1.412        4.286     -3.935   5.389       18.455         19.959
## 8    -17.235      -15.264    -29.099 -21.880      -14.796        -17.503
##         9      10      11      12
## 1  55.515  52.040  81.478  67.726
## 2  11.136   9.833  13.309   0.443
## 3   2.715   1.813   8.062  -9.549
## 4  -5.205   3.317  -4.971 -32.775
## 5  -0.459  -7.678   1.980 -20.377
## 6  -1.094   1.612   2.114 -26.626
## 7   4.052  -2.732   1.445 -24.420
## 8 -20.377 -10.986 -17.035 -23.050
```

``` r

# openxlsx::write.xlsx(
#   plate1_normalised,
#   "../tests/testthat/test_data/example1_normalised_without_anomaly_detection.xlsx")
```

## Processing all the files in the directory

``` r

#create xlsx and populate df into separate sheets. CHANGE rotation_deg_needed if the plate was ROTATED when setting up.
library(openxlsx)
wb<-createWorkbook()
for (neut_raw_file in neut_raw_files){
  neut_file <- basename(neut_raw_file) #remove file path
  neut_file = tools::file_path_sans_ext(neut_file) #remove extension
  addWorksheet(wb,sheetName=neut_file)
  writeData(wb, sheet = neut_file,
            x = NormaliseForIC50::final_func(
              neut_raw_file,
              control_neg_column = control_neg_column,
              control_pos_column = control_pos_column,
              rotation_deg_needed = rotate_by))
  print(paste0("normalised data written to:",neut_file))
}
```

    ## processing input file: /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example1.xlsx

    ## negative control = 83.75

    ## positive control = 299325

    ## Finished processing: /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example1.xlsx

``` bg-output
## [1] "normalised data written to:example1"
```

    ## processing input file: /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example10.xlsx

    ## negative control = 77.5

    ## positive control = 361125

    ## Finished processing: /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example10.xlsx

``` bg-output
## [1] "normalised data written to:example10"
```

    ## processing input file: /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example2.xlsx

    ## negative control = 96.25

    ## positive control = 361825

    ## Finished processing: /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example2.xlsx

``` bg-output
## [1] "normalised data written to:example2"
```

    ## processing input file: /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example3.xlsx

    ## negative control = 96.25

    ## positive control = 354575

    ## Finished processing: /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example3.xlsx

``` bg-output
## [1] "normalised data written to:example3"
```

    ## processing input file: /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example4.xlsx

    ## negative control = 93.75

    ## positive control = 363150

    ## Finished processing: /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example4.xlsx

``` bg-output
## [1] "normalised data written to:example4"
```

    ## processing input file: /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example5.xlsx

    ## negative control = 91.25

    ## positive control = 370775

    ## Finished processing: /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example5.xlsx

``` bg-output
## [1] "normalised data written to:example5"
```

    ## processing input file: /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example6.xlsx

    ## negative control = 87.5

    ## positive control = 351112.5

    ## Finished processing: /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example6.xlsx

``` bg-output
## [1] "normalised data written to:example6"
```

    ## processing input file: /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example7.xlsx

    ## negative control = 92.5

    ## positive control = 393425

    ## Finished processing: /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example7.xlsx

``` bg-output
## [1] "normalised data written to:example7"
```

    ## processing input file: /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example8.xlsx

    ## negative control = 101.25

    ## positive control = 381600

    ## Finished processing: /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example8.xlsx

``` bg-output
## [1] "normalised data written to:example8"
```

    ## processing input file: /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example9.xlsx

    ## negative control = 91.25

    ## positive control = 385575

    ## Finished processing: /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/2022-09-04_reads//example9.xlsx

``` bg-output
## [1] "normalised data written to:example9"
```

``` r

saveWorkbook(wb,file=output_file,overwrite = TRUE)
print(paste0("saved collated sheets to excel file:",output_file))
```

``` bg-output
## [1] "saved collated sheets to excel file:/home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/test.xlsx"
```

## Example2: custom plating

``` r

df <- NormaliseForIC50::read_promega_plate_excel(input_promega_excel_file_path = "../Validation/custom_control_plating/rbm 5.xlsx")

NormaliseForIC50::final_func("../Validation/custom_control_plating/rbm 5.xlsx",control_plating = "custom",
                             control_neg_wells=c("H1","H2","H3","H4","H5","H6"),
                             control_pos_wells=c("H7","H8","H9","H10","H11","H12"),
                             rotation_deg_needed = rotate_by)
```

    ## processing input file: ../Validation/custom_control_plating/rbm 5.xlsx

    ## Warning in check_max(df.values, filename = filename): rbm 5.xlsx Warning: The
    ## largest value is found outside of the last three rows of column 8

    ## Warning in check_max(df.values, filename = filename): rbm 5.xlsx Warning: The
    ## largest value is found outside of the last three rows of column 11

    ## Warning in check_max(df.values, filename = filename): rbm 5.xlsx Warning: The
    ## largest value is found outside of the last three rows of column 12

    ## negative control = 278.333333333333

    ## positive control = 2250166.66666667

    ## Finished processing: ../Validation/custom_control_plating/rbm 5.xlsx

``` bg-output
##        1      2      3       4      5       6       7       8      9     10
## 1 96.563 96.464 95.946  97.052 99.868  99.915  33.076  27.475 99.518 99.506
## 2 94.025 93.621 86.687  84.936 87.452  90.523 -61.507 -52.440 87.141 84.296
## 3 89.914 88.176 67.900  62.726 51.121  50.721 -56.351 -64.751 57.508 58.375
## 4 68.073 63.233 38.143  23.609 21.031  18.142 -28.127 -27.105 32.142 27.342
## 5 35.565 38.187 12.230  -2.882 -8.393   0.674 -14.971 -15.504  7.741 14.364
## 6 30.231 25.031  5.474 -17.016 -4.926  -0.748  -4.659   1.563  7.030 14.497
## 7 10.897 10.897 14.319   7.786 -0.526 -10.749 -13.371   8.941  0.674  1.696
##        11      12
## 1  35.520  33.476
## 2 -50.751 -66.974
## 3 -79.908 -84.530
## 4 -48.173 -49.906
## 5 -28.883 -23.016
## 6   5.252  -9.015
## 7   0.185 -10.749
```

``` r

neut_raw_files <- Sys.glob(paste0(
  paste0("../Validation/custom_control_plating","/*.xlsx")) # find all .xlsx file in input directory
)
neut_raw_files
```

``` bg-output
## [1] "../Validation/custom_control_plating/rbm 3.xlsx"
## [2] "../Validation/custom_control_plating/rbm 5.xlsx"
```

``` r

#create xlsx and populate df into separate sheets. CHANGE rotation_deg_needed if the plate was ROTATED when setting up.
library(openxlsx)
wb<-createWorkbook()
for (neut_raw_file in neut_raw_files){
  neut_file <- basename(neut_raw_file) #remove file path
  neut_file = tools::file_path_sans_ext(neut_file) #remove extension
  addWorksheet(wb,sheetName=neut_file)
  writeData(wb, sheet = neut_file,
            x = NormaliseForIC50::final_func(
              neut_raw_file,
              control_plating = "custom",
              control_neg_wells = c("H1","H2","H3","H4","H5","H6"),
              control_pos_column =c("H7","H8","H9","H10","H11","H12"),
              rotation_deg_needed = rotate_by))
  print(paste0("normalised data written to:",neut_file))
}
```

    ## processing input file: ../Validation/custom_control_plating/rbm 3.xlsx

    ## negative control = 236.666666666667

    ## positive control = 954992.5

    ## Finished processing: ../Validation/custom_control_plating/rbm 3.xlsx

``` bg-output
## [1] "normalised data written to:rbm 3"
```

    ## processing input file: ../Validation/custom_control_plating/rbm 5.xlsx

    ## Warning in check_max(df.values, filename = filename): rbm 5.xlsx Warning: The
    ## largest value is found outside of the last three rows of column 8

    ## Warning in check_max(df.values, filename = filename): rbm 5.xlsx Warning: The
    ## largest value is found outside of the last three rows of column 11

    ## Warning in check_max(df.values, filename = filename): rbm 5.xlsx Warning: The
    ## largest value is found outside of the last three rows of column 12

    ## negative control = 278.333333333333

    ## positive control = 800088.75

    ## Finished processing: ../Validation/custom_control_plating/rbm 5.xlsx

``` bg-output
## [1] "normalised data written to:rbm 5"
```

``` r

saveWorkbook(wb,file=here::here("Validation/test_CustomPlating.xlsx"),overwrite = TRUE)
print(paste0("saved collated sheets to excel file: ",here::here("Validation/test_CustomPlating.xlsx")))
```

``` bg-output
## [1] "saved collated sheets to excel file: /home/runner/work/NormaliseForIC50/NormaliseForIC50/Validation/test_CustomPlating.xlsx"
```
