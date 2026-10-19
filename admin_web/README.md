# NovaSys Admin Web — Phase 1

Shared administrator shell and Overview, based on all 22 references in
`../design_reference/SVG/`, with `47-Admin-Overview.svg` as the primary target.

Run from this directory:

```sh
flutter pub get
flutter run -d chrome
```

Validation:

```sh
flutter analyze
flutter test
```

The feature-based MVC structure lives in `lib/features/`. Shell selection uses
`ShellController`; `OverviewController` exposes immutable typed sample records.
Shared visual components live in `lib/shared/widgets/`, and visual tokens and
typography live in `lib/core/theme/`. No dependencies were added.

At widths below 1000 px, the sidebar becomes a drawer. Overview cards use four,
two, or one column according to available content width, and the panel pairs
stack below 900 px of content width. Navigation and Overview actions open a
consistent placeholder for each of the 21 future destinations.

The map is a locally painted illustrative schematic. All records and the
19 October 2026 morning date are deterministic mock data matching the reference.
Sign out explains that this preview has no signed-in session.

Tests cover shell selection, sample totals, navigation to every placeholder,
returning to Overview, the mobile drawer, and layouts at 1440, 1024, 768 and
390 px. Browser appearance is ready for visual review; no backend is connected.
