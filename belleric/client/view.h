#ifndef VIEW_H
#define VIEW_H

#include <QWidget>
class QTcpServer;
class QTcpSocket;
class QTextEdit;
class QTcpServer;
class QLineEdit;
class QSpinBox;
class QPushButton;

class ChatWindow : public QWidget
{
	Q_OBJECT

public:
	ChatWindow(QWidget *parent = 0);

private slots:
	void attemptConnection();
	void receiveMessage();
	void sendMessage();

private:
	QTcpSocket *clientSocket;
	QTextEdit *chatText;
	QLineEdit *messageEdit;
	QLineEdit *hostLine;
	QSpinBox *portSpin;
	QPushButton *connectButton;
};

#endif
