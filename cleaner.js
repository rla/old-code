var fs = require('fs');
var child_process = require('child_process');
var tmp = require('tmp');
var program = require('commander');
var Promise = require('bluebird');
var readdir = Promise.promisify(fs.readdir);
var rename = Promise.promisify(fs.rename);
var unlink = Promise.promisify(fs.unlink);
var stat = Promise.promisify(fs.stat);
var execFile = Promise.promisify(child_process.execFile);
var exec = Promise.promisify(child_process.exec);
var tmpName = Promise.promisify(tmp.tmpName);

program.command('check <encoding> <file>').action(check);
program.command('detect <file>').action(detect);
program.command('convert <file>').action(convert);
program.command('convert-all <dir>').action(convert_all);
program.command('validate-all <dir>').action(validate_all);
program.command('remove-nonsource <dir>').action(remove_nonsource);
program.command('remove-dot <dir>').action(remove_dot);

program.parse(process.argv);

function check(encoding, file) {

    if (encoding === 'ISO-8859-15') {

        check_file(iso_8859_15_valid, file).catch(exit_error);

    } else if (encoding === 'CP437') {

        check_file(cp437_valid, file).catch(exit_error);

    } else if (encoding === 'UTF-8') {

        check_file_utf8(file).catch(exit_error);

    } else {

        exit_error('Invalid encoding specified');
    }
}

function detect(file) {

    detect_file(file).then(function(encoding) {

        console.log(encoding);

    }).catch(exit_error);
}

function convert(file) {

    convert_file(file).catch(exit_error);
}

function text_file(name) {

    return !name.toLowerCase()
        .match(/\.(res|gif|ico|bmp|jpg|wav|nsi|doc|pdf|mid|zip|is|db|png|out|sxsch|jpeg|grm|dia|jar|ods|avi|odt|csv|lyx|dvi)$/);
}

function convert_all(dir) {

    file_list(dir).then(function(files) {

        var filtered = files.filter(function(file) {

            return text_file(file);
        });

        return filtered.reduce(function(prev, file) {

            return prev.then(function() {

                return convert_file(file);
            });

        }, Promise.resolve());

    }).catch(exit_error);
}

function validate_all(dir) {

    file_list(dir).then(function(files) {

        var filtered = files.filter(function(file) {

            return text_file(file);
        });

        return filtered.reduce(function(prev, file) {

            return prev.then(function() {

                console.log('Checking ' + file);

                return check_file_utf8(file);
            });

        }, Promise.resolve());

    }).catch(exit_error);
}

function convert_file(file) {

    return detect_file(file).then(function(encoding) {

        console.log('Converting ' + file + ' from ' + encoding);

        if (encoding === 'UTF-8') {

            console.log('Already in UTF-8');

        } else {

            return recode(encoding, file).then(function() {

                console.log('File ' + file + ' encoded');
            });
        }
    });
}

function remove_nonsource(dir) {

    file_list(dir).then(function(files) {

        var filtered = files.filter(function(file) {

            return file.match(/\.(class|o|war|jar)$/) || file.match(/~$/);
        });

        return filtered.reduce(function(prev, file) {

            return prev.then(function() {

                console.log('Removing ' + file);

                return unlink(file);
            });

        }, Promise.resolve());

    }).catch(exit_error);
}

function remove_dot(dir) {

    dot_file_list(dir).then(function(files) {

        return files.reduce(function(prev, file) {

            return prev.then(function() {

                console.log('Removing ' + file);

                return execFile('/usr/bin/rm', ['-r', file]);
            });

        }, Promise.resolve());

    }).catch(exit_error);
}

function exit_error(message) {

    process.stderr.write(message + '\n');
    process.exit(1);
}

