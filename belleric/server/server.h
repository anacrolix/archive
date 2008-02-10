#include <QObject>

class QTcpServer;
class QTcpSocket;

class ChatServer : QObject
{
	Q_OBJECT
public:
	ChatServer();
private slots:
	void newConnection();
	void newMessage();
private:
	QTcpServer *server;
	QTcpSocket *client;
};
