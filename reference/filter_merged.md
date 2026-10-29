# filter_merged

Filters the dataframe by conditions or virus

## Usage

``` r
filter_merged(plates_merged, condition = NULL, virus = NULL)
```

## Arguments

- plates_merged:

  the dataframe of the merged normalised plates

- condition:

  The inidividual or test condition you want to filter by, can be a
  single string, or a list. "AZ12"

- virus:

  The virus that you want to filter by. Can be a single string, or a
  list. e.g. c("Virus1","VIrus2")

## Value

A filtered dataframe of normalised values.
