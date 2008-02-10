#include <QList>
#include <QObject>
#include <QTcpSocket>

class QTcpServer;
class ClientSocket;

class ChatServer : QObject
{
	Q_OBJECT
public:
	ChatServer();
private slots:
	void newConnection();
	void newMessage(ClientSocket *cs);
private:
	QTcpServer *server;
	QList<ClientSocket *> clientSockets;
};

class ClientSocket : public QTcpSocket
{
	Q_OBJECT
public:
	ClientSocket();
signals:
	void newMessage(ClientSocket *cs);
private:
	void readyRead2();
};
