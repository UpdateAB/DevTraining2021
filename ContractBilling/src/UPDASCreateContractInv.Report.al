report 50070 "UPD AS Create Contract Inv."
{
    Caption = 'Create Contract Invoices';
    ProcessingOnly = true;

    dataset
    {
        dataitem(UPDASContract; "UPD AS Contract")
        {
            DataItemTableView = where(Active = filter(true));
            RequestFilterFields = "Customer No.", "Chamber Code";

            trigger OnAfterGetRecord()
            begin
                if GenerateInvoiceForChamber(UPDASContract) then
                    InvoicesCreated += 1;
            end;
        }
    }

    trigger OnPostReport()
    begin
        if GuiAllowed then
            Message(RoutineCompleteMsg, InvoicesCreated);
    end;

    procedure GenerateInvoiceForChamber(UPDASContract: Record "UPD AS Contract"): Boolean
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        SafeGetSetup();
        UPDASContract.CalcFields("Active Value");
        if UPDASContract."Active Value" > 0 then begin
            SalesHeader.Init();
            SalesHeader."Document Type" := "Sales Document Type"::Invoice;
            SalesHeader.Insert(true);
            SalesHeader.Validate("Sell-to Customer No.", UPDASContract."Customer No.");
            SalesHeader.Validate("UPD AS Test Chamber Code", UPDASContract."Chamber Code");
            SalesHeader.Modify(true);
            SalesLine.Init();
            SalesLine.Validate("Document Type", SalesHeader."Document Type");
            SalesLine.Validate("Document No.", SalesHeader."No.");
            SalesLine.Validate("Line No.", 10000);
            SalesLine.Insert(true);
            SalesLine.Validate(type, SalesLine.Type::"G/L Account");
            SalesLine.Validate("No.", ContractSetup."UPD AS Contract G/L Acct.");
            SalesLine.Validate(Quantity, 1);
            SalesLine.Validate("Unit Price", UPDASContract.GetContractValue());
            SalesLine.Modify(true);
            exit(true);
        end;
    end;

    var
        ContractSetup: Record "UPD AS Chamber Setup";
        IsSetupGot: Boolean;
        InvoicesCreated: Integer;
        RoutineCompleteMsg: Label 'Created %1 Sales Invoices', Comment = '%1';

    local procedure SafeGetSetup()
    begin
        if IsSetupGot then exit;
        ContractSetup.Get();
        ContractSetup.TestField("UPD AS Contract Value Rate");
        ContractSetup.TestField("UPD AS Contract G/L Acct.");
        IsSetupGot := true;
    end;
}
