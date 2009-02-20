#include <QApplication>

#include "view.h"

int main(int argc, char *argv[])
{
	QApplication app(argc, argv);
	ChatWindow chatWindow;
	chatWindow.show();
	return app.exec();
}
