codeunit 70062 "UPD AS Shipping Posting"
{
    //[FEATURE] Shipping Posting 
    Subtype = Test;

    var
        Customer: Record Customer;
        Item: Record Item;
        UPDASTestChamber: Record "UPD AS Test Chamber";

        Assert: Codeunit Assert;
        LibraryChamber: Codeunit "Chamber Library Functions";
        LibraryInventory: Codeunit "Library - Inventory";
        LibraryRandom: Codeunit "Library - Random";
        LibrarySales: Codeunit "Library - Sales";
        LibraryUtility: Codeunit "Library - Utility";
        isInitialized: Boolean;
    //[SCENARIO #0006] When Item is Shipped
    [Test]
    procedure ItemShippedToTestChamber()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        //[GIVEN] Customer
        //[GIVEN] Item
        //[GIVEN] Test Chamber
        Initialize();

        //[GIVEN] Sales Order
        //LibrarySales.CreateSalesOrder(SalesHeader);
        LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::Order, Customer."No.");
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, '', 10);

        //[GIVEN] Sales Order has Test Chamber
        SalesHeader.Validate("UPD AS Test Chamber Code", UPDASTestChamber.Code);
        SalesHeader.Modify();
        //[WHEN] Sales Order ships
        LibrarySales.PostSalesDocument(SalesHeader, true, false);

        //[THEN] Test Chamber Ledger is created
        VerifyTestChamberLedgerEntries(SalesHeader);

    end;
    //[SCENARIO #0007] When Item is Shipped (Value)
    //[GIVEN] Customer
    //[GIVEN] Item
    //[GIVEN] Test Chamber
    //[GIVEN] Sales Order
    //[GIVEN] Sales Order has Test Chamber
    //[GIVEN] Item has Price
    //[WHEN] Sales Order ships
    //[THEN] Test Chamber Ledger is created
    //[THEN] Test Chamber Ledger has same price
    //[SCENARIO #0008] When Item is Shipped, Item is Active
    //[GIVEN] Customer
    //[GIVEN] Item
    //[GIVEN] Test Chamber
    //[GIVEN] Sales Order
    //[GIVEN] Sales Order has Test Chamber
    //[WHEN] Sales Order ships
    //[THEN] Test Chamber Ledger is created
    //[THEN] Ledger entry is flagged Active
    local procedure Initialize()
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        ChamberSetup: Record "UPD AS Chamber Setup";
    begin
        if isInitialized then
            exit;

        ChamberSetup.Init();
        LibraryUtility.CreateNoSeries(NoSeries, true, false, false);
        LibraryUtility.CreateNoSeriesLine(NoSeriesLine, NoSeries.Code, '', '');
        ChamberSetup."Chamber No Series." := NoSeries.Code;
        ChamberSetup.Insert(true);

        LibrarySales.CreateCustomer(Customer);
        LibraryInventory.CreateItem(Item);
        LibraryChamber.CreateChamberForCustomer(UPDASTestChamber, Customer);


        isInitialized := true;
    end;

    local procedure VerifyTestChamberLedgerEntries(SalesHeader: Record "Sales Header")
    var

    begin

    end;
}
