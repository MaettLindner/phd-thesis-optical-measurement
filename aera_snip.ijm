//Clear log-screen
print("\\Clear");
//Name outputfile
name = "TESTTESTTEST"
//get or select input path
input_path = getDirectory("input files");
//get all files in folder and sort the list
fileList = getFileList(input_path) 
fileList = Array.sort(fileList); // sort filelist, start with -000 


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
	if (flag_first_loop == 1)
	{
	run("Restore Selection");
	//makeRectangle(xpoints[0],ypoints[0],xpoints[1],ypoints[1]);
	}


	if (flag_first_loop == 0)
	{
	// user draws 5cm electrode line which is then used for the scaling of the profile plot 
	waitForUser("Choose Rectangle Tool and select area you want to snip");  
	s = selectionType();
	getSelectionCoordinates(xpoints,ypoints);

	flag_first_loop = 1;
	}


	run("Cut");
	newImage(title, "8-bit black", 2500, 1000, 1);
	run("Paste");

//	waitForUser("Check Selection");
	//saveAs("Tiff", "C:/Users/lim38963/Desktop/play_around/output/"+ title +".tif");
	saveAs("Jpeg", "C:/Users/lim38963/Desktop/play_around/output/"+ title +".jpg");
}

	
	// #  ------------------- After Batch processing save LOG output -------------




run("Close All");