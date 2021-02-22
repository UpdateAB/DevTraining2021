codeunit 50060 "UPD AS Test Chamber Posting"
{

    local procedure PostedSalesLineToTestChamberLedger(SalesHeader: Record "Sales Header"; SalesShipmentLines: Record "Sales Shipment Line")
    var
        TestChamberLedger: Record "UPD AS Chamber Ledger";
        i: Integer;
    begin
        for i := 1 to SalesShipmentLines.Quantity do begin
            TestChamberLedger.Init();
            TestChamberLedger.Validate("Customer No.", SalesHeader."Sell-to Customer No.");
            TestChamberLedger.Validate("Chamber Code", SalesHeader."UPD AS Test Chamber Code");
            TestChamberLedger."Entry No." := 0;
            TestChamberLedger.Validate("Item No.", SalesShipmentLines."No.");
            TestChamberLedger.Validate(Active, true);
            TestChamberLedger.Validate(Value, SalesShipmentLines."Unit Price");
            TestChamberLedger.Validate("Delivery Date", SalesHeader."Posting Date");
            TestChamberLedger.Insert(true);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', true, true)]
    local procedure "Sales-Post_OnAfterPostSalesDoc"
    (
        var SalesHeader: Record "Sales Header";
        var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        SalesShptHdrNo: Code[20];
        RetRcpHdrNo: Code[20];
        SalesInvHdrNo: Code[20];
        SalesCrMemoHdrNo: Code[20];
        CommitIsSuppressed: Boolean;
        InvtPickPutaway: Boolean;
        var CustLedgerEntry: Record "Cust. Ledger Entry";
        WhseShip: Boolean;
        WhseReceiv: Boolean
    )
    var
        SalesShipmentLines: Record "Sales Shipment Line";

    begin
        //Error('Event Fired, %1, %2', SalesHeader.Ship, SalesHeader."UPD AS Test Chamber Code");
        if not SalesHeader.Ship then
            exit;
        if SalesHeader."UPD AS Test Chamber Code" = '' then
            exit;

        SalesShipmentLines.SetRange("Document No.", SalesShptHdrNo);
        SalesShipmentLines.SetRange(Type, SalesShipmentLines.Type::Item);
        if SalesShipmentLines.FindSet() then
            repeat
                PostedSalesLineToTestChamberLedger(SalesHeader, SalesShipmentLines);
            until SalesShipmentLines.Next() < 1
        else
            Error('No shipping lines found.');
    end;

}
