#include <systemd/sd-bus.h>

#include <log.h>

extern bool killed;
static sd_bus* bus = NULL;

static int method_pong(sd_bus_message* m,
                       void* userdata,
                       sd_bus_error* ret_error) {
  sd_bus_reply_method_return(m, "s", "pong");
}

static const sd_bus_vtable core_vtable[] = {
    SD_BUS_VTABLE_START(0),
    SD_BUS_METHOD("ping", "", "s", method_pong, SD_BUS_VTABLE_UNPRIVILEGED),
    SD_BUS_SIGNAL("log", "yss", 0), SD_BUS_VTABLE_END};

void dbus_log(int level, const char* tag, const char* data) {
  if (*(int*)tag == 'DBUS' || !bus)
    return;
  sd_bus_message* m = NULL;
  int r = sd_bus_message_new_signal(bus, &m, "/bedrockserver/core",
                                    "bedrockserver.core", "log");
  if (r < 0)
    goto finish;
  sd_bus_message_append(m, "yss", (int8_t)level, tag, data);
  r = sd_bus_send(bus, m, NULL);
  if (r < 0)
    goto finish;
finish:
  sd_bus_message_unrefp(&m);
  if (r < 0)
    Log::error("DBUS", "%s", strerror(-r));
}

void dbus_thread() {
  sd_bus_slot* slot = NULL;
  int r = 0;
  r = sd_bus_open_user(&bus);
  if (r < 0)
    goto dump;
  Log::info("DBUS", "Starting...");
  r = sd_bus_request_name(bus, "one.codehz.bedrockserver", 0);
  if (r < 0)
    goto finish;
  r = sd_bus_add_object_vtable(bus, &slot, "/bedrockserver/core",
                               "bedrockserver.core", core_vtable, NULL);
  if (r < 0)
    goto finish;

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