codeunit 70073 "UPD AS Generate Contract Inv."
{
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
    procedure BasicInvoiceCreation()
    begin
        //[SCENARIO #0107] Basic Invoice Created
        //[GIVEN] Customer
        //[GIVEN] Test Chamber
        //[GIVEN] Contract
        //[GIVEN] Item
        //[GIVEN] Test Chamber Ledger Entries
        //[GIVEN] Setup table has G/L Account
        Initialize();
        DeactivateChamberLedgerEntries();
        //[WHEN] Routine is Run
        //[THEN] Sales Invoice
        //[THEN] Sales Invoice Line
        //[THEN] Sales Invoice line has Contract Value as price
    end;


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
}
