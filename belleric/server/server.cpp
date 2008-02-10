#include "server.h"

#include <QtNetwork>

SocketNotifier::SocketNotifier(QTcpSocket* socket)
    :
    QObject(socket),
    m_socket(socket)
{
    connect(socket, SIGNAL(readyRead()), this, SLOT(readyRead()));
}

void
SocketNotifier::readyRead()
{
    emit newMessage(m_socket);
}

ChatServer::ChatServer() 
    :
    server(new QTcpServer(this))    
{
	server->listen(QHostAddress::Any, 1337);
	connect(server, SIGNAL(newConnection()), this, SLOT(newConnection()));
}

void ChatServer::newConnection()
{
    QTcpSocket *soc = server->nextPendingConnection();
    soc->write("Welcome");

    SocketNotifier *notifier = new SocketNotifier(soc);
    connect(notifier, SIGNAL(newMessage(QTcpSocket*)), 
            this,     SLOT(newMessage(QTcpSocket*)));
}

void ChatServer::newMessage(QTcpSocket* socket)
{
	QByteArray message = socket->readAll();
	socket->write("Thank you for your message");
}


