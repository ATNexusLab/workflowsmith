---
name: mobile-patterns
description: Use to implement or adjust mobile features in React Native, Flutter, Swift, or Kotlin, including builds, platform issues, and mobile UX.
kind: skill
tools:
  - read_file
  - grep
  - glob
  - run_shell_command
---

# Mobile Patterns

## When to Use

- Implement or debug a mobile feature
- Fix a platform-specific issue (iOS vs. Android behavior difference)
- Investigate a build failure in React Native, Flutter, Expo, Xcode, or Gradle
- Improve mobile performance, memory usage, or bundle size
- Design mobile-first UX interactions (gesture handling, keyboard, navigation, accessibility)
- Configure push notifications, deep linking, or permissions

## Core Principles

1. **Platform conventions first** — follow iOS HIG and Android Material guidelines; deviate intentionally and document why
2. **Offline resilience** — assume connectivity is unreliable; design local-first where possible
3. **Performance is a feature** — 60fps, fast startup, and minimal battery drain are baseline expectations, not nice-to-haves
4. **Accessibility by default** — VoiceOver (iOS) and TalkBack (Android) must work without special effort from users
5. **Test on device, not only simulator** — performance and hardware behavior differ substantially

## React Native Patterns

### Project Structure

```
src/
├── screens/          ← Route-level components (one per screen)
├── components/       ← Reusable UI components
│   ├── ui/           ← Generic primitives (Button, Input, Card)
│   └── domain/       ← Business-domain components (OrderCard, UserAvatar)
├── navigation/       ← React Navigation stack and tab definitions
├── hooks/            ← Custom hooks (useAuth, useOrders, useKeyboard)
├── store/            ← State management (Zustand, Redux, Jotai)
├── services/         ← API calls and external integrations
├── utils/            ← Pure utilities, formatters, validators
└── types/            ← Shared TypeScript types
```

### Navigation (React Navigation)

```tsx
// Stack navigator with typed params
import { createNativeStackNavigator } from '@react-navigation/native-stack';

type RootStackParamList = {
  Home: undefined;
  OrderDetail: { orderId: string };
  Settings: undefined;
};

const Stack = createNativeStackNavigator<RootStackParamList>();

export function AppNavigator() {
  return (
    <Stack.Navigator
      screenOptions={{
        headerStyle: { backgroundColor: colors.surface },
        headerTintColor: colors.text,
        animation: 'slide_from_right',
      }}
    >
      <Stack.Screen name="Home" component={HomeScreen} />
      <Stack.Screen
        name="OrderDetail"
        component={OrderDetailScreen}
        options={({ route }) => ({ title: `Order ${route.params.orderId}` })}
      />
    </Stack.Navigator>
  );
}
```

**Navigation rules:**
- Type all route params — never pass untyped objects
- Keep navigation logic in the navigator; screens receive params and call navigation actions
- Use `useNavigation` and `useRoute` hooks rather than prop drilling
- Define deep link config in the navigator, not scattered across screens

### FlatList Performance

```tsx
function OrderList({ orders }: { orders: Order[] }) {
  const renderOrder = useCallback(
    ({ item }: { item: Order }) => <OrderCard order={item} />,
    []
  );

  const keyExtractor = useCallback((item: Order) => item.id, []);

  const getItemLayout = useCallback(
    (_: unknown, index: number) => ({
      length: ORDER_CARD_HEIGHT,
      offset: ORDER_CARD_HEIGHT * index,
      index,
    }),
    []
  );

  return (
    <FlatList
      data={orders}
      renderItem={renderOrder}
      keyExtractor={keyExtractor}
      getItemLayout={getItemLayout}        // Required for large lists
      maxToRenderPerBatch={10}
      windowSize={10}
      removeClippedSubviews={true}
      initialNumToRender={10}
    />
  );
}
```

**FlatList rules:**
- Always `useCallback` on `renderItem` and `keyExtractor` to prevent re-renders
- Implement `getItemLayout` for fixed-height items — enables instant scroll position
- Set `removeClippedSubviews={true}` for memory savings on large lists
- Avoid anonymous functions in JSX props for list items

### Keyboard Handling

```tsx
import { KeyboardAvoidingView, Platform, ScrollView } from 'react-native';

function FormScreen() {
  return (
    <KeyboardAvoidingView
      style={{ flex: 1 }}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      <ScrollView keyboardShouldPersistTaps="handled">
        {/* Form fields */}
      </ScrollView>
    </KeyboardAvoidingView>
  );
}
```

