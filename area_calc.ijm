//Clear log-screen
print("\\Clear");

//get or select input path
input_path = getDirectory("input files");
//get all files in folder and sort the list
fileList = getFileList(input_path) 
fileList = Array.sort(fileList); // sort filelist, start with -000 

threshold1 = 65;
//Name outputfile
name = "Area_4Layer_th65"

flag_first_loop = 0;
total_slices = 100;


// #-------------Batch processing of all files in folder ------------
for (f = 0; f < lengthOf(fileList); f++) 
{
	// close open files 
	run("Close All");
	//open image 
	open(input_path + fileList[f]);
	//calculate length of 2D-vector 
	title = getTitle();

	setThreshold(threshold1, 254);
	//setThreshold(0, 25);
	setOption("BlackBackground", false);
	run("Convert to Mask");

	run("Analyze Particles...", "size=5-Infinity show=Outlines display clear summarize add");
	//waitForUser("Check PIC");
	// run("Analyze Particles...", "size=5-Infinity show=Outlines display clear summarize add");

	//saveAs("Tiff", "C:/Users/lim38963/Desktop/play_around/output/"+ title +".tif");
	//saveAs("Jpeg", "C:/Users/lim38963/Desktop/play_around/output/"+ title +".jpg");
}
	selectWindow("Summary");
	saveAs(".txt", "C:\\Users\\lim38963\\Desktop\\MACRO\\Auswertung\\" + name + "_summary.txt");
	
	// #  ------------------- After Batch processing save LOG output -------------




run("Close All");