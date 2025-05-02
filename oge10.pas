unit oge10;

interface

uses School;

function GenerateTasksOge10(count: integer): List<(string, List<(string, string)>, string)>;

implementation

function GenerateTasksOge10(count: integer): List<(string, List<(string, string)>, string)>;
begin
  var res := new List<(string, List<(string, string)>, string)>();
  
  for var i := 1 to count do
  begin
    var mode := Random(1, 4);
    
    case mode of
      1:
        begin
          var a := Random(100, 299);
          var b := a + Random(1, 5);
          var c := b + Random(1, 5);
          (a, b, c) := [a, b, c].Shuffle;
          
          var (b1, b2, b3) := (Random(2, 5), Random(6, 9), Random(11, 16));
          (b1, b2, b3) := [b1, b2, b3].Shuffle;
          
          var (ab, bb, cb) := (ToBase(a, b1), ToBase(b, b2), ToBase(c, b3));
          
          var dt := new List<(string, string)>();
          dt.Add((ab, b1.ToString));
          dt.Add((bb, b2.ToString));
          dt.Add((cb, b3.ToString));
          
          var (task, answ) := ('', '');
          var lb := NewLine;
          if Random(1, 100) > 50 then
          begin
            task := 'Среди приведённых выше чисел, ' + 
                        'записанных в различных системах счисления, ' + 
                        'найдите максимальное и запишите его в ответе ' + 
                        'в десятичной системе счисления. ' + lb + 
                        'В ответе запишите только число, ' + 
                        'основание системы счисления указывать не нужно.';
            answ := max(a, b, c).ToString;
          end
          else
          begin
            task := 'Среди приведённых выше чисел, ' + 
                        'записанных в различных системах счисления, ' + 
                        'найдите минимальное и запишите его в ответе ' + 
                        'в десятичной системе счисления. ' + lb + 
                        'В ответе запишите только число, ' + 
                        'основание системы счисления указывать не нужно.';
            answ := min(a, b, c).ToString;
          end;
          res.Add((task, dt, answ));
        end;
      2:
        begin
          var sm1, sm2, sm3: integer;
          var (b, num1, num2, num3) := (0, 
          new List<(integer, string, int64)>,
          new List<(integer, string, int64)>,
          new List<(integer, string, int64)>);
          
          repeat
            sm1 := Random(3, 25);
            sm2 := sm1 + Random(1, 3);
            sm3 := sm1 + Random(-3, -1);
            
            b := ([2..9] + [11..16]).ToList.Shuffle.First;
            
            (num1, num2, num3) := [sm1, sm2, sm3].Select((sm, ind) -> 
            (30..299)
              .Select(x -> (x, ToBase(x, b), 
            ToBase(x, b).ToString.Select(x -> School.Dec(x, b)).Sum))
              .Where(\(x, n, nsm) -> nsm = sm)
            .ToList);
          until (num1.Count > 0) and (num2.Count > 0) and (num3.Count > 0);
          
          var nums := [num1[Random(num1.Count)], 
          num2[Random(num2.Count)], num3[Random(num3.Count)]];
          
          var dt := new List<(string, string)>();
          dt.Add((nums[0][0].ToString, '10'));
          dt.Add((nums[1][0].ToString, '10'));
          dt.Add((nums[2][0].ToString, '10'));
          
          var (task, answ) := ('', '');
          var lb := NewLine;
          if Random(1, 100) > 50 then
          begin
            task := 'Среди приведенных выше трёх чисел, ' + 
            'записанных в десятичной системе счисления, найдите число, ' +
            'сумма цифр которого в системе счисления с основанием = ' + b + 
            ' наибольшая.' + lb + 
            'В ответе запишите сумму цифр в записи этого числа ' + 
            'в системе счисления с основанием = ' + b + '.';
            
            answ := max(nums[0][2], nums[1][2], nums[2][2]).ToString;
          end
          else
          begin
            task := 'Среди приведенных выше трёх чисел, ' + 
            'записанных в десятичной системе счисления, найдите число, ' +
            'сумма цифр которого в системе счисления с основанием = ' + b + 
            ' наименьшая.' + lb + 
            'В ответе запишите сумму цифр в записи этого числа ' + 
            'в системе счисления с основанием = ' + b + '.';
            
            answ := min(nums[0][2], nums[1][2], nums[2][2]).ToString;
          end;
          res.Add((task, dt, answ));
        end;
      3:
        begin
          var a, b, c, ss, mcrd: integer;
          var ab, bb, cb: string;
          var common := new List<char>();
          var rd: char;
          var crd: array of integer;
          
          if Random(100) > 50 then
          begin
            repeat
              a := Random(100, 299);
              b := a + Random(1, 5);
              c := b + Random(1, 5);
              (a, b, c) := [a, b, c].Shuffle;
              
              ss := Random(2, 5);
              
              (ab, bb, cb) := (ToBase(a, ss), ToBase(b, ss), ToBase(c, ss));
              common := ab.Intersect(bb).Intersect(cb).ToList;            
              rd := common[Random(common.Count)];
              crd := [ab.CountOf(rd), bb.CountOf(rd), cb.CountOf(rd)];
              mcrd := crd.Max;
            until (common.Count > 0) and (crd.CountOf(mcrd) = 1);
            
            var dt := new List<(string, string)>();
            dt.Add((a.ToString, '10'));
            dt.Add((b.ToString, '10'));
            dt.Add((c.ToString, '10'));
            
            var lb := NewLine;
            var task := 'Среди приведенных выше трёх чисел, ' + 
            'записанных в десятичной системе счисления, найдите число, ' + 
            'в записи которого в системе счисления с основанием = ' + ss + 
            $' наибольшее количество {rd}.' + lb + 
            $'В ответе запишите количество {rd} в записи этого числа ' + 
            $'в системе счисления с основанием = {ss}.';
            var answ := mcrd.ToString;
            res.Add((task, dt, answ));
          end
          else
          begin
            repeat
              a := Random(100, 299);
              b := a + Random(1, 5);
              c := b + Random(1, 5);
              (a, b, c) := [a, b, c].Shuffle;
              
              ss := Random(2, 5);
              
              (ab, bb, cb) := (ToBase(a, ss), ToBase(b, ss), ToBase(c, ss));
              common := ab.Intersect(bb).Intersect(cb).ToList;            
              rd := common[Random(common.Count)];
              crd := [ab.CountOf(rd), bb.CountOf(rd), cb.CountOf(rd)];
              mcrd := crd.Min;
            until (common.Count > 0) and (crd.CountOf(mcrd) = 1);
            
            var dt := new List<(string, string)>();
            dt.Add((a.ToString, '10'));
            dt.Add((b.ToString, '10'));
            dt.Add((c.ToString, '10'));
            
            var lb := NewLine;
            var task := 'Среди приведенных выше трёх чисел, ' + 
            'записанных в десятичной системе счисления, найдите число, ' + 
            'в записи которого в системе счисления с основанием = ' + ss + 
            $' наименьшее количество {rd}.' + lb + 
            $'В ответе запишите количество {rd} в записи этого числа ' + 
            $'в системе счисления с основанием = {ss}.';
            var answ := mcrd.ToString;
            res.Add((task, dt, answ));
          end;
          
        end;
      4:
        begin
          var a := Random(100, 299);
          var b := a + Random(-5, 5);
          var c := b + Random(-5, 5);
          var d := c + Random(-5, 5);
          var e := d + Random(-5, 5);          
          var nums := [a, b, c, d, e].Shuffle;
          
          var (b1, b2, b3, b4, b5) := (Random(2, 5), 
          Random(6, 9), Random(6, 9),
          Random(11, 16), Random(11, 16));
          var bases := [b1, b2, b3, b4, b5].Shuffle;
          
          var data := nums
          .Select((n, i) -> (n, bases[i], ToBase(n, bases[i])))
          .ToList;
          
          var ri := Random(data.Count);
          var r := data[ri];
          
          var dt := data
            .Where((x, i) -> i <> ri)
            .Select((x, i) -> (x[2], x[1].ToString))
          .ToList;
          
          var md := Random(1, 4);
          case md of
            1:          
              begin
                var answ := data
                                .Where((x, i) -> i <> ri)
                                .Select(x -> x[0])
                .Count(x -> x > data[ri][0])
                .ToString;
                
                var task := 'Среди приведенных выше чисел, записанных в различных ' + 
                            'системах счисления найдите количество чисел, которые больше чем ' + 
                             r[2] + ' в системе счисления с основанием = ' + r[1] + '.';
                
                res.Add((task, dt, answ));
              end;
            2:
              begin
                var answ := data
                                .Where((x, i) -> i <> ri)
                                .Select(x -> x[0])
                .Count(x -> x < data[ri][0])
                .ToString;
                
                var task := 'Среди приведенных выше чисел, записанных в различных ' + 
                            'системах счисления найдите количество чисел, которые меньше чем ' + 
                             r[2] + ' в системе счисления с основанием = ' + r[1] + '.';
                
                res.Add((task, dt, answ));
              end;
            3:
              begin
                var answ := data
                                .Where((x, i) -> i <> ri)
                                .Select(x -> x[0])
                .Count(x -> x <= data[ri][0])
                .ToString;
                
                var task := 'Среди приведенных выше чисел, записанных в различных ' + 
                            'системах счисления найдите количество чисел, которые не больше чем ' + 
                             r[2] + ' в системе счисления с основанием = ' + r[1] + '.';
                
                res.Add((task, dt, answ));
              end;
            4:
              begin
                var answ := data
                                .Where((x, i) -> i <> ri)
                                .Select(x -> x[0])
                .Count(x -> x >= data[ri][0])
                .ToString;
                
                var task := 'Среди приведенных выше чисел, записанных в различных ' + 
                            'системах счисления найдите количество чисел, которые не меньше чем ' + 
                             r[2] + ' в системе счисления с основанием = ' + r[1] + '.';
                
                res.Add((task, dt, answ));
              end;
          end;
        end; 
    end;
  end;
  
  result := res;
end;

end.