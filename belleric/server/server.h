#ifndef server_h
#define server_h

#include <QtNetwork>
#include "../common/chatsocket.h"

class ChatServer : QObject
{
		Q_OBJECT
	public:
		ChatServer();
	private slots:
		void newConnection();
		void newMessage(ChatSocket *, QByteArray &);
		void endConnection(ChatSocket *);
	private:
		QTcpServer *m_serverSocket;
		QSet<ChatSocket *> m_clients;
};

#endif
