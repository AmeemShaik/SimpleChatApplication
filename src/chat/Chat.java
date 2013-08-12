package chat;

import java.util.Properties;

import javax.jms.*;
import javax.naming.Context;
import javax.naming.InitialContext;

public class Chat implements MessageListener {
	private TopicSession pubSession;
	private TopicConnection connection;
	private TopicPublisher publisher;
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
		TopicSession pubSession = connection.createTopicSession(false, Session.AUTO_ACKNOWLEDGE);
		TopicSession subSession = connection.createTopicSession(false, Session.AUTO_ACKNOWLEDGE);
		Topic chatTopic = (Topic)jndi.lookup(topicName);
		TopicPublisher publisher = pubSession.createPublisher(chatTopic);
		TopicSubscriber subscriber = subSession.createSubscriber(chatTopic);
		subscriber.setMessageListener(this);
		this.pubSession = pubSession;
		this.connection = connection;
		this.publisher = publisher;
		connection.start();
	}
	public void writeMessage(String text)
	{
		TextMessage textMessage;
		try {
			textMessage = pubSession.createTextMessage();
			textMessage.setText(text);
			publisher.publish(textMessage);
		} catch (JMSException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
	}
	public void onMessage(Message message) {
		// TODO Auto-generated method stub
		TextMessage textmessage = (TextMessage) message;
		try {
			String text = textmessage.getText();
			System.out.println(text);
		} catch (JMSException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
}
