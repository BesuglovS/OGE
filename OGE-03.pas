{$reference System.Data.dll}

function RandomLogical(mode: integer := -1): string;
// mode = 1 - signs
// mode = 2 - %
begin
  if mode = -1 then
    loop 100 do mode := Random(2);
  var signs := ['>', '>=', '<', '<='];  
  if mode = 1 then
    result := $'(x {signs[Random(signs.Length)]} {Random(10, 300)})'
  else
  begin
    var mode2 := 0;
    loop 100 do mode2 := Random(2);
    var sign := if mode2 = 0 then '=' else '<>';
    result := $'(x % {Random(2, 20)} {sign} 0)';
  end;
end;

function Eval(expression: string; x: integer): string;
begin
  expression := expression.Replace('x', x.ToString);
  var table := new System.Data.Datatable();
  result := table.Compute(expression, string.Empty).ToString;
end;

function RandExpr(): string;
begin
  var exprs := [RandomLogical(1), RandomLogical, RandomLogical];
  var ts := ['e1 and e2', 'e1 or e2', 'not e1 and e2', 'not e1 or e2', 
  'e1 and e2', 'e1 or e2', 'not e1 and e2', 'not e1 or e2', 
  'e1 and e2', 'e1 or e2', 'not e1 and e2', 'not e1 or e2', 
  'e1 and e2', 'e1 or e2', 'not e1 and e2', 'not e1 or e2', 
  'e1 and e2', 'e1 or e2', 'not e1 and e2', 'not e1 or e2'];
  //  'e1 and e2 and e3', 'e1 and e2 or e3', 'e1 or e2 and e3', 'e1 or e2 or e3',
  //  'not e1 and e2 and e3', 'e1 and not e2 and e3', 'e1 and e2 and not e3'];
  //  'not e1 and e2 or e3', 'e1 and not e2 or e3', 'e1 and e2 or not e3',
  //  'not e1 or e2 and e3', 'e1 or not e2 and e3', 'e1 or e2 and not e3', 
  //  'not e1 or e2 or e3', 'e1 or not e2 or e3', 'e1 or e2 or not e3'
  
  
  result := ts[Random(ts.Length)]
    .Replace('e1', exprs[0]).Replace('e2', exprs[1]).Replace('e3', exprs[2]);
end;

function ReplaceOps(s: string): string;
Begin
  s := RegEx.Replace(s, '% (\d+) = 0', 'делится на $1');
  s := RegEx.Replace(s, '% (\d+) <> 0', 'не делится на $1');
  s := s.Replace('and', 'и');
  s := s.Replace('or', 'или');
  s := s.Replace('not', 'не');
  result := s;
end;

begin
  var f := OpenWrite('OGE-03.txt');
  var count := 0;
  while count <> 100 do
  begin
    var expr := RandExpr();     
    var tf := 0;
      loop 100 do tf := Random(2);
      var orig_expr := expr;
      if tf = 0 then
        expr := $'not ({expr})';
    if Range(1, 300).ToArray.Count(x -> Eval(expr, x) = 'True') > 0 then
    begin      
      var tf_str := if tf = 0 then 'ложно' else 'истинно';
      var modes := [0, 1]; // 0 - min; 1 - max
      if Range(300, 1000).ToArray.Count(x -> Eval(expr, x) = 'True') > 10 then
        modes := modes.Where(x -> x <> 1).ToArray;
      if Range(-1000, 0).ToArray.Count(x -> Eval(expr, x) = 'True') > 10 then
        modes := modes.Where(x -> x <> 0).ToArray;
      var mode2 := -1;
      if modes.Contains(1) then
        mode2 := 1
      else if modes.Contains(0) then
        mode2 := 0;
      if mode2 = 0 then
      begin
        var data := Range(1, 300).ToArray.Where(x -> Eval(expr, x) = 'True');        
        var answ := data.Min;
        orig_expr := ReplaceOps(orig_expr);
        Writeln(f, 'Напишите наименьшее натуральное число x, ' + 
        $'для которого {tf_str} высказывание {orig_expr}' + chr(9) + $'{answ}');
        count += 1;
      end;
      if mode2 = 1 then
      begin        
        var data := Range(1, 300).ToArray.Where(x -> Eval(expr, x) = 'True');        
        var answ := data.Max;
        orig_expr := ReplaceOps(orig_expr);
        Writeln(f, $'Напишите наибольшее натуральное число x, ' + 
        $'для которого {tf_str} высказывание {orig_expr}' + chr(9) + $'{answ}');
        count += 1;
      end;      
    end;
  end;  
  f.Close();
  Writeln('Done!');
end.