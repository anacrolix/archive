#include <QVBoxLayout>
#include <QLineEdit>
#include <QTextEdit>
#include <QTcpServer>
#include <QTcpSocket>
#include <QByteArray>
#include <QString>
#include <QSpinBox>
#include <QGroupBox>
#include <QPushButton>
#include <iostream>
#include "view.h"

ChatWindow::ChatWindow(QWidget *parent)
	: QWidget(parent)
{
	// set up ui
	hostLine = new QLineEdit("localhost", this);

	portSpin = new QSpinBox(this);
	portSpin->setRange(1, 65000); //tune me
	//portSpin->setPrefix("port ");
	portSpin->setValue(1337);

	messageEdit = new QLineEdit(QString("talk here"), this);
	connect(
		messageEdit, SIGNAL(returnPressed()),
		this, SLOT(sendMessage()));

	chatText = new QTextEdit(this);
	chatText->setReadOnly(true);

	connectButton = new QPushButton("Connect", this);
	QObject::connect(
		connectButton, SIGNAL(clicked()),
		this, SLOT(attemptConnection()));

	QGroupBox *connectGroup = new QGroupBox("Connect as client");
	QHBoxLayout *connectHBox = new QHBoxLayout(connectGroup);
	connectHBox->addWidget(hostLine);
	connectHBox->addWidget(portSpin);
	connectHBox->addWidget(connectButton);
	connectGroup->setLayout(connectHBox);

	QVBoxLayout *layout = new QVBoxLayout(this);
	layout->addWidget(connectGroup);
	layout->addWidget(chatText);
	layout->addWidget(messageEdit);
	setLayout(layout);
	// set up server
	chatServer = new QTcpServer(this);
	chatServer->listen(QHostAddress::Any, 1337);
	connect(
		chatServer, SIGNAL(newConnection()),
		this, SLOT(receiveConnection()));
	clientSocket = 0;
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

void ChatWindow::attemptConnection()
{
	std::cout << "attempting to connect" << std::endl;
	//close server if open
	//try to open socket to given host/port
	clientSocket = new QTcpSocket(this);
	clientSocket->connectToHost(hostLine->text(), portSpin->value());
	connect(
		clientSocket, SIGNAL(readyRead()),
		this, SLOT(receiveMessage()));
}

void ChatWindow::receiveMessage()
{
	std::cout << "there are bytes to be read" << std::endl;
	QByteArray message = clientSocket->readAll();
	if (chatText->toPlainText().isEmpty() == false)
	{
		chatText->insertPlainText("\n");
	}
	chatText->insertPlainText(message);
}

void ChatWindow::sendMessage()
{
	std::cout << "message will be sent" << std::endl;
	std::cout << "clientSocket has value " << clientSocket << std::endl;
	if (clientSocket != NULL)
	{
		QByteArray message;
		message.append(messageEdit->text());
		clientSocket->write(message);
	}
	messageEdit->clear();
}
