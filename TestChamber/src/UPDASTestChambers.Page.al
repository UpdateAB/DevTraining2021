page 50060 "UPD AS Test Chambers"
{

    ApplicationArea = All;
    Caption = 'UPD AS Test Chambers';
    PageType = List;
    SourceTable = "UPD AS Test Chamber";
    UsageCategory = Lists;
    CardPageId = "UPD AS Test Chamber";

    layout
    {
        area(content)
        {
            repeater(General)
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
            }
        }
    }

}
