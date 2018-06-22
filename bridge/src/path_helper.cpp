#include <mcpelauncher/path_helper.h>
#include <unistd.h>
#include <sys/stat.h>
#include <pwd.h>
#include <stdexcept>
#include <cstring>
#include <climits>
#include <cstdlib>
#ifdef __APPLE__
#include <sys/param.h>
#include <mach-o/dyld.h>
#endif

std::string const PathHelper::appDirName = "bedrockserver";

std::string PathHelper::findAppDir() {
#ifdef __APPLE__
    char buf[MAXPATHLEN];
    char tbuf[MAXPATHLEN];
    uint32_t size = sizeof(tbuf) - 1;
    if (_NSGetExecutablePath(tbuf, &size) || size <= 0)
        return std::string();
    if (!realpath(tbuf, buf))
        return std::string();
    size = strlen(buf);
#else
    char buf[PATH_MAX];
    ssize_t size = readlink("/proc/self/exe", buf, sizeof(buf) - 1);
    if (size <= 0)
        return std::string();
#endif
    buf[size] = '\0';
    char* dirs = strrchr(buf, '/');
    if (dirs != nullptr)
        dirs[0] = '\0';
    return std::string(buf);
}

std::string PathHelper::getWorkingDir() {
    char _cwd[256];
    getcwd(_cwd, 256);
    return std::string(_cwd) + "/";
}

std::string PathHelper::getParentDir(std::string const& path) {
    auto i = path.rfind('/', path.length() - 1); // we don't want to get the last / if the string ends up with a slash
    if (i == std::string::npos)
        return std::string();
    return path.substr(0, i);
}

bool PathHelper::fileExists(std::string const& path) {
    struct stat sb;
    return !stat(path.c_str(), &sb);
}

std::string PathHelper::findDataFile(std::string const& path) {
    std::string p = getPrimaryDataDirectory() + "/" + path;
    if (fileExists(p))
        return p;
    throw std::runtime_error("Failed to find data file: " + p);
}