unit dynamicList;

interface
  const
    NULL = nil;

  type
    tIdPhoto = integer;
    tFileName = string;
    tComment = string;
    tReported = boolean;
    tLikesCounter = integer;

    tItem = record
      idPhoto: tIdPhoto;
      fileName: tFileName;
      comment: tComment;
      reported: tReported;
      likes: tLikesCounter
    end;
    tPosL = ^tNode;
    tNode = record
      data: tItem;
      next: tPosL
    end;
    tList = tPosL;

  procedure createEmptyList(var L:tList);
  function isEmptyList(L:tList):boolean;
  function first(L:tList):tPosL;
  function last(L:tList):tPosL;
  function next(p:tPosL; L:tList):tPosL;
  function previous(p:tPosL; L:tList):tPosL;
  function insertItem(a:tItem; p:tPosL; var L:tList):boolean;
  procedure deleteAtPosition(p:tPosL; var L:tList);
  function getItem(p:tPosL; L:tList):tItem;
  procedure updateItem(var L:tList; p:tPosL; a:tItem);
  function findItem(a:tIdPhoto; L:tList):tPosL;

implementation

  procedure createEmptyList(var L:tList);

    // --------------------------------------------------------------------------------------
    // AIM: Creates an empty list                                                         ---
    // INPUT: A variable to initialize the list                                           ---
    // OUTPUT: A new list                                                                 ---
    // POSC: The list is initialised and has no elements                                  ---
    // --------------------------------------------------------------------------------------

    begin
      L:= NULL;

    end;

  function isEmptyList(L:tList):boolean;

  // --------------------------------------------------------------------------------------
  // AIM: To check whether the list is empty                                            ---
  // INPUT: A list to check                                                             ---
  // OUTPUT: True if empty, false if contains something                                 ---
  // --------------------------------------------------------------------------------------

    begin
      isEmptyList:= (L = NULL);
    end;

  function first(L:tList):tPosL;

  // --------------------------------------------------------------------------------------
  // AIM: To get the first position of the list                                         ---
  // INPUT: A list to get the position                                                  ---
  // OUTPUT: The position                                                               ---
  // PREC: The list must not be empty                                                   ---
  // --------------------------------------------------------------------------------------

    begin
      first:= L;
    end;

  function last(L:tList):tPosL;

  // --------------------------------------------------------------------------------------
  // AIM: To get the last position of the list                                          ---
  // INPUT: A list to get the position                                                  ---
  // OUTPUT: The position                                                               ---
  // PREC: The list must not be empty                                                   ---
  // --------------------------------------------------------------------------------------
    var
      i: tPosL;
    begin
      i:= L;
      while i^.next <>NULL do
        i:= i^.next;
      last:= i;
    end;

  function next(p:tPosL; L:tList):tPosL;

  // --------------------------------------------------------------------------------------
  // AIM: Returns the position following the one we indicate                            ---
  // INPUT: A list to get the position and the original position                        ---
  // OUTPUT: The position                                                               ---
  // POSC: Returns NULL if the specified position has no next element                   ---
  // --------------------------------------------------------------------------------------

    begin
      next:= p^.next;
    end;

  function previous(p:tPosL; L:tList):tPosL;
  // --------------------------------------------------------------------------------------
  // AIM: Returns the position preceding the one we indicate                            ---
  // INPUT: A list to get the position and the original position                        ---
  // OUTPUT: The position                                                               ---
  // POSC: Returns NULL if the specified position has no previous element               ---
  // --------------------------------------------------------------------------------------
    var
      i: tPosL;

    begin
      if p = L then // Case it's the first item
        previous:= NULL
      else begin
        i:= L;
        while i^.next <> p do
          i:= i^.next;
        previous:= i
      end
    end;

  function createNode(VAR p:tPosL):boolean;
    begin
      new(p);
      createNode:= (p<>nil);
    end;
  function insertItem(a:tItem; p:tPosL; var L:tList):boolean;

  // --------------------------------------------------------------------------------------
  // AIM: Inserts an element containing the provided data item before the given         ---
  //  position in the list                                                              ---
  // INPUT:                                                                             ---
  //  • The item to insert                                                              ---
  //  • The position where you want to insert the item                                  ---
  //  • The list where you want to insert the item                                      ---
  // OUTPUT:                                                                            ---
  //  • If the element could be inserted, the value true is returned,                   ---
  //     otherwise false is returned                                                    ---
  //  • A modified list with the new element                                            ---
  // PREC: The specified position is a valid position in the list or a NULL position    ---
  // POSC: If the specified position is NULL, then the element is added                 ---
  //  at the end of the list                                                            ---
  // --------------------------------------------------------------------------------------

    var
      i, n: tPosL; // n is a new node for the item
    begin
      if not createNode(n) then // If there's room for at least one more item
        insertItem:= false
      else begin
        insertItem:= true;
        n^.data:= a; // Fills the node with the new item
        n^.next:= NULL;
        if L = NULL then // Case it's empty
          L:= n
        else if p = NULL then begin // Case it's being inserted at the end
          i:= L;
          while i^.next <> NULL do
            i:= i^.next;
          i^.next:= n
        end else if p = L then begin // Case it's the first position
          n^.next:= L;
          L:= n
        end else begin // Somewhere else
          n^.next:= p^.next;
          p^.next := n;
          n^.data:=p^.data;
          p^.data:= a
        end
      end
    end;

  procedure deleteAtPosition(p:tPosL; var L:tList);

    // --------------------------------------------------------------------------------------
    // AIM: Deletes the element at the given position from the list                       ---
    // INPUT:                                                                             ---
    //  • The position you want to delete                                                 ---
    //  • The list where the item is stored                                               ---
    // OUTPUT: The modified list                                                          ---
    // PREC: The indicated position is a valid position in the list                       ---
    // POSC: The deleted position and the positions of the elements of the list           ---
    //  subsequent to it become invalid.                                                  ---
    // --------------------------------------------------------------------------------------

    var
      i: tPosL; // Auxiliar variable to loop over the positions of the list
    begin
      if L = p then // If it's the first
        L := p^.next
      else if p^.next = NULL then begin // If it's the last item
        i:= L;
        while (i^.next <> p) do
          i:= i^.next;
        i^.next:= NULL;
      end else begin // If it's any other

        // Swiping data method
        i:= p^.next;
        p^.data:= i^.data;
        p^.next:= i^.next;
        p:= i
      end;
      dispose(p);
    end;

  function getItem(p:tPosL; L:tList):tItem;

  // --------------------------------------------------------------------------------------
  // AIM: Retrieves the content of the element at the position we indicate              ---
  // INPUT:                                                                             ---
  //  • The position of the item we want to get                                         ---
  //  • The list where the item is stored                                               ---
  // OUTPUT: The item                                                                   ---
  // PREC: The indicated position is a valid position in the list                       ---
  // --------------------------------------------------------------------------------------

    begin
      getItem:= p^.data;
    end;

  procedure updateItem(var L:tList; p:tPosL; a:tItem);

    // --------------------------------------------------------------------------------------
    // AIM: Modifies the content of the element at the position we indicate               ---
    // INPUT:                                                                             ---
    //  • The position of the item want to update                                         ---
    //  • The item to overwrite                                                           ---
    //  • The list where the item is stored                                               ---
    // OUTPUT: The updated list                                                           ---
    // PREC: The indicated position is a valid position in the list                       ---
    // POSC: The order of the elements in the list has not been modified                  ---
    // --------------------------------------------------------------------------------------

    begin
      p^.data:= a;
    end;

  function findItem(a:tIdPhoto; L:tList):tPosL;

  // --------------------------------------------------------------------------------------
  // AIM: To search an item in a list                                                   ---
  // INPUT:                                                                             ---
  //  • The search key (photo ID)                                                       ---
  //  • The list where where you want to searh                                          ---
  // OUTPUT: The position of the item you looked for or NULL if it isn't in the list    ---
  // --------------------------------------------------------------------------------------
    var
      i: tPosL; // Auxiliar variable to loop over the list
    begin
      if L = NULL then // Case it's empty
        findItem:= NULL
      else begin
        i:= L;
        while (i <> NULL) and (i^.data.idPhoto <> a) do // Will stop at the end of the list or if you've found the item
          i:= i^.next;
        if i^.data.idPhoto = a then
          findItem:= i
        else
          findItem:= NULL
      end
    end;
end.
