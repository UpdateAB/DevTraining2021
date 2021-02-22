page 50070 "UPD AS Contract List"
{

    ApplicationArea = All;
    Caption = 'UPD AS Contract List';
    PageType = List;
    SourceTable = "UPD AS Contract";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No. field';
                }
                field("Chamber Code"; Rec."Chamber Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Chamber Code field';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Active field';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field';
                }
                field("Last Invoice Generated Date"; Rec."Last Invoice Generated Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Invoice Generated Date field';
                }
                field("Active Value"; Rec."Active Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Installed Value field';
                }
                field(ContractValue; ContractValue)
                {
                    ApplicationArea = All;
                    Caption = 'Contract Value';
                    ToolTip = 'Total Contract Value based on Setup % Rate';
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(OpenInvoices)
            {
                ApplicationArea = All;
                Caption = 'Open Invoices';
                Image = "Invoicing-View";
                ToolTip = 'Navigate to all Open Invoice for this Test Chamber';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SalesInvList: Page "Sales Invoice List";
                begin
                    Clear(SalesInvList);
                    SalesHeader.SetRange("Sell-to Customer No.", rec."Customer No.");
                    SalesHeader.SetRange("UPD AS Test Chamber Code", rec."Chamber Code");
                    SalesInvList.SetTableView(SalesHeader);
                    SalesInvList.Run();
                end;
            }
            action(PostedInvoices)
            {
                ApplicationArea = All;
                Caption = 'Posted Invoices';
                Image = "Invoicing-View";
                ToolTip = 'Navigate to all Posted Invoice for this Test Chamber';

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                    SalesInvList: Page "Posted Sales Invoices";
                begin
                    Clear(SalesInvList);
                    SalesInvHeader.SetRange("Sell-to Customer No.", rec."Customer No.");
                    SalesInvHeader.SetRange("UPD AS Test Chamber Code", rec."Chamber Code");
                    SalesInvList.SetTableView(SalesInvHeader);
                    SalesInvList.Run();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ContractValue := Rec.GetContractValue();
    end;

    var
        ContractValue: Decimal;

}
