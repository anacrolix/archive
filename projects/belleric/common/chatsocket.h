#ifndef chatsocket_h
#define chatsocket_h

#include <QObject>

class QTcpSocket;

class ChatSocket : public QObject
{
		Q_OBJECT
	public:
		ChatSocket(QTcpSocket *socket);
		void sendMessage(QByteArray &);
		QTcpSocket *m_socket;
	signals:
		void newMessage(ChatSocket *, QByteArray &);
		void endConnection(ChatSocket *);
	private slots:
		void readyRead();
		void disconnected();
	private:
		QByteArray m_messageData;
		bool m_pendingNewMessage;
		qint64 m_messageSize;
};

#endif
