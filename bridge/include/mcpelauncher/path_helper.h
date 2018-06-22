#pragma once

#include <string>
#include <vector>

class PathHelper
{
private:
  static std::string const appDirName;

  static std::string findAppDir();

public:
  static bool fileExists(std::string const &path);

  static std::string getParentDir(std::string const &path);

  static std::string getWorkingDir();

  static std::string findDataFile(std::string const &path);

  static std::string getPrimaryDataDirectory()
  {
    return findAppDir() + "/data";
  }

  static std::string getSecondaryDataDirectory()
  {
    return findAppDir() + "/user";
  }

  static std::string getCacheDirectory()
  {
    return findAppDir() + "/cache";
  }

  static std::string getUserDirectory()
  {
    return findAppDir() + "/user";
  }

  static std::string getWorldsDirectory()
  {
    return findAppDir() + "/worlds";
  }
};