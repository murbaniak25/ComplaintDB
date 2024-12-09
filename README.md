# README dla bazy danych ComplaintDB

## Opis bazy danych
Baza danych **ComplaintDB** została stworzona w celu zarządzania reklamacjami klientów oraz analizowania czasu rozwiązania zgłoszeń. Baza zawiera informacje o pracownikach, klientach, produktach oraz reklamacjach, umożliwiając generowanie raportów i analiz z wykorzystaniem narzędzi takich jak Power BI.

## Struktura bazy danych
Baza danych zawiera następujące tabele:

### 1. Employees
- Przechowuje dane o pracownikach odpowiedzialnych za obsługę reklamacji.
- **Kluczowe pola**: `EmployeeID`, `EmployeeName`.

### 2. Customers
- Przechowuje dane klientów składających reklamacje.
- **Kluczowe pola**: `CustomerID`, `CustomerName`.

### 3. Products
- Zawiera informacje o produktach, do których zgłaszane są reklamacje.
- **Kluczowe pola**: `ProductID`, `ProductName`.

### 4. Complaints
- Rejestruje reklamacje klientów.
- **Kluczowe pola**: `ComplaintID`, `CustomerID`, `EmployeeID`, `ProductID`, `StatusName`, `ResolutionTimeDays`.
