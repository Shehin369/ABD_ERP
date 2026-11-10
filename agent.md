# Agents & Architecture Specification: Car Wash ERP Software

## 1. System Overview
The Car Wash ERP application is a mobile/desktop software designed to streamline operations for car wash businesses. Built using **Flutter**, the app manages vehicle bookings, customer records, employee profiles, daily attendance, business expenses, and real-time wallet/cashflow tracking. Works in offline. Use theme colour Purple. secondary colour similar to purple

---

## 2. Agent Roles & Responsibilities

### 🤖 Agent 1: Lead Architect & State Manager
* **Role:** Define directory layout, state management (Provider/Riverpod/Bloc), local storage (Hive/SQLite), and clean architecture structure.
* **Outputs:** Data flow diagrams, repository patterns, dependency injection setup.

### 🤖 Agent 2: UI/UX Engineer
* **Role:** Design and build responsive Flutter screens, forms, dynamic conditional visibility (e.g., Vehicle Category -> Vehicle Type filter), theme configurations, and navigation router.
* **Outputs:** Presentation layer widgets, inputs, adaptive layouts.

### 🤖 Agent 3: Business Logic & Financials Developer
* **Role:** Implement core calculation logic including duration tracking, total income aggregations, expense logging, and cash vs. bank wallet balances.
* **Outputs:** Services, calculators, state models for Wallet, Expense, and Booking calculations.

---

## 3. Data Models & Database Schema

### 3.1 Booking Model (`booking_model.dart`)
* `id` (String, UUID)
* `vehicleName` (String?, optional)
* `vehicleNumber` (String?, optional)
* `color` (String)
* `category` (Enum: `car`, `bike`)
* `type` (Enum?: `hatchback`, `compactSUV`, `sedan`, `suv`, `sevenSeater` - *Required only if category == car*)
* `checkInTime` (DateTime, defaults to `DateTime.now()`)
* `checkOutTime` (DateTime?, optional until completed)
* `durationInMins` (int?, calculated upon checkout)
* `customerName` (String?, optional until checkout)
* `customerNumber` (String?, optional until checkout)
* `totalAmount` (double, optional until checkout)
* `paymentType` (Enum?: `gpay`, `cash`, `card`)
* `addOns` (List<Enum>: `stainRemove`, `undercoating`, `polishing`)
* `isRegularCustomer` (bool, toggle for saving to "All Vehicles")
* `status` (Enum: `inProgress`, `completed`, `cancelled`)

### 3.2 Vehicle/Customer Model (`saved_vehicle_model.dart`)
* `id` (String)
* `vehicleName` (String)
* `vehicleNumber` (String)
* `customerName` (String)
* `customerNumber` (String)
* `category` (Enum)
* `type` (Enum?)
* `color` (String)

### 3.3 Worker Model (`worker_model.dart`)
* `id` (String)
* `name` (String)
* `dob` (DateTime)
* `address` (String)
* `dateOfJoining` (DateTime)

### 3.4 Attendance Model (`attendance_model.dart`)
* `id` (String)
* `workerId` (String)
* `checkInTime` (DateTime?)
* `checkOutTime` (DateTime?)
* `isOnLeave` (bool)
* `comment` (String?)
* `date` (DateTime)

### 3.5 Expense Model (`expense_model.dart`)
* `id` (String)
* `date` (DateTime, default `DateTime.now()`)
* `category` (Enum: `maintenance`, `refill`, `eBill`, `rent`, `advanceSalary`, `salary`)
* `note` (String?)
* `amount` (double)
* `workerId` (String?, required if `category == advanceSalary` or `salary`)
* `paymentMethod` (Enum: `cash`, `bank`)

### 3.6 Wallet Summary Model (`wallet_model.dart`)
* `cashBalance` (double)
* `bankBalance` (double)
* `totalIncome` (double)
* `totalExpenses` (double)

---

## 4. Wallet Balance Logic
$$\text{Cash Balance} = \sum (\text{Bookings}_{\text{Cash}}) - \sum (\text{Expenses}_{\text{Cash}})$$

$$\text{Bank Balance} = \sum (\text{Bookings}_{\text{GPay}} + \text{Bookings}_{\text{Card}}) - \sum (\text{Expenses}_{\text{Bank}})$$

---

## 5. Technology Stack
* **Framework:** Flutter (3.x+)
* **Language:** Dart
* **State Management:** Flutter Riverpod
* **Local Persistence:** Hive
* **Date Parsing:** `intl` package

## 6. Current Implementation Status

### Phase 1 - Complete
* Feature-first project structure is established.
* Hive adapters and boxes are registered in `lib/core/storage/hive_service.dart`.
* Generic Hive repositories are provided through Riverpod.

### Phase 2 - Complete
* Booking check-in and completion forms are implemented in
  `lib/features/app/presentation/phase2_screens.dart`.
* Saved vehicles can be searched and used to create new bookings.
* Workers and attendance records support create, view, edit, and delete workflows.
* Expenses support conditional worker selection for salary and advance salary categories.
* Wallet calculations are implemented by `lib/core/services/wallet_service.dart`.
* Cash and bank balances update through Hive box listeners.

## 7. Project Conventions

* Keep feature data models and Hive adapters under each feature's `data/models` folder.
* Access Hive repositories through the providers in
  `lib/core/providers/repositories.dart`.
* Use Riverpod for application state and Hive `ValueListenableBuilder` widgets for
  real-time persisted data updates.
* Keep wallet aggregation in `WalletService`; widgets must not duplicate financial
  calculations.
* Use Material 3 widgets and the existing purple seed theme.
* Keep responsive navigation compatible with both phone and desktop layouts.
* For completed bookings, calculate duration from the difference between check-out
  and check-in timestamps.
* For salary and advance salary expenses, require a selected worker.
* Use completed cash bookings and cash expenses for cash balance calculations.
  Use completed GPay and card bookings and bank expenses for bank balance
  calculations.

## 8. Validation Requirements

After Dart or Flutter changes:

1. Run `dart format lib test`.
2. Run `flutter analyze`.
3. Run `flutter test`.

Update `plan.md` whenever implementation phases or their checklist items change.