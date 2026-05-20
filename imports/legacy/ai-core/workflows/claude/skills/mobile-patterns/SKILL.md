---
name: mobile-patterns
description: Use to implement or adjust mobile features in React Native, Flutter, Swift, or Kotlin, including builds, platform issues, and mobile UX.
when_to_use: >
  Use when implementing a feature in React Native, Flutter, Swift, or Kotlin, configuring a mobile build or fixing a platform issue, or adapting UI or UX for mobile devices.
---

# Mobile Patterns

## When to Use

- Implement features in React Native, Flutter, Swift, or Kotlin
- Configure iOS and Android builds
- Resolve platform-specific behavior or release issues
- Adapt product behavior from web assumptions to mobile realities

## Fundamental Patterns

### Mobile Performance

- Avoid rendering large lists all at once; use virtualization such as `FlatList` or `ListView.builder`
- Deliver images through an optimized CDN with correct sizes and lazy loading where possible
- Run animations on the native thread when the platform supports it
- Keep heavy synchronous work off the main thread

### Navigation

- Keep navigation concerns separate from business logic
- Validate deep-link parameters before use
- Preserve scroll position and view state when users return to a screen

### Offline and Connectivity

- Detect network status before critical operations
- Implement retry with backoff for API calls
- Cache frequently accessed data locally
- Define conflict handling for offline sync

### Mobile Security

- Never store secrets or tokens in source code
- Use Keychain on iOS or Keystore on Android for sensitive data
- Apply certificate pinning only when the threat model and operational cost justify it
- Enable production-safe build hardening, including obfuscation where relevant

### Build and Release

```bash
# React Native — Android release
cd android && ./gradlew assembleRelease

# React Native — iOS release
xcodebuild -workspace ios/App.xcworkspace -scheme App -configuration Release

# Flutter releases
flutter build apk --release
flutter build ios --release
```

## Never Do

- Never request every device permission during onboarding without a clear in-context reason
- Never store auth tokens in insecure local storage when secure platform storage is available
- Never assume emulator behavior matches a real device for performance, notifications, biometrics, camera, or deep links
- Never ship gesture-heavy or custom navigation patterns that fight platform conventions
- Never hide loading, empty, offline, or error states on mobile; a blank screen is a product bug
- Never block the main thread with parsing, crypto, or large JSON transforms during user interaction

## Validation Checklist

- [ ] Tested on at least one real device
- [ ] Tested across key screen sizes
- [ ] Every requested permission has a clear user-facing justification
- [ ] Deep links tested end to end
- [ ] Performance checked on lower-end hardware
- [ ] No sensitive data appears in production logs
- [ ] Release build is signed with the correct certificate or profile

## Steps

### 1. Identify the Target Platform

- **React Native**: JavaScript or TypeScript with shared iOS and Android code
- **Flutter**: Dart with high-fidelity cross-platform UI
- **Swift / SwiftUI**: native Apple-platform development
- **Kotlin / Jetpack Compose**: native Android development

### 2. Map the Required Foundations

Use the fundamental patterns section to decide which concerns matter:

- Navigation
- State management
- HTTP and caching
- Local storage
- Offline behavior

### 3. Implement with Platform Conventions

- Follow Apple Human Interface Guidelines and Android Material guidance where applicable
- Prefer native-feeling components over unnecessary custom controls
- Adapt layouts for safe areas, notches, keyboards, and varying screen sizes

### 4. Validate on Real Devices

- Test on both iOS and Android when the product is cross-platform
- Verify portrait and landscape behavior if the app supports rotation
- Test under poor connectivity and offline conditions

### 5. Complete the Release Checklist

Run the pre-release checklist before store submission or internal distribution.

## Examples

### React Native — Component with loading and error states

```tsx
function OrderList() {
  const { data, isLoading, error, refetch } = useOrders()

  if (isLoading) return <ActivityIndicator size="large" />
  if (error) return <ErrorState message={error.message} onRetry={refetch} />
  if (!data?.length) return <EmptyState message="No orders found" />

  return (
    <FlatList
      data={data}
      keyExtractor={(item) => item.id}
      renderItem={({ item }) => <OrderCard order={item} />}
    />
  )
}
```

### Flutter — State handling with Riverpod

```dart
final ordersProvider = FutureProvider<List<Order>>((ref) async {
  return ref.watch(orderRepositoryProvider).listOrders();
});

class OrdersScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);
    return ordersAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, _) => Text('Error: $err'),
      data: (orders) => ListView.builder(
        itemCount: orders.length,
        itemBuilder: (ctx, i) => OrderTile(order: orders[i]),
      ),
    );
  }
}
```