### Platform Differences

```tsx
import { Platform, StyleSheet } from 'react-native';

const styles = StyleSheet.create({
  shadow: {
    // iOS
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    // Android
    elevation: 4,
  },
  header: {
    paddingTop: Platform.select({
      ios: 44,
      android: 24,
      default: 20,
    }),
  },
});

// Platform-specific file resolution
// Button.ios.tsx  →  used on iOS
// Button.android.tsx  →  used on Android
// Button.tsx  →  fallback
```

### React Native Build Troubleshooting

```bash
# Clear all caches
npx react-native start --reset-cache
cd ios && pod install && cd ..
cd android && ./gradlew clean && cd ..

# Check linked native modules
npx react-native doctor

# iOS build from CLI
npx react-native run-ios --simulator="iPhone 15"
npx react-native run-ios --device

# Android build from CLI
npx react-native run-android
npx react-native run-android --variant=release

# Metro bundler logs
npx react-native log-ios
npx react-native log-android
```

**Common issues:**

| Symptom | Resolution |
|---|---|
| `Unable to load script` | Metro bundler not running or cache stale; run `--reset-cache` |
| iOS build fails after adding native module | Run `pod install` in `ios/` |
| Android build fails: `AAPT2 error` | Run `./gradlew clean` in `android/` |
| White screen on release build | JS bundle not bundled; check `android/app/build.gradle` bundleReleaseJsAndAssets |
| `Invariant Violation: requireNativeComponent` | Native module not linked; check `package.json` and run `pod install` |

## Flutter Patterns

### Project Structure

```
lib/
├── main.dart
├── app.dart              ← MaterialApp / routing configuration
├── features/             ← Feature-first organization
│   └── orders/
│       ├── data/         ← Repositories, data sources, models
│       ├── domain/       ← Entities, use cases, repository interfaces
│       └── presentation/ ← Widgets, state management (Bloc/Riverpod)
├── core/
│   ├── theme/            ← ThemeData, colors, typography
│   ├── widgets/          ← Shared UI components
│   └── utils/            ← Pure utilities
└── generated/            ← Localization, assets (auto-generated)
```

### State Management (Riverpod)

```dart
// Provider definition
final orderListProvider = AsyncNotifierProvider<OrderListNotifier, List<Order>>(
  OrderListNotifier.new,
);

class OrderListNotifier extends AsyncNotifier<List<Order>> {
  @override
  Future<List<Order>> build() async {
    return ref.watch(orderRepositoryProvider).getOrders();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(orderRepositoryProvider).getOrders(),
    );
  }
}

// Widget consumption
class OrderListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(orderListProvider);

    return ordersAsync.when(
      data: (orders) => OrderList(orders: orders),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => ErrorView(message: error.toString()),
    );
  }
}
```

### Performance Patterns

```dart
// const constructors for immutable widgets
const Text('Hello');
const SizedBox(height: 16);
const Icon(Icons.arrow_back);

// ListView.builder for large lists
ListView.builder(
  itemCount: orders.length,
  itemBuilder: (context, index) => OrderCard(order: orders[index]),
)

// RepaintBoundary to isolate expensive widget trees
RepaintBoundary(
  child: ComplexAnimatedWidget(),
)
```

### Flutter Build Troubleshooting

```bash
# Check Flutter environment
flutter doctor -v

# Clear caches
flutter clean
flutter pub get

# Run on specific device
flutter run -d "iPhone 15"
flutter run -d emulator-5554

# Build for production
flutter build ios --release
flutter build appbundle --release    # Android App Bundle for Play Store
flutter build apk --release          # APK for direct distribution

# Analyze performance
flutter run --profile
```

## iOS Patterns (Swift / SwiftUI)

### SwiftUI View Structure

```swift
struct OrderDetailView: View {
    let orderId: String
    @StateObject private var viewModel = OrderDetailViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .loaded(let order):
                OrderContent(order: order)
            case .error(let message):
                ErrorView(message: message) {
                    Task { await viewModel.load(orderId: orderId) }
                }
            }
        }
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load(orderId: orderId) }
    }
}
```

### Xcode Build Issues

```bash
# Clean build folder
xcodebuild clean -workspace App.xcworkspace -scheme App

# Install pods
cd ios && pod install --repo-update

# Build from command line
xcodebuild -workspace App.xcworkspace \
           -scheme App \
           -configuration Release \
           -destination "generic/platform=iOS"

# Show signing info
security find-identity -v -p codesigning
```

