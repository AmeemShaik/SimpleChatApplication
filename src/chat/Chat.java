package chat;

import java.util.Properties;

import javax.jms.*;
import javax.naming.Context;
import javax.naming.InitialContext;

public class Chat {
	public Chat(String topicName) throws Exception {
		Properties env = new Properties();
		env.put(Context.SECURITY_PRINCIPAL, "guest");
		env.put(Context.SECURITY_CREDENTIALS, "guest");
		env.put(Context.INITIAL_CONTEXT_FACTORY,
				"org.exolab.jms.jndi.InitialContextFactory");
		env.put(Context.PROVIDER_URL, "tcp://10.0.0.10:3035");
		InitialContext jndi = new InitialContext(env);
		TopicConnectionFactory conFactory = (TopicConnectionFactory) jndi.lookup("JmsTopicConnectionFactory");
		TopicConnection connection = conFactory.createTopicConnection();
		connection.start();
	}
	
}
