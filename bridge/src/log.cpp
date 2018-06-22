#include "../include/log.h"
#include <cstdio>
#include <ctime>

extern "C" void mcpelauncher_log(LogLevel level, const char *data);

void Log::vlog(LogLevel level, const char *tag, const char *text, va_list args)
{
  char buffer[4096];
  char buffer2[4096];
  vsnprintf(buffer, sizeof(buffer), text, args);
  snprintf(buffer2, sizeof(buffer2), "[%s] %s", tag, buffer);
  mcpelauncher_log(level, buffer2);
}