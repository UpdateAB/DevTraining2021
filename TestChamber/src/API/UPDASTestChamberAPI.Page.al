page 50064 "UPD AS Test Chamber API"
{

    APIGroup = 'aperture';
    APIPublisher = 'upd';
    APIVersion = 'v1.0';
    Caption = 'UPDASTestChamberAPI';
    DelayedInsert = true;
    EntityName = 'testChamber';
    EntitySetName = 'testChambers';
    PageType = API;
    SourceTable = "UPD AS Test Chamber";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(customerNo; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'customerNo', Locked = true;
                }
                field("code"; Rec.Code)
                {
                    ApplicationArea = All;
                    Caption = 'code', Locked = true;
                }
                field(active; Rec.Active)
                {
                    ApplicationArea = All;
                    Caption = 'active', Locked = true;
                }
                field(description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'description', Locked = true;
                }
                field(id; Rec.SystemId)
                {
                    ApplicationArea = All;
                }

                part(LedgerEntries; "UPD AS Chamber Ledgers Part")
                {
                    EntityName = 'ledgerEntry';
                    EntitySetName = 'ledgerEntries';
                    SubPageLink = "Customer No." = field("Customer No."), "Chamber Code" = field(Code);
                }
            }
        }
    }



}
