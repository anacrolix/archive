#ifndef server_h
#define server_h

#include <QList>
#include <QObject>

class QTcpServer;
class QTcpSocket;

class SocketNotifier : public QObject
{
		Q_OBJECT
	public:
		SocketNotifier(QTcpSocket* socket);
	signals:
		void newMessage(QTcpSocket*);
	private slots:
		void readyRead();
	private:
		QTcpSocket* m_socket;
};

class ChatServer : QObject
{
		Q_OBJECT
	public:
		ChatServer();
	private slots:
		void newConnection();
		void newMessage(QTcpSocket* socket);
	private:
		QTcpServer*        server;
		QList<QTcpSocket*> clientSockets;
};

#endif