function recode(encoding, file) {

    return new Promise(function(resolve, reject) {

        var table;

        if (encoding === 'ISO-8859-15') {

            table = iso_8859_15;

        } else if (encoding === 'CP437') {

            table = cp437;
        }

        tmpName().then(function(path) {

            var temp = fs.createWriteStream(path);

            var stream = fs.createReadStream(file);

            stream.on('data', function(buffer) {

                var out_buffer = new Buffer(buffer.length * 2), len = 0;

                for (var i = 0; i < buffer.length; i++) {

                    var byte = buffer.readUInt8(i);

                    var utf8_bytes = utf8_by_table(table, byte);

                    if (utf8_bytes) {

                        for (var j = 0; j < utf8_bytes.length; j++) {

                            out_buffer.writeUInt8(utf8_bytes[j], len);

                            len += 1;
                        }

                    } else {

                        out_buffer.writeUInt8(byte, len);

                        len += 1;
                    }
                }

                temp.write(out_buffer.slice(0, len));
            });

            stream.on('error', reject);

            stream.on('end', function() {

                temp.end();
            });

            temp.on('close', function() {

                rename(path, file).then(resolve, reject);
            });

        }).catch(reject);
    });
}

// Returns multibyte UTF-8 character
// if it is specified in the UTF-8 table.

function utf8_by_table(table, byte) {

    var keys = Object.keys(table), key;

    for (var i = 0; i < keys.length; i++) {

        if (table[keys[i]] === byte) {

            key = keys[i];

            break;
        }
    }

    return key ? utf8[key] : null;
}

function detect_file(file) {

    console.log('Detecting file ' + file + ' encoding');

    return check_file(iso_8859_15_valid, file).then(function() {

        return 'ISO-8859-15';

    }, function() {

        return check_file(cp437_valid, file).then(function() {

            return 'CP437';

        }, function() {

            return check_file_utf8(file).then(function() {

                return 'UTF-8';
            })
        });
    });
}

// Applies given callback for each
// byte in the file.

function check_file(fn, file) {

    return new Promise(function(resolve, reject) {

        var stream = fs.createReadStream(file);

        stream.on('data', function(buffer) {

            for (var i = 0; i < buffer.length; i++) {

                var byte = buffer.readUInt8(i);

                if (!fn(byte)) {

                    reject(new Error('Invalid ' + byte.toString(16)));

                    break;
                }
            }
        });

        stream.on('error', reject);
        stream.on('end', resolve);
    });
}

// Checks UTF-8 file. Deals with special
// multibyte characters.

function check_file_utf8(file) {

    return new Promise(function(resolve, reject) {

        var stream = fs.createReadStream(file);

        var multibyte;

        stream.on('data', function(buffer) {

            for (var i = 0; i < buffer.length; i++) {

                var byte = buffer.readUInt8(i);

                if (multibyte) {

                    if (!valid_in_set_array(utf8, [multibyte, byte])) {

                        reject('Invalid sequence ' + multibyte.toString(16) + ' ' + byte.toString(16) + '\n');
                    }

                    multibyte = null;

                } else if (byte < 0x20 || byte > 0x7e) {

                    // Outside ascii printable range.

                    // Not a line end or tab.

                    if (byte !== 0x0a && byte !== 0x0d && byte !== 0x09) {

                        // Multibyte start.

                        if (byte === 0xc3 || byte === 0xc5) {

                            multibyte = byte;

                        } else {

                            reject(new Error('Invalid ' + byte.toString(16) + '\n'));
                        }
                    }
                }
            }
        });

        stream.on('error', reject);
        stream.on('end', resolve);
    });
}

var utf8 = {

    'ö': [0xc3, 0xb6],

    'ä': [0xc3, 0xa4],

    'ü': [0xc3, 0xbc],

    'õ': [0xc3, 0xb5],

    'Ö': [0xc3, 0x96],

    'Ä': [0xc3, 0x84],

    'Ü': [0xc3, 0x9c],

    'Õ': [0xc3, 0x95],

    'š': [0xc5, 0xa1],

    'ž': [0xc5, 0xbe],

    'Š': [0xc5, 0xa0],

    'Ž': [0xc5, 0xbd]
};

