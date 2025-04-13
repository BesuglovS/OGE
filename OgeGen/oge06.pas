unit oge06;

interface

function GenerateTasksOge06(count: integer): List<(string, List<string>, string, integer)>;

implementation

{$reference System.Data.dll}

function RandomLogical(letter: string): string;
begin
  var signs := ['>', '>=', '<', '<='];    
  result := $'({letter} {signs[Random(signs.Length)]} {Random(-5, 10)})';
end;

function Eval(expression: string; x, y: integer): string;
begin
  expression := expression.Replace('x', x.ToString);
  expression := expression.Replace('y', y.ToString);
  var table := new System.Data.Datatable();
  result := table.Compute(expression, string.Empty).ToString;
end;

function RandExpr(): string;
begin
  var exprs := [RandomLogical('x'), RandomLogical('y')].Shuffle;
  var ts := ['e1 and e2', 'e1 or e2',
  'not e1 and e2', 'not e1 or e2',
  'e1 and not e2', 'e1 or not e2',
  'not (e1 and e2)', 'not (e1 or e2)'];
  
  result := ts[Random(ts.Length)]
    .Replace('e1', exprs[0]).Replace('e2', exprs[1]);
end;

function LangExprs(e: string): (string, string, string, string);
begin
  var eAlg := e.Replace('not', 'не').Replace('and', 'и').Replace('or', 'или');
  var ePas := e;
  var ePyt := e;
  var eCpp := e.Replace('not', '!').Replace('and', '&&').Replace('or', '||')
               .Replace('! ', '!');
  result := (eAlg, ePas, ePyt, eCpp);
end;

function GenerateTasksOge06(count: integer): List<(string, List<string>, string, integer)>;
begin
  var lb := NewLine;
  var tAlgo := 
  'алг' + lb + 
  'нач' + lb + 
  'цел x, y' + lb + 
  'ввод x' + lb + 
  'ввод y' + lb + 
  'если *****' + lb + 
  #160#160'то вывод "ДА"' + lb + 
  #160#160'иначе вывод "НЕТ"' + lb + 
  'все' + lb + 
  'кон';
  var tPascal := 
  'var x, y: integer;' + lb + 
  'begin' + lb + 
  #160#160#160#160'readln(x);' + lb + 
  #160#160#160#160'readln(y);' + lb + 
  #160#160#160#160'if *****' + lb + 
  #160#160#160#160'then writeln("ДА")' + lb + 
  #160#160#160#160'else writeln("НЕТ")' + lb + 
  'end.';
  var tPython := 
  'x = int(input())' + lb + 
  'y = int(input())' + lb + 
  'if *****:' + lb + 
  #160#160#160#160'print("ДА")' + lb + 
  'else:' + lb + 
  #160#160#160#160'print("НЕТ")';
  var tCpp := 
  '#include <iostream>' + lb + 
  'using namespace std;' + lb + 
  'int main() {' + lb + 
  #160#160'int x, y;' + lb + 
  #160#160'cin >> x;' + lb + 
  #160#160'cin >> y;' + lb + 
  #160#160'if (*****)' + lb + 
  #160#160#160#160'cout << "ДА"' + lb + 
  #160#160'else' + lb + 
  #160#160#160#160'cout << "НЕТ";' + lb + 
  #160#160'return 0;' + lb + 
  '}';
  
  var res := new List<(string, List<string>, string, integer)>();
  for var i := 1 to count do
  begin
    var exprs := LangExprs(RandExpr());  
    tAlgo := tAlgo.Replace('*****', exprs[0]);
    tPascal := tPascal.Replace('*****', exprs[1]);
    tPython := tPython.Replace('*****', exprs[2]);
    tCpp := tCpp.Replace('*****', exprs[3]);
    var progs := [tAlgo, tPascal, tPython, tCpp].ToList;
    
    var RunsCount := Random(9, 11);
    var pairs := Range(1, RunsCount).Select(x -> (Random(-6, 19), Random(-6, 19))).ToArray;
    var YesCount := pairs.Count(\(x, y) -> Eval(exprs[1], x, y) = 'True');
    var ok := (YesCount > 1) and (YesCount < 8);
    while not ok do
    begin
      pairs := Range(1, RunsCount).Select(x -> (Random(-6, 19), Random(-6, 19))).ToArray;
      YesCount := pairs.Count(\(x, y) -> Eval(exprs[1], x, y) = 'True');
      ok := (YesCount > 1) and (YesCount < 8);
    end;
    
    var pairsString := pairs
      .Select(\(x, y) -> $'({x}; {y})')
      .JoinToString(', ');
    var isYes := Random(0, 1) = 1;  
    var answ := if isYes then YesCount else RunsCount - YesCount;
    var ans := if isYes then 'ДА' else 'НЕТ';
    
    var taskText1 := 'Приведена программа, записанная на четырёх языках программирования.';
    var taskText2 := $'Было проведено {RunsCount} запусков программы, при которых ' + 
        $'в качестве значений переменных x и y вводились следующие пары чисел: ' + 
        lb + pairsString + '.' + lb + 
    $'Сколько было запусков, при которых программа напечатала "{ans}"?';
    
    var task := (taskText1, progs, taskText2, answ);
    res.Add(task);
  end;
  result := res;
end;

end.