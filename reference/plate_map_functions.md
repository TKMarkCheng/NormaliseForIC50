# Read in and validates, or generate PlateMap following strict formatting as Example_PlateMap.xlsx

Validates the PlateMap by checking if there are unexpected or missing
columns, and if there are missing columns, adding them.

## Usage

``` r
expected_columns

validate_plate_map(df, plateMap_file, read_mode = "default")

read_validate_plate_map(plateMap_file, sheet = "Sheet1")

find_promega_plate_paths(directory_of_files)

get_read_date(promega_excel_file)

generate_plate_map(
  directory_of_files = "Validation/",
  output_plateMap_file = "Validation/generated_platemap.xlsx",
  output_mode = "return"
)
```

## Format

An object of class `character` of length 11.

## Arguments

- df:

  The read in platemap dataframe

- plateMap_file:

  the filepath used to generate df. The validate function is required in
  both reading in and writing out to make sure the expected_columns are
  included.

- read_mode:

  "default" which silently adds missing column or "debug" which is
  invoked which provides warning of missing/unexpected columns.

- sheet:

  the sheet which the wanted PlateMap resides on in the plateMap_file

- directory_of_files:

  the directory_of_files that is iterated through to look for Promega
  output files to generated output_plateMap_file.

- promega_excel_file:

  A promega .xlsx file which has intact metadata (first sheet).

- output_plateMap_file:

  filepath where the generated PlateMap will be located.

- output_mode:

  "return" will return into a dataframe variable, "write" will write to
  excel file defined by output_plateMap_file

## Value

A dataframe, or an excel file with Wells prepared and two additional
columns. 1) The file path of the plates, and 2) the file creation date
which corresponds to read date.

## general

## read-created-plate-map

## generate-plate-map