var cp437 = {

    'ö': 0x94,

    'ä': 0x84,

    'ü': 0x81,

    'õ': 0xe4,

    'Ö': 0x99,

    'Ä': 0x8e,

    'Ü': 0x9a,

    'Õ': 0xe5,

    'š': 0xd0,

    'ž': 0xe7,

    'Š': 0xd1,

    'Ž': 0xe8
};

var iso_8859_15 = {

    'ö': 0xf6,

    'ä': 0xe4,

    'ü': 0xfc,

    'õ': 0xf5,

    'Ö': 0xd6,

    'Ä': 0xc4,

    'Ü': 0xdc,

    'Õ': 0xd5,

    'š': 0xa8,

    'ž': 0xb8,

    'Š': 0xa6,

    'Ž': 0xb4
};

// Checks that the give byte is in the valid
// range for ISO-8859-15.

function iso_8859_15_valid(byte) {

    // Line ends and tab.

    if (byte === 0x0a || byte === 0x0d || byte === 0x09) {

        return true;
    }

    // Copyright symbol.

    if (byte === 0xa9) {

        return true;
    }

    // Ascii printable range.

    if (byte >= 0x20 && byte <= 0x7e) {

        return true;
    }

    // One of the special characters.

    if (valid_in_set(iso_8859_15, byte)) {

        return true;
    }

    return false;
}

// Checks that the give byte is in the valid
// range for ISO-8859-15.

function cp437_valid(byte) {

    // Line ends and tab.

    if (byte === 0x0a || byte === 0x0d || byte === 0x09) {

        return true;
    }

    // "Printable" range.

    if (byte >= 0x20 && byte <= 0x7e) {

        return true;
    }

    // One of the special characters.

    if (valid_in_set(cp437, byte)) {

        return true;
    }

    return false;
}

function valid_in_set(set, byte) {

    var keys = Object.keys(set);

    for (var i = 0; i < keys.length; i++) {

        if (byte === set[keys[i]]) {

            return true;
        }
    }

    return false;
}

function valid_in_set_array(set, array) {

    var keys = Object.keys(set);

    for (var i = 0; i < keys.length; i++) {

        var test = set[keys[i]],
            up = Math.max(test.length, array.length),
            same = true;

        for (var j = 0; j < up; j++) {

            if (j >= test.length || j >= array.length) {

                return false;
            }

            if (test[j] !== array[j]) {

                same = false;
            }
        }

        if (same) {

            return true;
        }
    }

    return false;
}

// Recursively finds all files.

function file_list(dir) {

    var files = [];

    return file_list_rec(dir, files).then(function() {

        return files;
    });

    return files;
}

function file_list_rec(dir, files) {

    return readdir(dir).then(function(entries) {

        return entries.reduce(function(prev, entry) {

            var file = dir + '/' + entry;

            return prev.then(function() {

                return stat(file).then(function(stat_data) {

                    if (stat_data.isDirectory()) {

                        return file_list_rec(file, files);

                    } else {

                        files.push(file);
                    }
                });
            });

        }, Promise.resolve());
    });
}

// Recursively finds all dot files and directories.

function dot_file_list(dir) {

    var files = [];

    return dot_file_list_rec(dir, files).then(function() {

        return files;
    });

    return files;
}

function dot_file_list_rec(dir, files) {

    return readdir(dir).then(function(entries) {

        return entries.reduce(function(prev, entry) {

            var file = dir + '/' + entry;

            return prev.then(function() {

                if (file.indexOf('/.') >= 0) {

                    files.push(file);

                } else {

                    return stat(file).then(function(stat_data) {

                        if (stat_data.isDirectory()) {

                            return dot_file_list_rec(file, files);
                        }
                    });
                }
            });

        }, Promise.resolve());
    });
}
