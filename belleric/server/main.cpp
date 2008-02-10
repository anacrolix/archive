#include <QApplication>

#include "server.h"

int main (int argc, char **argv)
{
	QApplication app(argc, argv);
	ChatServer chatServer;
	return app.exec();
}
