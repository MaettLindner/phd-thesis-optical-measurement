run("8-bit");
setAutoThreshold("Default dark");
//run("Threshold...");
setThreshold(0, 65);
//setThreshold(0, 25);
setOption("BlackBackground", false);
run("Convert to Mask");