**Common issues:**

| Error | Resolution |
|---|---|
| `Provisioning profile not found` | Open Xcode → Signing & Capabilities → refresh profile |
| `Module not found` | Clean build folder, run `pod install`, restart Xcode |
| `Bitcode compilation error` | Disable Bitcode in Build Settings if not required |
| Swift version mismatch | Check `SWIFT_VERSION` in project and all pods |

## Android Patterns (Kotlin)

### Architecture (MVVM with Compose)

```kotlin
@HiltViewModel
class OrderListViewModel @Inject constructor(
    private val orderRepository: OrderRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow<OrderListUiState>(OrderListUiState.Loading)
    val uiState: StateFlow<OrderListUiState> = _uiState.asStateFlow()

    init {
        loadOrders()
    }

    fun loadOrders() {
        viewModelScope.launch {
            _uiState.value = OrderListUiState.Loading
            orderRepository.getOrders()
                .onSuccess { orders ->
                    _uiState.value = OrderListUiState.Success(orders)
                }
                .onFailure { error ->
                    _uiState.value = OrderListUiState.Error(error.message ?: "Unknown error")
                }
        }
    }
}

sealed class OrderListUiState {
    data object Loading : OrderListUiState()
    data class Success(val orders: List<Order>) : OrderListUiState()
    data class Error(val message: String) : OrderListUiState()
}
```

### Gradle Build Issues

```bash
# Clean
./gradlew clean

# Build debug APK
./gradlew assembleDebug

# Run tests
./gradlew test
./gradlew connectedAndroidTest

# Check dependencies
./gradlew dependencies --configuration releaseRuntimeClasspath

# Upgrade Gradle wrapper
./gradlew wrapper --gradle-version=8.5
```

## Mobile UX Patterns

### Touch Target Sizing

- Minimum touch target: **44×44pt** (iOS) / **48×48dp** (Android)
- For small visual elements, add invisible padding around the tappable area
- Do not place interactive elements closer than 8pt to each other

### Gesture Handling

- Use `activeOpacity` (React Native) or `pressedState` to provide visual feedback on tap
- Swipe-to-dismiss for modals and drawers follows platform convention
- Long-press actions must be discoverable through an alternative non-gesture path
- Avoid intercepting system gestures (iOS back swipe, Android back navigation)

### Offline and Loading States

Every network-dependent screen needs three states:
1. **Loading** — skeleton screens preferred over spinners for content-heavy layouts
2. **Error** — specific error message with retry action, not generic "Something went wrong"
3. **Empty** — empty state with an actionable prompt, not a blank screen

```tsx
// React Native skeleton pattern
function OrderCard({ loading, order }: Props) {
  if (loading) {
    return <SkeletonCard />;
  }
  return <ActualOrderCard order={order} />;
}
```

### Deep Linking

```typescript
// React Navigation deep link config
const linking: LinkingOptions<RootStackParamList> = {
  prefixes: ['myapp://', 'https://app.myapp.com'],
  config: {
    screens: {
      Home: '',
      OrderDetail: 'orders/:orderId',
      Settings: 'settings',
    },
  },
};
```

## Accessibility

```tsx
// React Native accessibility
<TouchableOpacity
  accessible={true}
  accessibilityLabel="Cancel order 123"
  accessibilityRole="button"
  accessibilityHint="Double tap to cancel this order"
  onPress={handleCancel}
>
  <Text>Cancel</Text>
</TouchableOpacity>
```

```dart
// Flutter semantics
Semantics(
  label: 'Cancel order',
  button: true,
  child: GestureDetector(
    onTap: handleCancel,
    child: const Text('Cancel'),
  ),
)
```

**Accessibility checklist:**
- [ ] All interactive elements have `accessibilityLabel` / `contentDescription`
- [ ] Text scales with system font size settings
- [ ] Color contrast meets 4.5:1 minimum
- [ ] All actions are reachable without gesture (VoiceOver, TalkBack compatible)
- [ ] Focus order is logical for screen reader navigation

## Never Do

- Hardcode pixel dimensions without using `PixelRatio` or density-independent units
- Block the main JS thread (React Native) or UI thread (iOS/Android) with synchronous work
- Skip `keyExtractor` in `FlatList` — missing keys cause incorrect rendering during updates
- Test only on simulators and assume device behavior will match
- Ship with debug logging enabled in release builds
- Request permissions before explaining why they are needed
- Ignore platform back-navigation conventions
