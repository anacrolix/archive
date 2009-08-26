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

typedef QList<QTreeWidgetItem *> ListType;
static void list_op(QList<QTreeWidgetItem *> list, void (*opfunc)(QTreeWidgetItem *))
{
    for (ListType::iterator i(list.begin()); i != list.end(); ++i)
    {
        opfunc(*i);
    }
}

static void incrementInitiative(ListType::value_type item)
{
    item->setText(1, QString::number(item->text(1).toInt() + 1));
}

void MainWindow::incrementInitiative()
{
    list_op(ui->cmbtList->selectedItems(), ::incrementInitiative);
}

void MainWindow::restartEncounter()
{
    QList<QTreeWidgetItem *> list(ui->cmbtList->selectedItems());
}

void MainWindow::decrementInitiative()
{
    QList<QTreeWidgetItem *> list(ui->cmbtList->selectedItems());
}

void MainWindow::removeCombatant()
{
    QList<QTreeWidgetItem *> list(ui->cmbtList->selectedItems());
}
