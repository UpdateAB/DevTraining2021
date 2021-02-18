codeunit 50060 "UPD AS Test Chamber Posting"
{

    local procedure PostedSalesLineToTestChamberLedger(SalesHeader: Record "Sales Header"; SalesLines: Record "Sales Line")
    var
        TestChamberLedger: Record "UPD AS Chamber Ledger";
        i: Integer;
    begin
        Error('PostedSalesLineToTestChamberLedger %1', SalesLines."Qty. to Ship");
        for i := 1 to SalesLines."Qty. to Ship" do begin
            TestChamberLedger.Init();
            TestChamberLedger.Validate("Customer No.", SalesHeader."Sell-to Customer No.");
            TestChamberLedger.Validate("Chamber Code", SalesHeader."UPD AS Test Chamber Code");
            TestChamberLedger.Validate("Item No.", SalesLines."No.");
            TestChamberLedger.Validate(Active, true);
            TestChamberLedger.Validate(Value, SalesLines."Unit Price");
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
        SalesLines: Record "Sales Line";

    begin
        //Error('Event Fired, %1, %2', SalesHeader.Ship, SalesHeader."UPD AS Test Chamber Code");
        if not SalesHeader.Ship then
            exit;
        if SalesHeader."UPD AS Test Chamber Code" = '' then
            exit;

        SalesLines.SetRange("Document Type", SalesHeader."Document Type");
        SalesLines.SetRange("Document No.", SalesHeader."No.");
        SalesLines.SetRange(Type, SalesLines.Type::Item);
        SalesLines.SetFilter("Qty. to Ship", '<>0');
        if SalesLines.FindSet() then
            repeat
                PostedSalesLineToTestChamberLedger(SalesHeader, SalesLines);
            until SalesLines.Next() < 1
        else
            Error('No shipping lines found.');
    end;

}
