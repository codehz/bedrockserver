#include <systemd/sd-bus.h>
#include <systemd/sd-journal.h>
#include <functional>
#include <condition_variable>

#include <log.h>

extern "C" const char* bridge_version();
extern std::function<std::string(std::string)> execCommand;
extern std::function<void(std::function<void()>)> queueForServerThread;
extern bool killed;
static sd_bus* bus = nullptr;

extern "C" sd_bus* get_dbus() {
  return bus;
}

extern "C" const char* (*_exec_hook)(const char*);
const char* (*_exec_hook)(const char*) = nullptr;

static int method_pong(sd_bus_message* m,
                       void* userdata,
                       sd_bus_error* ret_error) {
  sd_bus_reply_method_return(m, "s", bridge_version());
}

static int method_exec(sd_bus_message* m,
                       void* userdata,
                       sd_bus_error* ret_error) {
  char* dat;
  sd_bus_message_read(m, "s", &dat);
  auto custom = _exec_hook ? _exec_hook(dat) : nullptr;
  auto data = custom ? custom : execCommand(dat);
  sd_bus_reply_method_return(m, "s", data.c_str());
}


static int method_stop(sd_bus_message* m,
                       void* userdata,
                       sd_bus_error* ret_error) {
  sd_bus_reply_method_return(m, "");
  killed = true;
}

static const sd_bus_vtable core_vtable[] = {
    SD_BUS_VTABLE_START(0),
    SD_BUS_METHOD("ping", "", "s", method_pong, SD_BUS_VTABLE_UNPRIVILEGED),
    SD_BUS_METHOD("exec", "s", "s", method_exec, SD_BUS_VTABLE_UNPRIVILEGED),
    SD_BUS_METHOD("stop", "", "", method_stop, SD_BUS_VTABLE_UNPRIVILEGED),
    SD_BUS_SIGNAL("log", "yss", 0),
    SD_BUS_VTABLE_END};

int priMap[] = {
  LOG_DEBUG,
  LOG_DEBUG,
  LOG_INFO,
  LOG_NOTICE,
  LOG_WARNING,
  LOG_ERR,
  LOG_EMERG
};

void dbus_log(int level, const char* tag, const char* data) {
  sd_journal_print(priMap[level], "[%s] %s", tag, data);
  if (strcmp(tag, "DBUS") == 0 || !bus)
    return;
  sd_bus_message* m = NULL;
  int r = sd_bus_message_new_signal(bus, &m, "/one/codehz/bedrockserver", "one.codehz.bedrockserver.core", "log");
  if (r < 0)
    goto finish;
  sd_bus_message_append(m, "yss", (int8_t)level, tag, data);
  r = sd_bus_send(bus, m, NULL);
finish:
  sd_bus_message_unrefp(&m);
  if (r < 0)
    Log::error("DBUS", "%s", strerror(-r));
}

sd_bus_slot* slot = NULL;

void dbus_init(char* name) {
  int r = 0;
  r = sd_bus_open_system(&bus);
  if (r < 0)
    goto dump;
  Log::info("DBUS", "Starting...");
  r = sd_bus_request_name(bus, name, 0);
  if (r < 0)
    goto finish;
  r = sd_bus_add_object_vtable(bus, &slot, "/one/codehz/bedrockserver", "one.codehz.bedrockserver.core",
                               core_vtable, NULL);
  if (r < 0)
    goto finish;
  return;
finish:
  Log::info("DBUS", "Stoping...");
  bus = NULL;
  sd_bus_slot_unref(slot);
  sd_bus_unref(bus);
dump:
  if (r < 0) {
    Log::error("DBUS", "%s", strerror(-r));
  }
  exit(2);
}

static std::condition_variable cv;
static std::mutex mtx;

void dbus_loop() {
  int r = 0;
  bool ready = false;
  while (!killed) {
    if (queueForServerThread) {
      queueForServerThread([&] {
        std::unique_lock<std::mutex> lk(mtx);
        r = sd_bus_process(bus, NULL);
        ready = true;
        lk.unlock();
        cv.notify_one();
      });
      std::unique_lock<std::mutex> lk(mtx);
      cv.wait(lk, [&] { return ready; });
      ready = false;
    } else {
      r = sd_bus_process(bus, NULL);
    }
    if (r < 0)
      break;

    if (r > 0)
      continue;
    r = sd_bus_wait(bus, (uint64_t)-1);
    if (r < 0)
      break;
  }
  if (r < 0) {
    Log::error("DBUS", "%s", strerror(-r));
  }
}

void dbus_stop() {
  Log::info("DBUS", "Stoping...");
  bus = NULL;
  sd_bus_slot_unref(slot);
  sd_bus_unref(bus);
}