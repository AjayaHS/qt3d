/****************************************************************************
**
** Copyright (C) 2014 Klaralvdalens Datakonsult AB (KDAB).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt3D module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "effect.h"
#include "technique.h"

#include <QDebug>

namespace Qt3D {

Effect::Effect(Node *parent)
    : Node(parent)
{
    qRegisterMetaType<Qt3D::Effect*>();
    qDebug() << Q_FUNC_INFO;
}


QQmlListProperty<Qt3D::Technique> Effect::techniqueList()
{
    return QQmlListProperty<Qt3D::Technique>(this, m_techniques);
}

void Effect::addTechnique(Technique *t)
{
    Q_ASSERT(t);
    t->setParent(this);
    m_techniques.append(t);
    emit techniquesChanged();
}

QList<Technique *> Effect::techniques() const
{
    return m_techniques;
}

void Effect::clearTechniques()
{
    qDeleteAll(m_techniques);
    m_techniques.clear();
}

} // of namespace