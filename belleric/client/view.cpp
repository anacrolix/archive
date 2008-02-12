#include "view.h"

ChatWindow::ChatWindow(QWidget *parent) :
		QWidget(parent),
		clientSocket(0)
{
	// set up ui
	hostLine = new QLineEdit("stupidape.dyndns.org", this);

	portLine = new QLineEdit("1337", this);

	messageEdit = new QLineEdit(QString("talk here"), this);
	connect(
		messageEdit, SIGNAL(returnPressed()),
		this, SLOT(sendMessage()));

	chatText = new QTextEdit(this);
	chatText->setFontFamily("monospace");
	chatText->setReadOnly(true);
	chatText->setText(
		"Welcome to Belleric! "
		"Please enter server details above and click 'Connect'");

	connectButton = new QPushButton("Connect", this);
	QObject::connect(
		connectButton, SIGNAL(clicked()),
		this, SLOT(attemptConnection()));

	QGroupBox *connectGroup = new QGroupBox("Connection details");
	QHBoxLayout *connectHBox = new QHBoxLayout(connectGroup);
	connectHBox->addWidget(hostLine);
	connectHBox->addWidget(portLine);
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
		clientSocket->abort();
		clientSocket->deleteLater();
	}
	clientSocket = new QTcpSocket(this);
	clientSocket->connectToHost(hostLine->text(), portLine->text().toUShort());
	connect(clientSocket, SIGNAL(readyRead()),
			this, SLOT(receiveMessage()));
	connect(clientSocket, SIGNAL(disconnected()),
			this, SLOT(closedConnection()));
	connect(clientSocket, SIGNAL(connected()),
			this, SLOT(connectedToServer()));
	connect(clientSocket, SIGNAL(error(QAbstractSocket::SocketError)),
			this, SLOT(socketError(QAbstractSocket::SocketError)));
}

void ChatWindow::connectedToServer()
{
	QString msg("II Connection successful");
	logMessage(msg);
}

void ChatWindow::socketError(QAbstractSocket::SocketError)
{
	qDebug() << "oh noes lol a socket error";
	qDebug() << clientSocket->errorString();
}

void ChatWindow::receiveMessage()
{
	QString message("<< " + clientSocket->readAll());
	logMessage(message);
}

void ChatWindow::logMessage(QString &msg)
{
	chatText->moveCursor(QTextCursor::End);
	if (!chatText->toPlainText().isEmpty())
	{
		chatText->insertPlainText("\n");
	}
	chatText->insertPlainText(msg);
	chatText->verticalScrollBar()->triggerAction(QAbstractSlider::SliderToMaximum);
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
		QString log(">> " + message);
		logMessage(log);
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
