#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QtGui/QMainWindow>

namespace Ui
{
    class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = 0);
    ~MainWindow();

public slots:
    void addCombatant();
    void removeCombatant();
    void incrementInitiative();
    void decrementInitiative();
    void restartEncounter();

private:
    Ui::MainWindow *ui;
};

#endif // MAINWINDOW_H
