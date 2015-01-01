#include "Entry.h"

Entry::Entry(QObject *parent) : QObject(parent) {}

void Entry::setId(int id)
{
    this->id = id;
}

int Entry::getId() const
{
    return id;
}

void Entry::setSubmitDate(const QDate &date)
{
    this->submitDate = date;
}

void Entry::setTitle(const QString &title)
{
    this->title = title;
}

void Entry::setContents(const QString &contents)
{
    this->contents = contents;
}

QString Entry::getContents() const
{
    return contents;
}

QString Entry::getTitle() const
{
    return title;
}

QDate Entry::getSubmitDate() const
{
    return submitDate;
}
