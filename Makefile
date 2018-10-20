# Used to generate an svg to draw
generate:
	processing-java --sketch="$$PWD/hashiconf" --run $$(date +%s);

# Used to draw a generated svg with the plotter
plot:
	python axicli.py hashiconf/latest.svg;

# Used to manually adjust the plotter arm in the event that something goes wrong
release-motors:
	python axicli.py hashiconf/latest.svg --mode manual --manual_cmd disable_xy;

# Used to raise the pen in the event that paper or pens need adjustments
# Always raise the pen before tweaking paper or pens to avoid accidental marks
raise:
	python utils.py raise-pen;

# Used to lower the pen. Useful adusting the pen grip to ensure the pen will make
# contact with the paper, but isn't so low that the pen will drag when the plotter
# is in the raised state
lower:
	python utils.py lower-pen;
