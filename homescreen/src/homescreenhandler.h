#ifndef HOMESCREENHANDLER_H
#define HOMESCREENHANDLER_H

#include <QObject>
#include <libhomescreen.hpp>
#include <string>

using namespace std;

class HomescreenHandler : public QObject
{
    Q_OBJECT
public:
    explicit HomescreenHandler(QObject *parent = 0);
    ~HomescreenHandler();

    void init(int port, const char* token);

    Q_INVOKABLE void tapShortcut(QString application_name);

    void onRep(struct json_object* reply_contents);
    void onEv(const string& event, struct json_object* event_contents);

    static void* myThis;
    static void onRep_static(struct json_object* reply_contents);
    static void onEv_static(const string& event, struct json_object* event_contents);
signals:
    void homeButton();

private:
    LibHomeScreen *mp_hs;
};

#endif // HOMESCREENHANDLER_H
