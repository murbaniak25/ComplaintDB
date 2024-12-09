# ComplaintsDB - Dokumentacja Bazy Danych

## Spis Treści
1. [Opis Ogólny](#opis-ogólny)
2. [Tabele](#tabele)
3. [Procedury Składowane](#procedury-składowane)
4. [Triggery](#triggery)
5. [Testy i Dane](#testy-i-dane)

---

## Opis Ogólny
Baza danych **ComplaintsDB** została zaprojektowana w celu zarządzania procesem obsługi reklamacji w firmie. Umożliwia rejestrowanie klientów, produktów, reklamacji i ich obsługi, a także zapewnia analizę czasu rozwiązania zgłoszeń.

---

## Tabele
### 1. PostalCodes
Przechowuje dane o kodach pocztowych i powiązanych miejscowościach.
- **Kolumny**:
  - `PostalCodeID`: Unikalny identyfikator.
  - `PostalCode`: Kod pocztowy.
  - `City`: Nazwa miasta.

### 2. Addresses
Reprezentuje adresy klientów, pracowników oraz dostawców.
- **Kolumny**:
  - `AddressID`: Unikalny identyfikator.
  - `Street`: Nazwa ulicy.
  - `HouseNumber`: Numer budynku.
  - `PostalCodeID`: Powiązanie z tabelą `PostalCodes`.

### 3. Suppliers
Przechowuje dane o dostawcach produktów.
- **Kolumny**:
  - `SupplierID`: Unikalny identyfikator.
  - `SupplierName`: Nazwa dostawcy.
  - `AddressID`: Powiązanie z tabelą `Addresses`.

### 4. ResolutionTypes
Zawiera możliwe sposoby rozwiązywania reklamacji, np. naprawa, zwrot pieniędzy.
- **Kolumny**:
  - `ResolutionTypeID`: Unikalny identyfikator.
  - `ResolutionType`: Nazwa typu rozwiązania.

### 5. ShippingOptions
Opisuje opcje wysyłki dostępne w procesie reklamacji.
- **Kolumny**:
  - `ShippingMethodID`: Unikalny identyfikator.
  - `ShippingMethodName`: Nazwa metody wysyłki.
  - `ShippingMethodDescription`: Opis metody wysyłki.

### 6. PaymentMethods
Zawiera dostępne metody płatności.
- **Kolumny**:
  - `PaymentMethodID`: Unikalny identyfikator.
  - `PaymentMethodName`: Nazwa metody płatności.
  - `PaymentMethodDescription`: Opis metody płatności.

### 7. Customers
Przechowuje dane klientów składających reklamacje.
- **Kolumny**:
  - `CustomerID`: Unikalny identyfikator.
  - `CustomerName`: Imię i nazwisko klienta.
  - `Contact`: Dane kontaktowe.
  - `AddressID`: Powiązanie z tabelą `Addresses`.

### 8. Employees
Dane pracowników zajmujących się obsługą reklamacji.
- **Kolumny**:
  - `EmployeeID`: Unikalny identyfikator.
  - `LastName`: Nazwisko pracownika.
  - `FirstName`: Imię pracownika.
  - `HireDate`: Data zatrudnienia.
  - `Salary`: Wynagrodzenie.

### 9. Products
Informacje o produktach objętych reklamacjami.
- **Kolumny**:
  - `ProductID`: Unikalny identyfikator.
  - `SupplierID`: Powiązanie z tabelą `Suppliers`.
  - `ProductName`: Nazwa produktu.
  - `Price`: Cena jednostkowa.

### 10. Complaints
Rejestruje zgłoszenia reklamacyjne.
- **Kolumny**:
  - `ComplaintID`: Unikalny identyfikator.
  - `CustomerID`: Powiązanie z klientem.
  - `EmployeeID`: Powiązanie z pracownikiem.
  - `ProductID`: Powiązanie z produktem.
  - `StatusID`: Status reklamacji.

### 11. ComplaintDetails
Szczegóły reklamacji, takie jak opis, data zgłoszenia i rozwiązania.
- **Kolumny**:
  - `ComplaintID`: Unikalny identyfikator.
  - `Description`: Szczegółowy opis zgłoszenia.
  - `ComplaintDate`: Data zgłoszenia reklamacji.
  - `ResolutionDate`: Data rozwiązania reklamacji.

---

## Procedury Składowane

### Lista Procedur
1. **`usp_InsertCustomer`**  
   Dodaje nowego klienta do bazy danych.  
   **Parametry**:
   - `@CustomerName`: Imię i nazwisko klienta.
   - `@Contact`: Dane kontaktowe.
   - `@AddressID`: ID adresu klienta.

2. **`usp_InsertComplaint`**  
   Rejestruje nową reklamację.  
   **Parametry**:
   - `@StatusID`: ID statusu reklamacji.
   - `@CustomerID`: ID klienta.
   - `@EmployeeID`: ID pracownika.
   - `@ProductID`: ID produktu.

3. **`usp_UpdateComplaintStatus`**  
   Aktualizuje status reklamacji.  
   **Parametry**:
   - `@ComplaintID`: ID reklamacji.
   - `@NewStatusID`: Nowy status.

4. **`usp_DeleteComplaint`**  
   Usuwa reklamację i powiązane szczegóły.  

---

## Triggery

### Lista Triggerów
1. **`trg_IDUpdate_*`**  
   Automatycznie przypisują unikalne identyfikatory (`ID`) podczas wstawiania nowych rekordów. Dotyczy tabel:
   - `Customers`
   - `Employees`
   - `Products`
   - `Complaints`.

2. **`trg_UpdateResolutionDate`**  
   Ustawia datę rozwiązania reklamacji, gdy jej status zmienia się na "Zakończona".

---
