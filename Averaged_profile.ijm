 print("\\Clear");

material = "FR4_Layer1_S100_th180"
 
 input_path = getDirectory("input files");
 fileList = getFileList(input_path) 

fileList = Array.sort(fileList); // sort filelist, start with -000

for (f = 0; f < lengthOf(fileList); f++) 
{
print(fileList[f]);
} 

 threshold = getNumber("Choose Threshold value", 35);

 flag_first_loop = 0;
 
for (f = 0; f < lengthOf(fileList); f++) 
{
run("Close All");

//open image 
open(input_path + fileList[f]);

	
	
	function length(x1,x2,y1,y2) 
	{ 
	return sqrt( abs(pow((x1-x2),2) ) + abs(pow((y1-y2),2) )   );
	}
	
	function get_slope(x1,x2,y1,y2) 
	{ 
	return (y2-y1) / (x2-x1); 
	}
	
	function get_t(x1,x2,y1,y2) 
	{ 
	return y2 - get_slope(x1,x2,y1,y2) * x2
	}
	
	function get_angle(m) 
	{ 
	return atan(m) * 180/PI;
	}
	
	function profile_origin(x1,x2,y1,y2, total_slices, slice_count) 
	{ 
	//Ortsvektor
	// Plot-länge funktioniert noch nicht - gegebenenfalls (falls 5cm Messdistanz zu lang) noch anpassen 
	plot_laenge = 1;
	Ortsvektor = newArray(x1,y1);
	Richtungsvektor = newArray( x2 - x1, y2 - y1 );
	inverse_Richtungsvektor = newArray(Richtungsvektor[1], -Richtungsvektor[0]);
	
	//Slice number
	slice_ratio = slice_count / total_slices;
	vector = newArray( Ortsvektor[0] + slice_ratio * Richtungsvektor[0], Ortsvektor[1] + slice_ratio * Richtungsvektor[1]  );
	makeLine(Ortsvektor[0] + slice_ratio * Richtungsvektor[0], Ortsvektor[1] + slice_ratio * (Richtungsvektor[1]  / plot_laenge), Ortsvektor[0] + slice_ratio * Richtungsvektor[0] + inverse_Richtungsvektor[0],  Ortsvektor[1] + slice_ratio * Richtungsvektor[1] + (inverse_Richtungsvektor[1]  / plot_laenge));
	
	return vector;
	}
	
	function perform_plot(threshold) { 
	
	run("Plot Profile");
	counter = 0;
	
	x=0;
	y=0;
	sort_x = 0; 
	sort_y = 0; 
	Plot.getValues(x,y); 
	sort_x = Array.sort(x);
	sort_y = Array.sort(y);
	for (i=0; i<lengthOf(x); i++) {
	if (y[i] > threshold)
	{
		counter++;
	}
	} 
	//waitForUser("See");
	close();
	return counter;
	}
	
	
	
	total_slices = 100;
	temp_array = newArray(total_slices);
	//threshold = getNumber("Choose Threshold value", 35);
	
	
	// _______________ MAIN ______________________
	title = getTitle();
	//print(title);

	if (flag_first_loop == 0)
	{
	
	//setTool("line");
	waitForUser("Choose Linescan Tool and draw the upper line of the 5cm HV-electrode for scaling and alignment --> then hit OK");  
	s = selectionType();
	getSelectionCoordinates(xpoints,ypoints);
	
	five_centimeter = length(xpoints[0],xpoints[1],ypoints[0],ypoints[1]);
	run("Set Scale...", "distance=" + five_centimeter + " known=5 unit=cm");
	scale = length(xpoints[0],xpoints[1],ypoints[0],ypoints[1]) / 5;
	
	
	slice_distance = five_centimeter / total_slices;   // slice-zahl kann erhöht werden, jetzt 8 geraden für profilplots
	flag_first_loop = 1;
	}
	
	for (j=1; j< total_slices; j++){
	//calculate starting points
	vector = profile_origin(xpoints[0],xpoints[1],ypoints[0],ypoints[1], total_slices, j);
	result = perform_plot(threshold);
	
	temp_array[j-1] = result / scale;
	//print(result / scale );
	
	//close();
	//calculate othogonal line
	//calculate neue gerade 
	//makeLine(2610, 2790, 2604, 2178);
	//perform profile plot
	//save values regarding threshold
	}
	result_array = Array.trim(temp_array, total_slices-1);
	
	Array.getStatistics(result_array, min, max, mean, stdDev);

	logstring = replace(title,".JPG","");
	
	print(logstring + ";" + mean);
	//saveAs(result_array, "C:\\Users\\lim38963\\Desktop\\MACRO\\Auswertung");
}
	selectWindow("Log");
	saveAs(".txt", "C:\\Users\\lim38963\\Desktop\\MACRO\\Auswertung\\" + material + ".txt");
	//saveAs(".txt");

run("Close All");