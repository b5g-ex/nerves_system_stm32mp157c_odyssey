# ODYSSEY - STM32MP157C Support

This is the base Nerves System configuration for the [ODYSSEY - STM32MP157C](https://www.seeedstudio.com/ODYSSEY-STM32MP157C-p-4464.html).

![ODYSSEY - STM32MP157C](assets/images/stm32mp157c_odyssey.png)
This image is from [Seeed](https://www.seeedstudio.com/ODYSSEY-STM32MP157C-p-4464.html).

| Feature              | Description                                                 |
| -------------------- | ----------------------------------------------------------- |
| CPU                  | 650MHz Dual-core Arm-Cortex-A7 with Cortex-M4 integrated    |
| Memory               | 512MB DDR3 RAM                                              |
| Storage              | 4GB EMMC and MicroSD                                        |
| Linux kernel         | 5.10 w/ RCN patches                                         |
| IEx terminal         | UART `ttySTM0`                                              |
| GPIO, I2C, SPI       | Yes - [Elixir Circuits](https://github.com/elixir-circuits) |
| ADC                  | No                                                          |
| PWM                  | Yes, but no Elixir support                                  |
| UART                 | ttySTM0                                                     |
| Display              | MIPI DSI display interface, not supported yet               |
| Camera               | DVP camera interface, not supported yet                     |
| Ethernet             | Yes (eth0)                                                  |
| WiFi                 | Yes (wlan0)                                                 |
| Bluetooth            | Yes (hci0), not confirmed yet                               |
| Audio                | 3.5mm audio interface, not supported yet                    |
| RTC                  | 3VRTC battery interface                                     |


## Using

This port currently only runs off a SD card.

The most common way of using this Nerves System is create a project with `mix
nerves.new` and add `stm32mp157c_odyssey` references where needed and in a similar way
to the default systems like `bbb`, etc. Then export `MIX_TARGET=stm32mp157c_odyssey`.
See the [Getting started guide](https://hexdocs.pm/nerves/getting-started.html#creating-a-new-nerves-app)
for more information.

If you need custom modifications to this system for your device, clone this
repository and update as described in [Making custom systems](https://hexdocs.pm/nerves/systems.html#customizing-your-own-nerves-system).


## Networking

The board has one 1 Gbps Ethernet interface and one WiFi interface. Here's an example `:vintage_net`
configuration that enables both of them:

For WiFi configuration, see. https://hexdocs.pm/vintage_net/cookbook.html#normal-password-protected-wifi-wpa2-psk

```elixir
config :vintage_net,
  regulatory_domain: "US",
  config: [
    {"eth0", %{type: VintageNetEthernet, ipv4: %{method: :dhcp}}},
    {"wlan0", %{type: VintageNetWiFi}}
  ]
```

