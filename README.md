# A One-Page Presentation of an HPC

![Sample presentation page](very-brief-overview-hpc.png)

I've used this for some very quick overviews of our HPC facility during faculty or student meetings at the start of a semester.

It uses our [XDMoD](https://open.xdmod.org/) site to get current data on:
- how many jobs have been completed
- how many CPU hours were used on those jobs
- how the monthly total CPU hours change over time in graphical form

Since you'll probably get a big drop off on the CPU hours graph for the partial month you're in, the Makefile used to get the graph sets the graph end date to the last day of the previous month, ensuring you get whole months of data for a better comparison.

Tested mostly on macOS, occasionally on Linux.
Things to adjust in the Makefile:
- the path to your TeX installation
- the URL to your XDMoD instance
- toggle the comment characters on the `# %.pdf: data %.tex` and the `%.pdf: %.tex` lines when you're ready to test with your live data.

Things to adjust in the `.tex` file:
- your institute name
- your contact info
- your hardware and software specs
- your common job types, or whatever else you want to put in the lower-right box instead.

Run with `make`, and you should get an automatically-updated PDF with your current job totals.
