#ifndef PARAMETERMAP_H
#define PARAMETERMAP_H

#include <QVariant>
#include <QDate>

/*! @brief Helper class for working with parameters. */
class ParameterMap
{
public:
    ParameterMap(const QVariantMap &map);

    /*! @brief Returns string value. */
    QString getString(const QString &name) const;

    QDate getDate(const QString &name) const;

private:
    QVariantMap map;
};

#endif // PARAMETERMAP_H
