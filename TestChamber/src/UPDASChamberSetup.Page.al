page 50062 "UPD AS Chamber Setup"
{
    ApplicationArea = All;
    Caption = 'Chamber Setup';
    PageType = Card;
    SourceTable = "UPD AS Chamber Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Numbering)
            {
                field("Chamber No Series."; Rec."Chamber No Series.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Chamber No Series. field';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert(true);
        end;
    end;
}
