#include "server.h"

#include <QtNetwork>

SocketNotifier::SocketNotifier(QTcpSocket* socket)
		:
		QObject(socket),
		m_socket(socket)
{
	connect(socket, SIGNAL(readyRead()), this, SLOT(readyRead()));
}

void SocketNotifier::readyRead()
{
	emit newMessage(m_socket);
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
	connect(notifier, SIGNAL(newMessage(QTcpSocket*)),
			this,     SLOT(newMessage(QTcpSocket*)));
	m_clientSockets.append(newsock);
	qDebug() << "Now there are" << m_clientSockets.size() << "clients";
}

void ChatServer::newMessage(QTcpSocket* socket)
{
	QByteArray message = socket->readAll();
	socket->write("Roger.");
}


