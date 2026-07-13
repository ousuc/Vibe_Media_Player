#include <QGuiApplication>

#include "AppController.h"

int main(int argc, char *argv[]) {
        QGuiApplication app(argc, argv);
        AppController controller(app);

        return app.exec();
}