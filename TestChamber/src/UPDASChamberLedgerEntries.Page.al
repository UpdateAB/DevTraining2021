page 50063 "UPD AS Chamber Ledger Entries"
{
    ApplicationArea = All;
    Caption = 'Chamber Ledger Entries';
    Editable = false;
    PageType = List;
    Permissions = tabledata "UPD AS Chamber Ledger" = m;
    SourceTable = "UPD AS Chamber Ledger";
    UsageCategory = History;

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
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field';
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
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Value field';
                }
                field("Delivery Date"; Rec."Delivery Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delivery Date field';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ApproveAction)
            {
                ApplicationArea = All;
                Caption = 'Activate';
                Enabled = not Rec.Active;
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Marks the Chamber Item as Active.';

                trigger OnAction()
                begin
                    Rec.Active := true;
                    Rec.Modify(true);
                end;
            }
            action(CancelAction)
            {
                ApplicationArea = All;
                Caption = 'Deactivate';
                Enabled = Rec.Active;
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Marks the Chamber Item as Inactive.';

                trigger OnAction()
                begin
                    Rec.Active := false;
                    Rec.Modify(true);
                end;
            }

        }
    }

}
