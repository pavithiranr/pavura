# 🚖 Pavura: Malaysia Public Transport & Ride-Hailing App

**Pavura** is a Flutter-based intelligent transport app designed for Malaysia. It integrates **GTFS Realtime APIs**, **ride-hailing**, and **multi-modal travel** (bus, train, and taxi) into one seamless mobile experience.

---

## 🚀 Features

* 🚌 **Bus Tracking (GTFS Realtime)** – Live bus location for myBAS Johor Bahru, Prasarana Rapid KL, MRT Feeder, and more
* 🚆 **Train Schedule & Tracking** – KTMB and Rapid Rail integration (using GTFS Static & Realtime data)
* 🚖 **Ride-Hailing Module** – Book taxis or rides with origin/destination selection and fare comparison
* 🗺️ **Map Integration** – Real-time map with markers, clustering, and user location tracking
* 💰 **Price Comparison** – Compare estimated fares between Pavura rides and public transport options
* 🔐 **User Authentication** – Login, register, and manage user profiles
* 🏠 **Smart Home Screen** – Quick access to nearby stops, recent routes, and personalized suggestions

---

## 📦 Tech Stack

* **Framework**: Flutter (Dart)
* **Database**: MySQL (via backend API)
* **Map Service**: Google Maps API / OpenStreetMap (via `flutter_map`)
* **Transit Data**: GTFS Static & GTFS Realtime API (from [data.gov.my](https://data.gov.my))
* **Backend**: Node.js or PHP (depending on module)
* **Authentication**: Firebase Auth / Custom API

---

## 🧩 App Modules

| Folder     | Description                                                         |
| ---------- | ------------------------------------------------------------------- |
| `auth/`    | Handles login, signup, and authentication logic                     |
| `bus/`     | Displays GTFS Realtime bus routes and positions                     |
| `train/`   | Shows KTMB and Rapid Rail schedules and live data                   |
| `ride/`    | Ride-hailing interface for origin, destination, and fare comparison |
| `map/`     | Core map widget integration (Google Maps or OSM)                    |
| `home/`    | Dashboard and navigation overview                                   |
| `profile/` | User profile, settings, and saved routes                            |
| `splash/`  | Splash and onboarding screens                                       |

---

## ⚙️ Installation

1. **Clone the Repository**

```bash
git clone https://github.com/your-username/pavura_app.git
cd pavura_app
```

2. **Install Dependencies**

```bash
flutter pub get
```

3. **Run the App**

```bash
flutter run
```

---

## 📡 GTFS Realtime API Example

**Endpoint Format**

```bash
GET https://api.data.gov.my/gtfs-realtime/vehicle-position/prasarana?category=<category>
```

**Available Categories**

* `rapid-bus-kl`
* `rapid-bus-mrtfeeder`
* `rapid-bus-kuantan`
* `rapid-bus-penang`

> Note: Realtime feed for `rapid-rail-kl` may not always be stable.

---

## 🧠 How Pavura Works

1. Fetches **GTFS Static** and **Realtime** data for Malaysian transport agencies.
2. Parses `.proto` files using `gtfs_realtime_bindings`.
3. Displays vehicles and routes dynamically on an interactive map.
4. Integrates **ride-hailing logic** with fare estimation and origin/destination selection.
5. Provides **multi-modal suggestions** (bus, train, or ride) based on user’s journey.

---

## 🪪 License

This project is open-source and available under the **MIT License**.

---

## 🙌 Credits

* [Data.gov.my GTFS APIs](https://data.gov.my)
* [OpenStreetMap](https://www.openstreetmap.org/)
* [Google Maps Platform](https://developers.google.com/maps)
* [GTFS Realtime](https://developers.google.com/transit/gtfs-realtime)

---

Would you like me to format this README with **badges**, **screenshots placeholders**, and a **“Getting Started”** section (for better GitHub presentation)?
