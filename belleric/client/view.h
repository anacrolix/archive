#ifndef view_h
#define view_h

#include <QWidget>
#include <QVBoxLayout>
#include <QLineEdit>
#include <QTextEdit>
#include <QTcpSocket>
#include <QByteArray>
#include <QString>
#include <QSpinBox>
#include <QGroupBox>
#include <QPushButton>

class ChatWindow : public QWidget
{
		Q_OBJECT
	public:
		ChatWindow(QWidget *parent = 0);
	private slots:
		void attemptConnection();
		void receiveMessage();
		void sendMessage();
		void closedConnection();
	private:
		QTcpSocket *clientSocket;
		QTextEdit *chatText;
		QLineEdit *messageEdit;
		QLineEdit *hostLine;
		QSpinBox *portSpin;
		QPushButton *connectButton;
		void logMessage(QString &);
		void logMessage(QByteArray &);
};

#endif
