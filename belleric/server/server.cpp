#include "server.h"

SocketNotifier::SocketNotifier(QTcpSocket* socket)
		:
		QObject(socket),
		m_socket(socket)
{
	connect(socket, SIGNAL(readyRead()), this, SLOT(readyRead()));
	connect(socket, SIGNAL(disconnected()), this, SLOT(disconnected()));
}

void SocketNotifier::readyRead()
{
	emit newMessage(m_socket);
}

void SocketNotifier::disconnected()
{
	emit endConnection(m_socket);
}

ChatServer::ChatServer()
		:
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
	SocketNotifier *notifier = new SocketNotifier(newsock);
	connect(notifier, SIGNAL(newMessage(QTcpSocket *)),
			this,     SLOT(newMessage(QTcpSocket *)));
	connect(notifier, SIGNAL(endConnection(QTcpSocket *)),
			this, SLOT(endConnection(QTcpSocket *)));
	m_clientSockets << newsock;
	qDebug() << "Now there are" << m_clientSockets.size() << "clients";
}

void ChatServer::newMessage(QTcpSocket *socket)
{
	QByteArray message = socket->readAll();
	qDebug() << "Received message from" << socket->peerName() << ":";
	qDebug() << message;
	QSetIterator<QTcpSocket *> it(m_clientSockets);
	while (it.hasNext())
	{
		QTcpSocket *client = it.next();
		if (client != socket)
		{
			client->write(message);
		}
	}		
}

void ChatServer::endConnection(QTcpSocket *socket)
{
	if (m_clientSockets.remove(socket))
	{
		qDebug() << "Disconnected" << socket->peerName();
		qDebug() << "There are now" << m_clientSockets.size() << "clients";
	} else {
		qFatal("Socket %u is not listed!", socket);
	}
	delete socket;
}