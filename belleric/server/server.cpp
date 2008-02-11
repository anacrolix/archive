#include "server.h"

#include <QtNetwork>

SocketNotifier::SocketNotifier(QTcpSocket* socket)
		:
		QObject(socket),
		m_socket(socket)
{
	qDebug() << "SocketNotifier(" << socket << ")";
	connect(socket, SIGNAL(readyRead()), this, SLOT(readyRead()));
}

void SocketNotifier::readyRead()
{
	emit newMessage(m_socket);
}

ChatServer::ChatServer()
		:
		server(new QTcpServer(this))
{
	qDebug() << "ChatServer()";
	server->listen(QHostAddress::Any, 1337);
	connect(server, SIGNAL(newConnection()), this, SLOT(newConnection()));
}

void ChatServer::newConnection()
{
	QTcpSocket *newsock = server->nextPendingConnection();
	//qDebug() << "Accepted new connection from:" << newsock->peerAddress();
	qDebug() << "New connection from" << newsock->peerAddress();
	qDebug("New connection from (C++ sux ;D)");
	newsock->write("Welcome");

	SocketNotifier *notifier = new SocketNotifier(newsock);
	connect(notifier, SIGNAL(newMessage(QTcpSocket*)),
			this,     SLOT(newMessage(QTcpSocket*)));
}

void ChatServer::newMessage(QTcpSocket* socket)
{
	QByteArray message = socket->readAll();
	socket->write("Thank you for your message");
}


