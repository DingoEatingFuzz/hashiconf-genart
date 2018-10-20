# HashiConf 2018 Generative Art

A generative art installation for HashiConf 2018 that generates one-of-a-kind designs based
on one of the six HashiCorp products and then plots that design using an [AxiDraw plotter]().

## Generating SVGs

SVGs are generated using [Processing](https://processing.org/download/). Opening and running
`hashiconf/hashiconf.pde` will create an svg with a seed of 0. This is useful for testing the
script.

The Make target `make generate` will generate an svg from the commandline seeded with the current time.
This requires [the Processing CLI toolset to be installed](https://github.com/processing/processing/wiki/Command-Line).

## Plotting SVGs

SVGs are plotted using the [AxiDraw v3 CLI toolset](https://axidraw.com/doc/cli_api/#introduction). The
Make target `make plot` will tell the AxiDraw to plot the latest SVG generated from `make generate` (this
is done using an expected filename convention).

:warning: The AxiDraw CLI toolset (AxiCli) is not yet publically available. If you own an AxiDraw and would
like to run this project, [contact Evil Mad Scientist](https://shop.evilmadscientist.com/contact) to get
this prerelease software. If you have this software already, drop a copy in the root of this repo and everything
will work. Refer to the `.gitignore` file if you are unsure what files to put where.

