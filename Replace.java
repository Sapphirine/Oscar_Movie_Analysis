import java.util.Scanner;
import java.io.PrintWriter;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.File;
import java.io.IOException;
import java.lang.String;
import java.lang.Thread;

public class Replace{
	Replace(String file1){
		
		try{
			File file = new File(file1);
			//Scanner parser = new Scanner(file);
			BufferedReader parser = new BufferedReader(new FileReader(file));
			PrintWriter writer = new PrintWriter(new File("result_replace.txt")); 
			String headline;
			String line;
			String head = "";
			while(true){
				headline = parser.readLine();
				if (headline == null) break;	
		
				while(true){
					line = parser.readLine();
					
					if(line.length() != 0){
						line = line.replaceAll(" she ", " ");
						line = line.replaceAll(" She ", " ");
						line = line.replaceAll(" He ", " ");
						line = line.replaceAll(" he ", " ");
						line = line.replaceAll(" dvd ", " ");
						line = line.replaceAll(" his ", " ");
						line = line.replaceAll(" has ", " ");
						line = line.replaceAll(" You ", " ");
						line = line.replaceAll(" you ", " ");
						line = line.replaceAll(" her ", " ");
						line = line.replaceAll(" him ", " ");
						line = line.replaceAll(" I ", " ");
						line = line.replaceAll("great", " ");
						line = line.replaceAll("good", " ");
						line = line.replaceAll("like", " ");
						line = line.replaceAll("it's", " ");
						line = line.replaceAll("excellent", " ");
						line = line.replaceAll(" My ", " ");
						line = line.replaceAll(" my ", " ");
						line = line.replaceAll("movie", " ");
						line = line.replaceAll("film", " ");
						line = line.replaceAll("about", " ");
						line = line.replaceAll("who", " ");
						line = line.replaceAll("have", " ");
						line = line.replaceAll("<br />", " ");
						writer.println(line);
					}
					else{
						writer.println("");
						break;
					}
				}			
			}
			writer.close();
			
		}catch(IOException e){
			System.err.println(e);
		}		
	}

	public static void main(String[] args){
		new Replace("result_final.txt");
	}
}