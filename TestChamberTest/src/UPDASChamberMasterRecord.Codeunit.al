codeunit 70061 "UPD AS Chamber Master Record"
{
    //[FEATURE] Test Chamber Master Record
    Subtype = Test;

    var
        Customer: Record Customer;
        Item: Record Item;
        UPDASTestChamber: Record "UPD AS Test Chamber";

        Assert: Codeunit Assert;
        LibraryChamber: Codeunit "Chamber Library Functions";
        LibraryInventory: Codeunit "Library - Inventory";
        LibraryRandom: Codeunit "Library - Random";
        LibrarySales: Codeunit "Library - Sales";


        LibraryUtility: Codeunit "Library - Utility";
        isInitialized: Boolean;
    //[SCENARIO #0001] Create New Test Chamber
    [Test]
    procedure CreateNewTestChamber()
    begin
        Initialize();

        //[GIVEN] Customer

        //[WHEN] User creates new Test Chamber
        LibraryChamber.CreateChamberForCustomer(UPDASTestChamber, Customer);

        //[THEN] Test Chamber exists for Customer
        VerifyTestChamberExists();
    end;




    //[SCENARIO #0002] Customer is Deleted
    //[GIVEN] Customer
    //[GIVEN] Test Chamber exists for Customer
    //[WHEN] Customer is deleted
    //[THEN] Test Chamber is deleted



    //[SCENARIO #0003] Prevent Chamber Deletion if Inventory
    //[GIVEN] Customer
    //[GIVEN] Item
    //[GIVEN] Test Chamber
    //[GIVEN] No Test Chamber Ledger Entry Exists
    //[WHEN] Test Chamber is deleted
    //[THEN] Test Chamber is deleted


    //[SCENARIO #0004] Prevent Chamber Deletion if Inventory
    //[GIVEN] Customer
    //[GIVEN] Item
    //[GIVEN] Test Chamber
    //[GIVEN] Test Chamber Ledger Entry Exists
    //[WHEN] Test Chamber is deleted
    //[THEN] Test Chamber is not deleted, error is shown


    //[SCENARIO #0005] Create New from Customer Card
    //[GIVEN] Customer
    //[WHEN] User creates new Test Chamber
    //[THEN] Test Chamber exists for Customer


    local procedure Initialize()
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        ChamberSetup: Record "UPD AS Chamber Setup";
    begin
        if isInitialized then
            exit;

        ChamberSetup.Init();
        LibraryUtility.CreateNoSeries(NoSeries, true, false, false);
        LibraryUtility.CreateNoSeriesLine(NoSeriesLine, NoSeries.Code, '', '');
        ChamberSetup."Chamber No Series." := NoSeries.Code;
        ChamberSetup.Insert(true);

        LibrarySales.CreateCustomer(Customer);
        LibraryInventory.CreateItem(Item);

        isInitialized := true;
    end;


    local procedure VerifyTestChamberExists()
    begin
        UPDASTestChamber.Find('=');
        Assert.AreNotEqual(UPDASTestChamber.Code, '', LibraryChamber.GetFieldOnTableTxt(UPDASTestChamber.FieldCaption(Code), UPDASTestChamber.TableCaption));
    end;
}
