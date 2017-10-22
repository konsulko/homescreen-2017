/*
 * Copyright (C) 2016 The Qt Company Ltd.
 * Copyright (C) 2016, 2017 Mentor Graphics Development (Deutschland) GmbH
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

#include "applicationlauncher.h"

#include "afm_user_daemon_proxy.h"

#include <QtCore/QDebug>

extern org::AGL::afm::user *afm_user_daemon_proxy;

ApplicationLauncher::ApplicationLauncher(QObject *parent)
    : QObject(parent)
{
}

int ApplicationLauncher::launch(const QString &application)
{
    int result = -1;
    qDebug() << "ApplicationLauncher launch" << application;

    result = afm_user_daemon_proxy->start(application).value().toInt();
    qDebug() << "ApplicationLauncher pid:" << result;

    if (result > 1) {
        setCurrent(application);
    }

    return result;
}

QString ApplicationLauncher::current() const
{
    return m_current;
}

void ApplicationLauncher::setCurrent(const QString &current)
{
    if (m_current == current) return;
    m_current = current;
    emit currentChanged(current);
}
