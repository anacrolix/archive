#ifndef server_h
#define server_h

#include <QtNetwork>

class SocketNotifier : public QObject
{
		Q_OBJECT
	public:
		SocketNotifier(QTcpSocket *socket);
	signals:
		void newMessage(QTcpSocket *);
		void endConnection(QTcpSocket *);
	private slots:
		void readyRead();
		void disconnected();
	private:
		QTcpSocket *m_socket;
};

class ChatServer : QObject
{
		Q_OBJECT
	public:
		ChatServer();
	private slots:
		void newConnection();
		void newMessage(QTcpSocket *);
		void endConnection(QTcpSocket *);
	private:
		QTcpServer *m_serverSocket;
		QSet<QTcpSocket *> m_clientSockets;
};

#endif
