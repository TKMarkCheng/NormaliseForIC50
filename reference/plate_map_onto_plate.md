# map a single plate_map to a read promega_plate

Where there are repeated experiment columns, give them a suffix to
indicate the number of technical replicates, and more importantly
prevent automatic suffix addition in R to prevent unexpected results.
This acts as a daughter function of plate_map_onto_plate but also can
act as a stand alone function.

validate the columns of neg, pos, or samples

now treat each unique virus suffix as their own set, and normalise.

## Usage

``` r
adding_technical_replicate_suffix(mapped_plate)

plateMap_map_onto_promega_read(plate_map, promega_read_values)

validate_columns(columns)

convert_dilution_factor(dilution_factor_string = "1 in 3")

generate_dilution_series(
  Starting_Dilution_or_concentration = 20,
  num_steps = 8,
  dilution_factor = "1 in 3",
  titration_mode = c("dilution", "concentration")
)

normalise_plate_using_plateMap(
  plate_map = plate1_map,
  processed_read_values_with_tech_rep
)
```

## Arguments

- mapped_plate:

  the dataframe of values which columns are assigned but may have
  repeated columns

- plate_map:

  platemap with the strict platemap format

- promega_read_values:

  promega_plate_df generated from read_promega_plate_xlsx.R , if not
  specified, the plate_map column promega_plate_path will be searched

- columns:

  Negative_Control_Column, Positive_Control_Column, or column from a
  plate map, which can be strings like "5,6" when processing experiment
  columns which summarises

- dilution_factor_string:

  dilution formatted as numerator in denominator (e.g. 1 in 3)

- Starting_Dilution_or_concentration:

  The starting dilution or concentration (unitless)

- num_steps:

  Number of dilution rows including neat

- dilution_factor:

  dilution formatted as numerator in denominator (e.g. 1 in 3)

- titration_mode:

  If dilution, the numbers get bigger, if concentration, the numbers get
  smaller

- processed_read_values_with_tech_rep:

  output of plateMap_map_onto_promega_read

## Value

a dataframe where all values have \_techrepn suffixed, prevents having
repeated column names.

normalized values with , \<dilution_or_concentration\>,
\<dilution_serie\> from plate_map

validated version which is a list of integers

numeric dilution_factor

comma-separated string of dilution_series

validated version which is a list of integers
