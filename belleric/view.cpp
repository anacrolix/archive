#include <QVBoxLayout>
#include <QLineEdit>
#include <QTextEdit>
#include <QTcpServer>
#include <QTcpSocket>
#include <QByteArray>
#include <QString>
#include <iostream>
#include "view.h"

ChatWindow::ChatWindow(QWidget *parent)
	: QWidget(parent)
{
	// set up ui
	messageEdit = new QLineEdit(QString("talk here"), this);
	connect(
		messageEdit, SIGNAL(returnPressed()),
		this, SLOT(sendMessage()));
	chatText = new QTextEdit(this);
	QVBoxLayout *layout = new QVBoxLayout(this);
	layout->addWidget(chatText);
	layout->addWidget(messageEdit);
	setLayout(layout);
	// set up server
	chatServer = new QTcpServer(this);
	chatServer->listen(QHostAddress::Any, 1337);
	connect(
		chatServer, SIGNAL(newConnection()),
		this, SLOT(receiveConnection()));
}

void ChatWindow::receiveConnection()
{
	std::cout << "something connected" << std::endl;
	clientSocket = chatServer->nextPendingConnection();
	connect(
		clientSocket, SIGNAL(disconnected()),
		clientSocket, SLOT(deleteLater()));
	clientSocket->write("hello\n");
	connect(
		clientSocket, SIGNAL(readyRead()),
		this, SLOT(receiveMessage()));
}

void ChatWindow::receiveMessage()
{
	std::cout << "there are bytes to be read" << std::endl;
	QByteArray message = clientSocket->readAll();
	chatText->append(message);
}

void ChatWindow::sendMessage()
{
	std::cout << "message will be sent" << std::endl;
	if (clientSocket)
	{
		QByteArray message;
		message.append(messageEdit->text());
		message.append("\n");
		clientSocket->write(message);
	}
	messageEdit->clear();
}
