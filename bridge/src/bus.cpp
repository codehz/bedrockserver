#include <systemd/sd-bus.h>
#include <functional>

#include <log.h>

extern "C" const char* bridge_version();
extern std::function<void(std::string, std::function<void(std::string)>)>
    execCommand;
extern bool killed;
static sd_bus* bus = nullptr;
static unsigned rid = 0;

extern "C" sd_bus* get_dbus() {
  return bus;
}

static int method_pong(sd_bus_message* m,
                       void* userdata,
                       sd_bus_error* ret_error) {
  sd_bus_reply_method_return(m, "s", bridge_version());
}

static int method_exec(sd_bus_message* m,
                       void* userdata,
                       sd_bus_error* ret_error) {
  char* dat;
  int current_rid = rid++;
  sd_bus_message_read(m, "s", &dat);
  sd_bus_reply_method_return(m, "u", current_rid);
  if (!execCommand) return 0;
  execCommand(dat, [current_rid](auto data) {
    sd_bus_message* result = NULL;
    int r = sd_bus_message_new_signal(bus, &result, "/", "bedrockserver.core",
                                      "exec_result");
    if (r < 0)
      goto finish;
    sd_bus_message_append(result, "us", current_rid, data.c_str());
    sd_bus_send(bus, result, NULL);
  finish:
    sd_bus_message_unrefp(&result);
    if (r < 0)
      Log::error("DBUS", "%s", strerror(-r));
  });
}

static const sd_bus_vtable core_vtable[] = {
    SD_BUS_VTABLE_START(0),
    SD_BUS_METHOD("ping", "", "s", method_pong, SD_BUS_VTABLE_UNPRIVILEGED),
    SD_BUS_METHOD("exec", "s", "u", method_exec, SD_BUS_VTABLE_UNPRIVILEGED),
    SD_BUS_SIGNAL("exec_result", "us", 0),
    SD_BUS_SIGNAL("log", "yss", 0),
    SD_BUS_VTABLE_END};

void dbus_log(int level, const char* tag, const char* data) {
  if (strcmp(tag, "DBUS") == 0 || !bus)
    return;
  sd_bus_message* m = NULL;
  int r = sd_bus_message_new_signal(bus, &m, "/", "bedrockserver.core", "log");
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
  r = sd_bus_open_user(&bus);
  if (r < 0)
    goto dump;
  Log::info("DBUS", "Starting...");
  r = sd_bus_request_name(bus, name, 0);
  if (r < 0)
    goto finish;
  r = sd_bus_add_object_vtable(bus, &slot, "/", "bedrockserver.core",
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
}

void dbus_thread() {
  int r = 0;
  while (!killed) {
    r = sd_bus_process(bus, NULL);
    if (r < 0)
      goto finish;

    if (r > 0)
      continue;
    r = sd_bus_wait(bus, (uint64_t)100000);
    if (r < 0)
      goto finish;
  }
finish:
  Log::info("DBUS", "Stoping...");
  bus = NULL;
  sd_bus_slot_unref(slot);
  sd_bus_unref(bus);
dump:
  if (r < 0) {
    Log::error("DBUS", "%s", strerror(-r));
  }
}