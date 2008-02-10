#include <iostream>

#include <QTcpServer>
#include <QTcpSocket>
#include <QList>

#include "server.h"

ChatServer::ChatServer() : QObject()
{
	server = new QTcpServer();
	server->listen(QHostAddress::Any, 1337);
	connect(server, SIGNAL(newConnection()), this, SLOT(newConnection()));
}

void ChatServer::newConnection()
{
	ClientSocket *newSocket = static_cast<ClientSocket *>(server->nextPendingConnection());
	newSocket->write("Welcome");
	connect(newSocket, SIGNAL(newMessage(ClientSocket *cs)), this, SLOT(newMessage(cs)));
	clientSockets.append(newSocket);
}

void ChatServer::newMessage(ClientSocket *cs)
{
	std::cout << cs << std::endl;
	QByteArray message = cs->readAll();
	cs->write("Thank you for your message");
}

ClientSocket::ClientSocket() : QTcpSocket()
{
	connect(this, SIGNAL(readyRead()), SLOT(readyRead2()));
}

void ClientSocket::readyRead2()
{
	emit newMessage(this);
}
