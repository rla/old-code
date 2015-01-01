#include <QtCore/QCoreApplication>
#include <QTextStream>
#include <QVariantMap>
#include <QList>
#include <QDebug>
#include <iostream>
#include "parser.h"
#include "serializer.h"
#include "qobjecthelper.h"

#include "ParameterMap.h"
#include "Entry.h"

/*! @brief Sends debug output to standard error output. */
static void debugLogHandler(QtMsgType type, const char *msg) {
    Q_UNUSED(type);
    std::cerr << msg << "\n";
    std::cerr.flush();
}

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    Q_UNUSED(a);

    qInstallMsgHandler(debugLogHandler);

    QTextStream out(stdout);
    QTextStream in(stdin);

    int entryId = 0;
    QList<EntryPointer> entries;

    QJson::Parser parser;
    QJson::Serializer serializer;

    QString line;

    while (!in.atEnd())
    {
        line = in.readLine();

        bool ok;
        ParameterMap request = ParameterMap(parser.parse(line.toAscii(), &ok).toMap());
        QVariantMap response;

        if (request.getString("command") == "insert")
        {
            EntryPointer entry(new Entry());

            entry->setId(entryId++);
            entry->setTitle(request.getString("title"));
            entry->setContents(request.getString("contents"));
            entry->setSubmitDate(request.getDate("date"));

            entries << entry;

            response["success"] = true;
        }
        else if (request.getString("command") == "list")
        {
            QVariantList list;

            foreach (EntryPointer entry, entries)
            {
                list << QJson::QObjectHelper::qobject2qvariant(entry.data());
            }

            response["list"] = list;
            response["success"] = true;
        }
        else
        {
            response["success"] = false;
            response["errorMessage"] = "Invalid command";
        }

        out << serializer.serialize(response).replace('\n', QByteArray()).replace('\r', QByteArray());
        out << "\n";
        out.flush();
    }

    return 0;
}
