import java.util.Scanner;
import java.io.PrintWriter;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.File;
import java.io.IOException;
import java.lang.String;
import java.lang.Thread;

public class Modify{
	Modify(String file1){
		
		try{
			File file = new File(file1);
			//Scanner parser = new Scanner(file);
			BufferedReader parser = new BufferedReader(new FileReader(file));

			String headline;
			String line;
			String head = "";
			int filenum = 0;
			//while(parser.hasNext()){
			while(true){
				head = "";
				headline = parser.readLine();
				if (headline == null) break;
				headline = parser.readLine();
				if (headline == null) break;
				headline = parser.readLine();
				headline = parser.readLine();
				headline = parser.readLine();
				headline = parser.readLine();	
				filenum ++;
				String filename = "review" + Integer.toString(filenum) + ".txt";
				PrintWriter writer = new PrintWriter(new File(filename)); 
				while(true){
					line = parser.readLine();
					String[] headlines = headline.split(" ");	
					if(line.length() != 0){
						writer.println(line);
					}
					else{
						writer.println("");
						break;
					}
				}
				writer.close();
			}
			
		}catch(IOException e){
			System.err.println(e);
		}		
	}

	public static void main(String[] args){
		new Modify("result.txt");
	}
}