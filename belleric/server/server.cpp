#include "server.h"

ChatServer::ChatServer() :
		m_serverSocket(new QTcpServer(this))
{
	m_serverSocket->listen(QHostAddress::Any, 1337);
	connect(m_serverSocket, SIGNAL(newConnection()), this, SLOT(newConnection()));
	qDebug() << "Chat server started";
}

void ChatServer::newConnection()
{
	QTcpSocket *newsock = m_serverSocket->nextPendingConnection();
	qDebug() << "Accepted connection from" << newsock->peerAddress();
	newsock->write("Welcome to Belleric chat!");
	ChatSocket *cs = new ChatSocket(newsock);
	connect(cs, SIGNAL(newMessage()),
			this, SLOT(newMessage()));
	connect(cs, SIGNAL(endConnection()),
			this, SLOT(endConnection()));
	m_clients << cs;
	qDebug() << "Now there are" << m_clients.size() << "clients";
}

void ChatServer::newMessage(ChatSocket *cs, QByteArray &message)
{
	//qDebug() << socket->peerAddress().toString() << ":" << message;
	QSetIterator<ChatSocket *> it(m_clients);
	while (it.hasNext())
	{
		ChatSocket *client = it.next();
		if (client != cs)
		{
			client->sendMessage(message);
		}
	}
}

void ChatServer::endConnection(ChatSocket *cs)
{
	if (m_clients.remove(cs))
	{
		qDebug() << "Disconnected" << cs->m_socket->peerAddress().toString();
		qDebug() << "There are now" << m_clients.size() << "clients";
	}
	else
	{
		qFatal("Socket %u is not listed!", uint(cs));
	}
	cs->m_socket->deleteLater();
}
