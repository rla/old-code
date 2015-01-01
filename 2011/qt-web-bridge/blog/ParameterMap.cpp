#include "ParameterMap.h"

ParameterMap::ParameterMap(const QVariantMap &map) : map(map) {}

QString ParameterMap::getString(const QString &name) const
{
    return map[name].toList().value(0).toString();
}

QDate ParameterMap::getDate(const QString &name) const
{
    return QDate::fromString(getString(name), "yyyy-MM-dd");
}
