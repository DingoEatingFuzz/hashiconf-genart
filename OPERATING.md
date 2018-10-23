# How to Operate the HashiConf Generative Art Installation

## 1. Standard Operating Procedure

Under normal circumstances, operating the plotter has three steps.

1. Clip a piece of a paper to the plotter board so the long side is parallel to the plotter. The corner closest to the pen when the plotter is at rest is the top-right corner of whatever gets plotted.

2. Run `make generate && make plot`. This will first generate an svg and then instruct the plotter to plot the svg. The preview screen will automatically detect changes to the latest svg and refresh on its own. This will normally be the previous command in the terminal, so `Up, Enter` will work too.

3. Once the plot is finished (which will be when the pen returns to the origin point, which is right after drawing the HashiConf logo), carefully remove the plot and repeat. Since the gel pens are pretty inky, it's possible to smudge the plot if you aren't careful.

## 2. What to do when the plotter malfunctions

In the event that the plotter goes awry, there are tools to help.

1. `Ctrl^C` will kill the `make plot` instruction and stop the plotter if necessary. This will leave the plotter pen in the middle of the draw area, which means it needs to be reset.
2. `make release-motors` will allow you to manually move the pen back to the origin point.
3. Once the pen is back at the origin point, `make plot` can be ran again. Drawing the same SVG twice, assuming the paper, board, or pen didn't move, should result in an identical plot. Just bare in mind that lines will get thicker when the pen draws them multiple times.

## 3. How to change pens

Pens should only need to be adjusted once they run out of ink. However, these pens don't have a lot of ink. There are a couple tools to help here as well.

1. Make sure to remove any paper before messing with the pen, since it's easy to accidentally leave a mark in the top-right corner of the plot while doing this.
2. Unscrew the pen and replace it with a new one.
3. Screw the new pen in **loosely**. This is very important. If the pen is screwed in too tightly, then the plotter won't work. The pen is raised by a motor, but it is lowered by gravity. If the pen is too tight, then it won't lower. This is easy to test by manually lifting the pen and making sure it drops on its own.
4. It's important to get the pen height right. If it isn't right then the lowered state could be too high, resulting in the plotter not actually drawing. Or the lowered state could be too low, resulting in erroneous marks when the plotter thinks the pen is raised, but it actually still dragging the pen across the paper.
5. Use `make raise` and `make lower` to raise and lower the pen, respectively. The lowered state should be just below the paper, causing the plotter to press the pen into the paper when operating.

## 4. What to do when the preview screen stops refreshing

This means one of two thing: the SSE connection on the web page closed or the server crashed. Try these two fixes in order.

1. Refresh the web page. If the web page is now showing `hashiconf/latest.svg` then it was just the SSE connection that closed. The output of `make generate` will also say what product is being drawn, which may be easier to test with than opening `hashiconf/latest.svg`.
2. Restart the node server. The node server is running in the second iTerm2 tab. Kill it with `Ctrl^C` if it's still running. Start it again with `node server.js`. This should be the previous command in the terminal, so `Up, Enter` will work too.

## 5. Dealing with people

Some hard and fast rules for dealing with attendees.

1. NO requests. The plots are random and that is final.
2. To decide who gets a plot, it's first come first serve.
3. Don't let people take more than one. There will not be enough plots for everyone.
4. If a line forms, encourage people to go see talks. The plotter will run all conference.

Beyond these rules, use your best judgment.

## 6. Patting yourself on the back for being such a generous and helpful person

1. Open your hand so your fingers are so your fingers are together, but you can see your palm.
2. Raise your hand over the opposite shoulder.
3. Lower your hand behind your back as far as it will go without causing discomfort. This will typically actually be to your shoulder and not your back.
4. Repeated softly strike your back until the feeling of satisfaction diminishes.
