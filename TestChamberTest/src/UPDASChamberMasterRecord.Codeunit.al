codeunit 70061 "UPD AS Chamber Master Record"
{
    //[FEATURE] Test Chamber Master Record
    Subtype = Test;

    var
        Customer: Record Customer;
        Item: Record Item;
        UPDASTestChamber: Record "UPD AS Test Chamber";
        LibraryInventory: Codeunit "Library - Inventory";
        LibraryRandom: Codeunit "Library - Random";
        LibrarySales: Codeunit "Library - Sales";
        isInitialized: Boolean;

    //[SCENARIO #0001] Create New Test Chamber
    [Test]
    procedure CreateNewTestChamber()
    begin
        Initialize();

        //[GIVEN] Customer

        //[WHEN] User creates new Test Chamber
        CreateChamberForCustomer();

        //[THEN] Test Chamber exists for Customer
        UPDASTestChamber.Find('=');
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
    begin
        if isInitialized then
            exit;

        LibrarySales.CreateCustomer(Customer);
        LibraryInventory.CreateItem(Item);

        isInitialized := true;
    end;


    local procedure CreateChamberForCustomer()
    begin
        UPDASTestChamber.Init();
        UPDASTestChamber."Customer No." := Customer."No.";
        UPDASTestChamber.Code := CopyStr(LibraryRandom.RandText(20), 1, MaxStrLen(UPDASTestChamber.Code));
        UPDASTestChamber.Insert(true);
    end;
}
