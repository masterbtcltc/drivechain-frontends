# LitWindow Setup Checklist

LitWindow is the Litecoin/Liteverse signet adaptation branch of the upstream BitWindow frontend. The current branch has passed Go checks, but Dart/Flutter UI checks are pending when the Flutter toolchain is unavailable on the host.

## Flutter Toolchain

Install the Flutter SDK and use the Dart executable bundled with Flutter. This repo currently pins Flutter `3.41.6` in the app package constraints and CI workflows.

Verify the toolchain:

```bash
flutter --version
dart --version
```

Run shared UI checks:

```bash
cd sail_ui
flutter pub get
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

Run LitWindow app checks:

```bash
cd ../bitwindow
flutter pub get
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

Do not sign, package, publish, or upload artifacts as part of these local checks.

## Local Config Safety

Real LitWindow local config files are intentionally ignored:

- `bitwindow-bitcoin.conf`
- `bitwindow-enforcer.conf`
- `lib/config.dart`

Copy the matching `.example` files for local use and replace placeholders locally. Never commit real RPC credentials, cookies, wallet paths, private keys, or machine-local settings.

## Liteverse Bridge Status

LitWindow includes a read-only Liteverse Bridge Status panel under Sidechains.
The panel reads the local Liteverse Ops API and presents LiteverseEVM as the
slot 1 Litecoin/Liteverse sidechain.

- LiteverseEVM sidechain slot: `1`
- Litecoin network: Litecoin Core Signet
- The panel is read-only: it does not create peg-ins or peg-outs, sign transactions, activate slots, redeploy contracts, or modify Litecoin/enforcer/Besu/relayer/Ops state
- If slot 1 data is unavailable, the panel reports that directly instead of falling back to historical migration slots
- BMM/H* and M6/peg-out fields show `not available` until the local APIs expose those details directly
