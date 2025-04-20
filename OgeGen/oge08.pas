unit oge08;

interface

function GenerateTasksOge08(count: integer): List<(string, Dictionary<string, string>, string , string)>;

implementation

function GenerateTasksOge08(count: integer): List<(string, Dictionary<string, string>, string , string)>;
Begin
  var res := new List<(string, Dictionary<string, string>, string, string)>();
  
  result := res;
end;

end.