table 50062 "UPD AS Chamber Ledger"
{
    Caption = 'Chamber Ledger';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
        }
        field(2; "Chamber Code"; Code[20])
        {
            Caption = 'Chamber Code';
            DataClassification = CustomerContent;
        }
        field(3; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
        }
        field(20; Active; Boolean)
        {
            Caption = 'Active';
            DataClassification = CustomerContent;
        }
        field(30; Value; Decimal)
        {
            Caption = 'Value';
            DataClassification = CustomerContent;
        }
        field(40; "Delivery Date"; Date)
        {
            Caption = 'Delivery Date';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Customer No.", "Chamber Code", "Entry No.")
        {
            Clustered = true;
        }
    }

    procedure ActivateItem()
    var
        IsHandled: Boolean;
    begin
        OnBeforeActivateItem(IsHandled);
        if IsHandled then
            exit;
        Rec.Validate(Active, true);
        OnAfterActivateItem();
    end;

    procedure DeactivateItem()
    begin

    end;


    [BusinessEvent(false)]
    local procedure OnAfterActivateItem()
    begin
    end;

    [BusinessEvent(false)]
    local procedure OnBeforeActivateItem(var IsHandled: Boolean)
    begin
    end;

}
