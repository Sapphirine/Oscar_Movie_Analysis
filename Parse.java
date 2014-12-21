import java.util.Scanner;
import java.io.PrintWriter;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.File;
import java.io.IOException;
import java.lang.String;
import java.lang.Thread;

public class Parse{
	Parse(String file1, String file2 ){
		
		try{
			File file = new File(file1);
			//Scanner parser = new Scanner(file);
			BufferedReader parser = new BufferedReader(new FileReader(file));
			PrintWriter writer = new PrintWriter(new File(file2));

			String headline;
			String line;
			String head = "";

			//while(parser.hasNext()){
			while(true){
				head = "";
				headline = parser.readLine();
				if (headline == null) break;
				head = head + headline + "\n";
				headline = parser.readLine();
				if (headline == null) break;
				head = head + headline + "\n";
				headline = parser.readLine();
				head = head + headline + "\n";
				headline = parser.readLine();
				head = head + headline + "\n";
				headline = parser.readLine();
				String[] headlines = headline.split(" ");
				if(headlines[1].equals("5.0")){
					
					writer.print(head);
					writer.println(headline);
					
					while(true){
						line = parser.readLine();
					
						if(line.length() != 0){
							writer.println(line);
						}
						else{
							writer.println("");
							break;
						}
					}
				}
				else{
					while(true){
						line = parser.readLine();
						if(line.length() == 0) break;
					}
				}	
			}
			writer.close();
		}catch(IOException e){
			System.err.println(e);
		}		
	}
	public static void main(String[] args){
		new Parse("movies.txt", "result.txt");
	}
}