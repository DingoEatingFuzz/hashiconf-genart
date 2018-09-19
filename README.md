# HashiConf 2018 Generative Art

Please don't mind the mess.

## Goal

Make plotter-safe SVGs that resemble HashiCorp branding but are all one-of-a-kind.

## Current State

- [x] Single color logos
- [x] Constrained lines that can be drawn in arbitrary polygons
- [x] Constrained circles that can be drawn in arbitrary polygons
- [x] Functions to generate each product grid in a polygon
- [x] Some experimental entropy for product grids to add variations to spacing, angles, and radii
- [x] A composition that is heavy on branding
- [x] A composition that is heavy on generative Art
- [x] SVG exporting
- [ ] Confirm that everything is plotter safe
- [ ] Accept a seed via commandline args

## How to run

First, get [Processing](https://processing.org/download/), then run any of the pde files named after the directory they are in.

  - circle_math: Some experiments to nail down constrained shapes
  - logo_spread: An experiement with the product logos
  - product_grids: Used to get the product grids just right
  - speaker_processing: The project you actually want
