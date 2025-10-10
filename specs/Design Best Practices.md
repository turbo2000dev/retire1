# Application Design

The application is designed with a features-first design, with
separation of concerns. Within features, there are:

-   **Domain** (directory: domain/): This layer represents the core
    business concepts, such as customers, products, invoices, and user
    profiles

-   **Data** (directory: data/): This layer handles data fetching,
    persistence, and conversion between domain models and the storage
    format (e.g., Firestore documents, Firebase Auth data, etc.).

-   **Presentation** (directory: presentation/): This layer builds the
    user interface and handles user interactions. The focus here is on
    widgets, routing, and displaying state provided by the state
    management solution (Riverpod).

-   **Service** (directory: service/): This layer encapsulate complex
    business operations, integrations with external services, or logic
    that doesn't neatly fit into domain or data. Examples include email
    sending, push notifications, analytics, or integrating with
    third-party APIs.

# Best Practices for Domain Layer

This layer encapsulates business logic, rules, and entities independent
of UI or data storage. Classes are immutable and created using freezed.
We encapsulate validations and business rules within value objects
(e.g., an Email type that validates format) so that business logic is
centralized and consistent.

Instead of scattering logic in widgets, we encapsulate key operations
(e.g., calculating totals, applying discounts, validating payment terms)
in dedicated classes or functions. This makes the logic easier to test
and reuse.

# Best practices for Data Layer

We implement repositories that abstract the details of data access. We
create Data Transfer Objects (DTOs) to match the Firestore or API
schema. Then, we implement mappers to convert between DTOs and the
domain models. This separation helps when the backend format changes.

We use Riverpod to create providers that expose repositories and data
services. The providers provide clear initialization to enable
mechanisms to protect us from racing conditions.

We define clear error classes (or use a Result/Either type pattern) so
that errors in data operations (like network issues or Firebase errors)
are handled gracefully. This also aids in unit testing.

# Best Practices for Presentation Layer

We use the Riverpod pattern to keep our widgets "dumb." We let Riverpod
providers or dedicated controllers handle state and logic, while out
widgets simply render state and dispatch events.

We build our UI using Flutter's widget composition and create reusable
widgets. We keep widgets focused on rendering rather than logic. We try
to keep widgets not too long, breaking them into separate widgets when
it makes sense.

We write widget tests to ensure our UI responds correctly to various
states provided by Riverpod. This ensures that refactoring logic in the
domain or data layers won't inadvertently break the UI.

# Best Practices for Services Layer

The service layer should not contain UI code. Instead, it should expose
methods that can be called from our business logic or controllers. For
example, a PaymentService might handle the registration of a payment
with Firestore and perform any necessary business logic (e.g.,
validating partial vs. full payment).

We integrate robust error handling and logging within service
operations. 

# Best Practices for Routing

We use GoRouter to manage deep linking and route transitions. We define
a clear routing table and leverage route guards if needed (for example,
to protect routes that require authentication).

Feature Routes are stored in the feature's directory and then integrated
in the main router configuration. This helps readability,
maintainability and reusability.

# Directory Structure

This Flutter project is organized using a **feature-based
architecture**, separating concerns into **core
functionalities**, **features**, and **app-level configuration**.

**📂 lib/**

The main directory containing the entire Flutter application.

**📄 main.dart**

-   The **entry point** of the application. It initializes the app and
    runs the Appwidget.

**📄  app.dart**

-   The root widget of the application, responsible for **app-wide state
    management and routing**.

**📂 lib/core/ (Shared Utilities & Configuration)**

This directory contains **foundational components** that are shared
across multiple features.

**📂 lib/core/config/ (Application Configuration)**

**📂 lib/core/error/ (Error Handling)**

**📂 lib/core/logger/ (Logging Services)**

**📂 lib/core/router/ (Navigation & Routing)**

**📂 lib/features/ (Feature Modules)**

Each feature in the app (e.g., **authentication**, **home screen**) is
structured into separate subdirectories following the **DDD
(Domain-Driven Design) approach**.

**📂 lib/features/auth/ (Authentication Feature)**

**📂 lib/features/home/ (Home Screen Feature)**

## Coding Style

- Prefer small composable widgets over large ones
- Prefer using flex values over hardcoded sizes when creating widgets inside rows/columns, ensuring the UI adapts to various screen sizes
- Use `log` from `dart.developer` rather than `print` or `debugPrint` for logging
