//Clear log-screen
print("\\Clear");
//Name outputfile
material = "NAME_OF_OUTPUT"
//get or select input path
input_path = getDirectory("input files");
//get all files in folder and sort the list
fileList = getFileList(input_path) 
fileList = Array.sort(fileList); // sort filelist, start with -000 
// set threshold value - default = 35 
threshold = getNumber("Choose Threshold value", 35);

flag_first_loop = 0;

// #-------------Batch processing of all files in folder ------------
for (f = 0; f < lengthOf(fileList); f++) 
{
// close open files 
run("Close All");
//open image 
open(input_path + fileList[f]);
	//calculate length of 2D-vector 
	function length(x1,x2,y1,y2) 
	{ 
	return sqrt( abs(pow((x1-x2),2) ) + abs(pow((y1-y2),2) )   );
	}
	//calculate profile plot origins 
	function profile_origin(x1,x2,y1,y2, total_slices, slice_count) 
	{ 
	plot_laenge = 1; // for profile plot length = electrode length 
	//location vector
	Ortsvektor = newArray(x1,y1);
	//direction vector
	Richtungsvektor = newArray( x2 - x1, y2 - y1 );
	//inverse direction vector -> scale product =! 0
	inverse_Richtungsvektor = newArray(Richtungsvektor[1], -Richtungsvektor[0]);
	
	//Slice number
	slice_ratio = slice_count / total_slices;
	vector = newArray( Ortsvektor[0] + slice_ratio * Richtungsvektor[0], Ortsvektor[1] + slice_ratio * Richtungsvektor[1]  );
	makeLine(Ortsvektor[0] + slice_ratio * Richtungsvektor[0], Ortsvektor[1] + slice_ratio * (Richtungsvektor[1]  / plot_laenge), Ortsvektor[0] + slice_ratio * Richtungsvektor[0] + inverse_Richtungsvektor[0],  Ortsvektor[1] + slice_ratio * Richtungsvektor[1] + (inverse_Richtungsvektor[1]  / plot_laenge));
	
	return vector;
	}

	// plot profile
	function perform_plot(threshold) { 
	run("Plot Profile");
	counter = 0;
	x=0;
	y=0;
	// get array values and save it in variable x&y
	Plot.getValues(x,y); 
	// count values above threshold 
	for (i=0; i<lengthOf(x); i++) {
	if (y[i] > threshold)
	{
		counter++;
	}
	} 
	//optional user-check
	//waitForUser("Everything OK");
	close();
	return counter;
	}
	

	
	// _______________ MAIN ______________________
		// how many profile plots? -> slice counter 
	total_slices = 100;
	temp_array = newArray(total_slices);
	
	title = getTitle();
	//print(title);

	// first loop for amient light picture 
	if (flag_first_loop == 0)
	{
	// user draws 5cm electrode line which is then used for the scaling of the profile plot 
	waitForUser("Choose Linescan Tool and draw the upper line of the 5cm HV-electrode for scaling and alignment --> then hit OK");  
	s = selectionType();
	getSelectionCoordinates(xpoints,ypoints);
	
	five_centimeter = length(xpoints[0],xpoints[1],ypoints[0],ypoints[1]);
	run("Set Scale...", "distance=" + five_centimeter + " known=5 unit=cm");
	scale = length(xpoints[0],xpoints[1],ypoints[0],ypoints[1]) / 5;

	// flag=1 after first loop
	flag_first_loop = 1;
	}

	//calculate all starting points for profile plots and perform plots 
	for (j=1; j<total_slices; j++){
	//calculate starting points
	vector = profile_origin(xpoints[0],xpoints[1],ypoints[0],ypoints[1], total_slices, j);
	result = perform_plot(threshold);
	temp_array[j-1] = result / scale;
	}
	// array with expansion values for all plots 
	result_array = Array.trim(temp_array, total_slices-1);
	
	Array.getStatistics(result_array, min, max, mean, stdDev);

	logstring = replace(title,".JPG","");

	print(logstring + ";" + mean );
	//optional - more information 
	//print(logstring + ";" + mean + ";" + stdDev );
}
	// #  ------------------- After Batch processing save LOG output -------------
	selectWindow("Log");
	saveAs(".txt", "C:\\Users\\lim38963\\Desktop\\MACRO\\Auswertung\\" + material + ".txt");
	//saveAs(".txt");

run("Close All");