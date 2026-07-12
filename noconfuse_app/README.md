# NoConfuse — Flutter App

A Flutter conversion of the NoConfuse electronics price-comparison website
(originally an HTML/CSS/JS + PHP site). All 70 products, categories, price
comparisons, search, filters, wishlist, sign-in, "top rated" and "new
launches" shelves, and a "book a demo" form are reproduced natively.

## What's included

```
lib/
  main.dart                     - app entry point
  theme.dart                    - colors, ThemeData, category icons
  models/product.dart           - Product model (best/worst price, savings)
  data/products_data.dart       - all 70 products, generated from data.js
  data/store_links.dart         - store URL builders (Amazon, Flipkart, ...)
  providers/app_state.dart      - search/filter/sort, auth, wishlist state
  screens/
    home_screen.dart            - search, categories, deals grid, results
    product_detail_screen.dart  - full specs + store price comparison
    auth_screen.dart            - sign in / create account (stored on-device)
    top_rated_screen.dart       - top rated picks + wishlist view
    new_launches_screen.dart    - "New Collection" shelf
    book_demo_screen.dart       - demo request form
  widgets/
    product_card.dart
    store_price_strip.dart
    category_strip.dart
    deals_grid.dart
  utils/formatters.dart         - ₹ Indian-style number formatting
pubspec.yaml
```

## What's different from the website

- The PHP backend (`api/*.php`) isn't used — all 70 products are bundled
  in `lib/data/products_data.dart` so the app works fully offline, the same
  way the site's own sample dataset does today (`data.js`).
- Sign-in/registration is stored locally on-device (via `shared_preferences`)
  rather than the PHP session/MySQL backend — good enough for a demo, but
  swap in real API calls in `app_state.dart` if you want it backed by your
  server (the `api/` folder from your original zip already has the login,
  register and session endpoints ready to call).
- "View at store" buttons open the real, live Amazon / Flipkart / Croma /
  Reliance Digital / Google search links in the phone's browser, exactly
  like the website.

## Important — about the APK

This build sandbox does not have the Flutter SDK or Android SDK installed,
and its network access is locked to package registries (npm, pip, crates,
GitHub) — it cannot download Flutter, the Android SDK/build tools, or
Gradle. So **I generated the complete, ready-to-build source code, but I
could not compile the actual `.apk` file here.** You'll need to build it
yourself (it's quick — see below) or use a free cloud build service.

### Option A — Build locally (fastest if you already use Flutter)

1. Install Flutter: https://docs.flutter.dev/get-started/install
2. Unzip this project, then in the project folder run:
   ```
   flutter create .        # scaffolds android/ios/web folders (safe — won't touch lib/ or pubspec.yaml)
   flutter pub get
   flutter build apk --release
   ```
3. Your APK will be at `build/app/outputs/flutter-apk/app-release.apk`.
4. To install straight to a plugged-in Android phone instead:
   `flutter install`

### Option B — No local setup: build in the cloud

If you don't want to install Flutter/Android Studio, upload this project
folder to a free CI service and it will hand you back an APK:
- **Codemagic** (https://codemagic.io) — has a Flutter quick-start that
  builds an APK from a zipped project or GitHub repo, free tier available.
- **GitHub Actions** — push this folder to a GitHub repo and add the
  `subosito/flutter-action` step in a workflow to run
  `flutter build apk --release`; the APK is uploaded as a build artifact.

### Option C — FlutterFlow / online IDE

Tools like Replit or Codespaces sometimes support installing the Flutter
SDK and Android command-line tools inside the container and building
there — same commands as Option A once the SDK is present.

## Running in an emulator/simulator while developing

```
flutter pub get
flutter run
```

## Notes

- Minimum Flutter SDK: 3.3+ (uses Material 3, `RangeSlider`, standard
  packages only — `provider`, `shared_preferences`, `url_launcher`).
- No external image assets are used (icons are drawn with Flutter's
  Material icon set), so there's nothing extra to bundle for the build to
  succeed offline.
