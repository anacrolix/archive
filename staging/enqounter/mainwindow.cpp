#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QInputDialog>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent), ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    //ui->addCmbt->addAction(
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::addCombatant()
{
    QInputDialog a;
    QStringList b(a.getText(this, "New Combatant", "New Combatant Name"));
    b << "+0";
    ui->cmbtList->addTopLevelItem(new QTreeWidgetItem(b));
}
