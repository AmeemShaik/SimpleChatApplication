package chat;

import java.io.BufferedReader;
import java.io.InputStreamReader;

public class RunChat {
	public static void main(String[] args){
		try {
			Chat chat = new Chat("test");
			BufferedReader commandLine = new BufferedReader(new InputStreamReader(System.in));
			while(true){
				String s = commandLine.readLine();
				chat.writeMessage(s);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
