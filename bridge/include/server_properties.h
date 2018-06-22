#pragma once

// #include <properties/property.h>
#include <string>
#include <sstream>
#include <fstream>
#include <cstdlib>
#include <mcpelauncher/path_helper.h>
#include <minecraft/Level.h>

extern "C" const char *mcpelauncher_property_get(const char *, const char *);

template <typename T>
std::string asString(const T &n)
{
  std::ostringstream stm;
  stm << n;
  return stm.str();
}
template <>
std::string asString<bool>(const bool &n)
{
  return n ? "true" : "false";
}

template <typename T>
T asT(const char *str);

template <>
std::string asT<std::string>(const char *str)
{
  return std::string(str);
}

template <>
int asT<int>(const char *str)
{
  return atoi(str);
}

template <>
float asT<float>(const char *str)
{
  return atof(str);
}

template <>
bool asT<bool>(const char *str)
{
  if (str == "0" || str == "false") return false;
  return true;
}

template <typename T>
struct property
{
  const char *name;
  T value;
  property(const char *name, T default_value) : name(name), value(default_value)
  {
    value = asT<T>(mcpelauncher_property_get(name, asString(default_value).c_str()));
  }
  operator T() { return value; }
  T get() { return value; }
};

class ServerProperties
{

public:
  property<std::string> worldDir;
  property<std::string> worldName;
  property<int> worldGenerator;
  property<std::string> motd;
  property<std::string> worldSeed;
  property<int> gamemode;
  property<bool> forceGamemode;
  property<int> difficulty;
  property<int> port;
  property<int> portV6;
  property<int> maxPlayers;
  property<int> viewDistance;
  property<bool> onlineMode;
  property<float> playerIdleTimeout;

  ServerProperties() : worldDir("level-dir", "world"),
                       worldName("level-name", "world"),
                       worldSeed("level-seed", "0"),
                       worldGenerator("level-generator", 1),
                       motd("motd", "A Minecraft Server"),
                       gamemode("gamemode", 0),
                       forceGamemode("force-gamemode", false),
                       difficulty("difficulty", 0),
                       port("server-port", 19132),
                       portV6("server-port-v6", 19133),
                       maxPlayers("max-players", 20),
                       viewDistance("view-distance", 22),
                       onlineMode("online-mode", true),
                       playerIdleTimeout("player-idle-timeout", 0.f)
  {
  }
};