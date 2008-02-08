#ifndef VIEW_H
#define VIEW_H

#include <QWidget>
class QTcpServer;
class QTcpSocket;
class QTextEdit;
class QTcpServer;
class QLineEdit;

class ChatWindow : public QWidget
{
	Q_OBJECT

public:
	ChatWindow(QWidget *parent = 0);

private slots:
	void receiveConnection();
	void receiveMessage();
	void sendMessage();

private:
	QTcpServer *chatServer;
	QTcpSocket *clientSocket;
	QTextEdit *chatText;
	QLineEdit *messageEdit;
};

#endif
