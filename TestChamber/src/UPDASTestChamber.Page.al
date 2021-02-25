page 50061 "UPD AS Test Chamber"
{

    Caption = 'UPD AS Test Chamber';
    PageType = Card;
    SourceTable = "UPD AS Test Chamber";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Active field';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Serial No. field';
                }
            }
            part(LedgerEntries; "UPD AS Chamber Ledgers Part")
            {
                SubPageLink = "Customer No." = field("Customer No."), "Chamber Code" = field(Code);
            }
        }
    }

}
