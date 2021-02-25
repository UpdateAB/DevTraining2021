page 50065 "UPD AS Chamber Ledgers Part"
{

    Caption = 'UPD AS Chamber Ledgers Part';
    PageType = ListPart;
    SourceTable = "UPD AS Chamber Ledger";

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
                    Visible = false;
                }
                field("Chamber Code"; Rec."Chamber Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Chamber Code field';
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Active field';
                }
                field("Delivery Date"; Rec."Delivery Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delivery Date field';
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Value field';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Activate)
            {
                ApplicationArea = All;
                Caption = 'Activate';
                Image = Approval;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'bleh';

                trigger OnAction()
                begin
                    PageActivateItem();
                end;
            }
            action(Deactivate)
            {
                ApplicationArea = All;
                Caption = 'Deactivate';
                Image = DisableBreakpoint;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'bleh';

                trigger OnAction()
                begin
                    PageDeactivateItem();
                end;
            }
        }
    }

    [ServiceEnabled]
    [Scope('OnPrem')]
    procedure PageActivateItem()
    begin
        rec.ActivateItem();
    end;

    [ServiceEnabled]
    [Scope('OnPrem')]
    procedure PageDeactivateItem()
    begin
        rec.DeactivateItem();
    end;
}
