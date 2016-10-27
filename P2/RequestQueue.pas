unit RequestQueue;

interface
  const
    NULLQ = nil;

  type
    tCode = char;

    tItemQ = record
      code: tCode;
      parameter1: string;
      parameter2: string;
      parameter3: string
    end;
    tPosQ = ^tNodeQ;
    tNodeQ = record
      data: tItemQ;
      next: tPosQ
    end;
    tQueue = record
    front: tPosQ;
    rear: tPosQ
    end;

  procedure createEmptyQueue(var Q:tQueue);
  function isEmptyQueue(Q:tQueue):boolean;
  function front(Q:tQueue):tItemQ;
  function enqueue(a:tItemQ; var Q:tQueue):boolean;
  procedure dequeue(var Q:tQueue);

implementation

  procedure createEmptyQueue(var Q:tQueue);
  // --------------------------------------------------------------------------------------
  // AIM: Creates an empty queue                                                        ---
  // INPUT: A variable to initialize the queue                                          ---
  // OUTPUT: An initialized queue                                                       ---
  // --------------------------------------------------------------------------------------
    begin
      Q.front:= NULLQ;
      Q.rear:= NULLQ
    end;

  function isEmptyQueue(Q:tQueue):boolean;
  // --------------------------------------------------------------------------------------
  // AIM: Checks whether the queue is empty                                             ---
  // INPUT: The queue                                                                   ---
  // OUTPUT: A boolean (if empty = true, else false)                                    ---
  // PREC: The queue has been initialized                                               ---
  // --------------------------------------------------------------------------------------
    begin
      isEmptyQueue:= (Q.front = NULLQ)
    end;

  function front(Q:tQueue):tItemQ;
  // --------------------------------------------------------------------------------------
  // AIM: Gets the front element of the queue                                           ---
  // INPUT: The queue                                                                   ---
  // OUTPUT: The element                                                                ---
  // PREC: The queue has been initialized                                               ---
  // --------------------------------------------------------------------------------------
    begin
      front:= Q.front^.data
    end;

  function createNodeQ(VAR p:tPosQ):boolean;
  // Auxiliar function to create a node and check if there's room for it
    begin
      new(p);
      createNodeQ:= (p<>nil);
    end;

  function enqueue(a:tItemQ; var Q:tQueue):boolean;
  // --------------------------------------------------------------------------------------
  // AIM: To insert a new element to the queue                                             ---
  // INPUT: The queue, the item to be inserted                                          ---
  // PREC: The queue has been initialized                                               ---
  // OUTPUT: The modified queue and a boolean (true if successful, false if not)        ---
  // --------------------------------------------------------------------------------------
    var
      n: tPosQ; // n is a new node for the item
    begin
      if not createNodeQ(n) then // If there's room for at least one more item
        enqueue:= false
      else begin
        enqueue:= true;
        n^.data:= a; // Fills the node with the new item
        n^.next:= NULLQ;
        if Q.front = NULLQ then begin // Case it's empty
          Q.front:= n;
          Q.rear:= n
        end else begin // Case it isn't
          Q.rear^.next:= n;
          Q.rear:= n
        end
      end
    end;

    procedure dequeue(var Q:tQueue);
    // --------------------------------------------------------------------------------------
    // AIM: To remove the front element                                                   ---
    // INPUT: The queue                                                                   ---
    // PREC: The queue is not empty                                                       ---
    // OUTPUT: The modified queue                                                         ---
    // --------------------------------------------------------------------------------------
    var
      i: tPosQ;
    begin
      i:= Q.front;
      Q.front:= Q.front^.next; // We define front as the following element
      if Q.front = NULLQ then // In case there was only one element
        Q.rear:= NULLQ;
      dispose(i);
    end;
end.
