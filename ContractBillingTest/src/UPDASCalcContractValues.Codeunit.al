codeunit 70071 "UPD AS Calc Contract Values"
{
    //[FEATURE] Calculate Test Chamber Values 
    Subtype = Test;

    var
        Customer: Record Customer;
        Item: Record Item;
        UPDASTestChamber: Record "UPD AS Test Chamber";

        Assert: Codeunit Assert;
        LibraryInventory: Codeunit "Library - Inventory";
        LibraryRandom: Codeunit "Library - Random";
        LibrarySales: Codeunit "Library - Sales";
        LibraryUtility: Codeunit "Library - Utility";
        LibraryChamber: Codeunit "UPD AS Library - Chamber";
        isDeactivated: Boolean;
        isInitialized: Boolean;
        DeactivatedValue: Decimal;
        PricePerTestUnit: Decimal;
        TargetInstalledValue: Decimal;
        DeactivedQuantity: Integer;
        QtyToTest: Integer;


    [Test]
    procedure CheckContractInstalledValueTotal()
    var
        Contract: Record "UPD AS Contract";
    begin
        //[SCENARIO #0103] Contract Installed Value Total
        //[GIVEN] Customer
        //[GIVEN] Test Chamber
        //[GIVEN] Contract
        //[GIVEN] Item
        //[GIVEN] Test Chamber Ledger Entries Exists
        //[GIVEN] Test Chamber Ledger Entries are Active
        //[GIVEN] Test Chamber Ledger Entries Has Total Value
        Initialize();
        //[WHEN] Installed Value is calculated
        Contract.Get(Customer."No.", UPDASTestChamber.Code);
        Contract.CalcFields("Active Value");

        //[THEN] Flowfield should equal total value
        Assert.AreEqual(Contract."Active Value", TargetInstalledValue, StrSubstNo('%1 should be %2', Contract."Active Value", TargetInstalledValue));
    end;

    [Test]
    [HandlerFunctions('DeactivateConfirmHandler')]
    procedure CheckContractInstalledValueActiveTotal()
    var
        ContractLedger: Record "UPD AS Chamber Ledger";
        Contract: Record "UPD AS Contract";
    begin
        //[SCENARIO #0104] Contract Installed Value Active Total
        //[GIVEN] Customer
        //[GIVEN] Test Chamber
        //[GIVEN] Contract
        //[GIVEN] Item
        //[GIVEN] Test Chamber Ledger Entries Exists
        //[GIVEN] Test Chamber Ledger Entries are Active
        //[GIVEN] Test Chamber Ledger Entries Has Total Value
        //[GIVEN] Test Chamber Ledger Entries Exists
        Initialize();
        //[GIVEN] Test Chamber Ledger Entries are Inactive
        //[GIVEN] Test Chamber Ledger Entries Has Total Value
        DeactivatedValue := DeactivateChamberLedgerEntries();
        //[WHEN] Installed Value is calculated
        Contract.Get(Customer."No.", UPDASTestChamber.Code);
        Contract.CalcFields("Active Value");
        //[THEN] Flowfield should equal total value of Active entries
        Assert.AreEqual(Contract."Active Value", TargetInstalledValue - DeactivatedValue, StrSubstNo('%1 should be %2', Contract."Active Value", TargetInstalledValue - DeactivatedValue));
    end;

    [Test]
    [HandlerFunctions('DeactivateConfirmHandler,HandleContractEntriesDrilldown')]
    procedure CheckContractInstalledActiveValueDrilldown()
    var
        ContractLedger: Record "UPD AS Chamber Ledger";
        Contract: Record "UPD AS Contract";
        ContractList: TestPage "UPD AS Contract List";
    begin
        Initialize();
        //[GIVEN] Test Chamber Ledger Entries are Inactive
        //[GIVEN] Test Chamber Ledger Entries Has Total Value
        DeactivatedValue := DeactivateChamberLedgerEntries();
        //[WHEN] Installed Value is calculated
        Contract.Get(Customer."No.", UPDASTestChamber.Code);
        Contract.CalcFields("Active Value");

        ContractList.OpenView();
        ContractList.GoToKey(Customer."No.", UPDASTestChamber.Code);
        ContractList."Active Value".Drilldown();
    end;

    //[SCENARIO #0105] Contract Value Calculation Returns
    //[GIVEN] Customer
    //[GIVEN] Test Chamber
    //[GIVEN] Contract
    //[GIVEN] Item
    //[GIVEN] Test Chamber Ledger Entries Exists
    //[GIVEN] Test Chamber Ledger Entries are Active
    //[GIVEN] Test Chamber Ledger Entries Has Total Value
    //[GIVEN] Installed Value is calculated
    //[GIVEN] Setup table has % Rate
    //[WHEN] Calculation function is called
    //[THEN] Contract Value is correct
    //[SCENARIO #0106] Contract Value Calculation Returns
    //[GIVEN] Customer
    //[GIVEN] Test Chamber
    //[GIVEN] Contract
    //[GIVEN] Item
    //[GIVEN] Test Chamber Ledger Entries Exists
    //[GIVEN] Test Chamber Ledger Entries are Active
    //[GIVEN] Test Chamber Ledger Entries Has Total Value
    //[GIVEN] Installed Value is calculated
    //[GIVEN] Setup table does not have % Rate
    //[WHEN] Calculation function is called
    //[THEN] Error is thrown
    local procedure Initialize()
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ChamberSetup: Record "UPD AS Chamber Setup";
    begin
        if isInitialized then
            exit;

        QtyToTest := 8;
        PricePerTestUnit := 12345;
        TargetInstalledValue := QtyToTest * PricePerTestUnit;

        ChamberSetup.Init();
        LibraryUtility.CreateNoSeries(NoSeries, true, false, false);
        LibraryUtility.CreateNoSeriesLine(NoSeriesLine, NoSeries.Code, '', '');
        ChamberSetup."Chamber No Series." := NoSeries.Code;
        ChamberSetup."UPD AS Contract Value Rate" := 10;
        ChamberSetup.Insert(true);

        LibrarySales.CreateCustomer(Customer);
        LibraryInventory.CreateItem(Item);
        LibraryChamber.CreateChamberForCustomer(UPDASTestChamber, Customer);

        LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::Order, Customer."No.");
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, '', QtyToTest);
        SalesLine.Validate("Qty. to Ship", SalesLine.Quantity);
        SalesLine.Validate("Unit Price", PricePerTestUnit);
        SalesLine.modify(true);

        SalesHeader.Validate("UPD AS Test Chamber Code", UPDASTestChamber.Code);
        SalesHeader.Modify(true);

        LibrarySales.PostSalesDocument(SalesHeader, true, false);

        isInitialized := true;
    end;

    local procedure DeactivateChamberLedgerEntries() ValueToDeduct: Decimal
    var
        ChamberEntries: Record "UPD AS Chamber Ledger";
        i: Integer;
    begin
        if isDeactivated then
            exit;

        DeactivedQuantity := Round(QtyToTest / 2);
        ChamberEntries.SetRange("Customer No.", Customer."No.");
        ChamberEntries.SetRange("Chamber Code", UPDASTestChamber.Code);
        ChamberEntries.FindFirst();
        for i := 1 to DeactivedQuantity do begin
            ChamberEntries.DeactivateItem();
            ValueToDeduct += ChamberEntries.Value;
            ChamberEntries.Next();
        end;

        isDeactivated := true;
    end;

    [ConfirmHandler]
    procedure DeactivateConfirmHandler(Message: Text[1024]; var Reply: Boolean)
    var
        ExpectedQuestion: Label 'Are you sure you want to deactivate this item?';
        WrongConfirmationPromptErr: Label 'UI Expected %1. Got: %2';
    begin
        Assert.AreEqual(Message, ExpectedQuestion, StrSubstNo(WrongConfirmationPromptErr, ExpectedQuestion, Message));
        Reply := true;
    end;

    [PageHandler]
    procedure HandleContractEntriesDrilldown(var ChamberEntriesList: TestPage "UPD AS Chamber Ledger Entries")
    var
        EntryCount: Integer;
    begin
        ChamberEntriesList.First();
        repeat
            EntryCount += 1;
        until not ChamberEntriesList.Next();

        Assert.AreEqual(EntryCount, DeactivedQuantity, StrSubstNo('Expected %1 entries, got %2', EntryCount, DeactivedQuantity));
        ChamberEntriesList.OK().Invoke();
    end;
}
