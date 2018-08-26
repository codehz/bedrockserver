#pragma once

#include <cstdlib>
#include <vector>
#include <cstdarg>

#define LogFuncDef(name, logLevel)                         \
  static void name(const char *tag, const char *text, ...) \
  {                                                        \
    va_list args;                                          \
    va_start(args, text);                                  \
    vlog(logLevel, tag, text, args);                       \
    va_end(args);                                          \
  }
enum class LogLevel : int
{
  TRACE = 0,
  DEBUG = 1,
  INFO = 2,
  NOTICE = 3,
  WARN = 4,
  ERROR = 5,
  FATAL = 6,
};

class Log
{

public:
  static inline const char *getLogLevelString(LogLevel lvl)
  {
    if (lvl == LogLevel::TRACE)
      return "Trace";
    if (lvl == LogLevel::DEBUG)
      return "Debug";
    if (lvl == LogLevel::INFO)
      return "Info";
    if (lvl == LogLevel::WARN)
      return "Warn";
    if (lvl == LogLevel::ERROR)
      return "Error";
    return "?";
  }

  static void vlog(LogLevel level, const char *tag, const char *text, va_list args);

  static void log(LogLevel level, const char *tag, const char *text, ...)
  {
    va_list args;
    va_start(args, text);
    vlog(level, tag, text, args);
    va_end(args);
  }

  LogFuncDef(trace, LogLevel::TRACE)
  LogFuncDef(debug, LogLevel::DEBUG)
  LogFuncDef(info, LogLevel::INFO)
  LogFuncDef(notice, LogLevel::NOTICE)
  LogFuncDef(warn, LogLevel::WARN)
  LogFuncDef(error, LogLevel::ERROR)
  LogFuncDef(fatal, LogLevel::FATAL)
};

#undef LogFuncDef