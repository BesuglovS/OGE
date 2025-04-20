unit oge07;

interface

function GenerateTasksOge07(count: integer): List<(string, List<(integer, string)>, string)>;

implementation

function GenerateTasksOge07(count: integer): List<(string, List<(integer, string)>, string)>;
Begin
  var protocols := ['http', 'https', 'ftp', 'ftps', 'sftp'];
  var sites := ['kremlin.ru', 'gosuslugi.ru', 'government.ru', 'nalog.ru',
  'gov.ru', 'mkrf.ru', 'znanija.com', 'kompege.ru',
  'litres.ru', 'cyberleninka.ru', 'stepik.org'];
  var filenames := ['algorithm', 'variable', 'loop', 'condition',
  'function', 'array', 'oop', 'class', 'object', 'recursion', 'api',
  'git', 'commit', 'backend', 'frontend', 'database', 'sql',
  'framework', 'ide', 'debug', 'curriculum', 'syllabus', 
  'evaluation'];
  var extensions := ['pdf', 'docx', 'txt', 'pptx', 'xlsx', 'html', 
  'css', 'js', 'json', 'xml', 'jpg', 'jpeg', 'png', 'gif', 'mp3',
  'mp4', 'avi', 'zip', 'exe', 'dmg', 'apk'];
  
  var addrs := Cartesian(protocols, sites, filenames, extensions)
    .ToList
    .Shuffle
    .Take(count)
    .ToList;
  
  var res := new List<(string, List<(integer, string)>, string)>();
  
  foreach var addr in addrs do
  begin
    var dot1 := Random(1,100) < 30;
    var dot2 := Random(1,100) > 50;
    var host := addr[1].Split('.');
    var parts := [addr[0], '://', 
    host[0] + (if dot1 then '.' else ''), 
    (if dot1 then '' else '.') + host[1], '/',
    addr[2] + (if dot2 then '.' else ''), 
    (if dot2 then '' else '.') + addr[3]];
    
    var lb := NewLine;
    var task := $'Доступ к файлу {addr[2]}.{addr[3]}, ' + 
    $'находящемуся на сервере {addr[1]}, ' + 
    $'осуществляется по протоколу {addr[0]}.' + lb + 
    $'Фрагменты адреса файла закодированы цифрами от 1 до 7.' + lb +
    'Запишите в ответе последовательность этих цифр, ' + 
    'кодирующую адрес указанного файла в сети Интернет.';
    
    var partsDict := parts.Numerate(1).ToList.Shuffle;
    var answ := Range(1, partsDict.Count)
      .Select(i -> partsDict
                    .Select((x, ind) -> (ind, x))
                    .First(\(ii, x) -> i = x[0])[0]+1)
      .JoinToString('');
      
    partsDict := partsDict.Select((x, i) -> (i+1, x[1])).ToList;
    
    res.Add((task, partsDict, answ));
  end;
  
  result := res;
end;

end.