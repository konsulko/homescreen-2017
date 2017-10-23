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

#include "hmi-debug.h"
#include "layouthandler.h"

#define HOMESCREEN "HomeScreen"

LayoutHandler::LayoutHandler(QObject *parent) :
    QObject(parent),
    mp_wm(NULL)
{
    isActived = false;
}

LayoutHandler::~LayoutHandler()
{
}

void LayoutHandler::init(int port, const char* token)
{
    if (mp_wm != NULL) exit(EXIT_FAILURE);

    mp_wm = new LibWindowmanager();

    if (mp_wm->init(port, token) != 0) {
        exit(EXIT_FAILURE);
    }

    json_object *obj = json_object_new_object();
    json_object_object_add(obj, mp_wm->kKeyDrawingName, json_object_new_string(HOMESCREEN));
    mp_wm->requestSurface(obj);

    mp_wm->set_event_handler(LibWindowmanager::Event_Active, [this](json_object *object) {
        this->isActived = true;
        HMI_DEBUG("HomeScreen","Surface %s got activated!", HOMESCREEN);
    });

    mp_wm->set_event_handler(LibWindowmanager::Event_Inactive, [this](json_object *object) {
        this->isActived = false;
        HMI_DEBUG("HomeScreen","Surface %s got deactivated!", HOMESCREEN);
    });

	mp_wm->set_event_handler(LibWindowmanager::Event_Visible, [](json_object *object) {
		HMI_DEBUG("HomeScreen","Surface %s  got visibled!", HOMESCREEN);
	});

	mp_wm->set_event_handler(LibWindowmanager::Event_Invisible, [](json_object *object) {
		HMI_DEBUG("HomeScreen","Surface %s  got invisibled!", HOMESCREEN);
	});

    mp_wm->set_event_handler(LibWindowmanager::Event_SyncDraw, [this](json_object *object) {
        HMI_DEBUG("HomeScreen","Surface %s got syncDraw!", HOMESCREEN);
        HMI_DEBUG("HomeScreen","Try to endDraw Surface %s Start!", HOMESCREEN);
        json_object *obj = json_object_new_object();
        json_object_object_add(obj, mp_wm->kKeyDrawingName, json_object_new_string(HOMESCREEN));
        this->mp_wm->endDraw(obj);
        HMI_DEBUG("HomeScreen","Try to endDraw Surface %s End!", HOMESCREEN);
    });

    mp_wm->set_event_handler(LibWindowmanager::Event_FlushDraw, [](json_object *object) {
        HMI_DEBUG("HomeScreen","Surface %s got flushDraw!", HOMESCREEN);
    });
}

void LayoutHandler::activateSurface()
{
    json_object *obj = json_object_new_object();
    json_object_object_add(obj, mp_wm->kKeyDrawingName, json_object_new_string(HOMESCREEN));
    json_object_object_add(obj, mp_wm->kKeyDrawingArea, json_object_new_string("normal.full"));
    mp_wm->activateSurface(obj);
}

void LayoutHandler::slotActivateSurface()
{
    if(isActived)
        return;
    HMI_DEBUG("HomeScreen","called");
    this->activateSurface();
}

void LayoutHandler::slotHomeButton()
{
    HMI_DEBUG("HomeScreen","called");
    this->activateSurface();
}
