#ifndef ENTRY_H
#define ENTRY_H

#include <QObject>
#include <QDate>
#include <QSharedPointer>

class Entry : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int id READ getId WRITE setId)
    Q_PROPERTY(QString title READ getTitle WRITE setTitle)
    Q_PROPERTY(QDate submitDate READ getSubmitDate WRITE setSubmitDate)
    Q_PROPERTY(QString contents READ getContents WRITE setContents)
public:
    explicit Entry(QObject *parent = 0);

    void setId(int id);

    void setSubmitDate(const QDate &date);

    void setTitle(const QString &title);

    void setContents(const QString &contents);

    int getId() const;

    QDate getSubmitDate() const;

    QString getTitle() const;

    QString getContents() const;

private:
    int id;
    QDate submitDate;
    QString title;
    QString contents;
};

typedef QSharedPointer<Entry> EntryPointer;

#endif // ENTRY_H
