table 50062 "UPD AS Chamber Ledger"
{
    Caption = 'Chamber Ledger';
    DataClassification = ToBeClassified;
    DrillDownPageId = "UPD AS Chamber Ledger Entries";

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
        Rec.Modify(true);
        OnAfterActivateItem();
    end;

    procedure DeactivateItem()
    var
        Confirmed: Boolean;
        IsHandled: Boolean;
    begin
        OnBeforeDeactivateItem(IsHandled);
        if IsHandled then
            exit;
        Confirmed := true;
        if GuiAllowed then
            Confirmed := Confirm('Are you sure you want to deactivate this item?', true);
        if Confirmed then begin
            Rec.Validate(Active, false);
            Rec.Modify(true);
            OnAfterDeactivateItem();
        end;
    end;

    [BusinessEvent(false)]
    local procedure OnAfterActivateItem()
    begin
    end;

    [BusinessEvent(false)]
    local procedure OnBeforeActivateItem(var IsHandled: Boolean)
    begin
    end;

    [BusinessEvent(false)]
    local procedure OnBeforeDeactivateItem(IsHandled: Boolean)
    begin
    end;

    [BusinessEvent(false)]
    local procedure OnAfterDeactivateItem()
    begin
    end;

}
