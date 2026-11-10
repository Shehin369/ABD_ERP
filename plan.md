# Car Wash ERP Software - Development Plan

## Phase 1: Setup & Data Layer
- [x] Initialize Flutter project with folder structure (Clean Architecture / Feature-First).
- [x] Install dependencies (`riverpod`, `hive`, `hive_flutter`, `intl`, `uuid`).
- [x] Define Hive TypeAdapters for Bookings, Vehicles, Workers, Attendance, and Expenses.
- [x] Implement Repository Layer for CRUD operations.

## Phase 2: Feature Implementation

### 1. Booking Module
- [x] **Check-In Form:**
  - Mandatory fields on arrival: Category, Color, Check-in Time (`DateTime.now()`).
  - Dynamic display: Show `Vehicle Type` dropdown only when `Category == Car`.
- [x] **Check-Out & Update Form:**
  - Enable input for checkout fields: Checkout time, Customer details, Total Amount, Payment Type, Add-ons.
  - Auto-calculate `Duration` in minutes: $(\text{CheckOutTime} - \text{CheckInTime})$.
  - "Save Regular Customer" checkbox: Auto-saves/updates records in `All Vehicles`.

### 2. All Vehicles Module
- [x] Fetch and display list of vehicles saved via the "Save Regular Customer" toggle.
- [x] Search and filter options by Vehicle Number or Customer Name.
- [x] Quick-select saved vehicle when creating new bookings.

### 3. Worker Details Module
- [x] Create form for registering workers (Name, DOB, Address, Date of Joining).
- [x] List & view existing workers with edit/delete options.

### 4. Attendance Tracker
- [x] Daily attendance sheet linked to existing Workers.
- [x] Inputs for Check-in time, Check-out time, Leave toggle flag, and optional Comment.

### 5. Expense Management
- [x] Expense entry form with date defaulted to `DateTime.now()`.
- [x] Dropdown for Category (`Maintenance`, `Refill`, `E bill`, `Rent`, `Advance salary`, `Salary`).
- [x] Conditional UI: Show Worker dropdown selector when Category is `Advance salary` or `Salary`.
- [x] Deduct option selector (Cash vs Bank account).

### 6. Wallet & Financial Dashboard
- [x] Aggregation service for calculating total earnings from completed Bookings.
- [x] Aggregation service for calculating total expenses.
- [x] Display card for **Cash Box Balance**.
- [x] Display card for **Bank Account Balance**.
- [x] Real-time state listener updating balances on new transactions.

## Phase 3: Testing & Polish
- [ ] Form validation check across all input screens.
- [ ] Testing conditional visibility rules (e.g., Bike category hiding Car types, salary showing workers).
- [ ] UX/UI polish with dark/light themes.