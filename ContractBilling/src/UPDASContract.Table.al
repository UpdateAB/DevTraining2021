table 50071 "UPD AS Contract"
{
    Caption = 'UPD AS Contract';
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
        field(10; Active; Boolean)
        {
            Caption = 'Active';
            DataClassification = CustomerContent;
        }
        field(20; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(21; "Last Invoice Generated Date"; Date)
        {
            Caption = 'Last Invoice Generated Date';
            DataClassification = CustomerContent;
        }

        field(1000; "Active Value"; Decimal)
        {
            CalcFormula = sum("UPD AS Chamber Ledger".Value where("Customer No." = field("Customer No."), "Chamber Code" = field("Chamber Code"), Active = const(true)));
            Caption = 'Installed Value';
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(PK; "Customer No.", "Chamber Code")
        {
            Clustered = true;
        }
    }

    procedure GetContractValue(): Decimal
    var
        ContractSetup: Record "UPD AS Chamber Setup";
    begin
        CalcFields("Active Value");
        if ContractSetup.Get() then begin
            ContractSetup.TestField("UPD AS Contract Value Rate");
            exit("Active Value" * (ContractSetup."UPD AS Contract Value Rate" / 100));
        end;
    end;
}
