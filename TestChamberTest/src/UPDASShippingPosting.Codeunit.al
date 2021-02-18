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
        QtyToTest: Integer;
    begin
        //[GIVEN] Customer
        //[GIVEN] Item
        //[GIVEN] Test Chamber
        Initialize();
        QtyToTest := 10;

        //[GIVEN] Sales Order
        LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::Order, Customer."No.");
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, '', QtyToTest);
        SalesLine.Validate("Qty. to Ship", SalesLine.Quantity);
        SalesLine.modify(true);

        //[GIVEN] Sales Order has Test Chamber
        SalesHeader.Validate("UPD AS Test Chamber Code", UPDASTestChamber.Code);
        SalesHeader.Modify(true);

        //[WHEN] Sales Order ships
        LibrarySales.PostSalesDocument(SalesHeader, true, false);

        //[THEN] Test Chamber Ledger is created
        VerifyTestChamberLedgerEntries(SalesHeader, SalesLine, QtyToTest);

    end;
    //[SCENARIO #0007] When Item is Shipped (Value)
    [Test]
    procedure ItemShippedToTestChamberValue()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        QtyToTest: Integer;
    begin
        //[GIVEN] Customer
        //[GIVEN] Item
        //[GIVEN] Test Chamber
        Initialize();
        QtyToTest := 10;

        //[GIVEN] Sales Order
        LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::Order, Customer."No.");
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, '', QtyToTest);

        //[GIVEN] Sales Order has Test Chamber
        SalesHeader.Validate("UPD AS Test Chamber Code", UPDASTestChamber.Code);
        SalesHeader.Modify();

        //[WHEN] Sales Order ships
        LibrarySales.PostSalesDocument(SalesHeader, true, false);

        //[THEN] Test Chamber Ledger is created
        VerifyTestChamberLedgerEntries(SalesHeader, SalesLine, QtyToTest);

        //[THEN] Test Chamber Ledger has same price

    end;

    //[SCENARIO #0008] When Item is Shipped, Item is Active
    [Test]
    procedure ItemShippedToTestChamberActive()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        QtyToTest: Integer;
    begin
        //[GIVEN] Customer
        //[GIVEN] Item
        //[GIVEN] Test Chamber
        Initialize();
        QtyToTest := 10;

        //[GIVEN] Sales Order
        LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::Order, Customer."No.");
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, '', QtyToTest);

        //[GIVEN] Sales Order has Test Chamber
        SalesHeader.Validate("UPD AS Test Chamber Code", UPDASTestChamber.Code);
        SalesHeader.Modify();

        //[WHEN] Sales Order ships
        LibrarySales.PostSalesDocument(SalesHeader, true, false);

        //[THEN] Test Chamber Ledger is created
        VerifyTestChamberLedgerEntries(SalesHeader, SalesLine, QtyToTest);
        //[THEN] Ledger entry is flagged Active
    end;


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

    local procedure VerifyTestChamberLedgerEntries(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; QtyToTest: Integer)
    var
        UPDASChamberLedg: Record "UPD AS Chamber Ledger";
        IncorrectLedgerCountMsg: Label 'Expected %1 entries, found %2 entries', Comment = '%1, %2';
    begin
        UPDASChamberLedg.SetRange("Customer No.", SalesHeader."Sell-to Customer No.");
        UPDASChamberLedg.SetRange("Chamber Code", SalesHeader."UPD AS Test Chamber Code");
        //UPDASChamberLedg.SetRange("Item No.", SalesLine."No.");
        Assert.AreEqual(UPDASChamberLedg.Count, QtyToTest, StrSubstNo(IncorrectLedgerCountMsg, QtyToTest, UPDASChamberLedg.Count));
    end;


}
