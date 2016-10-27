unit UserList;

interface

  uses PhotoList;
  const
    NULLU = nil;

  type
    tNickname = string;
    tUsername = string;
    tAccount = (free, premium); // Why would we want an enumerated type for a boolean behavior? This is nonsense

    tItemU = record
      nickname: tNickname;
      username: tUsername;
      account: tAccount;
      photos: tListP;
    end;
    tPosU = ^tNodeU;
    tNodeU = record
      data: tItemU;
      next: tPosU
    end;
    tListU = tPosU;

  procedure createEmptyListU(var L:tListU);
  function isEmptyListU(L:tListU):boolean;
  function firstU(L:tListU):tPosU;
  function lastU(L:tListU):tPosU;
  function nextU(p:tPosU; L:tListU):tPosU;
  function previousU(p:tPosU; L:tListU):tPosU;
  function insertItemU(a:tItemU; var L:tListU):boolean;
  procedure deleteAtPositionU(p:tPosU; var L:tListU);
  function getItemU(p:tPosU; L:tListU):tItemU;
  procedure updateItemU(var L:tListU; p:tPosU; a:tItemU);
  function findItemU(a:tNickname; L:tListU):tPosU;

implementation

  procedure createEmptyListU(var L:tListU);

    // --------------------------------------------------------------------------------------
    // AIM: Creates an empty list                                                         ---
    // INPUT: A variable to initialize the list                                           ---
    // OUTPUT: A new list                                                                 ---
    // POSC: The list is initialised and has no elements                                  ---
    // --------------------------------------------------------------------------------------

    begin
      L:= NULLU;

    end;

  function isEmptyListU(L:tListU):boolean;

  // --------------------------------------------------------------------------------------
  // AIM: To check whether the list is empty                                            ---
  // INPUT: A list to check                                                             ---
  // OUTPUT: True if empty, false if contains something                                 ---
  // --------------------------------------------------------------------------------------

    begin
      isEmptyListU:= (L = NULLU);
    end;

  function firstU(L:tListU):tPosU;

  // --------------------------------------------------------------------------------------
  // AIM: To get the first position of the list                                         ---
  // INPUT: A list to get the position                                                  ---
  // OUTPUT: The position                                                               ---
  // PREC: The list must not be empty                                                   ---
  // --------------------------------------------------------------------------------------

    begin
      firstU:= L;
    end;

  function lastU(L:tListU):tPosU;

  // --------------------------------------------------------------------------------------
  // AIM: To get the last position of the list                                          ---
  // INPUT: A list to get the position                                                  ---
  // OUTPUT: The position                                                               ---
  // PREC: The list must not be empty                                                   ---
  // --------------------------------------------------------------------------------------
    var
      i: tPosU;
    begin
      i:= L;
      while i^.next <> NULLU do
        i:= i^.next;
      lastU:= i;
    end;

  function nextU(p:tPosU; L:tListU):tPosU;

  // --------------------------------------------------------------------------------------
  // AIM: Returns the position following the one we indicate                            ---
  // INPUT: A list to get the position and the original position                        ---
  // OUTPUT: The position                                                               ---
  // POSC: Returns NULLU if the specified position has no next element                  ---
  // --------------------------------------------------------------------------------------

    begin
      nextU:= p^.next;
    end;

  function previousU(p:tPosU; L:tListU):tPosU;
  // --------------------------------------------------------------------------------------
  // AIM: Returns the position preceding the one we indicate                            ---
  // INPUT: A list to get the position and the original position                        ---
  // OUTPUT: The position                                                               ---
  // POSC: Returns NULLU if the specified position has no previous element              ---
  // --------------------------------------------------------------------------------------
    var
      i: tPosU;

    begin
      if p = L then // Case it's the first item
        previousU:= NULLU
      else begin
        i:= L;
        while i^.next <> p do
          i:= i^.next;
        previousU:= i
      end
    end;

  function createNodeU(VAR p:tPosU):boolean;
    begin
      new(p);
      createNodeU:= (p<>nil);
    end;
  function insertItemU(a:tItemU; var L:tListU):boolean;

  // --------------------------------------------------------------------------------------
  // AIM: Inserts an element containing the provided data item (ordered) into the list  ---
  // INPUT:                                                                             ---
  //  • The item to insert                                                              ---
  //  • The list where you want to insert the item                                      ---
  // OUTPUT:                                                                            ---
  //  • If the element could be inserted, the value true is returned,                   ---
  //     otherwise false is returned                                                    ---
  //  • A modified list with the new element                                            ---
  // PREC: The specified position is a valid position in the list or a NULLU position   ---
  // --------------------------------------------------------------------------------------

    var
      i, n: tPosU; // n is a new node for the item
    begin
      if not createNodeU(n) then // If there's room for at least one more item
        insertItemU:= false
      else begin
        insertItemU:= true;
        n^.data:= a; // Fills the node with the new item
        n^.next:= NULLU;
        if L = NULLU then // Case it's empty
          L:= n
        else if a.nickname < L^.data.nickname then begin
          n^.next:= L;
          L:= n
        end else begin
          i:= L;
          while (i^.next <> NULLU) and (i^.next^.data.nickname < a.nickname) do
              i:= i^.next;
          n^.next:= i^.next;
          i^.next:= n
        end
      end
    end;

  procedure deleteAtPositionU(p:tPosU; var L:tListU);

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
      i: tPosU; // Auxiliar variable to loop over the positions of the list
    begin
      if L = p then // If it's the first
        L := p^.next
      else if p^.next = NULLU then begin // If it's the last item
        i:= L;
        while (i^.next <> p) do
          i:= i^.next;
        i^.next:= NULLU;
      end else begin // If it's any other
        i:= p^.next;
        p^.data:= i^.data;
        p^.next:= i^.next;
        p:= i
      end;
      dispose(p);
    end;

  function getItemU(p:tPosU; L:tListU):tItemU;

  // --------------------------------------------------------------------------------------
  // AIM: Retrieves the content of the element at the position we indicate              ---
  // INPUT:                                                                             ---
  //  • The position of the item we want to get                                         ---
  //  • The list where the item is stored                                               ---
  // OUTPUT: The item                                                                   ---
  // PREC: The indicated position is a valid position in the list                       ---
  // --------------------------------------------------------------------------------------

    begin
      getItemU:= p^.data;
    end;

  procedure updateItemU(var L:tListU; p:tPosU; a:tItemU);

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

  function findItemU(a:tNickname; L:tListU):tPosU;

  // --------------------------------------------------------------------------------------
  // AIM: To search an item in a list                                                   ---
  // INPUT:                                                                             ---
  //  • The search key (photo ID)                                                       ---
  //  • The list where where you want to searh                                          ---
  // OUTPUT: The position of the item you looked for or NULLU if it isn't in the list   ---
  // --------------------------------------------------------------------------------------
    var
      i: tPosU; // Auxiliar variable to loop over the list
    begin
      if L = NULLU then // Case it's empty
        findItemU:= NULLU
      else begin
        i:= L;
        while (i^.next <> NULLU) and (i^.data.nickname < a) do // Will stop at the end of the list or if you've found the item
          i:= i^.next;
        if i^.data.nickname = a then
          findItemU:= i
        else
          findItemU:= NULLU
      end
    end;
end.
