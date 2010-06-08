#include <QApplication>
#include <QWidget>
#include <QGridLayout>
#include <QSpinBox>
#include <QLabel>
#include <QVBoxLayout>
#include <QGroupBox>

#include "tibia-xp.h"

void setupWindow(QWidget &window)
{
	QSpinBox *victimLevelSpin = new QSpinBox();
	QSpinBox *killerLevelSpin = new QSpinBox();
	QGridLayout *deathConfLayout = new QGridLayout();
	deathConfLayout->addWidget(
		new QLabel("Victim: ", &window), 0, 0);
	deathConfLayout->addWidget(victimLevelSpin, 0, 1);
	deathConfLayout->addWidget(
		new QLabel("Killer: ", &window), 1, 0);
	deathConfLayout->addWidget(killerLevelSpin, 1, 1);
	QGroupBox *deathConfGroup = new QGroupBox("Initial settings");
	deathConfGroup->setLayout(deathConfLayout);

	QVBoxLayout *windowLayout = new QVBoxLayout();;
	windowLayout->addWidget(deathConfGroup);

	window.setLayout(windowLayout);
}

int main (int argc, char *argv[])
{
	QApplication app(argc, argv);
	QWidget window;
	setupWindow(window);
	window.show();
	return app.exec();
}
