# Performs clockwise rotations (0,90,180,270 degrees)

This function rotates a data.frame of any size by 0 (no rotation), 90,
180, or 270 degrees clockwise.

## Usage

``` r
rotate(df, rotation_deg_needed = 0)
```

## Arguments

- df:

  dataframe to rotate

- rotation_deg_needed:

  how many degrees clockwise to rotated (default=0 (no rotation), 90,
  180, or 270)

## Value

A dataframe rotated by rotation_deg_needed degrees clockwise
