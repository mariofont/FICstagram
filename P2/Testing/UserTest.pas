program UnitTest;

uses UserList, PhotoList, crt;

type
	position = (next, previous, last, first);

const
	finished = 'Done!';

procedure header(s:string);
	begin
		if s <> 'Initialize Queue' then
			writeln;
		TextColor(Blue);
		writeln('*****************************************************************************');
		writeln(s);
		writeln('*****************************************************************************');
		TextColor(White);
	end;

procedure isThisEmptyQuestionMark(L:tListU; expectedValue:boolean; var errors:integer);
	begin
		if isEmptyListU(L) then
			writeln('TRUE')
		else
			writeln('FALSE');

		if isEmptyListU(L) <> expectedValue then
			errors:= errors + 1;
	end;

procedure insert(c:string; var L:tListU);
	var
		d: tItemU;
		P: tListP;
	begin
		d.nickname:=c;
		d.username:= '';
		d.account:= free;
		createEmptyListP(P);
		d.photos:= P;
		insertItemU(d, L);
		writeln(finished);
	end;

procedure showPos(p:position; L:tListU; expectedValue:string; var errors:integer);
	var
		s: string;
		r: tPosU;
	begin
		case p of
				last: r:= lastU(L);
				first: r:= firstU(L);
				next: r:= nextU(firstU(L), L);
				previous: r:= previousU(lastU(L), L)
		end;
		write('Contains: ');
		if r = NULLU then begin
			writeln('NULL');
			s:= 'NULL'
		end else begin
			writeln(getItemU(r, L).nickname);
			s:= getItemU(r, L).nickname
		end;
		if s <> expectedValue then
			errors:= errors + 1
	end;

procedure findingNemo(a:string; L:tListU; expectedValue:string; var errors:integer);
	var
		s: string;
		i: tPosU;
	begin
		i:= findItemU(a, L);
		write('Result: ');
		if i = NULLU then begin
			s:= 'NULL';
			writeln('Not found')
		end else begin
			s:= getItemU(i, L).nickname;
			writeln('Found')
		end;
		if s <> expectedValue then
			errors:= errors + 1
	end;

procedure updateTheFOutOfFirst(var L:tListU; expectedValue:string; var errors:integer);
	var
		a: tItemU;

	begin
		a:= getItemU(firstU(L), L);
		a.nickname:= expectedValue;
		updateItemU(L, firstU(L), a);
		showPos(first, L, expectedValue, errors);
	end;

procedure deletePosition(p:position; var L:tListU; expectedValue:string; var errors:integer);
	var
	 a: tPosU;

	begin
		case p of
			last: a:= lastU(L);
			first: a:= firstU(L);
			next: a:= nextU(firstU(L), L);
			previous: a:= previousU(lastU(L), L)
		end;
		deleteAtPositionU(a, L);
		showPos(p, L, expectedValue, errors);
	end;

var
	L: tListU;
	errors: integer = 0;

begin
	header('Initialize User List');
	createEmptyListU(L);
	writeln(finished);

	header('Is it Empty?');
	isThisEmptyQuestionMark(L, true, errors);
	writeln('Must be: TRUE');

	header('Insert User "B"');
	insert('B', L);

	header('First');
	showPos(first, L, 'B', errors);
	writeln('Must be: B');

	header('Last');
	showPos(last, L, 'B', errors);
	writeln('Must be: B');

	header('Insert User "A"');
	insert('A', L);

	header('Is it Empty?');
	isThisEmptyQuestionMark(L, false, errors);
	writeln('Must be: FALSE');

	header('First');
	showPos(first, L, 'A', errors);
	writeln('Must be: A');

	header('Last');
	showPos(last, L, 'B', errors);
	writeln('Must be: B');

	header('Find "A" item');
	findingNemo('A', L, 'A', errors);
	writeln('Must be: Found');

	header('Find "Aa" item');
	findingNemo('Aa', L, 'NULL', errors);
	writeln('Must be: Not Found');

	header('Find "E" item');
	findingNemo('E', L, 'NULL', errors);
	writeln('Must be: Not Found');

	header('Last''s previous');
	showPos(previous, L, 'A', errors);
	writeln('Must be: A');

	header('First''s next');
	showPos(next, L, 'B', errors);
	writeln('Must be: B');

	header('Update First');
	updateTheFOutOfFirst(L, 'X', errors);
	writeln('Must be: X');

	header('Delete First');
	deletePosition(first, L, 'B', errors);
	writeln('Must be: B');

	header('Insert User "A"');
	insert('A', L);

	header('Delete Last');
	deletePosition(last, L, 'A', errors);
	writeln('Must be: A');

	header('Insert User "A"');
	insert('A', L);

	header('Insert User "C"');
	insert('C', L);

	header('Delete First''s next');
	deletePosition(next, L, 'C', errors);
	writeln('Must be: C');

	header('Delete First');
	deletePosition(first, L, 'C', errors);
	writeln('Must be: C');

	header('First''s next');
	showPos(next, L, 'NULL', errors);
	writeln('Must be: NULL');

	header('Last''s previous');
	showPos(previous, L, 'NULL', errors);
	writeln('Must be: NULL');

	header('Delete First');
	deletePosition(first, L, 'NULL', errors);
	writeln('Must be: NULL');

	header('Is it Empty?');
	isThisEmptyQuestionMark(L, true, errors);
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
