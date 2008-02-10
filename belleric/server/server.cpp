#include <QTcpServer>
#include <QTcpSocket>

#include "server.h"

ChatServer::ChatServer() : QObject()
{
	server = new QTcpServer();
	server->listen(QHostAddress::Any, 1337);
	connect(server, SIGNAL(newConnection()), this, SLOT(newConnection()));
}

void ChatServer::newConnection()
{
	client = server->nextPendingConnection();
	client->write("Welcome");
	connect(client, SIGNAL(readyRead()), this, SLOT(newMessage()));
}

void ChatServer::newMessage()
{
	QByteArray message = client->readAll();
	client->write("Thank you for your message");
}
