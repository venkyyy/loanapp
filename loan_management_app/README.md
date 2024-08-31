# Loan Management App

A Flutter-based mobile application for managing loan applications, approvals, and repayments.

## Project Overview

The Loan Management App is designed to streamline the process of loan management, from application to repayment. It provides functionality for users to apply for loans, administrators to approve or reject applications, and manage loan repayments.

## Architecture and Main Building Blocks

The application follows a layered architecture with the following main components:

1. **Models**: Represent the core data structures of the application.
   - User
   - Loan
   - LoanApplication
   - Payment

2. **Screens**: Implement the user interface for different functionalities.
   - LoginScreen
   - HomeScreen
   - UserFormScreen
   - LoanApplicationScreen
   - LoanApprovalScreen
   - LoanStatusScreen
   - RepaymentScreen
   - UserManagementScreen
   - DashboardScreen

3. **Services**: Handle business logic and data management.
   - UserService
   - LoanService
   - LoanApplicationService
   - PaymentService
   - LoanDisbursementService

4. **Local Storage**: Utilizes Hive for efficient local data storage and retrieval.

## Framework and Libraries

The project is built using the following technologies:

- **Flutter**: The main framework for building the cross-platform mobile application.
- **Dart**: The programming language used with Flutter.
- **Hive**: A lightweight and fast NoSQL database for local storage.
- **path_provider**: A Flutter plugin for finding commonly used locations on the filesystem.
- **cupertino_icons**: Provides iOS-style icons for Cupertino (iOS-style) widgets.

Development dependencies:
- **flutter_lints**: Provides a set of recommended lints for Flutter apps, packages, and plugins.
- **hive_generator**: Code generation for Hive.
- **build_runner**: A build system for Dart code generation and modular compilation.
- **mocktail**: A mocking library for Dart, used for unit testing.

## Getting Started

To get started with the project:

1. Ensure you have Flutter installed (SDK version >=3.2.0 <4.0.0).
2. Clone the repository.
3. Run `flutter pub get` to install dependencies.
4. Run `flutter pub run build_runner build` to generate necessary files.
5. Use `flutter run` to start the application on your connected device or emulator.

## Contributing

To contribute to this project:

1. Familiarize yourself with the project structure and architecture.
2. Create a new branch for your feature or bug fix.
3. Write clear, concise, and well-documented code.
4. Ensure all tests pass and add new tests for new functionality.
5. Submit a pull request with a detailed description of your changes.

## Testing

The project uses the `flutter_test` framework for unit and widget testing. To run the tests, use the command `flutter test`.

---

For more detailed information about specific components or functionalities, please refer to the inline documentation within the source code.
