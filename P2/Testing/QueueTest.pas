program UnitTest;

uses RequestQueue, crt;

const
	finished = 'Done!';

procedure isThisEmptyQuestionMark(Q:tQueue; expectedValue: boolean; var errors:integer);
	begin
		if isEmptyQueue(Q) then
			writeln('TRUE')
		else
			writeln('FALSE');

		if isEmptyQueue(Q) <> expectedValue then
			errors:= errors + 1;
	end;

procedure insert(c:char; var Q:tQueue);
	var
		d: tItemQ;
	begin
		d.code:=c;
		d.parameter1:= '';
		d.parameter2:= '';
		d.parameter3:= '';
		enqueue(d, Q);
		writeln(finished);
	end;

procedure showFront(Q:tQueue; expectedValue: char; var errors:integer);
	begin
		writeln('Contains: ',front(Q).code);
		if front(Q).code <> expectedValue then
			errors:= errors + 1;
	end;

procedure header(s:string);
	begin
		if s <> 'Initialize Queue' then
			writeln;
		writeln('*****************************************************************************');
		writeln(s);
		writeln('*****************************************************************************');
	end;
var
	Q: tQueue;
	errors: integer = 0;

begin
	header('Initialize Queue');
	createEmptyQueue(Q);
	writeln(finished);


	header('Is it Empty?');
	isThisEmptyQuestionMark(Q, true, errors);
	writeln('Must be: TRUE');

	header('Enqueue A');
	insert('A', Q);

	header('Front');
	showFront(Q, 'A', errors);
	writeln('Must be: A');
	writeln;

	header('Enqueue B');
	insert('B', Q);

	header('Front');
	showFront(Q, 'A', errors);
	writeln('Must be: A');

	header('Dequeue A');
	dequeue(Q);
	writeln(finished);

	header('Front');
	showFront(Q, 'B', errors);
	writeln('Must be: B');

	header('Is it Empty?');
	isThisEmptyQuestionMark(Q, false, errors);
	writeln('Must be: FALSE');

	header('Dequeue B');
	dequeue(Q);
	writeln(finished);

	header('Is it Empty?');
	isThisEmptyQuestionMark(Q, true, errors);
	writeln('Must be: TRUE');

	header('Enqueue A');
	insert('A', Q);

	header('Is it Empty?');
	isThisEmptyQuestionMark(Q, false, errors);
	writeln('Must be: FALSE');

	header('Dequeue A');
	dequeue(Q);
	writeln(finished);

	header('Is it Empty?');
	isThisEmptyQuestionMark(Q, true, errors);
	writeln('Must be: TRUE');


	header('ERROR COUNTER');
	if errors = 0 then begin
		TextColor(Green);
		writeln(errors, ' errors found. You are free to go!');
		TextColor(White);
	end else begin
	TextColor(Red);
	writeln(errors, ' error(s) found. You better check this shit out e_e');
	TextColor(White);
	end;
end.
