codeunit 70073 "UPD AS Generate Contract Inv."
{
    Subtype = Test;

    var
        Customer: Record Customer;
        Item: Record Item;
        ChamberSetup: Record "UPD AS Chamber Setup";
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
    [HandlerFunctions('DeactivateConfirmHandler,InvoicesCreatedHandler')]
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
        GenerateContractInvoices();

        //[THEN] Sales Invoice
        VerifySalesInvoices();

        //[THEN] Sales Invoice Line
        //[THEN] Sales Invoice line has Contract Value as price
        VerifySalesInvoiceLine();

    end;
    /*
 
 888    888        d8888 888b    888 8888888b.  888      8888888888 8888888b.   .d8888b.  
 888    888       d88888 8888b   888 888  "Y88b 888      888        888   Y88b d88P  Y88b 
 888    888      d88P888 88888b  888 888    888 888      888        888    888 Y88b.      
 8888888888     d88P 888 888Y88b 888 888    888 888      8888888    888   d88P  "Y888b.   
 888    888    d88P  888 888 Y88b888 888    888 888      888        8888888P"      "Y88b. 
 888    888   d88P   888 888  Y88888 888    888 888      888        888 T88b         "888 
 888    888  d8888888888 888   Y8888 888  .d88P 888      888        888  T88b  Y88b  d88P 
 888    888 d88P     888 888    Y888 8888888P"  88888888 8888888888 888   T88b  "Y8888P"  
                                                                                          
                                                                                          
                                                                                          
 
*/
    [ConfirmHandler]
    procedure DeactivateConfirmHandler(Message: Text[1024]; var Reply: Boolean)
    var
        ExpectedQuestion: Label 'Are you sure you want to deactivate this item?';
        WrongConfirmationPromptErr: Label 'UI Expected %1. Got: %2';
    begin
        Assert.AreEqual(Message, ExpectedQuestion, StrSubstNo(WrongConfirmationPromptErr, ExpectedQuestion, Message));
        Reply := true;
    end;

    [MessageHandler]
    procedure InvoicesCreatedHandler(Message: Text[1024])
    var
        ExpectedMessage: Label 'Created 1 Sales Invoices';
        WrongResultMessageErr: Label 'UI Expected ''%1'' but got ''%2''';
    begin
        Assert.AreEqual(Message, ExpectedMessage, StrSubstNo(WrongResultMessageErr, ExpectedMessage, Message));
    end;

    /*
 
 888     888 888    d8b 888 d8b 888             
 888     888 888    Y8P 888 Y8P 888             
 888     888 888        888     888             
 888     888 888888 888 888 888 888888 888  888 
 888     888 888    888 888 888 888    888  888 
 888     888 888    888 888 888 888    888  888 
 Y88b. .d88P Y88b.  888 888 888 Y88b.  Y88b 888 
  "Y88888P"   "Y888 888 888 888  "Y888  "Y88888 
                                            888 
                                       Y8b d88P 
                                        "Y88P"  
 
*/

    local procedure Initialize()
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
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
        ChamberSetup."UPD AS Contract G/L Acct." := '3071';
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

    local procedure GenerateContractInvoices()
    var
        Contract: Record "UPD AS Contract";
        CreateContractInvoice: Report "UPD AS Create Contract Inv.";
    begin
        Contract.Get(UPDASTestChamber."Customer No.", UPDASTestChamber.Code);
        Contract.SetRecFilter();
        CreateContractInvoice.SetTableView(Contract);
        CreateContractInvoice.UseRequestPage(false);
        CreateContractInvoice.Run();
    end;

    local procedure VerifySalesInvoices()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
        SalesHeader.SetRange("Sell-to Customer No.", UPDASTestChamber."Customer No.");
        SalesHeader.SetRange("UPD AS Test Chamber Code", UPDASTestChamber.Code);
        SalesHeader.FindFirst();
    end;

    local procedure VerifySalesInvoiceLine()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Contract: Record "UPD AS Contract";
    begin
        Contract.Get(UPDASTestChamber."Customer No.", UPDASTestChamber.Code);
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
        SalesHeader.SetRange("Sell-to Customer No.", UPDASTestChamber."Customer No.");
        SalesHeader.SetRange("UPD AS Test Chamber Code", UPDASTestChamber.Code);
        SalesHeader.FindFirst();

        // Make sure the first line exists
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.FindFirst();

        // verify type, no, quantity, and price
        Assert.AreEqual(SalesLine.Type::"G/L Account", SalesLine.Type, GetFieldOnTableTxt(SalesLine.FieldCaption(Type), SalesLine.TableCaption));
        Assert.AreEqual(ChamberSetup."UPD AS Contract G/L Acct.", SalesLine."No.", GetFieldOnTableTxt(SalesLine.FieldCaption("No."), SalesLine.TableCaption));
        Assert.AreEqual(1, SalesLine.Quantity, GetFieldOnTableTxt(SalesLine.FieldCaption(Quantity), SalesLine.TableCaption));
        Assert.AreEqual(Contract.GetContractValue(), SalesLine."Unit Price", GetFieldOnTableTxt(SalesLine.FieldCaption("Unit Price"), SalesLine.TableCaption));
    end;


    procedure GetFieldOnTableTxt(FieldCaption: Text; TableCaption: Text): Text
    var
        FieldOnTableTxt: Label '%1 on %2';
    begin
        exit(StrSubstNo(
                FieldOnTableTxt,
                FieldCaption,
                TableCaption))
    end;
}
