# Smart bulb controller app

A replica of the original **WizV2** app designed to connect to **WiZ smart bulbs** using UDP over a local network.

## Features

- Turn lights on and off (Power control)
- Adjust brightness
- Select scenes via SceneId
- Connect via the local network using the bulb's IP address using UDP

## Architecture & Technical Highlights

- Designed using the **MVVM (Model-View-ViewModel)** architectural pattern for clean, scalable, and testable code.
- Implements **async/await** for efficient handling of asynchronous operations.
- Implements **network throttling** to reduce network load
- Focused on **object-oriented design** principles to enhance maintainability and extensibility.

## Disclaimer

This project is independent and not affiliated with WiZ or its development team.
