PROGRAM cobblersShoeShop;

USES
    crt;

CONST
     NORMAL_TIME_MULTIPLIER = 1;
     OVER_TIME_MULTIPLIER = 1.5;

VAR
   employeeName:string;
   employeeTime,employeeOverTime,employeePay:real;
   anotherEmployee:char;

BEGIN
     clrscr;
     writeln('COBBLER''S SHOE SHOP WAGE CALCULATOR');
     writeln('===================================');
     writeln;
     anotherEmployee := 'Y';
     WHILE (NOT (anotherEmployee = 'N')) DO
     writeln('PLEASE ENTER:');
     write('  EMPLOYEE NAME   >>> ');
     readln(employeeName);
     write('  TIME WORKED     >>> ');
     readln(employeeTime);
     write('  OVERTIME WORKED >>> ');
     readln(employeeOverTime);
     writeln;
     employeePay := employeeTime * NORMAL_TIME_MULTIPLIER + employeeOverTime * OVER_TIME_MULTIPLIER;
     clrscr;
     writeln('WAGES FOR ',employeeName,':');
     writeln;
     writeln('     $ ',employeePay);
     writeln;
     write('ANOTHER EMPLOYEE ? (Y/N)');
     anotherEmployee := readkey;
     anotherEmployee := upcase(anotherEmployee);
     IF (anotherEmployee <> 'Y') AND (anotherEmployee <> 'N') THEN anotherEmployee := 'N';
     END;
END.

