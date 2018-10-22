job "hashiconf-plotter" {
	type = "batch"

	datacenters = ["dc1"]

	parameterized {
		payload = "forbidden"
	}

	group "hashiconf-plotter" {
		task "hashiconf-plotter" {
			driver = "raw_exec"

			config {
				command = "bash"
				args = ["/Users/michael/work/hashiconf-genart/bin/hashi-plot"]
			}

			constraint {
				distinct_property = "${meta.axidraw}"
				value = "true"
			}
		}
	}
}