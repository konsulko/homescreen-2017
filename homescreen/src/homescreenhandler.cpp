/*
 * Copyright (c) 2017 TOYOTA MOTOR CORPORATION
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "homescreenhandler.h"
#include <functional>

void* HomescreenHandler::myThis = 0;

HomescreenHandler::HomescreenHandler(QObject *parent) :
    QObject(parent),
    mp_hs(NULL)
{

}

HomescreenHandler::~HomescreenHandler()
{
    if (mp_hs != NULL) {
        delete mp_hs;
    }
}

void HomescreenHandler::init(int port, const char *token)
{
    mp_hs = new LibHomeScreen();
    mp_hs->init(port, token);

    myThis = this;

//    mp_hs->registerCallback(HomescreenHandler::onEv_static, HomescreenHandler::onRep_static);
//    mp_hs->subscribe(LibHomeScreen::event_list[0]);
//    mp_hs->subscribe(LibHomeScreen::event_list[1]);

    mp_hs->registerCallback(nullptr, HomescreenHandler::onRep_static);

    mp_hs->set_event_handler(LibHomeScreen::Event_OnScreenMessage, [this](const char* display_message){
        qDebug("set_event_handler Event_OnScreenMessage display_message = %s", display_message);
    });

	mp_hs->set_event_handler(LibHomeScreen::Event_TapShortcut, [this](const char* application_name){
        if(strcmp(application_name, "Home") == 0){
            emit this->homeButton();
        }
	});

}

void HomescreenHandler::tapShortcut(QString application_name)
{
    qDebug("tapShortcut %s", qPrintable(application_name));
    mp_hs->tapShortcut(application_name.toStdString().c_str());
}

void HomescreenHandler::onRep_static(struct json_object* reply_contents)
{
    static_cast<HomescreenHandler*>(HomescreenHandler::myThis)->onRep(reply_contents);
}

void HomescreenHandler::onEv_static(const string& event, struct json_object* event_contents)
{
    static_cast<HomescreenHandler*>(HomescreenHandler::myThis)->onEv(event, event_contents);
}

void HomescreenHandler::onRep(struct json_object* reply_contents)
{
    const char* str = json_object_to_json_string(reply_contents);
    qDebug("HomeScreen onReply %s", str);
}

void HomescreenHandler::onEv(const string& event, struct json_object* event_contents)
{
    const char* str = json_object_to_json_string(event_contents);
    qDebug("HomeScreen onEv %s, contents: %s", event.c_str(), str);

    if (event.compare("homescreen/on_screen_message") == 0) {
        struct json_object *json_data = json_object_object_get(event_contents, "data");
        struct json_object *json_display_message = json_object_object_get(json_data, "display_message");
        const char* display_message = json_object_get_string(json_display_message);

        qDebug("display_message = %s", display_message);
    }
}
