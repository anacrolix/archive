#include "view.h"

ChatWindow::ChatWindow(QWidget *parent) :
		QWidget(parent),
		clientSocket(0)
{
	// set up ui
	hostLine = new QLineEdit("stupidape.dyndns.org", this);

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

	QGroupBox *connectGroup = new QGroupBox("Connection details");
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
}

void ChatWindow::attemptConnection()
{
	if (clientSocket)
	{
		clientSocket->deleteLater();
	}
	clientSocket = new QTcpSocket(this);
	clientSocket->connectToHost(hostLine->text(), portSpin->value());
	connect(clientSocket, SIGNAL(readyRead()),
			this, SLOT(receiveMessage()));
	connect(clientSocket, SIGNAL(disconnected()),
			this, SLOT(closedConnection()));
}

void ChatWindow::receiveMessage()
{
	QString message(">> " + clientSocket->readAll());
	logMessage(message);
}

void ChatWindow::logMessage(QString &msg)
{
	if (!chatText->toPlainText().isEmpty())
	{
		chatText->insertPlainText("\n");
	}
	chatText->insertPlainText(msg);
}

void ChatWindow::logMessage(QByteArray &msg)
{
	QString msg2(msg);
	logMessage(msg2);
}

void ChatWindow::sendMessage()
{
	if (clientSocket && clientSocket->isValid())
	{
		QByteArray message;
		message.append(messageEdit->text());
		clientSocket->write(message);
		logMessage(message);
		messageEdit->clear();
	}
	else
	{
		QString errMsg("!! Failed to send message");
		logMessage(errMsg);
	}
}

void ChatWindow::closedConnection()
{
	QString msg("!! Connection was closed");
	logMessage(msg);
	clientSocket->deleteLater();
	clientSocket = 0;
}
