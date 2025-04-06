unit oge05;

interface

function GenerateTasksOge05(count: integer): List<(string, string)>;

implementation

function GenerateTask005(): (string, string);
begin
  var initialNumber := Random(10, 100);
  var (opSeq, res, desc1, desc2, answer, letter) := ('', -1, '', '', '', '');
  var maxAttempts := 100;
  var ok := True;
  var atCount := 0;
  loop maxAttempts do
  begin
    atCount += 1;
    var num := initialNumber;
    ok := True;
    var actions := Arr(
    ('+', 'прибавить'),
    ('-', 'вычесть'),
    ('*', 'умножить на'),
    ('/', 'разделить на'),
    ('^', 'возвести в квадрат'),
    ('√', 'извлечь квадратный корень'));
    var actions2 := [actions[:2].Shuffle.First, actions[2:].Shuffle.First].Shuffle;
    var action1 := actions2[0];
    var action2 := actions2[1];
    var opSequence := ['1', '2']
      .CartesianPower(5)
      .Where(x -> ('111' not in x.JoinToString) and 
                  ('222' not in x.JoinToString))
      .Select(x -> x.JoinToString)
    .ToArray
    .Shuffle
    .First;
    
    var operands := (1..2)
      .Select((x, i) -> ((actions2[i][0] = '*') or (actions2[i][0] = '/')) ? 
    Random(2, 9) : Random(1, 9))
    .ToArray;
    for var opNum := 1 to 5 do
    begin
      var op := if opSequence[opNum] = '1' then action1[0] else action2[0];            
      var operand := if opSequence[opNum] = '1' then operands[0] else operands[1];
      
      case op of
        '+':
          begin
            num += operand;            
          end;
        '-':
          begin
            num -= operand;
          end;
        '*':
          begin
            num *= operand;
          end;
        '/':
          begin
            if num mod operand = 0 then
              num := num div operand
            else
            begin
              ok := False;
              break;
            end;
          end;
        '^':
          begin
            num *= num;
          end;
        '√':
          begin
            if frac(num ** 0.5) = 0 then
              num := integer(num ** 0.5)
            else
            begin
              ok := False;
              break;
            end;
          end;
      end;
      if (num < 0) or (num > 500) then
      begin
        ok := False;
        break;
      end;
    end;
    
    if ok then
    begin
      opSeq := opSequence;
      res := num;        
      var ops := [action1.Item1 in '^√' ? '' : operands[0].ToString,
      action2.Item1 in '^√' ? '' : operands[1].ToString];      
      var opNum := Random(0, 1);
      while ops[opNum] = '' do opNum := Random(0, 1);
      
      answer := ops[opNum];
      letter := ['d', 'f', 'g', 'q', 'r', 's', 'u', 'v', 'z', 'x']
        .ToArray[Random(0, 9)];
      ops[opNum] := letter;
      
      desc1 := $'1) {action1[1]} {ops[0]}';
      desc2 := $'2) {action2[1]} {ops[1]}';
      break;
    end;
  end;
  
  var greeks := ['мю', 'ню', 'пи', 'кси', 'тау', 'пси', 'бета', 'тета', 'йота',
  'альфа', 'гамма', 'сигма', 'дельта', 'лямбда', 'эпсилон', 'омикрон', 'ипсилон'];
  var greekLet := greeks[Random(greeks.Length)].ToUpper;
  var lb := NewLine;
  var question := $'У исполнителя {greekLet} две команды.' + lb;
  question += desc1 + lb;
  question += desc2 + lb;
  question += $'Где {letter} неизвестное натуральное число.' + lb;
  question += $'Программа для исполнителя {greekLet} – это последовательность ' +
  $'номеров команд 1 и 2.' + lb + 
  $'Известно, что программа {opSeq} переводит число ' +
  $'{initialNumber} в число {res}. Определите значение {letter}.';
  result := (question, answer);
end;

function GenerateTasksOge05(count: integer): List<(string, string)>;
begin
  var res := new List<(string, string)>();
  var done := 0;
  while done < count do
  begin
    var (q, a) := GenerateTask005();
    if a <> '' then
    begin
      res.Add((q, a));
      done += 1;
    end;
  end;
  
  result := res;
end;

end.