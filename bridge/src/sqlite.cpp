#include "../include/log.h"
#include <sqlite3/sqlite3.h>

static sqlite3 *db;
static sqlite3_stmt *stmt;

extern "C" void openDB(const char *filename) {
  if (sqlite3_open(filename, &db) != SQLITE_OK) {
    auto msg = sqlite3_errmsg(db);
    Log::fatal("LogDB", "Cannot open database: %s", msg);
    sqlite3_free((void *)msg);
    atexit([]() { sqlite3_close(db); });
  }
  char *err = 0;
  sqlite3_exec(db,
               "CREATE TABLE IF NOT EXISTS Log(id INTEGER PRIMARY KEY "
               "AUTOINCREMENT, time TIMESTAMP DEFAULT CURRENT_TIMESTAMP, level "
               "INT, tag TEXT, data TEXT)",
               nullptr, nullptr, &err);
  if (err) {
    Log::fatal("LogDB", "Cannot create table: %s", err);
    sqlite3_free((void *)err);
  }
  sqlite3_exec(db, "PRAGMA synchronous = OFF; PRAGMA journal_mode = MEMORY", nullptr, nullptr, &err);
  if (sqlite3_prepare_v3(db,
                         "INSERT INTO Log(level, tag, data) VALUES (?, ?, ?)",
                         -1, SQLITE_PREPARE_PERSISTENT, &stmt, nullptr)) {
    auto msg = sqlite3_errmsg(db);
    Log::fatal("LogDB", "Cannot prepare database: %s", msg);
    sqlite3_free((void *)msg);
    atexit([]() { sqlite3_finalize(stmt); });
  }
}

extern "C" void writeLog(LogLevel lvl, const char *tag, const char *data) {
  if (!db || !stmt)
    return;
  sqlite3_reset(stmt);
  sqlite3_bind_int(stmt, 1, (int)lvl);
  sqlite3_bind_text(stmt, 2, tag, -1, nullptr);
  sqlite3_bind_text(stmt, 3, data, -1, nullptr);
  if (sqlite3_step(stmt) == SQLITE_ERROR) {
    auto msg = sqlite3_errmsg(db);
    Log::fatal("LogDB", "Cannot write to database: %s", msg);
    sqlite3_free((void *)msg);
  }
}