# Reading in Promega plate data, from the excel sheet format.

This function loads the Promega system generated excel sheet in a 8x12
matrix whilst keeping the column and row names.

## Usage

``` r
read_promega_plate_excel(input_promega_excel_file_path, sheetname = "Results")
```

## Arguments

- input_promega_excel_file_path:

  Path to the input file

- sheetname:

  The sheetname where the result is recorded on the Promega file. Should
  be "Results" if not manually changed.

## Value

A 8x12 data.frame with rownames and column headers
